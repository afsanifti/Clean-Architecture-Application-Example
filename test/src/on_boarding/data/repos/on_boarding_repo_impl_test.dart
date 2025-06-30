import 'package:clean_arch_examples/core/errors/exceptions.dart';
import 'package:clean_arch_examples/core/errors/failures.dart';
import 'package:clean_arch_examples/src/on_boarding/data/datasources/on_boarding_local_data_src.dart';
import 'package:clean_arch_examples/src/on_boarding/data/repos/on_boarding_repo_impl.dart';
import 'package:clean_arch_examples/src/on_boarding/domain/repos/on_boarding_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOnBoardingLocalDataSrc extends Mock
    implements OnBoardingLocalDataSrc {}

void main() {
  late OnBoardingLocalDataSrc localDataSrc;
  late OnBoardingRepoImpl repoImpl;

  setUp(() {
    localDataSrc = MockOnBoardingLocalDataSrc();
    repoImpl = OnBoardingRepoImpl(localDataSrc);
  });

  test('Should be subclass of [OnBoardingRepo]', () {
    expect(repoImpl, isA<OnBoardingRepo>());
  });

  group('cacheFirstTimer', () {
    test('should complete successfully', () async {
      when(
        () => localDataSrc.cacheFirstTimer(),
      ).thenAnswer((_) async => Future.value());

      final result = await repoImpl.cacheFirstTimer();

      expect(result, equals(const Right<dynamic, void>(null)));
      verify(() => localDataSrc.cacheFirstTimer());
      verifyNoMoreInteractions(localDataSrc);
    });

    test('Should return a [CacheFailure] when call to local '
        'is unsuccessful', () async {
      when(
        () => localDataSrc.cacheFirstTimer(),
      ).thenThrow(const CacheException(message: 'Insufficient storage'));

      final result = await repoImpl.cacheFirstTimer();

      expect(
        result,
        Left<CacheFailure, dynamic>(
          CacheFailure(message: 'Insufficient storage', statusCode: 500),
        ),
      );
      verify(() => localDataSrc.cacheFirstTimer());
      verifyNoMoreInteractions(localDataSrc);
    });
  });

  group('checkIfUserFirstTimer', () {
    test('Should complete successfully', () async {
      when(
        () => localDataSrc.checkIfUserFirstTimer(),
      ).thenAnswer((_) async => Future.value(true));
    });
  });
}
