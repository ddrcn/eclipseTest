import 'package:hive/hive.dart';
part 'album.g.dart';

@HiveType(typeId: 6)
class Album {
  @HiveField(0)
  int userId;
  @HiveField(1)
  int id;
  @HiveField(2)
  String title;

  Album({required this.userId, required this.id, required this.title});

  factory Album.fromJson(Map<String, dynamic> json) => Album(
        userId: json['userId'] as int,
        id: json['id'] as int,
        title: json['title'] as String,
      );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'id': id,
        'title': title,
      };
}
