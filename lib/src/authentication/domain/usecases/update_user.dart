import 'package:clean_arch_examples/core/enums/update_user.dart';
import 'package:clean_arch_examples/core/usecases/usecases.dart';
import 'package:clean_arch_examples/core/utils/typedefs.dart';
import 'package:clean_arch_examples/src/authentication/domain/repos/auth_repo.dart';
import 'package:equatable/equatable.dart';

class UpdateUser extends UsecaseWithParams<void, UpdateUserParams> {
  const UpdateUser(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<void> call(UpdateUserParams params) =>
      _repo.updateUser(action: params.action, userData: params.userData);
}

class UpdateUserParams extends Equatable {
  const UpdateUserParams({required this.action, required this.userData});

  const UpdateUserParams.empty()
    : this(action: UpdateUserAction.displayName, userData: '');

  final UpdateUserAction action;
  final dynamic userData;

  @override
  List<dynamic> get props => [action, userData];
}
