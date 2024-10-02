import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:screenshot/screenshot.dart';
import 'dart:typed_data'; // Import this for Uint8List

class CapturePrintWidget extends StatelessWidget {
  final ScreenshotController screenshotController;

  CapturePrintWidget({required this.screenshotController});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _captureConvertAndPrint(context),
      child: Text('Capture, Convert to PDF, and Print'),
    );
  }

  Future<void> _captureConvertAndPrint(BuildContext context) async {
    // Capture the screen
    Uint8List? capturedImage = await screenshotController.capture();

    if (capturedImage != null) {
      // Convert the image to a PDF
      pw.Document pdfDocument = pw.Document();

      final pdfImage = pw.MemoryImage(
        capturedImage,
      );

      pdfDocument.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(pdfImage),
            );
          },
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Screenshot captured, converted to PDF, and printing...')),
      );

      // Print the PDF
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfDocument.save(),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to capture screenshot.')),
      );
    }
  }
}
