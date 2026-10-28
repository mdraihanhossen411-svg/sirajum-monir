import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfReaderPage extends StatefulWidget {
  final String title;
  final String assetPath;

  const PdfReaderPage({
    super.key,
    required this.title,
    required this.assetPath,
  });

  @override
  State<PdfReaderPage> createState() => _PdfReaderPageState();
}

class _PdfReaderPageState extends State<PdfReaderPage> {
  final PdfViewerController _pdfController = PdfViewerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            tooltip: 'প্রথম পৃষ্ঠা',
            icon: const Icon(Icons.first_page),
            onPressed: () => _pdfController.firstPage(),
          ),
          IconButton(
            tooltip: 'শেষ পৃষ্ঠা',
            icon: const Icon(Icons.last_page),
            onPressed: () => _pdfController.lastPage(),
          ),
        ],
      ),
      body: SfPdfViewer.asset(
        widget.assetPath,
        controller: _pdfController,
        enableDoubleTapZooming: true,
        canShowScrollHead: true,
        canShowScrollStatus: true,
      ),
    );
  }
}
