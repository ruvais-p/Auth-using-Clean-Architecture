import 'dart:io';

import 'package:blogapp/core/error/exception.dart';
import 'package:blogapp/core/error/failures.dart';
import 'package:blogapp/core/network/connection_checker.dart';
import 'package:blogapp/feacture/blog/data/datasources/blog_local_data_source.dart';
import 'package:blogapp/feacture/blog/data/datasources/blog_remote_data_source.dart';
import 'package:blogapp/feacture/blog/data/models/blog_models.dart';
import 'package:blogapp/feacture/blog/domain/entities/blog.dart';
import 'package:blogapp/feacture/blog/domain/repositories/blog_repositories.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;
  final BlogLocalDataSource blogLocalDataSource;
  final ConnectionChecker connectionChecker;
  BlogRepositoryImpl(this.blogRemoteDataSource, this.blogLocalDataSource, this.connectionChecker);
  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required List<String> topics,
    required String posterId,
  }) async {
    try {
      if(!await (connectionChecker.isConnected)){
        return left(Failure('No internet connection'));
      }
      BlogModels blogModel = BlogModels(
        id: const Uuid().v1(),
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: '',
        topics: topics,
        updatedAt: DateTime.now(),
      );
      final imageUrl = await blogRemoteDataSource.uploadBlogImage(
        image: image,
        blog: blogModel,
      );
      blogModel = blogModel.copyWith(
        imageUrl: imageUrl,
      );

      final uploadBlog = await blogRemoteDataSource.uploadBlog(
        blogModel,
      );
      return right(uploadBlog);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async {
    try {
      if(!await (connectionChecker.isConnected)){
        final blogs = blogLocalDataSource.loadBlogs();
        return right(blogs);
      }
      final blogs = await blogRemoteDataSource.getAllBlogs();
      blogLocalDataSource.uploadLocalBlogs(blogs: blogs);
      return right(blogs);
    } on ServerException catch (e) {
      throw left(Failure(e.toString()));
    }
  }
}
