import 'package:hive/hive.dart';

part 'company.g.dart';

@HiveType(typeId: 3)
class Company {
  @HiveField(0)
  String name;
  @HiveField(1)
  String catchPhrase;
  @HiveField(2)
  String bs;

  Company({
    required this.name,
    required this.catchPhrase,
    required this.bs,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        name: json['name'] as String,
        catchPhrase: json['catchPhrase'] as String,
        bs: json['bs'] as String,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'catchPhrase': catchPhrase,
        'bs': bs,
      };
}
