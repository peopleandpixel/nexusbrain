import 'package:isar_community/isar.dart';
import 'page.dart';

part 'tag.g.dart';

@Collection()
class Tag {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String name;

  String? color;
  DateTime? createdAt;

  final pages = IsarLinks<Page>();

  Tag({
    required this.name,
    this.color,
    this.createdAt,
  });
}
