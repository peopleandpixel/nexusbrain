// Deprecated — replaced by block-based architecture
class ImportExportService {
  final dynamic repo;
  ImportExportService(this.repo);
  Future<ImportResult> importFile() async => ImportResult(cancelled: true);
  Future<ImportResult> importFromDirectory() async => ImportResult(cancelled: true);
  Future<ExportResult> exportAllNotes() async => ExportResult(cancelled: true);
  Future<ExportResult> exportAsJson() async => ExportResult(cancelled: true);
}

class ImportResult {
  final int imported;
  final int failed;
  final bool cancelled;
  ImportResult({this.imported = 0, this.failed = 0, this.cancelled = false});
}

class ExportResult {
  final int exported;
  final bool cancelled;
  ExportResult({this.exported = 0, this.cancelled = false});
}
