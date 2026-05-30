import 'dart:typed_data';
import 'package:webdav_client/webdav_client.dart' as webdav;
import 'sync_service.dart';

/// Implementierung des [SyncService] für WebDAV.
///
/// Ermöglicht die Synchronisation von App-Daten mit einem WebDAV-Server
/// (z.B. Nextcloud, Synology).
class WebDavSyncService implements SyncService {
  final String host;
  final String user;
  final String password;
  final String path;
  final int port;
  final bool secure;

  webdav.Client? _client;

  WebDavSyncService({
    required this.host,
    required this.user,
    required this.password,
    this.path = '/',
    this.port = 443,
    this.secure = true,
  });

  @override
  Future<bool> connect() async {
    try {
      _client = webdav.newClient(
        host,
        user: user,
        password: password,
      );
      
      // Test connection by listing root
      await _client!.readDir('/');
      return true;
    } catch (e) {
      _client = null;
      return false;
    }
  }

  @override
  Future<void> disconnect() async {
    _client = null;
  }

  @override
  Future<bool> isConnected() async {
    return _client != null;
  }

  @override
  Future<void> uploadFile(String remotePath, List<int> content) async {
    if (_client == null) throw Exception('Not connected');
    await _client!.write(remotePath, Uint8List.fromList(content));
  }

  @override
  Future<List<int>?> downloadFile(String remotePath) async {
    if (_client == null) throw Exception('Not connected');
    try {
      final response = await _client!.read(remotePath);
      return response.toList();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<String>> listFiles(String remotePath) async {
    if (_client == null) throw Exception('Not connected');
    final response = await _client!.readDir(remotePath);
    return response.map((f) => f.name ?? '').where((name) => name.isNotEmpty).toList();
  }

  @override
  Future<void> deleteFile(String remotePath) async {
    if (_client == null) throw Exception('Not connected');
    await _client!.remove(remotePath);
  }

  @override
  Future<bool> fileExists(String remotePath) async {
    if (_client == null) throw Exception('Not connected');
    try {
      // webdav_client doesn't have a simple exists, so we try to list it or read metadata
      await _client!.readDir(remotePath);
      return true;
    } catch (e) {
      return false;
    }
  }
}
