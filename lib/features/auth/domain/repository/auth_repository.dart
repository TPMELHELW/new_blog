import 'package:fpdart/fpdart.dart';
import 'package:new_blog_app/core/errors/failure.dart';
import 'package:new_blog_app/core/common/entities/user.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<Either<Failure, User>> logIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> currentUser();
}
