import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_blog_app/core/common/widgets/loader.dart';
import 'package:new_blog_app/core/theme/app_pallete.dart';
import 'package:new_blog_app/core/utils/show_snackbar.dart';
import 'package:new_blog_app/features/auth/presentation/pages/login_page.dart';
import 'package:new_blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:new_blog_app/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:new_blog_app/features/blog/presentation/widgets/blog_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BlogPage extends StatefulWidget {
  static MaterialPageRoute<dynamic> route() =>
      MaterialPageRoute(builder: (context) => BlogPage());
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    context.read<BlogBloc>().add(GetAllBlogs());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog Page'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, AddNewBlogPage.route());
            },
            icon: Icon(CupertinoIcons.add_circled),
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () {
            Supabase.instance.client.auth.signOut();
            Navigator.push(context, LoginPage.route());
          },
        ),
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return Loader();
          }
          if (state is BlogDisplaySuccess) {
            return ListView.builder(
              itemCount: state.blogs.length,
              itemBuilder: (context, index) {
                final blog = state.blogs[index];
                return BlogCard(
                  blog: blog,
                  color: index % 2 == 1
                      ? AppPallete.gradient1
                      : AppPallete.gradient2,
                );
              },
            );
          }
          return Text('dd');
        },
      ),
    );
  }
}
