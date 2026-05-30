import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../domain/models/block.dart';
import '../../domain/models/note.dart';
import '../../domain/models/page.dart';
import '../../domain/models/tag.dart';
import '../../domain/models/template.dart';

class IsarService {
  static Isar? _isar;

  static Future<Isar> get instance async {
    if (_isar != null && _isar!.isOpen) return _isar!;
    return init();
  }

  static Future<Isar> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [PageSchema, BlockSchema, NoteSchema, TagSchema, TemplateSchema],
      directory: dir.path,
      name: 'nexusbrain',
      inspector: true,
    );
    return _isar!;
  }

  static Future<void> close() async {
    await _isar?.close();
    _isar = null;
  }
}
