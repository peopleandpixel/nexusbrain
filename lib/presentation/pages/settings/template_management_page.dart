import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexusbrain/domain/models/template.dart';
import 'package:nexusbrain/presentation/state/notes_state.dart';

class TemplateManagementPage extends ConsumerWidget {
  const TemplateManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templatesAsync = ref.watch(templatesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Templates'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded),
            onPressed: () => _importTemplates(context, ref),
            tooltip: 'Templates importieren',
          ),
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => _editTemplate(context, ref),
            tooltip: 'Neues Template',
          ),
        ],
      ),
      body: templatesAsync.when(
        data: (templates) {
          if (templates.isEmpty) {
            return const Center(
              child: Text('Keine Templates gefunden. Erstelle eins oder importiere welche.'),
            );
          }
          return ListView.builder(
            itemCount: templates.length,
            itemBuilder: (context, index) {
              final template = templates[index];
              return ListTile(
                title: Text(template.name),
                subtitle: Text(template.description ?? 'Keine Beschreibung'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.upload_rounded),
                      onPressed: () => _exportTemplate(context, template),
                      tooltip: 'Exportieren',
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_rounded),
                      onPressed: () => _editTemplate(context, ref, template: template),
                      tooltip: 'Bearbeiten',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_rounded),
                      onPressed: () => _confirmDelete(context, ref, template),
                      tooltip: 'Löschen',
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Fehler: $err')),
      ),
    );
  }

  void _editTemplate(BuildContext context, WidgetRef ref, {Template? template}) {
    final nameController = TextEditingController(text: template?.name);
    final descController = TextEditingController(text: template?.description);
    final contentController = TextEditingController(text: template?.content);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(template == null ? 'Neues Template' : 'Template bearbeiten'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Beschreibung'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contentController,
                maxLines: 10,
                decoration: const InputDecoration(
                  labelText: 'Inhalt (Markdown)',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newTemplate = Template(
                templateId: template?.templateId ?? DateTime.now().millisecondsSinceEpoch.toString(),
                name: nameController.text,
                description: descController.text,
                content: contentController.text,
                updatedAt: DateTime.now(),
                createdAt: template?.createdAt,
              );
              await ref.read(templatesProvider.notifier).saveTemplate(newTemplate);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Speichern'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Template template) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Template löschen?'),
        content: Text('Möchtest du "${template.name}" wirklich löschen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(templatesProvider.notifier).deleteTemplate(template.templateId);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Löschen', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _exportTemplate(BuildContext context, Template template) async {
    // Einfacher Export als JSON-String in die Zwischenablage oder Datei (hier Datei-Sim)
    final Map<String, dynamic> data = {
      'templateId': template.templateId,
      'name': template.name,
      'description': template.description,
      'content': template.content,
      'category': template.category,
      'tags': template.tags,
      'source': template.source,
    };
    
    final jsonStr = const JsonEncoder.withIndent('  ').convert(data);
    
    // In einer echten App würde man hier einen File Saver nutzen. 
    // Wir zeigen es hier als Dialog mit dem JSON.
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Template Export'),
        content: SingleChildScrollView(
          child: SelectableText(jsonStr),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Schließen')),
        ],
      ),
    );
  }

  Future<void> _importTemplates(BuildContext context, WidgetRef ref) async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null && result.files.single.path != null) {
      try {
        final file = File(result.files.single.path!);
        final content = await file.readAsString();
        final dynamic data = jsonDecode(content);

        if (data is Map<String, dynamic>) {
          await _importSingleTemplate(ref, data);
        } else if (data is List) {
          for (final item in data) {
            if (item is Map<String, dynamic>) {
              await _importSingleTemplate(ref, item);
            }
          }
        }
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Import erfolgreich')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Fehler beim Import: $e')),
          );
        }
      }
    }
  }

  Future<void> _importSingleTemplate(WidgetRef ref, Map<String, dynamic> data) async {
    final template = Template(
      templateId: data['templateId'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: data['name'] ?? 'Imported Template',
      description: data['description'],
      content: data['content'] ?? '',
      category: data['category'],
      tags: List<String>.from(data['tags'] ?? []),
      source: data['source'] ?? 'imported',
    );
    await ref.read(templatesProvider.notifier).saveTemplate(template);
  }
}
