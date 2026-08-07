import 'package:new_blog_app/features/blog/domain/entities/blog.dart';

class BlogModel extends Blog {
  BlogModel({
    required super.id,
    required super.posterId,
    required super.title,
    required super.content,
    required super.imageUrl,
    required super.updatedAt,
    required super.topics,
    super.posterName,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'poster_id': posterId,
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'topics': topics,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory BlogModel.fromJson(Map<String, dynamic> data) {
    return BlogModel(
      id: data['id'],
      posterId: data['poster_id'],
      title: data['title'],
      content: data['content'],
      imageUrl: data['image_url'],
      updatedAt: data['updated_at'] == null
          ? DateTime.now()
          : DateTime.parse(data['updated_at']),
      topics: List<String>.from(data['topics'] ?? []),
    );
  }

  BlogModel copyWith({
    String? title,
    String? content,
    String? imageUrl,
    List<String>? topics,
    String? id,
    String? posterId,
    DateTime? updatedAt,
    String? posterName,
  }) {
    return BlogModel(
      id: id ?? this.id,
      posterId: posterId ?? this.posterId,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      updatedAt: updatedAt ?? this.updatedAt,
      topics: topics ?? this.topics,
      posterName: posterName ?? this.posterName,
    );
  }
}
