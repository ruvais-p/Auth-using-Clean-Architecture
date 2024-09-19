import 'package:blogapp/feacture/blog/data/models/blog_models.dart';
import 'package:hive/hive.dart';

abstract interface class BlogLocalDataSource {
  void uploadLocalBlogs({required List<BlogModels> blogs});
  List<BlogModels> loadBlogs();
}

class BlogLocalDataSourceImpl implements BlogLocalDataSource {
  final Box box;
  BlogLocalDataSourceImpl(this.box);
  @override
  List<BlogModels> loadBlogs() {
    List<BlogModels> blogs = [];
    box.read(() {
      for (int i = 0; i < box.length; i++) {
        blogs.add(
          BlogModels.fromJason(
            box.get(i.toString()),
          ),
        );
      }
    });
    return blogs;
  }

  @override
  void uploadLocalBlogs({required List<BlogModels> blogs}) {
    box.clear();
    box.write(() {
      for (int i = 0; i < blogs.length; i++) {
        box.put(i.toString(), blogs[i].toJason());
      }
    });
  }
}
