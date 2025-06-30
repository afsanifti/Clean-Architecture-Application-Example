import 'package:clean_arch_examples/core/errors/exceptions.dart';
import 'package:clean_arch_examples/core/errors/failures.dart';
import 'package:clean_arch_examples/core/utils/typedefs.dart';
import 'package:clean_arch_examples/src/on_boarding/data/datasources/on_boarding_local_data_src.dart';
import 'package:clean_arch_examples/src/on_boarding/domain/repos/on_boarding_repo.dart';
import 'package:dartz/dartz.dart';

class OnBoardingRepoImpl implements OnBoardingRepo {
  /// onBoardingRepoImpl depends on a data source.
  /// we don't have a remote data source as it is not taking to the server.
  /// In this case, we have our local data source.
  const OnBoardingRepoImpl(this._localDataSrc);

  final OnBoardingLocalDataSrc _localDataSrc;

  @override
  ResultFuture<void> cacheFirstTimer() async {
    try {
      await _localDataSrc.cacheFirstTimer();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<bool> checkIfUserFirstTimer() async {
    try {
      final result = await _localDataSrc.checkIfUserFirstTimer();
      return Right(result); 
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
