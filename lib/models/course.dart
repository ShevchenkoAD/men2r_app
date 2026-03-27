import 'package:hive/hive.dart';

part 'course.g.dart';

@HiveType(typeId: 1)
class Course extends HiveObject {
  @HiveField(0)
  late int serverId;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String description;

  @HiveField(3)
  late String startDate;

  @HiveField(4)
  late String endDate;

  @HiveField(5)
  late int tutorId;

  @HiveField(6)
  late int hours;

  @HiveField(7)
  late double price;

  Course({
    required this.serverId,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.tutorId,
    required this.hours,
    required this.price,
  });

  factory Course.fromJson(Map<String, dynamic> json) => Course(
    serverId: json['id'],
    title: json['title'],
    description: json['description'],
    startDate: json['startDate'],
    endDate: json['endDate'],
    tutorId: json['tutorId'],
    hours: json['hours'],
    price: (json['price'] as num).toDouble(),
  );
}