import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/tutor.dart';

class TutorCard extends StatelessWidget {
  final Tutor tutor;
  final VoidCallback onTap;

  const TutorCard({super.key, required this.tutor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    
    final String subjectsString = tutor.subjects != null 
        ? tutor.subjects!.map((s) => s.name).join(', ') 
        : '';

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        
        leading: Hero(
          tag: 'tutor_photo_${tutor.serverId}', 
          child: CircleAvatar(
            backgroundColor: Colors.blue.shade100,
            backgroundImage: tutor.imageUrl != null && tutor.imageUrl!.isNotEmpty
                ? CachedNetworkImageProvider(tutor.imageUrl!)
                : null,
            child: tutor.imageUrl == null || tutor.imageUrl!.isEmpty
                ? const Icon(Icons.person, color: Colors.blue)
                : null,
          ),
        ),
        title: Text(
          "${tutor.firstname} ${tutor.lastname}", 
          style: const TextStyle(fontWeight: FontWeight.bold)
        ),
        subtitle: Text(
          subjectsString, 
          maxLines: 1, 
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.grey.shade600),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        onTap: onTap,
      ),
    );
  }
}