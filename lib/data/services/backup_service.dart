import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/database/isar_service.dart';
import '../../presentation/state/backup_state.dart';

class BackupService {
  Future<String?> exportBackup() async {
    final isar = await IsarService.instance;
    final dir = await getTemporaryDirectory();
    final backupFile = File(p.join(dir.path, 'nexusbrain_backup.isar'));
    
    if (await backupFile.exists()) {
      await backupFile.delete();
    }
    
    // Copy Isar file
    await isar.copyToFile(backupFile.path);
    
    // Use file_picker to save file
    String? outputFile = await FilePicker.saveFile(
      dialogTitle: 'Backup speichern',
      fileName: 'nexusbrain_backup_${DateTime.now().millisecondsSinceEpoch}.isar',
    );
    
    if (outputFile != null) {
      await backupFile.copy(outputFile);
      return outputFile;
    }
    return null;
  }

  Future<bool> restoreBackup() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.any,
    );
    
    if (result != null && result.files.single.path != null) {
      final backupFile = File(result.files.single.path!);
      final dir = await getApplicationDocumentsDirectory();
      final databaseFile = File(p.join(dir.path, 'nexusbrain.isar'));
      
      // Close Isar before restoring
      await IsarService.close();
      
      // Replace database file
      await backupFile.copy(databaseFile.path);
      
      // Re-initialize Isar
      await IsarService.init();
      
      return true;
    }
    return false;
  }

  Future<void> checkAndRunAutomaticBackup(WidgetRef ref) async {
    final settings = ref.read(backupSettingsProvider);
    if (!settings.enabled) return;

    final now = DateTime.now();
    final lastBackup = settings.lastBackupTime;

    bool shouldBackup = false;
    if (lastBackup == null) {
      shouldBackup = true;
    } else {
      final difference = now.difference(lastBackup);
      switch (settings.interval) {
        case BackupInterval.daily:
          if (difference.inDays >= 1) shouldBackup = true;
          break;
        case BackupInterval.weekly:
          if (difference.inDays >= 7) shouldBackup = true;
          break;
        case BackupInterval.monthly:
          if (difference.inDays >= 30) shouldBackup = true;
          break;
      }
    }

    if (shouldBackup) {
      await performAutomaticBackup(ref);
    }
  }

  Future<void> performAutomaticBackup(WidgetRef ref) async {
    final isar = await IsarService.instance;
    final appDir = await getApplicationDocumentsDirectory();
    final backupDir = Directory(p.join(appDir.path, 'backups'));
    
    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }

    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-').split('.').first;
    final backupFile = File(p.join(backupDir.path, 'backup_$timestamp.isar'));

    // Copy Isar file
    await isar.copyToFile(backupFile.path);

    // Update last backup time
    await ref.read(backupSettingsProvider.notifier).updateSettings(
      lastBackupTime: DateTime.now(),
    );

    // Cleanup old backups
    await _cleanupOldBackups(backupDir, ref.read(backupSettingsProvider).keepCount);
  }

  Future<void> _cleanupOldBackups(Directory backupDir, int keepCount) async {
    final files = await backupDir.list().where((entity) => entity is File && entity.path.endsWith('.isar')).toList();
    
    if (files.length > keepCount) {
      // Sort by last modified
      files.sort((a, b) => (a as File).lastModifiedSync().compareTo((b as File).lastModifiedSync()));
      
      // Delete oldest files
      final toDelete = files.take(files.length - keepCount);
      for (final file in toDelete) {
        await file.delete();
      }
    }
  }
}
