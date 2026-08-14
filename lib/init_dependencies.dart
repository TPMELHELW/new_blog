import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:new_blog_app/core/common/cubit/app_user_cubit.dart';
import 'package:new_blog_app/core/network/connection_checker.dart';
import 'package:new_blog_app/core/secrets/app_secrets.dart';
import 'package:new_blog_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:new_blog_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:new_blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:new_blog_app/features/auth/domain/usecases/current_user_usecase.dart';
import 'package:new_blog_app/features/auth/domain/usecases/user_sign_in_usecase.dart';
import 'package:new_blog_app/features/auth/domain/usecases/user_sign_up_usecase.dart';
import 'package:new_blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:new_blog_app/features/blog/data/datasources/blog_local_data_source.dart';
import 'package:new_blog_app/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:new_blog_app/features/blog/data/repository/blog_repository_impl.dart';
import 'package:new_blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:new_blog_app/features/blog/domain/usecases/get_all_blogs_usecase.dart';
import 'package:new_blog_app/features/blog/domain/usecases/upload_blog_usecase.dart';
import 'package:new_blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final servicesLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  final supabase = await Supabase.initialize(
    url: AppSecrets.url,
    publishableKey: AppSecrets.anonKey,
  );

  Hive.init((await getApplicationDocumentsDirectory()).path);
  servicesLocator.registerFactory(() => InternetConnection());

  servicesLocator.registerLazySingleton(() => supabase.client);
  servicesLocator.registerLazySingleton(() => Hive.box('blogs'));

  servicesLocator.registerLazySingleton(() => AppUserCubit());

  servicesLocator.registerLazySingleton<ConnectionChecker>(
    () => ConnectionCheckerImpl(internetConnection: servicesLocator()),
  );
}

void _initAuth() {
  servicesLocator
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(supabaseClient: servicesLocator()),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        authRemoteDataSource: servicesLocator<AuthRemoteDataSource>(),
        connectionChecker: servicesLocator<ConnectionCheckerImpl>(),
      ),
    )
    ..registerLazySingleton<UserSignUpUsecase>(
      () => UserSignUpUsecase(authRepository: servicesLocator()),
    )
    ..registerLazySingleton(
      () => UserSignInUsecase(authRepository: servicesLocator()),
    )
    ..registerLazySingleton(
      () => CurrentUserUseCase(authRepository: servicesLocator()),
    )
    ..registerFactory(
      () => AuthBloc(
        servicesLocator<UserSignUpUsecase>(),
        servicesLocator<UserSignInUsecase>(),
        servicesLocator<CurrentUserUseCase>(),
        servicesLocator<AppUserCubit>(),
      ),
    );
}

void _initBlog() {
  servicesLocator
    ..registerLazySingleton<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(
        supabaseClient: servicesLocator<SupabaseClient>(),
      ),
    )
    ..registerLazySingleton<BlogLocalDataSource>(
      () => BlogLocalDataSourceImpl(box: servicesLocator()),
    )
    ..registerLazySingleton<BlogRepository>(
      () => BlogRepositoryImpl(
        blogRemoteDataSource: servicesLocator<BlogRemoteDataSource>(),
        connectionChecker: servicesLocator<ConnectionCheckerImpl>(),
        blogLocalDataSource: servicesLocator<BlogLocalDataSource>(),
      ),
    )
    ..registerLazySingleton<UploadBlogUsecase>(
      () =>
          UploadBlogUsecase(blogRepository: servicesLocator<BlogRepository>()),
    )
    ..registerLazySingleton<GetAllBlogsUsecase>(
      () =>
          GetAllBlogsUsecase(blogRepository: servicesLocator<BlogRepository>()),
    )
    ..registerFactory<BlogBloc>(
      () => BlogBloc(
        servicesLocator<UploadBlogUsecase>(),
        servicesLocator<GetAllBlogsUsecase>(),
      ),
    );
}
