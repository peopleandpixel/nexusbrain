import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerPage extends StatefulWidget {
  final String filePath;
  final int? initialPage;

  const PdfViewerPage({
    super.key,
    required this.filePath,
    this.initialPage,
  });

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  late PdfViewerController _pdfViewerController;
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
    if (widget.initialPage != null) {
      // Delay jumping to page until document is loaded
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.filePath.split('/').last),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_add_outlined),
            onPressed: () {
              final pageNumber = _pdfViewerController.pageNumber;
              final link = 'pdf://page=$pageNumber';
              Clipboard.setData(ClipboardData(text: link));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Deep-Link kopiert: $link'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: SfPdfViewer.file(
        File(widget.filePath),
        controller: _pdfViewerController,
        key: _pdfViewerKey,
        onDocumentLoaded: (PdfDocumentLoadedDetails details) {
          if (widget.initialPage != null) {
            _pdfViewerController.jumpToPage(widget.initialPage!);
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () => _pdfViewerController.previousPage(),
            ),
            Text(
              'Seite ${_pdfViewerController.pageNumber} / ${_pdfViewerController.pageCount}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () => _pdfViewerController.nextPage(),
            ),
          ],
        ),
      ),
    );
  }
}
