import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'sync_service.dart';

/// Implementierung des [SyncService] für Git.
///
/// Ermöglicht die Synchronisation von App-Daten mit einem Git-Repository.
class GitSyncService implements SyncService {
  final String repoUrl;
  final String branch;
  final String? user;
  final String? password;

  Directory? _localDir;
  bool _isConnected = false;

  GitSyncService({
    required this.repoUrl,
    this.branch = 'main',
    this.user,
    this.password,
  });

  @override
  Future<bool> connect() async {
    try {
      final docDir = await getApplicationDocumentsDirectory();
      _localDir = Directory(p.join(docDir.path, 'nexusbrain_git_sync'));

      if (!await _localDir!.exists()) {
        await _localDir!.create(recursive: true);
      }

      if (!await Directory(p.join(_localDir!.path, '.git')).exists()) {
        // Clone if not exists
        String authenticatedUrl = repoUrl;
        if (user != null && password != null) {
          final uri = Uri.parse(repoUrl);
          authenticatedUrl = uri.replace(
            userInfo: '$user:$password',
          ).toString();
        }
        
        await Process.run('git', ['clone', '-b', branch, authenticatedUrl, _localDir!.path]);
      } else {
        // Pull latest changes
        await Process.run('git', ['pull', 'origin', branch], workingDirectory: _localDir!.path);
      }

      _isConnected = true;
      return true;
    } catch (e) {
      _isConnected = false;
      return false;
    }
  }

  @override
  Future<void> disconnect() async {
    _isConnected = false;
  }

  @override
  Future<bool> isConnected() async {
    return _isConnected;
  }

  @override
  Future<void> uploadFile(String remotePath, List<int> content) async {
    if (_localDir == null) throw Exception('Not connected');
    
    final file = File(p.join(_localDir!.path, remotePath));
    await file.writeAsBytes(content);

    await Process.run('git', ['add', remotePath], workingDirectory: _localDir!.path);
    await Process.run('git', ['commit', '-m', 'Sync update from NexusBrain'], workingDirectory: _localDir!.path);
    await Process.run('git', ['push', 'origin', branch], workingDirectory: _localDir!.path);
  }

  @override
  Future<List<int>?> downloadFile(String remotePath) async {
    if (_localDir == null) throw Exception('Not connected');
    
    // Always pull before download to be sure
    await Process.run('git', ['pull', 'origin', branch], workingDirectory: _localDir!.path);
    
    final file = File(p.join(_localDir!.path, remotePath));
    if (await file.exists()) {
      return file.readAsBytes();
    }
    return null;
  }

  @override
  Future<List<String>> listFiles(String remotePath) async {
    if (_localDir == null) throw Exception('Not connected');
    final dir = Directory(p.join(_localDir!.path, remotePath));
    if (await dir.exists()) {
      return dir.list().map((entity) => p.basename(entity.path)).toList();
    }
    return [];
  }

  @override
  Future<void> deleteFile(String remotePath) async {
    if (_localDir == null) throw Exception('Not connected');
    final file = File(p.join(_localDir!.path, remotePath));
    if (await file.exists()) {
      await Process.run('git', ['rm', remotePath], workingDirectory: _localDir!.path);
      await Process.run('git', ['commit', '-m', 'Delete $remotePath'], workingDirectory: _localDir!.path);
      await Process.run('git', ['push', 'origin', branch], workingDirectory: _localDir!.path);
    }
  }

  @override
  Future<bool> fileExists(String remotePath) async {
    if (_localDir == null) return false;
    return File(p.join(_localDir!.path, remotePath)).exists();
  }
}
