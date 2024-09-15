import 'package:blogapp/core/error/exception.dart';
import 'package:blogapp/core/error/failures.dart';
import 'package:blogapp/feacture/auth/data/auth_remote_data_source.dart';
import 'package:blogapp/core/common/entities/user.dart';
import 'package:blogapp/feacture/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  const AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(Failure("User is not logged in!"));
      }

      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, User>> signUpwithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    return _getUser(
      () async => await remoteDataSource.signUpwithEmailAndPassword(
        email: email,
        password: password,
        name: name,
      ),
    );
  }

  Future<Either<Failure, User>> _getUser(
    Future<User> Function() fn,
  ) async {
    try {
      final user = await fn();
      return right(user);
    } on sb.AuthException catch (e) {
      return left(Failure(e.message));
    } on ServerException catch (e) {
      return left(
        Failure(e.message),
      );
    }
  }
}
