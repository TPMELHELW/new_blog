import 'package:fpdart/src/either.dart';
import 'package:new_blog_app/core/errors/failure.dart';
import 'package:new_blog_app/core/usecase/usecase.dart';
import 'package:new_blog_app/core/common/entities/user.dart';
import 'package:new_blog_app/features/auth/domain/repository/auth_repository.dart';

class CurrentUserUseCase implements Usecase<User, NoParams> {
  final AuthRepository _authRepository;

  CurrentUserUseCase({required this._authRepository});
  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await _authRepository.currentUser();
  }
}

class NoParams {}
