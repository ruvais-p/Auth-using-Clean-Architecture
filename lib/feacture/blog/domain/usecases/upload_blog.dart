import 'dart:io';

import 'package:blogapp/core/error/failures.dart';
import 'package:blogapp/core/usecase/usecase.dart';
import 'package:blogapp/feacture/blog/domain/entities/blog.dart';
import 'package:blogapp/feacture/blog/domain/repositories/blog_repositories.dart';
import 'package:fpdart/src/either.dart';

class UploadBlog implements UseCase<Blog, UploadBlogParam> {
  final BlogRepository blogRepository;
  UploadBlog(this.blogRepository);
  @override
  Future<Either<Failure, Blog>> call(UploadBlogParam params) async {
    return await blogRepository.uploadBlog(
      image: params.image,
      title: params.title,
      content: params.content,
      topics: params.topics,
      posterId: params.posterId,
    );
  }
}

class UploadBlogParam {
  final String posterId;
  final String title;
  final String content;
  final File image;
  final List<String> topics;

  UploadBlogParam({
    required this.posterId,
    required this.title,
    required this.content,
    required this.image,
    required this.topics,
  });
}
