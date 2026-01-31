import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../database/db_helper.dart';
import '../models/file_item.dart';
import 'file_event.dart';
import 'file_state.dart';

class FileBloc extends Bloc<FileEvent, FileState> {
  final DBHelper db;

  List<FileItem> _allFiles = [];

  FileBloc(this.db) : super(FileLoading()) {
    on<LoadFiles>(_loadFiles);
    on<AddFile>(_addFile);
    on<DeleteFile>(_deleteFile);
    on<ToggleFavorite>(_toggleFavorite);
    on<SearchFiles>(_searchFiles);
  }

  Future<void> _loadFiles(
      LoadFiles event, Emitter<FileState> emit) async {
    try {
      _allFiles = await db.fetchFiles();
      _allFiles.removeWhere((f) => !File(f.path).existsSync());
      emit(FileLoaded(_allFiles));
    } catch (e) {
      emit(FileError('Failed to load files'));
    }
  }

  Future<void> _addFile(
      AddFile event, Emitter<FileState> emit) async {
    await db.insertFile(event.file);
    add(LoadFiles());
  }

  Future<void> _deleteFile(
      DeleteFile event, Emitter<FileState> emit) async {
    if (event.file.id != null) {
      await db.deleteFile(event.file.id!);
      add(LoadFiles());
    }
  }

  Future<void> _toggleFavorite(
      ToggleFavorite event, Emitter<FileState> emit) async {
    if (event.file.id != null) {
      await db.toggleFavorite(
          event.file.id!, !event.file.isFavorite);
      add(LoadFiles());
    }
  }

  void _searchFiles(
      SearchFiles event, Emitter<FileState> emit) {
    final filtered = _allFiles
        .where((f) =>
        f.name.toLowerCase().contains(event.query.toLowerCase()))
        .toList();
    emit(FileLoaded(filtered));
  }
}
