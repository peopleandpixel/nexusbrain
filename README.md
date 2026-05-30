# NexusBrain

A personal knowledge management app — Logseq alternative built with Flutter.

## Features

- **Block-based editor** — Logseq-style outliner with infinite nesting
- **Task management** — TODO / DOING / DONE / CANCELLED states with keyboard shortcuts
- **WikiLinks & Block Refs** — `[[Page Title]]` and `((block-id))` for deep interconnected knowledge
- **Graph visualization** — Interactive visual map of all page connections with zoom & pan
- **Hybrid Search** — FTS5 for exact matches and AI-powered Semantic Search for context-aware discovery
- **WebDAV & Git Sync** — Seamless bi-directional synchronization with E2EE (End-to-End Encryption)
- **PDF-Viewer & Annotation** — Deep-link directly into PDFs from your notes
- **Biometric Security** — Secure your brain with Fingerprint or FaceID
- **Plugins & Scripting** — Extend functionality with JavaScript-based plugins (JS-Hooks API)
- **Multi-Window Support** — Open multiple notes in separate windows on Desktop
- **Modern UI/UX** — Material You, Glassmorphism, and i18n support (DE, EN, FR, ES, PT)
- **Cross-platform** — Native performance on Web, Desktop, and Mobile (Android, iOS)

## AI Vision

NexusBrain aims to be more than just a notebook. We are integrating local AI to help you discover hidden connections:
- **Semantic Search:** Find what you mean, not just what you typed.
- **Topic Extraction:** Automatically suggest tags and categories for your blocks.
- **Hidden Connections:** Discovery of related pages that aren't linked yet.
- **Local First:** All AI processing happens on your device. Your data never leaves your machine.

## Tech Stack

- **Language:** Dart
- **Framework:** Flutter
- **Database:** Isar NoSQL (Community Edition)
- **State Management:** Riverpod (with Generator)
- **AI:** ONNX Runtime for local Vektor-Embeddings

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
