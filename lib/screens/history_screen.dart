import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scanner_project/screens/scanner_screen.dart';
import '../bloc/file_bloc.dart';
import '../bloc/file_event.dart';
import '../bloc/file_state.dart';
import '../widgets/file_tile.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('File History')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ScannerScreen(),
            ),
          );
        },
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search file',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (v) =>
                  context.read<FileBloc>().add(SearchFiles(v)),
            ),
          ),
          Expanded(
            child: BlocBuilder<FileBloc, FileState>(
              builder: (context, state) {
                if (state is FileLoading) {
                  return const Center(
                      child: CircularProgressIndicator());
                }
                if (state is FileLoaded) {
                  if (state.files.isEmpty) {
                    return const Center(
                        child: Text('No files'));
                  }
                  return ListView.builder(
                    itemCount: state.files.length,
                    itemBuilder: (_, i) =>
                        FileTile(file: state.files[i]),
                  );
                }
                return const Center(child: Text('Error'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
