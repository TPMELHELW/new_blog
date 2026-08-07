import 'package:fpdart/fpdart.dart';
import 'package:new_blog_app/core/errors/failure.dart';

abstract interface class Usecase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}
