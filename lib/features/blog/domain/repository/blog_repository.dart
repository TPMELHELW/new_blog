import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:new_blog_app/core/errors/failure.dart';
import 'package:new_blog_app/features/blog/domain/entities/blog.dart';

abstract interface class BlogRepository {
  Future<Either<Failure, Blog>> uploadBlog({
    required String title,
    required String content,
    required String posterId,
    required File image,
    required List<String> topics,
  });

  Future<Either<Failure, List<Blog>>> getAllBlogs();
}
