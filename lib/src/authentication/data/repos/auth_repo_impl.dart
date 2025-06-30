import 'package:clean_arch_examples/core/enums/update_user.dart';
import 'package:clean_arch_examples/core/errors/exceptions.dart';
import 'package:clean_arch_examples/core/errors/failures.dart';
import 'package:clean_arch_examples/core/utils/typedefs.dart';
import 'package:clean_arch_examples/src/authentication/data/datasources/auth_remote_data_src.dart';
import 'package:clean_arch_examples/src/authentication/domain/entities/user.dart';
import 'package:clean_arch_examples/src/authentication/domain/repos/auth_repo.dart';
import 'package:dartz/dartz.dart';

class AuthRepoImpl extends AuthRepo {
  const AuthRepoImpl(this._remoteDataSrc);

  final AuthRemoteDataSrc _remoteDataSrc;

  @override
  ResultFuture<void> forgotPassword(String email) async {
    try {
      await _remoteDataSrc.forgotPassword(email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<LocalUser> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _remoteDataSrc.signIn(
        email: email,
        password: password,
      );

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> signUp({
    required String email,
    required String fullName,
    required String password,
  }) async {
    try {
      await _remoteDataSrc.signUp(
        email: email,
        fullName: fullName,
        password: password,
      );

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> updateUser({
    required UpdateUserAction action,
    required dynamic userData,
  }) async {
    try {
      await _remoteDataSrc.updateUser(action: action, userData: userData);

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
