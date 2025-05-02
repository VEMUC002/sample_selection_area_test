import 'package:flutter/material.dart';

class ImageSectionWidget extends StatelessWidget {
  const ImageSectionWidget({super.key, required this.backgroundColor});

  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return _buildImageSection();
  }

  Widget _buildImageSection() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: backgroundColor,
                ),
                child: const Icon(Icons.landscape, size: 80),
              ),
              const SizedBox(height: 8),
              const Text(
                'Nature landscape image with mountains and lakes',
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: backgroundColor,
                ),
                child: const Icon(Icons.pets, size: 80),
              ),
              const SizedBox(height: 8),
              const Text(
                'Cute puppy playing in the grass on a sunny day',
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Image section with captions
