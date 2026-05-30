import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexusbrain/core/plugins/plugin_manager.dart';

class PluginMarketplacePage extends ConsumerStatefulWidget {
  const PluginMarketplacePage({super.key});

  @override
  ConsumerState<PluginMarketplacePage> createState() => _PluginMarketplacePageState();
}

class _PluginMarketplacePageState extends ConsumerState<PluginMarketplacePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Mock-Daten für den Marktplatz (In einer echten App kämen diese von einer API)
  final List<Map<String, String>> _availablePlugins = [
    {
      'id': 'word-count',
      'name': 'Word Count',
      'description': 'Zeigt die Wortanzahl für die aktuelle Seite in der Sidebar an.',
      'author': 'NexusBrain Team',
      'script': '''
        (function() {
          NexusBrain.registerUiExtension('sidebar', {
            label: 'Word Count',
            icon: 'text_fields',
            action: function() {
              // In einer echten Implementierung würde hier die Wortanzahl berechnet
              console.log('Word Count triggered');
            }
          });
        })();
      ''',
    },
    {
      'id': 'table-of-contents',
      'name': 'Table of Contents',
      'description': 'Generiert automatisch ein Inhaltsverzeichnis basierend auf Überschriften.',
      'author': 'Community Dev',
      'script': 'console.log("ToC Plugin loaded");',
    },
    {
      'id': 'emoji-picker',
      'name': 'Emoji Picker',
      'description': 'Ein Slash-Command (:emoji), um Emojis schnell einzufügen.',
      'author': 'OpenSource Guru',
      'script': '''
        NexusBrain.registerCommand('emoji', function(data) {
          return '🚀';
        });
      ''',
    },
    {
      'id': 'github-sync-pro',
      'name': 'GitHub Sync Pro',
      'description': 'Erweiterte Synchronisations-Optionen für GitHub Repositories.',
      'author': 'DevOps Master',
      'script': 'console.log("GitHub Sync Pro loaded");',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pluginManagerState = ref.watch(pluginManagerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('settings.pluginMarketplace'.tr()),
        centerTitle: false,
      ),
      body: pluginManagerState.when(
        data: (manager) {
          final installedPluginIds = manager.plugins.map((p) => p.id).toSet();
          final filteredPlugins = _availablePlugins.where((p) {
            final name = p['name']!.toLowerCase();
            final desc = p['description']!.toLowerCase();
            final query = _searchQuery.toLowerCase();
            return name.contains(query) || desc.contains(query);
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'settings.searchPlugins'.tr(),
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: filteredPlugins.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.extension_off_outlined, size: 64, color: Colors.grey),
                            const SizedBox(height: 16),
                            Text('settings.noPluginsFound'.tr(), style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredPlugins.length,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemBuilder: (context, index) {
                          final pluginData = filteredPlugins[index];
                          final id = pluginData['id']!;
                          final isInstalled = installedPluginIds.contains(id);

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.primaryContainer,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Icon(
                                          Icons.extension,
                                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              pluginData['name']!,
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                            ),
                                            Text(
                                              'by ${pluginData['author']}',
                                              style: Theme.of(context).textTheme.bodySmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (isInstalled)
                                        const Icon(Icons.check_circle, color: Colors.green),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    pluginData['description']!,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      if (!isInstalled)
                                        ElevatedButton(
                                          onPressed: () async {
                                            await manager.loadPlugin(Plugin(
                                              id: id,
                                              name: pluginData['name']!,
                                              description: pluginData['description']!,
                                              script: pluginData['script']!,
                                            ),);
                                            if (!context.mounted) return;
                                            setState(() {}); // Refresh UI
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('settings.pluginInstalled'.tr())),
                                            );
                                          },
                                          child: Text('settings.install'.tr()),
                                        )
                                      else
                                        TextButton(
                                          onPressed: id == 'core-utils' ? null : () {
                                            // Hinweis: Deinstallation erfordert i.d.R. einen Neustart oder komplexe Bereinigung im PluginManager
                                            // Für dieses MVP zeigen wir eine Meldung
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Deinstallation erfordert App-Neustart (MVP Einschränkung)')),
                                            );
                                          },
                                          child: Text('settings.uninstall'.tr(), style: const TextStyle(color: Colors.red)),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Fehler: $err')),
      ),
    );
  }
}
