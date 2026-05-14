// Deprecated — replaced by block-based architecture
class Note {
  final String id;
  final String title;
  final String? content;
  final String? filePath;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<String> tags;
  final List<String> topics;
  const Note({required this.id, required this.title, this.content, this.filePath, this.createdAt, this.updatedAt, this.tags = const [], this.topics = const []});
  Note copyWith({String? id, String? title, String? content, String? filePath, DateTime? createdAt, DateTime? updatedAt, List<String>? tags, List<String>? topics}) => Note(id: id ?? this.id, title: title ?? this.title, content: content ?? this.content, filePath: filePath ?? this.filePath, createdAt: createdAt ?? this.createdAt, updatedAt: updatedAt ?? this.updatedAt, tags: tags ?? this.tags, topics: topics ?? this.topics);
}
