import 'package:clean_arch_examples/core/usecases/usecases.dart';
import 'package:clean_arch_examples/core/utils/typedefs.dart';
import 'package:clean_arch_examples/src/authentication/domain/repos/auth_repo.dart';
import 'package:equatable/equatable.dart';

class SignUp extends UsecaseWithParams<void, SignUpParams> {
  const SignUp(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<void> call(SignUpParams params) => _repo.signUp(
    email: params.email,
    fullName: params.fullName,
    password: params.password,
  );
}

class SignUpParams extends Equatable {
  const SignUpParams({
    required this.email,
    required this.fullName,
    required this.password,
  });

  const SignUpParams.empty() : email = '', fullName = '', password = '';

  final String email;
  final String fullName;
  final String password;

  @override
  List<Object?> get props => [email, fullName, password];
}
