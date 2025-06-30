import 'package:clean_arch_examples/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

typedef ResultFuture<T> = Future<Either<Failures, T>>;

typedef DataMap = Map<String, dynamic>;
