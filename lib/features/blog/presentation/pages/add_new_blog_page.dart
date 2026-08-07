import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_blog_app/core/common/cubit/app_user_cubit.dart';
import 'package:new_blog_app/core/common/widgets/loader.dart';
import 'package:new_blog_app/core/theme/app_pallete.dart';
import 'package:new_blog_app/core/utils/pick_image.dart';
import 'package:new_blog_app/core/utils/show_snackbar.dart';
import 'package:new_blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:new_blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:new_blog_app/features/blog/presentation/widgets/blog_editor.dart';

class AddNewBlogPage extends StatefulWidget {
  static MaterialPageRoute<dynamic> route() =>
      MaterialPageRoute(builder: (context) => const AddNewBlogPage());
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  List<String> selectedTopics = [];
  File? selectedImage;
  void selectImage() async {
    final file = await pickImage();
    if (file != null) {
      setState(() {
        selectedImage = file;
      });
    }
  }

  void uploadBlog() {
    if (!_formState.currentState!.validate() ||
        selectedTopics.isEmpty ||
        selectedImage == null) {
      return;
    }
    final posterId =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
    context.read<BlogBloc>().add(
      BlogUpload(
        title: titleController.text.trim(),
        content: contentController.text.trim(),
        posterId: posterId,
        topics: selectedTopics,
        image: selectedImage!,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: uploadBlog, icon: Icon(Icons.done_rounded)),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.message);
          }
          if (state is BlogUploadSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              BlogPage.route(),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          // print(state);
          if (state is BlogLoading) {
            // print('ddd');
            return Loader();
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formState,
              child: Column(
                spacing: 10.0,
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  selectedImage != null
                      ? GestureDetector(
                          onTap: selectImage,
                          child: SizedBox(
                            height: 150.0,
                            width: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.file(
                                selectedImage!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: selectImage,

                          child: DottedBorder(
                            // options: DottedBorderOptions(borderType: null),
                            options: RectDottedBorderOptions(
                              color: AppPallete.borderColor,
                              dashPattern: [10, 4],
                            ),
                            child: SizedBox(
                              height: 150.0,
                              width: double.infinity,
                              child: Column(
                                spacing: 15.0,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.folder_open, size: 40.0),
                                  Text(
                                    "Select your image",
                                    style: TextStyle(fontSize: 15.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          [
                                'Technology',
                                'Business',
                                'Programming',
                                'Entertainment',
                              ]
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (selectedTopics.contains(e)) {
                                        selectedTopics.remove(e);
                                      } else {
                                        selectedTopics.add(e);
                                      }
                                      setState(() {});
                                    },
                                    child: Chip(
                                      color: selectedTopics.contains(e)
                                          ? WidgetStatePropertyAll(
                                              AppPallete.gradient1,
                                            )
                                          : null,
                                      label: Text(e),
                                      side: selectedTopics.contains(e)
                                          ? null
                                          : BorderSide(
                                              color: AppPallete.borderColor,
                                            ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ),

                  BlogEditor(controller: titleController, hint: 'Blog Title'),
                  // SizedBox(height: 10.0),
                  BlogEditor(
                    controller: contentController,
                    hint: 'Blog Content',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
