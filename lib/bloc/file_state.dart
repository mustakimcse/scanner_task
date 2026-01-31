import '../models/file_item.dart';

abstract class FileState {}

class FileLoading extends FileState {}

class FileLoaded extends FileState {
  final List<FileItem> files;
  FileLoaded(this.files);
}

class FileError extends FileState {
  final String message;
  FileError(this.message);
}
