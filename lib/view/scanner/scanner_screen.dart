import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simplest_document_scanner/simplest_document_scanner.dart';

import '../../viewmodel/file_history/file_bloc.dart';
import '../../models/file_item.dart';
import '../../viewmodel/file_history/file_event.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  bool isLoading = false;

  Future<void> startScan() async {
    try {
      setState(() => isLoading = true);

      final document =
      await SimplestDocumentScanner.scanDocuments(
        options: const DocumentScannerOptions(
          maxPages: 8,
          returnJpegs: false,
          returnPdf: true,
          allowGalleryImport: true
        ),
      );

      if (document == null) {
        // user cancelled
        return;
      }

      if (!document.hasPdf) {
        throw Exception('PDF not generated');
      }

      /// Save PDF bytes to file
      final Uint8List pdfBytes = document.pdfBytes!;
      final dir = await getApplicationDocumentsDirectory();

      final fileName =
          'scan_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${dir.path}/$fileName');

      await file.writeAsBytes(pdfBytes);

      final stat = await file.stat();

      /// Send to BLoC → SQLite
      context.read<FileBloc>().add(
        AddFile(
          FileItem(
            name: fileName,
            path: file.path,
            size: stat.size,
            type: 'PDF',
            createdAt: stat.modified.toIso8601String(),
          ),
        ),
      );

      if (mounted) Navigator.pop(context);
    } on DocumentScanException catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Scan failed')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Document')),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton.icon(
          icon: const Icon(Icons.document_scanner),
          label: const Text('Start Scan'),
          onPressed: startScan,
        ),
      ),
    );
  }
}
