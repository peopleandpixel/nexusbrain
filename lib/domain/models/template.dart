import 'package:isar_community/isar.dart';

part 'template.g.dart';

@Collection()
class Template {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String templateId;

  late String name;
  String? description;
  
  /// Der Inhalt des Templates (z.B. Markdown-Struktur oder JSON-Blöcke).
  late String content;
  
  /// Kategorie des Templates (z.B. 'Meeting', 'Journal', 'Project').
  String? category;

  /// Metadaten oder Tags für das Template.
  List<String> tags = [];

  /// Quelle des Templates (z.B. 'user', 'plugin:my_plugin').
  String source = 'user';

  DateTime? createdAt;
  DateTime? updatedAt;

  Template({
    required this.templateId,
    required this.name,
    this.description,
    required this.content,
    this.category,
    this.tags = const [],
    this.source = 'user',
    this.createdAt,
    this.updatedAt,
  });
}
