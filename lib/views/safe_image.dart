import 'package:flutter/material.dart';

// Round profile picture. If the image file is missing, shows a person icon
// instead of crashing.
class SafeAvatar extends StatelessWidget {
  const SafeAvatar({super.key, required this.path, required this.radius});

  final String path;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey.shade300,
      child: ClipOval(
        child: Image.asset(
          path,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
          errorBuilder: (context, error, stack) =>
              Icon(Icons.person, size: radius, color: Colors.grey.shade600),
        ),
      ),
    );
  }
}

// The big picture inside a post. If the file is missing, shows a grey box.
class SafePostImage extends StatelessWidget {
  const SafePostImage({super.key, required this.path, this.height = 350});

  final String path;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Image.asset(
        path,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stack) => Container(
          color: Colors.grey.shade300,
          child: Icon(
            Icons.image_not_supported,
            size: 48,
            color: Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}