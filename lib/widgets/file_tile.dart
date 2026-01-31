import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/file_bloc.dart';
import '../bloc/file_event.dart';
import '../models/file_item.dart';
import '../screens/file_details_screen.dart';

class FileTile extends StatelessWidget {
  final FileItem file;
  const FileTile({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(file.name),
      subtitle: Text(file.type),
      trailing: Wrap(
        children: [
          IconButton(
            icon: Icon(
              file.isFavorite ? Icons.star : Icons.star_border,
              color: Colors.amber,
            ),
            onPressed: () => context
                .read<FileBloc>()
                .add(ToggleFavorite(file)),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => context
                .read<FileBloc>()
                .add(DeleteFile(file)),
          ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FileDetailsScreen(file: file),
          ),
        );
      },
    );
  }
}
