import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'plugin_manager.g.dart';

/// Repräsentiert ein geladenes Plugin im System.
class Plugin {
  /// Eindeutige ID des Plugins.
  final String id;
  /// Anzeigename des Plugins.
  final String name;
  /// Kurze Beschreibung der Funktionalität.
  final String description;
  /// Der JavaScript-Quellcode des Plugins.
  final String script;
  /// Gibt an, ob das Plugin aktuell aktiv ist.
  bool enabled;

  Plugin({
    required this.id,
    required this.name,
    this.description = '',
    required this.script,
    this.enabled = true,
  });
}

/// Verwaltet die Plugin-Infrastruktur und die JavaScript-Laufzeitumgebung.
///
/// Ermöglicht das Laden von Plugins, das Registrieren von Hooks und das
/// Ausführen von JavaScript-Code zur Erweiterung der App-Funktionalität.
class PluginManager {
  final JavascriptRuntime _jsRuntime;
  final List<Plugin> _plugins = [];
  
  // Hook registries: HookName -> List of JS function names/references
  /// Registrierte Hooks: HookName -> Liste der JS-Callback-Namen.
  final Map<String, List<String>> _hooks = {
    'onBlockCreate': [],
    'onBlockUpdate': [],
    'uiExtension': [],
    'registerCommand': [],
    'registerTemplate': [],
  };

  /// Registrierte Templates von Plugins: ID -> TemplateData
  final Map<String, Map<String, dynamic>> _pluginTemplates = {};

  /// UI-Extensions: Position -> List of data
  final Map<String, List<Map<String, dynamic>>> _uiExtensions = {};

  /// Registrierte Slash-Commands: Name -> Callback
  final Map<String, String> _slashCommands = {};

  PluginManager() : _jsRuntime = getJavascriptRuntime() {
    _setupContext();
  }

  /// Richtet den JS-Kontext und die Brücke zwischen Dart und JavaScript ein.
  void _setupContext() {
    // Provide a bridge for plugins to register hooks
    _jsRuntime.onMessage('registerHook', (dynamic args) {
      final String hookName = args['hookName'];
      final String callbackName = args['callbackName'];
      
      if (_hooks.containsKey(hookName)) {
        _hooks[hookName]!.add(callbackName);
        debugPrint('Plugin registered hook: $hookName with callback: $callbackName');
      }
    });

    _jsRuntime.onMessage('registerUiExtension', (dynamic args) {
      final String position = args['position'];
      final Map<String, dynamic> data = Map<String, dynamic>.from(args['data']);
      
      _uiExtensions.putIfAbsent(position, () => []).add(data);
      debugPrint('Plugin registered UI extension at: $position');
    });

    _jsRuntime.onMessage('registerSlashCommand', (dynamic args) {
      final String commandName = args['commandName'];
      final String callbackName = args['callbackName'];
      
      _slashCommands[commandName] = callbackName;
      debugPrint('Plugin registered slash command: $commandName');
    });

    _jsRuntime.onMessage('registerTemplate', (dynamic args) {
      final Map<String, dynamic> templateData = Map<String, dynamic>.from(args);
      final String templateId = templateData['templateId'];
      _pluginTemplates[templateId] = templateData;
      debugPrint('Plugin registered template: $templateId');
    });

    _jsRuntime.onMessage('log', (message) {
      debugPrint('Plugin log: $message');
    });

    // Initialize the NexusBrain JS object
    _jsRuntime.evaluate("""
      var NexusBrain = {
        hooks: {},
        registerHook: function(hookName, callback) {
          var callbackName = 'cb_' + hookName + '_' + Math.random().toString(36).substr(2, 9);
          this.hooks[callbackName] = callback;
          sendMessage('registerHook', JSON.stringify({hookName: hookName, callbackName: callbackName}));
        },
        registerUiExtension: function(position, data) {
          sendMessage('registerUiExtension', JSON.stringify({position: position, data: data}));
        },
        registerCommand: function(commandName, callback) {
          var callbackName = 'cmd_' + commandName + '_' + Math.random().toString(36).substr(2, 9);
          this.hooks[callbackName] = callback;
          sendMessage('registerSlashCommand', JSON.stringify({commandName: commandName, callbackName: callbackName}));
        },
        registerTemplate: function(templateData) {
          sendMessage('registerTemplate', JSON.stringify(templateData));
        },
        _triggerHook: function(hookName, callbackName, data) {
          if (this.hooks[callbackName]) {
            return this.hooks[callbackName](JSON.parse(data));
          }
        }
      };
    """);
  }

  /// Lädt ein [plugin] und führt dessen Skript aus, falls es aktiviert ist.
  Future<void> loadPlugin(Plugin plugin) async {
    _plugins.add(plugin);
    if (plugin.enabled) {
      await _executePlugin(plugin);
    }
  }

  /// Führt den JavaScript-Code eines Plugins in der Runtime aus.
  Future<void> _executePlugin(Plugin plugin) async {
    try {
      final JsEvalResult result = _jsRuntime.evaluate(plugin.script);
      debugPrint('Plugin ${plugin.name} loaded: ${result.stringResult}');
    } catch (e) {
      debugPrint('Error loading plugin ${plugin.name}: $e');
    }
  }

  /// Triggert einen spezifischen [hookName] mit den übergebenen [data].
  ///
  /// Durchläuft alle für diesen Hook registrierten Plugins und gibt das
  /// potenziell transformierte Ergebnis zurück.
  Future<dynamic> triggerHook(String hookName, dynamic data) async {
    if (!_hooks.containsKey(hookName) || _hooks[hookName]!.isEmpty) {
      return data;
    }

    dynamic currentData = data;
    
    for (final callbackName in _hooks[hookName]!) {
      try {
        final String jsonData = jsonEncode(currentData);
        final JsEvalResult result = await _jsRuntime.evaluateAsync(
          "NexusBrain._triggerHook('$hookName', '$callbackName', '$jsonData')",
        );
        
        // If the hook returns something, we might want to use it as the next input (e.g. for content transformation)
        if (result.stringResult != 'undefined' && result.stringResult != 'null') {
          try {
            // flutter_js might return the result as a string or json
            final decoded = jsonDecode(result.stringResult);
            currentData = decoded;
          } catch (_) {
            // Not JSON, just use the string result if it's a primitive
            currentData = result.stringResult;
          }
        }
      } catch (e) {
        debugPrint('Error triggering hook $hookName for callback $callbackName: $e');
      }
    }
    
    return currentData;
  }

  List<Plugin> get plugins => List.unmodifiable(_plugins);

  /// Gibt alle registrierten UI-Extensions für eine [position] zurück.
  List<Map<String, dynamic>> getUiExtensions(String position) {
    return _uiExtensions[position] ?? [];
  }

  /// Gibt alle registrierten Slash-Commands zurück.
  List<String> getSlashCommands() {
    return _slashCommands.keys.toList();
  }

  /// Gibt alle von Plugins registrierten Templates zurück.
  List<Map<String, dynamic>> getPluginTemplates() {
    return _pluginTemplates.values.toList();
  }

  /// Führt einen Slash-Command aus.
  Future<dynamic> executeSlashCommand(String commandName, dynamic data) async {
    final callbackName = _slashCommands[commandName];
    if (callbackName == null) return null;

    try {
      final String jsonData = jsonEncode(data);
      final JsEvalResult result = await _jsRuntime.evaluateAsync(
        "NexusBrain._triggerHook('registerCommand', '$callbackName', '$jsonData')",
      );
      return result.stringResult;
    } catch (e) {
      debugPrint('Error executing slash command $commandName: $e');
      return null;
    }
  }

  void dispose() {
    _jsRuntime.dispose();
  }
}

@riverpod
Future<PluginManager> pluginManager(Ref ref) async {
  final manager = PluginManager();
  
  // Load a built-in example plugin for demonstration
  await manager.loadPlugin(Plugin(
    id: 'core-utils',
    name: 'Core Utilities',
    description: 'Bietet nützliche Basis-Funktionen und Slash-Commands.',
    script: """
      (function() {
        NexusBrain.registerUiExtension('sidebar', {
          label: 'Plugin Guide',
          icon: 'info'
        });

        NexusBrain.registerCommand('today', function(data) {
          return new Date().toLocaleDateString();
        });

        NexusBrain.registerCommand('shrug', function(data) {
          return '¯\\\\_(ツ)_/¯';
        });

        NexusBrain.registerHook('onBlockUpdate', function(block) {
          if (block.content.includes('(c)')) {
            return { content: block.content.replace('(c)', '©') };
          }
          return block;
        });

        NexusBrain.registerTemplate({
          templateId: 'meeting-notes',
          name: 'Meeting Notes (Plugin)',
          description: 'Ein strukturiertes Meeting-Protokoll.',
          content: '# Meeting: \\n\\n## Teilnehmer:\\n- \\n\\n## Agenda:\\n- \\n\\n## Action Items:\\n- [ ] '
        });
      })();
    """,
  ),);

  ref.onDispose(() => manager.dispose());
  return manager;
}
