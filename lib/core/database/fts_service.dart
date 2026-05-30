import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

/// Service für die Volltextsuche (Full-Text Search) mittels SQLite FTS5.
///
/// Dieser Service verwaltet eine separate SQLite-Datenbank, die speziell für
/// performante Textsuche über alle Blöcke und Seitentitel optimiert ist.
class FtsService {
  static Database? _db;
  static const String _dbName = 'fts_search.db';

  /// Gibt die Singleton-Instanz der FTS-Datenbank zurück.
  static Future<Database> get instance async {
    if (_db != null) return _db!;
    return _init();
  }

  /// Initialisiert die FTS-Datenbank und erstellt die virtuelle Tabelle.
  static Future<Database> _init() async {
    if (kIsWeb || (Platform.environment.containsKey('FLUTTER_TEST'))) {
      // In-memory Fallback für Web und Tests
      _db = sqlite3.openInMemory();
    } else {
      final dir = await getApplicationDocumentsDirectory();
      final dbPath = p.join(dir.path, _dbName);
      _db = sqlite3.open(dbPath);
    }

    final db = _db!;

    // FTS5 Tabelle erstellen falls sie nicht existiert
    db.execute('''
      CREATE VIRTUAL TABLE IF NOT EXISTS search_index USING fts5(
        blockId UNINDEXED,
        pageId UNINDEXED,
        content,
        tokenize='unicode61'
      );
    ''');

    _db = db;
    return db;
  }

  /// Synchronisiert einen Block (oder einen Seitentitel) mit dem FTS-Index.
  ///
  /// Bestehende Einträge für die [blockId] werden vorher entfernt.
  static Future<void> syncBlock(String blockId, String pageId, String content) async {
    final db = await instance;
    db.execute('DELETE FROM search_index WHERE blockId = ?', [blockId]);
    db.execute(
      'INSERT INTO search_index (blockId, pageId, content) VALUES (?, ?, ?)',
      [blockId, pageId, content],
    );
  }

  /// Entfernt einen Block anhand seiner [blockId] aus dem FTS-Index.
  static Future<void> deleteBlock(String blockId) async {
    final db = await instance;
    db.execute('DELETE FROM search_index WHERE blockId = ?', [blockId]);
  }

  /// Entfernt alle Einträge einer Seite anhand ihrer [pageId] aus dem FTS-Index.
  static Future<void> deletePage(String pageId) async {
    final db = await instance;
    db.execute('DELETE FROM search_index WHERE pageId = ?', [pageId]);
  }

  /// Führt eine Volltextsuche durch.
  ///
  /// Gibt eine Liste von Maps zurück, die `blockId`, `pageId` und ein `highlight` (Snippet) enthalten.
  static Future<List<Map<String, String>>> search(String query) async {
    final db = await instance;
    // SQLite FTS5 Suche mit Snippet für bessere Suchergebnisse
    // Wir nutzen snippet() um den relevanten Teil des Inhalts hervorzuheben
    // Escaping des Suchbegriffs für FTS5 (einfaches Einpacken in Anführungszeichen)
    final sanitizedQuery = query.replaceAll('"', '""');
    final results = db.select(
      "SELECT blockId, pageId, snippet(search_index, 2, '<b>', '</b>', '...', 10) as highlight FROM search_index WHERE content MATCH ? ORDER BY rank",
      ['"$sanitizedQuery"'],
    );

    return results.map((row) => {
      'blockId': row['blockId'] as String,
      'pageId': row['pageId'] as String,
      'highlight': row['highlight'] as String,
    },).toList();
  }

  /// Schließt die Datenbankverbindung.
  static Future<void> close() async {
    _db?.close();
    _db = null;
  }
}
