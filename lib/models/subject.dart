import 'package:hive/hive.dart';

part 'subject.g.dart';

@HiveType(typeId: 2)
class Subject extends HiveObject {
  @HiveField(0)
  late int id;

  @HiveField(1)
  late String name;

  Subject({required this.id, required this.name});

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
    id: json['id'],
    name: json['name'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}