import 'package:hive/hive.dart';

part 'tutor.g.dart';

@HiveType(typeId: 2)
class Tutor extends HiveObject {
  @HiveField(0)
  late int serverId;

  @HiveField(1)
  late String lastname;

  @HiveField(2)
  late String firstname;

  @HiveField(3)
  String? patronymic;

  @HiveField(4)
  late int experience;

  @HiveField(5)
  late String description;

  @HiveField(6)
  late String subjects;

  Tutor({
    required this.serverId,
    required this.lastname,
    required this.firstname,
    this.patronymic,
    required this.experience,
    required this.description,
    required this.subjects,
  });

  factory Tutor.fromJson(Map<String, dynamic> json) => Tutor(
    serverId: json['id'],
    lastname: json['lastname'],
    firstname: json['firstname'],
    patronymic: json['patronymic'],
    experience: json['experience'],
    description: json['description'],
    subjects: json['subjects'],
  );
}