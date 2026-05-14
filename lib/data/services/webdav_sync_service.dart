// Deprecated — replaced by block-based architecture
// Provider is now defined in notes_state.dart
class WebDavSyncService {
  final dynamic repo;
  final String baseUrl;
  final String username;
  final String password;
  final String remotePath;
  WebDavSyncService({required this.repo, required this.baseUrl, required this.username, required this.password, this.remotePath = '/nexusbrain'});
  Future<SyncResult> sync() async => SyncResult(pushed: 0, pulled: 0, conflicts: 0, success: false, error: 'Deprecated');
}

class SyncResult {
  final int pushed;
  final int pulled;
  final int conflicts;
  final bool success;
  final String? error;
  SyncResult({required this.pushed, required this.pulled, required this.conflicts, required this.success, this.error});
}

class WebDavConfig {
  final String baseUrl;
  final String username;
  final String password;
  final String remotePath;
  WebDavConfig({required this.baseUrl, required this.username, required this.password, this.remotePath = '/nexusbrain'});
}
