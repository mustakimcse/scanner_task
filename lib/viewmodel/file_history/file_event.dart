

import '../../models/file_item.dart';

abstract class FileEvent {}

class LoadFiles extends FileEvent {}

class AddFile extends FileEvent {
  final FileItem file;
  AddFile(this.file);
}

class DeleteFile extends FileEvent {
  final FileItem file;
  DeleteFile(this.file);
}

class ToggleFavorite extends FileEvent {
  final FileItem file;
  ToggleFavorite(this.file);
}

class SearchFiles extends FileEvent {
  final String query;
  SearchFiles(this.query);
}
