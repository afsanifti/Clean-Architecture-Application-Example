import 'package:bloc_test/bloc_test.dart';
import 'package:clean_arch_examples/core/errors/failures.dart';
import 'package:clean_arch_examples/src/on_boarding/domain/usecases/cache_first_timer.dart';
import 'package:clean_arch_examples/src/on_boarding/domain/usecases/check_if_user_first_timer.dart';
import 'package:clean_arch_examples/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCacheFirstTimer extends Mock implements CacheFirstTimer {}

class MockCheckIfUserFirstTimer extends Mock implements CheckIfUserFirstTimer {}

void main() {
  late CacheFirstTimer cacheFirstTimer;
  late CheckIfUserFirstTimer checkIfUserFirstTimer;
  late OnBoardingCubit cubit;

  final tFailure = CacheFailure(
    message: 'Insufficient Storage Permission',
    statusCode: 4032,
  );

  setUp(() {
    cacheFirstTimer = MockCacheFirstTimer();
    checkIfUserFirstTimer = MockCheckIfUserFirstTimer();
    cubit = OnBoardingCubit(
      cacheFirstTimer: cacheFirstTimer,
      checkIfUserFirstTimer: checkIfUserFirstTimer,
    );
  });

  test('Initial test should be [OnBoardingInitial]', () {
    expect(cubit.state, const OnBoardingInitial());
  });

  group('cacheFirstTimer', () {
    blocTest<OnBoardingCubit, OnBoardingState>(
      'Should emit [CachingFirstTImer, UserCached] when successful',

      build: () {
        when(
          () => cacheFirstTimer(),
        ).thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.cacheFirstTimer(),
      expect: () => [const CachingFirstTimer(), const UserCached()],
      verify: (_) {
        verify(() => cacheFirstTimer()).called(1);
        verifyNoMoreInteractions(cacheFirstTimer);
      },
    );

    blocTest(
      'Should emit [CachingFirstTimer, OnBoardingError] when unsuccessful',
      build: () {
        when(() => cacheFirstTimer()).thenAnswer((_) async => Left(tFailure));
        return cubit;
      },
      act: (cubit) => cubit.cacheFirstTimer(),

      expect:
          () => [
            const CachingFirstTimer(),
            OnBoardingError(tFailure.errorMessage),
          ],
      verify: (_) {
        verify(() => cacheFirstTimer()).called(1);
        verifyNoMoreInteractions(cacheFirstTimer);
      },
    );
  });

  group('checkIfUserFirstTimer', () {
    blocTest<OnBoardingCubit, OnBoardingState>(
      'Should emit [CheckingIfUserFirstTimer, OnBoardingStatus] '
      'when successful',
      build: () {
        when(
          () => checkIfUserFirstTimer(),
        ).thenAnswer((_) async => const Right(false));
        return cubit;
      },

      act: (cubit) => cubit.checkIfUserFirstTimer(),

      expect:
          () => [
            const CheckingIfUserFirstTimer(),
            const OnBoardingStatus(isFirstTImer: false),
          ],

      verify: (_) {
        verify(() => checkIfUserFirstTimer()).called(1);
        verifyNoMoreInteractions(checkIfUserFirstTimer);
      },
    );

    blocTest<OnBoardingCubit, OnBoardingState>(
      'Should emit [CheckingIfUserFirstTimer, OnBoardingStatus] '
      'when unsuccessful',
      build: () {
        when(
          () => checkIfUserFirstTimer(),
        ).thenAnswer((_) async => Left(tFailure));
        return cubit;
      },

      act: (cubit) => cubit.checkIfUserFirstTimer(),

      expect:
          () => [
            const CheckingIfUserFirstTimer(),
            const OnBoardingStatus(isFirstTImer: true),
          ],

      verify: (_) {
        verify(() => checkIfUserFirstTimer()).called(1);
        verifyNoMoreInteractions(checkIfUserFirstTimer);
      },
    );
  });
}
