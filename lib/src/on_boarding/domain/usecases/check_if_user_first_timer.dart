import 'package:clean_arch_examples/core/usecases/usecases.dart';
import 'package:clean_arch_examples/core/utils/typedefs.dart';
import 'package:clean_arch_examples/src/on_boarding/domain/repos/on_boarding_repo.dart';

class CheckIfUserFirstTimer extends UsecaseWithoutParams<bool> {
  const CheckIfUserFirstTimer(this._repo);

  final OnBoardingRepo _repo;

  @override
  ResultFuture<bool> call() async => _repo.checkIfUserFirstTimer();
}
