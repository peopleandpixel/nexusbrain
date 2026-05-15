import 'package:isar_community/isar.dart';
import 'block.dart';
import 'tag.dart';

part 'page.g.dart';

@Collection()
class Page {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String pageId;

  late String title;
  String? filePath;
  bool isJournal = false;
  DateTime? createdAt;
  DateTime? updatedAt;

  final tags = IsarLinks<Tag>();

  Page({
    required this.pageId,
    required this.title,
    this.filePath,
    this.isJournal = false,
    this.createdAt,
    this.updatedAt,
  });
}
