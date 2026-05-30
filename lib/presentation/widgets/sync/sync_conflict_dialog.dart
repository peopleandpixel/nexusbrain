import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../domain/models/sync_conflict.dart';

class SyncConflictDialog extends StatelessWidget {
  final SyncConflict conflict;

  const SyncConflictDialog({super.key, required this.conflict});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('settings.sync_conflict.title'.tr()),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('settings.sync_conflict.subtitle'.tr(args: [conflict.localPage.title])),
            const SizedBox(height: 16),
            _VersionComparison(conflict: conflict),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text('settings.sync_conflict.use_local'.tr()),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('settings.sync_conflict.use_remote'.tr()),
        ),
      ],
    );
  }
}

class _VersionComparison extends StatelessWidget {
  final SyncConflict conflict;

  const _VersionComparison({required this.conflict});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _VersionCard(
          title: 'settings.sync_conflict.local_version'.tr(),
          updatedAt: conflict.localPage.updatedAt,
          blocksCount: conflict.localBlocks.length,
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        const SizedBox(height: 8),
        const Icon(Icons.vignette_outlined),
        const SizedBox(height: 8),
        _VersionCard(
          title: 'settings.sync_conflict.remote_version'.tr(),
          updatedAt: conflict.remotePage.updatedAt,
          blocksCount: conflict.remoteBlocks.length,
          color: Theme.of(context).colorScheme.secondaryContainer,
        ),
      ],
    );
  }
}

class _VersionCard extends StatelessWidget {
  final String title;
  final DateTime? updatedAt;
  final int blocksCount;
  final Color color;

  const _VersionCard({
    required this.title,
    required this.updatedAt,
    required this.blocksCount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 4),
            Text('settings.sync_conflict.updated_at'.tr(args: [
              updatedAt != null ? DateFormat.yMMMd().add_Hm().format(updatedAt!) : '-',
            ],),),
            Text('settings.sync_conflict.blocks_count'.tr(args: [blocksCount.toString()])),
          ],
        ),
      ),
    );
  }
}
