import 'dart:io';

import 'package:blogapp/core/error/exception.dart';
import 'package:blogapp/feacture/blog/data/models/blog_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModels> uploadBlog(BlogModels blog);
  Future<String> uploadBlogImage({
    required File image,
    required BlogModels blog,
  });
  Future<List<BlogModels>> getAllBlogs();
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final SupabaseClient supabaseClient;
  BlogRemoteDataSourceImpl(this.supabaseClient);
  @override
  Future<BlogModels> uploadBlog(BlogModels blog) async {
    try {
      final blogdata =
          await supabaseClient.from('blogs').insert(blog.toJason()).select();
      return BlogModels.fromJason(blogdata.first);
    }on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadBlogImage({
    required File image,
    required BlogModels blog,
  }) async {
    try {
      await supabaseClient.storage.from('blog_images').upload(
            blog.id,
            image,
          );
      return supabaseClient.storage.from('blog_images').getPublicUrl(blog.id);
    }on StorageException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BlogModels>> getAllBlogs() async {
    try {
      final blogs =
          await supabaseClient.from('blogs').select('*,profiles (name)');
      return blogs
          .map((blog) => BlogModels.fromJason(blog).copyWith(
                posterName: blog['profiles']['name'],
              ))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
