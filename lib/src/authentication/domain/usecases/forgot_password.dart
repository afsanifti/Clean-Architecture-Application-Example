import 'package:clean_arch_examples/core/usecases/usecases.dart';
import 'package:clean_arch_examples/core/utils/typedefs.dart';
import 'package:clean_arch_examples/src/authentication/domain/repos/auth_repo.dart';

class ForgotPassword extends UsecaseWithParams<void, String> {
  const ForgotPassword(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<void> call(String params) => _repo.forgotPassword(params);
}
