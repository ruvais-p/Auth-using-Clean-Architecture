import 'package:blogapp/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blogapp/core/network/connection_checker.dart';
import 'package:blogapp/core/secretes/keys.dart';
import 'package:blogapp/feacture/auth/data/auth_remote_data_source.dart';
import 'package:blogapp/feacture/auth/data/repository/auth_repository_impl.dart';
import 'package:blogapp/feacture/auth/domain/repository/auth_repository.dart';
import 'package:blogapp/feacture/auth/domain/usecases/current_user.dart';
import 'package:blogapp/feacture/auth/domain/usecases/user_login.dart';
import 'package:blogapp/feacture/auth/domain/usecases/user_sign_up.dart';
import 'package:blogapp/feacture/auth/presentation/bloc/auth_bloc.dart';
import 'package:blogapp/feacture/blog/data/datasources/blog_local_data_source.dart';
import 'package:blogapp/feacture/blog/data/datasources/blog_remote_data_source.dart';
import 'package:blogapp/feacture/blog/data/repositories/blog_repository_impl.dart';
import 'package:blogapp/feacture/blog/domain/repositories/blog_repositories.dart';
import 'package:blogapp/feacture/blog/domain/usecases/get_all_blogs.dart';
import 'package:blogapp/feacture/blog/domain/usecases/upload_blog.dart';
import 'package:blogapp/feacture/blog/presentation/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;
Future<void> init_dependency() async {
  _initAuth();
  _initBlog();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.anonKey,
  );

  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  serviceLocator.registerLazySingleton(() => supabase.client);

  serviceLocator.registerLazySingleton(() => Hive.box(name: 'blogs'));

  serviceLocator.registerFactory(
    () => InternetConnection(),
  );
  serviceLocator.registerLazySingleton(
    () => AppUserCubit(),
  );
  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(
      serviceLocator(),
    ),
  );
}

void _initAuth() {
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
      serviceLocator(),
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => UserSignUp(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => UserLogin(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => CurrentUser(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      userSignUp: serviceLocator(),
      userLogin: serviceLocator(),
      currentUser: serviceLocator(),
      appUserCubit: serviceLocator(),
    ),
  );
}

void _initBlog() {
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<BlogLocalDataSource>(
      () => BlogLocalDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UploadBlog(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetAllBlogs(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => BlogBloc(
        uploadBlog: serviceLocator(),
        getAllBlogs: serviceLocator(),
      ),
    );
}
