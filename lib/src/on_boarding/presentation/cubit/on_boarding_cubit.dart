import 'package:bloc/bloc.dart';
import 'package:clean_arch_examples/src/on_boarding/domain/usecases/cache_first_timer.dart';
import 'package:clean_arch_examples/src/on_boarding/domain/usecases/check_if_user_first_timer.dart';
import 'package:equatable/equatable.dart';

part 'on_boarding_state.dart';

class OnBoardingCubit extends Cubit<OnBoardingState> {
  OnBoardingCubit({
    required CacheFirstTimer cacheFirstTimer,
    required CheckIfUserFirstTimer checkIfUserFirstTimer,
  }) : _cacheFirstTimer = cacheFirstTimer,
       _checkIfUserFirstTimer = checkIfUserFirstTimer,
       super(const OnBoardingInitial());

  final CacheFirstTimer _cacheFirstTimer;
  final CheckIfUserFirstTimer _checkIfUserFirstTimer;

  Future<void> cacheFirstTimer() async {
    emit(const CachingFirstTimer());
    final result = await _cacheFirstTimer();

    result.fold(
      (failure) => emit(OnBoardingError(failure.errorMessage)),
      (_) => emit(const UserCached()),
    );
  }

  Future<void> checkIfUserFirstTimer() async {
    emit(const CheckingIfUserFirstTimer());
    final result = await _checkIfUserFirstTimer();

    result.fold(
      (failure) => emit(const OnBoardingStatus(isFirstTImer: true)),
      (status) => emit(OnBoardingStatus(isFirstTImer: status)),
    );
   }
}
