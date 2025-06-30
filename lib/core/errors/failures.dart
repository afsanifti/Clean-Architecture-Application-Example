import 'package:clean_arch_examples/core/errors/exceptions.dart';
import 'package:equatable/equatable.dart';

abstract class Failures extends Equatable {
  Failures({required this.message, required this.statusCode})
    : assert(
        statusCode is String || statusCode is int,
        'statusCode cannot be a ${statusCode.runtimeType}',
      );

  final String message;
  final dynamic statusCode;

  String get errorMessage =>
      '$statusCode${statusCode is String ? '' : ' Error'}: $message';

  @override
  List<dynamic> get props => [message, statusCode];
}

class CacheFailure extends Failures {
  CacheFailure({required super.message, required super.statusCode});
}

class ServerFailure extends Failures {
  ServerFailure({required super.message, required super.statusCode});

  ServerFailure.fromException(ServerException exception)
    : this(message: exception.message, statusCode: exception.statusCode);
}
