class MdBombPage {
  final String id;
  final String title;
  final String? filePath;
  final bool isJournal;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> tags;

  const MdBombPage({
    required this.id,
    required this.title,
    this.filePath,
    this.isJournal = false,
    required this.createdAt,
    required this.updatedAt,
    this.tags = const [],
  });

  MdBombPage copyWith({
    String? id,
    String? title,
    String? filePath,
    bool? isJournal,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? tags,
  }) {
    return MdBombPage(
      id: id ?? this.id,
      title: title ?? this.title,
      filePath: filePath ?? this.filePath,
      isJournal: isJournal ?? this.isJournal,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
    );
  }

  factory MdBombPage.fromDrift(dynamic driftPage, List<String> tagNames) {
    return MdBombPage(
      id: driftPage.id as String,
      title: driftPage.title as String,
      filePath: driftPage.filePath as String?,
      isJournal: driftPage.isJournal as bool,
      createdAt: driftPage.createdAt as DateTime,
      updatedAt: driftPage.updatedAt as DateTime,
      tags: tagNames,
    );
  }
}
