import 'package:fpdart/fpdart.dart';
import 'package:new_blog_app/core/errors/failure.dart';
import 'package:new_blog_app/core/usecase/usecase.dart';
import 'package:new_blog_app/core/common/entities/user.dart';
import 'package:new_blog_app/features/auth/domain/repository/auth_repository.dart';

class UserSignUpUsecase implements Usecase<User, UserSignUpParams> {
  final AuthRepository authRepository;

  UserSignUpUsecase({required this.authRepository});
  @override
  Future<Either<Failure, User>> call(UserSignUpParams params) async {
    return await authRepository.signUpWithEmailPassword(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignUpParams {
  final String email;
  final String password;
  final String name;

  UserSignUpParams({
    required this.email,
    required this.password,
    required this.name,
  });
}
