import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfViewerScreen extends StatelessWidget {
  final String downloadUrl;

  PdfViewerScreen({required this.downloadUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: PDFView(
        filePath: downloadUrl, // Make sure to provide the correct file path
        autoSpacing: false,
        pageFling: true,
        onError: (error) {
          debugPrint('Error while viewing PDF: $error');
        },
      ),
    );
  }
}
