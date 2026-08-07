import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_blog_app/core/common/cubit/app_user_cubit.dart';
import 'package:new_blog_app/core/theme/theme.dart';
import 'package:new_blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:new_blog_app/features/auth/presentation/pages/login_page.dart';
import 'package:new_blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:new_blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:new_blog_app/init_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => servicesLocator<AuthBloc>()),
        BlocProvider<AppUserCubit>(
          create: (_) => servicesLocator<AppUserCubit>(),
        ),
        BlocProvider<BlogBloc>(create: (_) => servicesLocator<BlogBloc>()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // print('ssss');
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.darkThemeMode,
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) {
          return state is AppUserLoggedIn;
        },
        builder: (context, state) {
          if (state) {
            return BlogPage();
          }
          return LoginPage();
        },
      ),
    );
  }
}
