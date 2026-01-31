import 'package:flutter/material.dart';
import '../../models/file_item.dart';

class FileDetailsScreen extends StatelessWidget {
  final FileItem file;
  const FileDetailsScreen({super.key, required this.file});

  String size(int b) =>
      '${(b / 1024).toStringAsFixed(2)} KB';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('File Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${file.name}'),
            Text('Type: ${file.type}'),
            Text('Size: ${size(file.size)}'),
            Text('Date: ${file.createdAt}'),
            Text('Path: ${file.path}'),
          ],
        ),
      ),
    );
  }
}
