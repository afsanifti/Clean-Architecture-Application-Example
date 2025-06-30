import 'dart:convert';
import 'dart:io';

import 'package:clean_arch_examples/core/enums/update_user.dart';
import 'package:clean_arch_examples/core/errors/exceptions.dart';
import 'package:clean_arch_examples/core/utils/constants.dart';
import 'package:clean_arch_examples/core/utils/typedefs.dart';
import 'package:clean_arch_examples/src/authentication/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

abstract class AuthRemoteDataSrc {
  const AuthRemoteDataSrc();

  Future<void> forgotPassword(String email);

  Future<LocalUserModel> signIn({
    required String email,
    required String password,
  });

  Future<void> signUp({
    required String email,
    required String fullName,
    required String password,
  });

  Future<void> updateUser({
    required UpdateUserAction action,
    required dynamic userData,
  });
}

class AuthRemoteDataSrcImpl implements AuthRemoteDataSrc {
  const AuthRemoteDataSrcImpl({
    required FirebaseAuth authClient,
    required FirebaseFirestore cloudStorageClient,
    required FirebaseStorage dbClient,
  }) : _authClient = authClient,
       _cloudStorageClient = cloudStorageClient,
       _dbClient = dbClient;

  final FirebaseAuth _authClient;
  final FirebaseFirestore _cloudStorageClient;
  final FirebaseStorage _dbClient;

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _authClient.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error occurred',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  /// The [_setUserData] method is used in the sign in flow for specific cases
  /// User can exist in Firebase Authentication which doesn't have corresponding
  /// data in FireStore.
  ///
  /// This can happen in scenarios like :-
  ///   - User was created in FirebaseAuth but app crashed before Firestore
  ///     data could be created.
  ///   - User was imported into Firebase Auth from another system
  ///   - User data was accidentally deleted from Firestore
  ///
  /// The method creates a new document in Firestore's users collection with:-
  ///   - UID
  ///   - Basic user information
  ///   - default values for additional fields
  ///
  /// First [signIn] tries to get user data from Firestore.
  /// If user data doesn't exist, then it creates missing data.
  /// And then fetches newly created data and returns it
  @override
  Future<LocalUserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _authClient.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;

      if (user == null) {
        throw const ServerException(
          message: 'Please try again later',
          statusCode: 'Unknown error',
        );
      }

      var userData = await _getUserData(user.uid);

      if (userData.exists) {
        return LocalUserModel.fromMap(userData.data()!);
      }

      // upload the user
      await _setUserData(user, email);
      userData = await _getUserData(user.uid);
      return LocalUserModel.fromMap(userData.data()!);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error occurred',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  @override
  Future<void> signUp({
    required String email,
    required String fullName,
    required String password,
  }) async {
    try {
      final userCred = await _authClient.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCred.user?.updateDisplayName(fullName);
      await userCred.user?.updatePhotoURL(kDefaultAvatar);
      await _setUserData(_authClient.currentUser!, email);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error occurred',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  @override
  Future<void> updateUser({
    required UpdateUserAction action,
    required dynamic userData,
  }) async {
    try {
      switch (action) {
        case UpdateUserAction.bio:
          await _updateUserData({'bio': userData as String});

        case UpdateUserAction.displayName:
          await _authClient.currentUser?.updateDisplayName(userData as String);
          await _updateUserData({'fullName': userData});

        case UpdateUserAction.email:
          await _authClient.currentUser?.verifyBeforeUpdateEmail(
            userData as String,
          );
          await _updateUserData({'email': userData});

        case UpdateUserAction.password:
          if (_authClient.currentUser?.email == null) {
            throw const ServerException(
              message: 'User does not exist',
              statusCode: 'Insufficient permission',
            );
          }
          final newData = jsonDecode(userData as String) as DataMap;
          await _authClient.currentUser?.reauthenticateWithCredential(
            EmailAuthProvider.credential(
              email: _authClient.currentUser!.email!,
              password: newData['oldPassword'] as String,
            ),
          );
          await _authClient.currentUser?.updatePassword(
            newData['newPassword'] as String,
          );

        case UpdateUserAction.profilePic:
          final ref = _dbClient.ref().child(
            'profile_pics/${_authClient.currentUser?.uid}',
          );
          await ref.putFile(userData as File);
          final url = await ref.getDownloadURL();
          await _authClient.currentUser?.updatePhotoURL(url);
          await _updateUserData({'profilePic': url});
      }
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error occurred',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  Future<DocumentSnapshot<DataMap>> _getUserData(String uid) async {
    return _cloudStorageClient.collection('users').doc(uid).get();
  }

  Future<void> _setUserData(User user, String fallbackEmail) async {
    await _cloudStorageClient
        .collection('users')
        .doc(user.uid)
        .set(
          LocalUserModel(
            uid: user.uid,
            email: user.email ?? fallbackEmail,
            fullName: user.displayName ?? '',
            profilePic: user.photoURL ?? '',
            points: 0,
          ).toMap(),
        );
  }

  Future<void> _updateUserData(DataMap data) async {
    await _cloudStorageClient
        .collection('users')
        .doc(_authClient.currentUser?.uid)
        .update(data);
  }
}
