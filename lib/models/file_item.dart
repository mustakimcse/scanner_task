class FileItem {
  final int? id;
  final String name;
  final String path;
  final int size;
  final String type;
  final String createdAt;
  final bool isFavorite;

  FileItem({
    this.id,
    required this.name,
    required this.path,
    required this.size,
    required this.type,
    required this.createdAt,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'path': path,
    'size': size,
    'type': type,
    'created_at': createdAt,
    'is_favorite': isFavorite ? 1 : 0,
  };

  factory FileItem.fromMap(Map<String, dynamic> map) => FileItem(
    id: map['id'],
    name: map['name'],
    path: map['path'],
    size: map['size'],
    type: map['type'],
    createdAt: map['created_at'],
    isFavorite: map['is_favorite'] == 1,
  );
}
