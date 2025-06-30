import 'package:clean_arch_examples/core/errors/failures.dart';
import 'package:clean_arch_examples/src/on_boarding/domain/repos/on_boarding_repo.dart';
import 'package:clean_arch_examples/src/on_boarding/domain/usecases/cache_first_timer.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'on_boarding_repo.mock.dart';

void main() {
  late OnBoardingRepo repo;
  late CacheFirstTimer usecase;

  setUp(() {
    repo = MockOnBoardingRepo();
    usecase = CacheFirstTimer(repo);
  });

  test('Should call the [OnBoardingRepo.cacheFirstTimer] '
      'and should return the right data', () async {
    when(() => repo.cacheFirstTimer()).thenAnswer(
      (_) async =>
          Left(ServerFailure(message: 'Unknown Error', statusCode: 500)),
    );

    final result = await repo.cacheFirstTimer();

    expect(
      result,
      equals(
        Left<Failures, dynamic>(
          ServerFailure(message: 'Unknown Error', statusCode: 500),
        ),
      ),
    );
    verify(() => repo.cacheFirstTimer());
    verifyNoMoreInteractions(repo);
  });
}
