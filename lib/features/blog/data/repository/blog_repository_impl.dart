import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:new_blog_app/core/errors/failure.dart';
import 'package:new_blog_app/core/errors/server_exception.dart';
import 'package:new_blog_app/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:new_blog_app/features/blog/data/model/blog_model.dart';
import 'package:new_blog_app/features/blog/domain/entities/blog.dart';
import 'package:new_blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource _blogRemoteDataSource;

  BlogRepositoryImpl({required this._blogRemoteDataSource});

  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required String title,
    required String content,
    required String posterId,
    required File image,
    required List<String> topics,
  }) async {
    try {
      BlogModel blog = BlogModel(
        id: const Uuid().v1(),
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: '',
        updatedAt: DateTime.now(),
        topics: topics,
      );
      final imageUrl = await _blogRemoteDataSource.uploadImage(
        file: image,
        blog: blog,
      );

      blog = blog.copyWith(imageUrl: imageUrl);

      final newBlog = await _blogRemoteDataSource.uploadBlog(blog);
      return right(newBlog);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async {
    try {
      final blogs = await _blogRemoteDataSource.getAllBlogs();
      return right(blogs);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
