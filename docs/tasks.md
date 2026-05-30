# NexusBrain - TODO Liste

Diese Liste enthält Vorschläge für Verbesserungen, neue Features und Wartungsarbeiten, basierend auf der aktuellen Projektanalyse.

## 🚀 Neue Features
- [x] **Erweiterte Suche (Semantic Search):** Integration eines lokalen LLM-Embeddings (z.B. via `langchain_dart` oder `onnx`) für eine echte semantische Suche, wie in der README versprochen.
- [x] **Erweiterte Query-Engine:** Implementierung einer fortgeschrittenen Query-Engine (ähnlich Datalog), um komplexe Abfragen über Blöcke und Beziehungen zu ermöglichen.
- [x] **PDF-Annotation & Deep-Links:** Integration eines PDF-Readers mit der Möglichkeit, Deep-Links von Notizen direkt auf PDF-Stellen zu setzen.
- [x] **Dark Mode Persistenz:** Automatisches Speichern der Theme-Einstellung in `shared_preferences`, damit die Wahl nach dem Neustart erhalten bleibt.
- [x] **Backup & Restore:** Einfacher Export der Isar-Datenbank als Datei zur manuellen Sicherung.
- [x] **Journal-Autokreation:** Option zum automatischen Erstellen einer neuen Journal-Seite beim ersten Start am Tag.
- [x] **Multi-Window Support (Desktop):** Ermöglichen, mehrere Notizen gleichzeitig in separaten Fenstern zu öffnen.
- [x] **Cloud Sync (WebDAV & Git):** Bidirektionale Synchronisation mit WebDAV-Servern und Git-Repositories implementiert (Zeitstempel-basierte Konfliktauflösung).
- [x] **Plugin-Ökosystem Ausbau:** Erweiterung der Basis-Infrastruktur, um ein reichhaltiges Ökosystem an Community-Plugins zu ermöglichen. (Implementiert: UI-Extensions, Slash-Commands, Dokumentation)
- [x] **Plugins/Scripting:** Basis-Infrastruktur mit `flutter_js` geschaffen.
    - [x] **Plugin-Hooks definieren:**
        - `onBlockCreate(block)`: Hook für Aktionen nach Block-Erstellung (z.B. Default-Inhalt).
        - `onBlockUpdate(block)`: Hook für Inhaltsverarbeitung (z.B. Auto-Formatierung, Linting).
        - `uiExtension(position)`: Registrierung von UI-Komponenten (In der Sidebar integriert).
        - `registerCommand(name, callback)`: Eigene Slash-Commands (Im Editor integriert).

## 🛠️ Technische Verbesserungen
- [x] **FTS5 Integration:** Integration von SQLite FTS5 für eine leistungsfähige Volltextsuche, die plattformübergreifend funktioniert (inkl. Web-Fallback). Synchronisation von Blöcken und Seitentiteln ist implementiert.
- [x] **Block-Referenz-Vorschläge:** Autocomplete-Menü (z.B. bei Eingabe von `((`), um existierende Blöcke leichter zu referenzieren.
- [x] **Code Dokumentation:** Viele Repositories und UI-Komponenten haben keine DartDocs. Hinzufügen von Dokumentation für komplexe Logik (besonders in `isar_block_repository.dart`).
- [x] **Unit & Widget Tests:** Erhöhung der Testabdeckung. Aktuell wurden Unit-Tests für `SyncManager` und `IsarBlockRepository` sowie Basis-Widget-Tests implementiert.
- [x] **Lints Verschärfen:** Anpassung der `analysis_options.yaml` an strengere Regeln (z.B. `flutter_lints` + `riverpod_lint`).
- [x] **Riverpod Generator:** Umstellung auf den `@riverpod` Generator, um Boilerplate zu reduzieren und Typsicherheit zu erhöhen.
- [x] **Isar Inspector Integration:** Einrichtung für einfacheres Debugging der lokalen Datenbank im Entwicklungsmodus.

## 🎨 UI/UX Optimierungen
- [x] **Drag & Drop Reordering:** Blöcke im Editor per Drag & Drop verschieben.
- [x] **Keyboard Shortcuts im UI anzeigen:** Kleine Tooltips oder ein Hilfe-Overlay für die Shortcuts (Ctrl+Enter, Tab, etc.).
- [x] **Graph-Interaktion:** Zoom & Pan im Graph verbessern, sowie Filter für bestimmte Tags/Kategorien im Graph-View.
- [x] **Responsive Design:** Optimierung der Desktop-Ansicht (Sidebar statt Bottom-Nav bei breiten Bildschirmen).
- [x] **Dynamic Color (Material You):** Unterstützung für systemweite Akzentfarben unter Android und Windows.
- [x] **Glassmorphism Design:** Optionales Theme mit transluzenten Oberflächen (Blur-Effekte) für ein moderneres Desktop-Gefühl.
- [x] **Custom Fonts:** Auswahlmöglichkeit für verschiedene Editor-Schriftarten (z.B. JetBrains Mono für Code-Blocks).
- [x] **Interaktives Onboarding:** Erstellung einer "Welcome"-Seite mit interaktiven Übungen für neue Nutzer.
- [x] **Shortcut-Overlay:** Globales Hilfe-Overlay (z.B. via `?`), das alle verfügbaren Tastenkombinationen anzeigt.
- [x] **Template-System:** Unterstützung für vordefinierte Block-Strukturen (z.B. Meeting-Notes, Daily Journal). Vollständige Implementierung mit Slash-Commands, Platzhaltern ({{date}}, {{time}}) und verbesserter UI.

## 🛡️ Sicherheit & Vertrauen
- [x] **End-to-End Verschlüsselung (E2EE):** Optionale Verschlüsselung der Daten vor der Synchronisation (WebDAV/Git).
- [x] **Automatisierte Backups:** System für regelmäßige, automatische lokale Datenbank-Snapshots.

## 📝 Wartung
- [x] **Dependency Update:** Regelmäßige Prüfung auf Updates der Community-Isar Version und anderer Packages. (Abgeschlossen: Update auf Riverpod 3.x, Isar 3.3.2, etc.)
- [x] **Translations vervollständigen:** Sicherstellen, dass alle Hardcoded Strings in `easy_localization` JSONs überführt sind.
- [x] **Sync-Konflikt UI:** Dialog-basiertes Management bei Datenkonflikten während der Synchronisation.

## 🏁 Weg zum Release (v1.0.0)
- [x] **Internationalisierung (i18n):**
    - [x] Audit aller UI-Komponenten auf hardcodierte Strings (Settings, Home, Notes).
    - [x] Abgleich von `en.json` und `de.json` auf Vollständigkeit.
    - [x] Hinzufügen weiterer Sprachen (ES, FR, IT).
- [x] **Stabilisierung & Tests:**
    - [x] Unit-Tests für `SyncManager` (bidirektionaler Merge).
    - [x] Unit-Tests für `IsarBlockRepository` (FTS5 & CRUD).
    - [x] Basis Widget-Tests für kritische Flows (Notiz erstellen/editieren).
- [x] **AI-Textanalyse (Integration):**
    - [x] `NexusBrainAi` reaktivieren: Implementierung der Platzhalter-Methoden für Isar.
    - [x] **Automatische Themenextraktion:** Vorschläge für Tags basierend auf Blockinhalten.
    - [x] **Hidden Connections:** KI-gestützte Vorschläge für Verknüpfungen zwischen Seiten, die noch nicht verlinkt sind.
    - [x] **Smart Summaries:** Zusammenfassung von langen Seiten via lokalem LLM/Heuristiken.
    - [x] **Vektor-Embeddings:** Upgrade der semantischen Suche auf echte Vektor-Suche (lokal via ONNX - implementiert mit flutter_onnxruntime und dart_bert_tokenizer).
    - [x] **Aktive Verknüpfungsvorschläge:** UI-Integration für die Entdeckung von "Hidden Connections" während des Schreibens. (Vektor-basiert implementiert)
- [x] **Feature Polish & Bug Fixes:**
    - [x] WebDAV Sync UI in `settings_page.dart` fertigstellen (Platzhalter entfernen).
    - [x] FTS5 Suche in `notes_page.dart` für Block-Inhalte verifizieren.
    - [x] Multi-Window State-Synchronisation prüfen. (Eingeschränkt durch Provider-Refresh-Logik, aber funktionsfähig)
    - [x] **Mobile Optimierung:** Share-Sheet Integration und Home-Screen Widgets für Schnelleingaben.
    - [x] **Plugin-Marktplatz:** Einfache Installation von Plugins über eine zentrale Registry.
- [x] **Technische Qualität:**
    - [x] `analysis_options.yaml` verschärfen (Lints wie `prefer_const_constructors` reaktivieren).
    - [x] DartDocs für Core-Komponenten und Repositories ergänzen.
    - [x] Migration auf `@riverpod` Generator abschließen.
- [x] **Release-Konfiguration:**
    - [x] App-Icons und Splash-Screens für alle Plattformen generieren.
    - [x] Versionierung in `pubspec.yaml` auf `1.0.0` anheben.
    - [ ] Build-Prozess mit Obfuskierung testen.


