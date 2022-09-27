import 'package:hive/hive.dart';
part 'geo.g.dart';

@HiveType(typeId: 2)
class Geo {
  @HiveField(0)
  String lat;
  @HiveField(1)
  String lng;

  Geo({required this.lat, required this.lng});

  factory Geo.fromJson(Map<String, dynamic> json) => Geo(
        lat: json['lat'] as String,
        lng: json['lng'] as String,
      );

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
      };
}
