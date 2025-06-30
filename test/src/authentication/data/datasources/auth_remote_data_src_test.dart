import 'package:clean_arch_examples/src/authentication/data/datasources/auth_remote_data_src.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';

void main() async {
  late FakeFirebaseFirestore cloudStoreClient;
  late MockFirebaseAuth authClient;
  late MockFirebaseStorage dbClient;
  late AuthRemoteDataSrc dataSrc;

  setUp(() async {
    cloudStoreClient = FakeFirebaseFirestore();
    final googleSignIn = MockGoogleSignIn();
    final signInAccount = await googleSignIn.signIn();
    final googleAuth = await signInAccount!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // Sign in.
    final mockUser = MockUser(
      uid: 'someuid',
      email: 'bob@somedomain.com',
      displayName: 'Bob',
    );

    authClient = MockFirebaseAuth(mockUser: mockUser);
    final result = await authClient.signInWithCredential(credential);
    final user = result.user;

    dbClient = MockFirebaseStorage();

    dataSrc = AuthRemoteDataSrcImpl(
      authClient: authClient,
      cloudStorageClient: cloudStoreClient,
      dbClient: dbClient,
    );
  });

  const tPassword = 'Test Password';
  const tFullName = 'Test Full Name';
  const tEmail = 'testemail@mail.com';

  test('signUp', () async {
    await dataSrc.signUp(
      email: tEmail,
      fullName: tFullName,
      password: tPassword,
    );

    expect(authClient.currentUser, isNotNull);
    expect(authClient.currentUser!.displayName, tFullName);

    final user =
        await cloudStoreClient
            .collection('users')
            .doc(authClient.currentUser!.uid)
            .get();

    expect(user.exists, isTrue);
  });

  test('signIn', () async {
    await dataSrc.signUp(
      email: tEmail,
      fullName: tFullName,
      password: tPassword,
    );
    await authClient.signOut();
    await dataSrc.signIn(email: tEmail, password: tPassword);

    expect(authClient.currentUser, isNotNull);
    expect(authClient.currentUser!.email, tEmail);
  });

  group('updateUser', () {

  });
}
