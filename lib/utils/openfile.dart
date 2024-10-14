import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:onehr/screens/pdf_viewer_page.dart';
import 'package:open_filex/open_filex.dart';

class OpenFileUtil {
  static Future<void> openFile(File file) async {
    final filePath = file.path;
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
    if (filePath.endsWith('.pdf')) {
      // Open PDF viewer
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (context) => PdfViewerPage(filePath: filePath),
        ),
      );
    } else {
      // Use OpenFilex to open other file types
      OpenFilex.open(filePath);
    }
  }
}
