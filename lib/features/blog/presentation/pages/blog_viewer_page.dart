import 'package:flutter/material.dart';
import 'package:new_blog_app/core/utils/calculate_reading_time.dart';
import 'package:new_blog_app/core/utils/format_date.dart';
import 'package:new_blog_app/features/blog/domain/entities/blog.dart';

class BlogViewerPage extends StatelessWidget {
  static MaterialPageRoute<dynamic> route(Blog blog) =>
      MaterialPageRoute(builder: (context) => BlogViewerPage(blog: blog));
  final Blog blog;

  const BlogViewerPage({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Scrollbar(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            // spacing: 20.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                blog.title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              const SizedBox(height: 20),
              Text(
                'By ${blog.posterName}',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 5.0),
              Text(
                '${formatDateBydMMMYYYY(blog.updatedAt)} . ${calculateReadingTime(blog.content)} min',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0),
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(blog.imageUrl),
              ),
              const SizedBox(height: 20),
              Text(blog.content, style: TextStyle(fontSize: 16.0, height: 2.0)),
            ],
          ),
        ),
      ),
    );
  }
}
