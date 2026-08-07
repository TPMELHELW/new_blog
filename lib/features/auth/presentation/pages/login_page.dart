import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_blog_app/core/common/widgets/loader.dart';
import 'package:new_blog_app/core/theme/app_pallete.dart';
import 'package:new_blog_app/core/utils/show_snackbar.dart';
import 'package:new_blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:new_blog_app/features/auth/presentation/pages/signup_page.dart';
import 'package:new_blog_app/features/auth/presentation/widgets/auth_field_widget.dart';
import 'package:new_blog_app/features/auth/presentation/widgets/gredient_button_widget.dart';

class LoginPage extends StatefulWidget {
  static MaterialPageRoute<dynamic> route() =>
      MaterialPageRoute(builder: (context) => const LoginPage());
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    // nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Signup')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              showSnackBar(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return Loader();
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Sign In.",
                  style: TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.0),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 12,
                    children: [
                      // AuthFieldWidget(hintText: 'Name', controller: nameController),
                      AuthFieldWidget(
                        hintText: 'Email',
                        controller: emailController,
                      ),
                      AuthFieldWidget(
                        hintText: 'Password',
                        controller: passwordController,
                        isObscure: true,
                      ),
                      GredientButtonWidget(
                        text: 'Sign In',
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          context.read<AuthBloc>().add(
                            UserSignIn(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            ),
                          );
                        },
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: "Don`t have an account? ",
                          style: Theme.of(context).textTheme.titleMedium,
                          children: [
                            TextSpan(
                              text: "Sign Up",
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: AppPallete.gradient1,
                                    fontWeight: FontWeight.bold,
                                  ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Navigate to the login page
                                  Navigator.push(context, SignupPage.route());
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
