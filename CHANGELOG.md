# Changelog

Alle wichtigen Änderungen an diesem Projekt werden in dieser Datei dokumentiert.

Das Format basiert auf [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
und dieses Projekt hält sich an [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-05-21

### Hinzugefügt
- **Semantische Suche:** Lokale Vektor-Embeddings (ONNX) für bedeutungsorientierte Suche.
- **Hidden Connections:** KI-gestützte Vorschläge für Verknüpfungen während des Schreibens.
- **WebDAV & Git Sync:** Bidirektionale Synchronisation mit E2EE (End-to-End Verschlüsselung).
- **Plugin-System:** JavaScript-basierte Hooks und UI-Erweiterungen via Slash-Commands.
- **PDF-Viewer:** Integrierter Reader mit Deep-Link Unterstützung für Annotationen.
- **Material You:** Unterstützung für dynamische Farben unter Android und Windows.
- **Biometrische Authentifizierung:** Schutz der App via Fingerabdruck/FaceID.
- **Internationalisierung:** Vollständige Unterstützung für DE, EN, FR, ES, PT.

### Geändert
- Migration von Drift zu **Isar NoSQL** für verbesserte Performance (Community Edition).
- Komplette Umstellung auf **Riverpod Generator** für bessere Typsicherheit.
- Optimierung der Graph-Visualisierung (Zoom/Pan & Filter-Funktionen).

### Behoben
- Diverse Fixes bei der Block-Synchronisation und Konfliktauflösung.
- Korrektur von Speicherlecks bei der Multi-Window Nutzung auf Desktop.

## [0.2.0] - 2025-11-12

### Hinzugefügt
- **Multi-Window Support:** Mehrere Notizen gleichzeitig auf Desktop-Plattformen öffnen.
- **Redo-Funktionalität:** Erweiterung des Undo-Stacks um Redo-Support.
- **Template-System:** Unterstützung für vordefinierte Block-Strukturen mit Platzhaltern.

### Geändert
- Verbessertes Drag & Drop Reordering von Blöcken.
- Aktualisierung der README und Dokumentation der Shortcuts.

## [0.1.0] - 2025-08-01

### Hinzugefügt
- Initiales Release von NexusBrain.
- Block-basierter Editor (Outliner-Stil).
- WikiLinks & Block-Referenzen.
- Basis WebDAV Synchronisation.
- Graph-Visualisierung.
- Dunkelmodus.

---
[1.0.0]: https://github.com/peopleandpixel/nexusbrain/releases/tag/v1.0.0
[0.2.0]: https://github.com/peopleandpixel/nexusbrain/releases/tag/v0.2.0
[0.1.0]: https://github.com/peopleandpixel/nexusbrain/releases/tag/v0.1.0
