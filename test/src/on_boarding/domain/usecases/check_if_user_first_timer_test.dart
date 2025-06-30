import 'package:clean_arch_examples/src/on_boarding/domain/repos/on_boarding_repo.dart';
import 'package:clean_arch_examples/src/on_boarding/domain/usecases/check_if_user_first_timer.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'on_boarding_repo.mock.dart';

void main() {
  late OnBoardingRepo repo;
  late CheckIfUserFirstTimer usecase;

  setUp(() {
    repo = MockOnBoardingRepo();
    usecase = CheckIfUserFirstTimer(repo);
  });

  test('should return the right data '
      'when [repo.checkIfFirstTimer]', () async {
    when(
      () => repo.checkIfUserFirstTimer(),
    ).thenAnswer((_) async => const Right(true));

    final result = await usecase();

    expect(result, equals(const Right<dynamic, bool>(true)));
    verify(() => repo.checkIfUserFirstTimer());
    verifyNoMoreInteractions(repo);
  });
}
