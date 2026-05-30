import 'package:isar_community/isar.dart';
import '../../domain/models/block.dart';

/// Die `QueryEngine` ermöglicht komplexe Abfragen über Blöcke und Beziehungen.
/// Sie unterstützt Filter für Task-Status, Inhalte, Zeiträume und mehr.
class QueryEngine {
  final Isar isar;

  QueryEngine(this.isar);

  /// Führt eine Query aus und gibt eine Liste von Blöcken zurück.
  /// 
  /// Das [query] Format ist ein Map-basiertes DSL:
  /// {
  ///   'task': 'TODO', // Filtert nach Task-Status
  ///   'content': 'Suche', // Filtert nach Inhalt (enthält)
  ///   'pageId': '...', // Filtert nach einer bestimmten Seite
  ///   'scheduledBetween': [start, end], // Filtert nach Datum
  ///   'isOverdue': true, // Filtert nach überfälligen Tasks
  /// }
  Future<List<Block>> findBlocks(Map<String, dynamic> query) async {
    var filter = isar.blocks.filter();

    if (query.containsKey('task')) {
      final taskState = query['task'] as String?;
      if (taskState == null) {
        filter = filter.taskStateIsNotNull();
      } else {
        filter = filter.taskStateEqualTo(taskState);
      }
    }

    if (query.containsKey('content')) {
      final content = query['content'] as String;
      filter = filter.contentContains(content, caseSensitive: false);
    }

    if (query.containsKey('pageId')) {
      final pageId = query['pageId'] as String;
      filter = filter.pageIdEqualTo(pageId);
    }

    if (query.containsKey('scheduledAfter')) {
      final date = query['scheduledAfter'] as DateTime;
      filter = filter.scheduledAtGreaterThan(date);
    }

    if (query.containsKey('scheduledBefore')) {
      final date = query['scheduledBefore'] as DateTime;
      filter = filter.scheduledAtLessThan(date);
    }

    if (query.containsKey('deadlineAfter')) {
      final date = query['deadlineAfter'] as DateTime;
      filter = filter.deadlineAtGreaterThan(date);
    }

    if (query.containsKey('deadlineBefore')) {
      final date = query['deadlineBefore'] as DateTime;
      filter = filter.deadlineAtLessThan(date);
    }

    if (query.containsKey('isOverdue') && query['isOverdue'] == true) {
      final now = DateTime.now();
      filter = filter.group((q) => q
          .deadlineAtLessThan(now)
          .and()
          .not()
          .taskStateEqualTo('DONE')
          .and()
          .not()
          .taskStateEqualTo('CANCELLED'),);
    }

    return (filter as QueryBuilder<Block, Block, QQueryOperations>).findAll();
  }

  /// Parsed einen String im Logseq-ähnlichen Query-Stil.
  /// Beispiel: `{{query (task TODO)}}` oder einfach `(task TODO)`
  Future<List<Block>> executeStringQuery(String queryString) async {
    final queryMap = parseQueryString(queryString);
    return findBlocks(queryMap);
  }

  /// Ein einfacher Parser für Query-Strings.
  Map<String, dynamic> parseQueryString(String query) {
    final result = <String, dynamic>{};
    
    // Einfaches Regex-Parsing für (key value) Paare
    final regExp = RegExp(r'\((\w+)\s+([^)]+)\)');
    final matches = regExp.allMatches(query);
    
    for (final match in matches) {
      final key = match.group(1);
      final value = match.group(2)?.trim();
      
      if (key == 'task') {
        result['task'] = value;
      } else if (key == 'content') {
        result['content'] = value;
      } else if (key == 'page') {
        result['pageId'] = value;
      } else if (key == 'overdue') {
        result['isOverdue'] = value == 'true';
      }
    }
    
    // Fallback: Wenn kein (key value) gefunden wurde, behandle den ganzen String als Content-Suche
    if (result.isEmpty && query.trim().isNotEmpty) {
      result['content'] = query.trim();
    }

    return result;
  }
}
