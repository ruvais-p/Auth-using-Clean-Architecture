import 'dart:io';

import 'package:blogapp/core/error/failures.dart';
import 'package:blogapp/feacture/blog/domain/entities/blog.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class BlogRepository{
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required List<String> topics,
    required String posterId,
  });

  Future<Either<Failure, List<Blog>>> getAllBlogs();
}