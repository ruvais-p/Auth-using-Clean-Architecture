import 'package:blogapp/core/error/failures.dart';
import 'package:blogapp/core/common/entities/user.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signUpwithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });
  Future<Either<Failure, User>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<Either<Failure, User>> currentUser();
}
