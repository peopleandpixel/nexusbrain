# NexusBrain Plugin Dokumentation

Diese Dokumentation erklärt, wie man Plugins für NexusBrain erstellt und nutzt. Plugins ermöglichen es, die Funktionalität der App durch JavaScript zu erweitern.

## Inhaltsverzeichnis
1. [Grundlagen](#grundlagen)
2. [Plugin-Struktur](#plugin-struktur)
3. [Hooks](#hooks)
4. [UI-Erweiterungen](#ui-erweiterungen)
5. [Slash-Commands](#slash-commands)
6. [Beispiel-Plugin](#beispiel-plugin)

---

## Grundlagen

NexusBrain verwendet eine eingebettete JavaScript-Runtime (`flutter_js`), um Plugins auszuführen. Plugins haben Zugriff auf das globale `NexusBrain`-Objekt, über das sie Hooks registrieren, UI-Elemente hinzufügen und Befehle definieren können.

## Plugin-Struktur

Ein Plugin besteht aus Metadaten (ID, Name, Beschreibung) und einem JavaScript-Skript.

```javascript
// Beispiel für den Aufbau eines Plugins
(function() {
  console.log("Plugin geladen!");
  
  // Plugin-Logik hier...
})();
```

## Hooks

Hooks ermöglichen es Plugins, auf Ereignisse in der App zu reagieren oder Daten zu transformieren.

### `onBlockCreate(block)`
Wird aufgerufen, wenn ein neuer Block erstellt wird.
- **Input:** `{ blockId: string, content: string, pageId: string }`
- **Verwendung:** Initialisierung von Default-Inhalten.

### `onBlockUpdate(block)`
Wird aufgerufen, wenn der Inhalt eines Blocks geändert wird.
- **Input:** `{ blockId: string, content: string, pageId: string }`
- **Output:** Kann ein Objekt mit einem neuen `content` zurückgeben, um den Text zu transformieren.
- **Beispiel:** Automatische Formatierung (z.B. "TODO" zu "DONE").

```javascript
NexusBrain.registerHook('onBlockUpdate', function(block) {
  if (block.content.includes(':hello:')) {
    return { content: block.content.replace(':hello:', '👋') };
  }
  return block;
});
```

## UI-Erweiterungen

Plugins können eigene Schaltflächen an vordefinierten Stellen in der UI hinzufügen.

### `registerUiExtension(position, data)`
- **Position:** Aktuell unterstützt: `'sidebar'`.
- **Data:** `{ label: string, icon: string }`
- **Icons:** Unterstützte Strings: `'bolt'`, `'auto_awesome'`, `'extension'`, `'info'`.

```javascript
NexusBrain.registerUiExtension('sidebar', {
  label: 'Mein Plugin',
  icon: 'bolt'
});
```

## Slash-Commands

Slash-Commands ermöglichen es, Aktionen durch Eingabe von `/befehl` im Editor auszuführen.

### `registerCommand(commandName, callback)`
- **commandName:** Der Name des Befehls (ohne `/`).
- **callback:** Funktion, die aufgerufen wird, wenn der Befehl eingegeben wird.

```javascript
NexusBrain.registerCommand('date', function(data) {
  return new Date().toLocaleDateString();
});
```

## Beispiel-Plugin

Hier ist ein vollständiges Beispiel-Plugin, das mehrere Funktionen kombiniert:

```javascript
(function() {
  // 1. UI Erweiterung registrieren
  NexusBrain.registerUiExtension('sidebar', {
    label: 'Formatierer',
    icon: 'auto_awesome'
  });

  // 2. Slash-Command für Zeitstempel
  NexusBrain.registerCommand('now', function(data) {
    return new Date().toLocaleTimeString();
  });

  // 3. Hook für automatische Ersetzung
  NexusBrain.registerHook('onBlockUpdate', function(block) {
    if (block.content.includes('(c)')) {
      return { content: block.content.replace('(c)', '©') };
    }
    return block;
  });
})();
```
