import 'package:flutter/material.dart';
import '../../models/tutor.dart';

class TutorCard extends StatelessWidget {
  final Tutor tutor;
  final VoidCallback onTap;

  const TutorCard({super.key, required this.tutor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text("${tutor.firstname} ${tutor.lastname}", 
          style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(tutor.subjects, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}