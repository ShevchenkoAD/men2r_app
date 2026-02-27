import 'package:flutter/material.dart';
import '../../models/course.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback onTap;

  const CourseCard({super.key, required this.course, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.book)),
        title: Text(course.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(course.date),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}