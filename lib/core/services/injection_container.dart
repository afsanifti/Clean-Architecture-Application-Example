import 'package:clean_arch_examples/src/on_boarding/data/datasources/on_boarding_local_data_src.dart';
import 'package:clean_arch_examples/src/on_boarding/data/repos/on_boarding_repo_impl.dart';
import 'package:clean_arch_examples/src/on_boarding/domain/repos/on_boarding_repo.dart';
import 'package:clean_arch_examples/src/on_boarding/domain/usecases/cache_first_timer.dart';
import 'package:clean_arch_examples/src/on_boarding/domain/usecases/check_if_user_first_timer.dart';
import 'package:clean_arch_examples/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  final prefs = await SharedPreferences.getInstance();

  sl
    // Business Logic
    ..registerFactory(
      () => OnBoardingCubit(cacheFirstTimer: sl(), checkIfUserFirstTimer: sl()),
    )
    // usecases
    ..registerLazySingleton(() => CacheFirstTimer(sl()))
    ..registerLazySingleton(() => CheckIfUserFirstTimer(sl()))
    // Repository
    ..registerLazySingleton<OnBoardingRepo>(() => OnBoardingRepoImpl(sl()))
    // DataSource
    ..registerLazySingleton<OnBoardingLocalDataSrc>(
      () => OnBoardingLocalDataSrcImpl(sl()),
    )
    // SharePreferences
    ..registerLazySingleton(() => prefs);
}
