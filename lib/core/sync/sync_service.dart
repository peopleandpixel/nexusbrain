abstract class SyncService {
  Future<bool> connect();
  Future<void> disconnect();
  Future<bool> isConnected();
  
  /// Uploads a file to the remote storage
  Future<void> uploadFile(String remotePath, List<int> content);
  
  /// Downloads a file from the remote storage
  Future<List<int>?> downloadFile(String remotePath);
  
  /// Lists files in a remote directory
  Future<List<String>> listFiles(String remotePath);
  
  /// Deletes a file from the remote storage
  Future<void> deleteFile(String remotePath);

  /// Checks if a file exists on the remote storage
  Future<bool> fileExists(String remotePath);
}
