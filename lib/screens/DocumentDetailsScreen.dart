import 'package:flutter/material.dart';

class DocumentDetailsScreen extends StatelessWidget {
  static const routeName = '/document/details';

  final int documentId;
  final String documentType;

  const DocumentDetailsScreen({Key? key, required this.documentId, required this.documentType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$documentType Details')),
      body: Center(
        child: Text('Display details for $documentType document with ID: $documentId'),
      ),
    );
  }
}
