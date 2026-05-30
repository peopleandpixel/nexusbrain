# NexusBrain Query-Engine

NexusBrain unterstützt fortgeschrittene Abfragen über Blöcke und Aufgaben, ähnlich wie Datalog in Logseq, aber mit einer vereinfachten Syntax.

## Syntax

Abfragen können entweder als einfache Textsuche oder mit speziellen Filtern in Klammern erfolgen.

### Filter

| Filter | Beschreibung | Beispiel |
|--------|--------------|----------|
| `(task <state>)` | Filtert nach Aufgabenstatus (TODO, DOING, DONE, CANCELLED) | `(task TODO)` |
| `(content <text>)` | Filtert nach Textinhalt | `(content Projekt X)` |
| `(page <id>)` | Filtert nach einer bestimmten Seiten-ID | `(page 1715965321)` |
| `(overdue true)` | Findet alle überfälligen Aufgaben | `(overdue true)` |

### Kombinationen

Mehrere Filter können kombiniert werden, um die Ergebnisse einzuschränken (AND-Verknüpfung):

```text
(task TODO) (content Wichtig)
```

Dies findet alle Blöcke, die den Status TODO haben UND das Wort "Wichtig" enthalten.

## Integration in Blöcke (Geplant)

Zukünftig können Abfragen direkt in Blöcke eingebettet werden:

```text
{{query (task TODO)}}
```

## Programmatische Nutzung

Die `QueryEngine` kann auch über eine Map-basierte API in Dart genutzt werden:

```dart
final results = await queryEngine.findBlocks({
  'task': 'TODO',
  'content': 'Suche',
  'isOverdue': true,
});
```
