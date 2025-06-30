import 'package:clean_arch_examples/core/utils/typedefs.dart';

abstract class OnBoardingRepo {
  const OnBoardingRepo();

  /// this function decides whether to show on boarding screen
  /// or move user to login screen if it's not their first time
  ResultFuture<void> cacheFirstTimer();

  ResultFuture<bool> checkIfUserFirstTimer();
}
