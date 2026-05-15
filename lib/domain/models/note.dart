import 'package:isar_community/isar.dart';

part 'note.g.dart';

@Collection()
class Note {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String noteId;

  late String title;
  String? content;
  String? filePath;
  DateTime? createdAt;
  DateTime? updatedAt;

  @Index(type: IndexType.value, caseSensitive: false)
  List<String> get contentWords =>
      (content ?? '').toLowerCase().split(RegExp(r'\s+'));

  Note({
    required this.noteId,
    required this.title,
    this.content,
    this.filePath,
    this.createdAt,
    this.updatedAt,
  });
}
