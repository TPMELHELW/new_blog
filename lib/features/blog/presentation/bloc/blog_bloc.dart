import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_blog_app/features/auth/domain/usecases/current_user_usecase.dart';
import 'package:new_blog_app/features/blog/domain/entities/blog.dart' show Blog;
import 'package:new_blog_app/features/blog/domain/usecases/get_all_blogs_usecase.dart';
import 'package:new_blog_app/features/blog/domain/usecases/upload_blog_usecase.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlogUsecase _uploadBlogUsecase;
  final GetAllBlogsUsecase _getAllBlogsUsecase;
  BlogBloc(this._uploadBlogUsecase, this._getAllBlogsUsecase)
    : super(BlogInitial()) {
    // on<BlogEvent>((event, emit) => emit(BlogLoading()));
    on<BlogUpload>(_onBlogUpload);
    on<GetAllBlogs>(_getAllBlogs);
  }

  void _onBlogUpload(BlogUpload event, Emitter<BlogState> emit) async {
    emit(BlogLoading());
    final data = await _uploadBlogUsecase(
      UploadBlogParams(
        title: event.title,
        content: event.content,
        topics: event.topics,
        image: event.image,
        posterId: event.posterId,
      ),
    );

    data.fold((error) {
      emit(BlogFailure(message: error.message));
      print(error.message);
    }, (r) => emit(BlogUploadSuccess()));
  }

  void _getAllBlogs(GetAllBlogs event, Emitter emit) async {
    emit(BlogLoading());
    final data = await _getAllBlogsUsecase(NoParams());

    data.fold(
      (error) => emit(BlogFailure(message: error.message)),
      (blogs) => emit(BlogDisplaySuccess(blogs: blogs)),
    );
  }
}
