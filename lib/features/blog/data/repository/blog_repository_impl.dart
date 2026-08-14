import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:new_blog_app/core/errors/failure.dart';
import 'package:new_blog_app/core/errors/server_exception.dart';
import 'package:new_blog_app/core/network/connection_checker.dart';
import 'package:new_blog_app/features/blog/data/datasources/blog_local_data_source.dart';
import 'package:new_blog_app/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:new_blog_app/features/blog/data/model/blog_model.dart';
import 'package:new_blog_app/features/blog/domain/entities/blog.dart';
import 'package:new_blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource _blogRemoteDataSource;
  final BlogLocalDataSource _blogLocalDataSource;
  final ConnectionChecker connectionChecker;
  BlogRepositoryImpl({
    required this._blogRemoteDataSource,
    required this._blogLocalDataSource,
    required this.connectionChecker,
  });

  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required String title,
    required String content,
    required String posterId,
    required File image,
    required List<String> topics,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure('No internet connection'));
      }
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
      if (!await (connectionChecker.isConnected)) {
        final blogs = _blogLocalDataSource.loadBlogs();
        return right(blogs);
      }
      final blogs = await _blogRemoteDataSource.getAllBlogs();
      _blogLocalDataSource.uploadLocalBlogs(blogs: blogs);
      return right(blogs);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
