import 'package:fpdart/fpdart.dart';
import 'package:new_blog_app/core/errors/failure.dart';
import 'package:new_blog_app/core/usecase/usecase.dart';
import 'package:new_blog_app/core/common/entities/user.dart';
import 'package:new_blog_app/features/auth/domain/repository/auth_repository.dart';

class UserSignInUsecase implements Usecase<User, UserSignInParams> {
  final AuthRepository _authRepository;

  UserSignInUsecase({required this._authRepository});

  @override
  Future<Either<Failure, User>> call(UserSignInParams params) async {
    return await _authRepository.logIn(
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignInParams {
  final String email;
  final String password;

  UserSignInParams({required this.email, required this.password});
}
