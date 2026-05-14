# NexusBrain

A personal knowledge management app — Logseq alternative built with Flutter.

## Features

- **Block-based editor** — Logseq-style outliner with infinite nesting
- **Task management** — TODO / DOING / DONE / CANCELLED states with keyboard shortcuts
- **WikiLinks** — `[[Page Title]]` syntax for page links
- **Block references** — `((block-id))` for deep linking
- **Graph visualization** — Visual map of page connections
- **Semantic search** — AI-powered embeddings for content discovery
- **Full-text search** — SQLite FTS5 for fast content search
- **WebDAV sync** — Nextcloud / ownCloud integration
- **Import/Export** — Markdown file support
- **Cross-platform** — Web, Desktop (Linux, macOS, Windows), Mobile (Android, iOS)

## Tech Stack

- **Language:** Dart
- **Framework:** Flutter
- **Database:** Drift (SQLite) with FTS5
- **State Management:** Riverpod
- **AI:** Embeddings for semantic search

## Project Structure

```
lib/
├── core/
│   ├── ai/            # Embedding service, AI features
│   └── database/      # Drift database schema & queries
├── data/
│   ├── repositories/  # Block & note repositories
│   └── services/      # Import/Export, WebDAV sync
├── domain/models/     # Block, Note, Page models
└── presentation/      # UI pages, state, theme
```

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| Enter | Newline (empty block → new sibling) |
| Ctrl+Enter | Add child block |
| Alt+Enter | Add block below |
| Tab | Indent |
| Shift+Tab | Outdent |
| Ctrl+Z | Undo |
| Ctrl+Shift+Z | Redo |
| Ctrl+Backspace | Delete block |
| Ctrl+T | Toggle task state |

## Development

```bash
# Install dependencies
flutter pub get

# Generate code (drift, json_serializable)
flutter packages pub run build_runner build

# Run on current platform
flutter run

# Build for web
flutter build web

# Build for Android
flutter build apk --release
```

## Platform Notes

- **Web:** Uses drift_flutter with SQLite WASM. Persistent storage via IndexedDB.
- **Android/iOS:** SQLite via `sqlite3_flutter_libs`
- **Desktop:** Native SQLite via drift

## License

Private — peopleandpixel
