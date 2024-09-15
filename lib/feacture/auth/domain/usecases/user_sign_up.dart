import 'package:blogapp/core/error/failures.dart';
import 'package:blogapp/core/usecase/usecase.dart';
import 'package:blogapp/core/common/entities/user.dart';
import 'package:blogapp/feacture/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignUp implements UseCase<User, UserSignUpParams> {
  final AuthRepository repository;
  const UserSignUp(this.repository);
  @override
  Future<Either<Failure, User>> call(UserSignUpParams params) async {
    return await repository.signUpwithEmailAndPassword(
      email: params.email,
      password: params.password,
      name: params.name,
    );
  }
  }

class UserSignUpParams {
  final String email;
  final String password;
  final String name;
  const UserSignUpParams({
    required this.email,
    required this.password,
    required this.name,
  });
}
