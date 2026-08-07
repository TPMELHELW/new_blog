import 'package:fpdart/fpdart.dart';
import 'package:new_blog_app/core/errors/failure.dart';
import 'package:new_blog_app/core/usecase/usecase.dart';
import 'package:new_blog_app/features/auth/domain/usecases/current_user_usecase.dart';
import 'package:new_blog_app/features/blog/domain/entities/blog.dart';
import 'package:new_blog_app/features/blog/domain/repository/blog_repository.dart';

class GetAllBlogsUsecase implements Usecase<List<Blog>, NoParams> {
  final BlogRepository _blogRepository;

  GetAllBlogsUsecase({required this._blogRepository});

  @override
  Future<Either<Failure, List<Blog>>> call(NoParams params) async {
    return await _blogRepository.getAllBlogs();
  }
}
