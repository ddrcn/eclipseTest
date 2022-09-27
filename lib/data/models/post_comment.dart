import 'package:hive/hive.dart';
part 'post_comment.g.dart';

@HiveType(typeId: 7)
class PostComment {
  @HiveField(0)
  int postId;
  @HiveField(1)
  int id;
  @HiveField(2)
  String name;
  @HiveField(3)
  String email;
  @HiveField(4)
  String body;

  PostComment({
    required this.postId,
    required this.id,
    required this.name,
    required this.email,
    required this.body,
  });

  factory PostComment.fromJson(Map<String, dynamic> json) => PostComment(
        postId: json['postId'] as int,
        id: json['id'] as int,
        name: json['name'] as String,
        email: json['email'] as String,
        body: json['body'] as String,
      );

  Map<String, dynamic> toJson() => {
        'postId': postId,
        'id': id,
        'name': name,
        'email': email,
        'body': body,
      };
}
