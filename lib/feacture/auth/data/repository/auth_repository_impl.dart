import 'package:blogapp/core/error/exception.dart';
import 'package:blogapp/core/error/failures.dart';
import 'package:blogapp/core/network/connection_checker.dart';
import 'package:blogapp/feacture/auth/data/auth_remote_data_source.dart';
import 'package:blogapp/core/common/entities/user.dart';
import 'package:blogapp/feacture/auth/data/model/user_model.dart';
import 'package:blogapp/feacture/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;
  const AuthRepositoryImpl(this.remoteDataSource, this.connectionChecker);

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final session = remoteDataSource.currentUserSession;
        if(session == null){
          return left(Failure("User is not logged in!"));
        }
        return right(UserModel(id: session.user.id, email:  session.user.email ?? '', name:  'name'));
      }
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
      if (!await (connectionChecker.isConnected)) {
        return left(Failure("No internet connection!"));
      }
      final user = await fn();
      return right(user);
    } on ServerException catch (e) {
      return left(
        Failure(e.message),
      );
    }
  }
}
