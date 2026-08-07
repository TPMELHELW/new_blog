import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:new_blog_app/core/errors/failure.dart';
import 'package:new_blog_app/core/usecase/usecase.dart';
import 'package:new_blog_app/features/blog/domain/entities/blog.dart';
import 'package:new_blog_app/features/blog/domain/repository/blog_repository.dart';

class UploadBlogUsecase implements Usecase<Blog, UploadBlogParams> {
  final BlogRepository _blogRepository;

  UploadBlogUsecase({required this._blogRepository});
  @override
  Future<Either<Failure, Blog>> call(UploadBlogParams params) async {
    return await _blogRepository.uploadBlog(
      title: params.title,
      content: params.content,
      posterId: params.posterId,
      image: params.image,
      topics: params.topics,
    );
  }
}

class UploadBlogParams {
  final String title;
  final String content;
  final List<String> topics;
  final File image;
  final String posterId;

  UploadBlogParams({
    required this.title,
    required this.content,
    required this.topics,
    required this.image,
    required this.posterId,
  });
}
