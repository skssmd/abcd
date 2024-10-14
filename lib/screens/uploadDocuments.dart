// screens/home_screen.dart
import 'package:flutter/material.dart';
import '../services/document_service.dart';
import '../models/document_model.dart';

class UploadDocuments extends StatefulWidget {
  @override
  _UploadDocumentsState createState() => _UploadDocumentsState();
}

class _UploadDocumentsState extends State<UploadDocuments> {
  late Future<Map<String, dynamic>> documentsFuture;

  @override
  void initState() {
    super.initState();
    documentsFuture = DocumentService().fetchDocuments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Documents'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: documentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            final ids = (data['ids'] as List)
                .map((json) => IDDocument.fromJson(json))
                .toList();
            final onboardings = (data['onboardings'] as List)
                .map((json) => OnboardingDocument.fromJson(json))
                .toList();
            final supervisions = (data['supervisions'] as List)
                .map((json) => SupervisionDocument.fromJson(json))
                .toList();
            final certificates = (data['certificates'] as List)
                .map((json) => CertificateDocument.fromJson(json))
                .toList();

            return ListView(
              padding: EdgeInsets.all(8.0),
              children: [
                Text('IDs:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ...ids.map((id) => ListTile(title: Text(id.name))),
                Divider(),
                Text('Onboardings:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ...onboardings.map((onboarding) => ListTile(title: Text(onboarding.name))),
                Divider(),
                Text('Supervisions:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ...supervisions.map((supervision) => ListTile(title: Text(supervision.month))),
                Divider(),
                Text('Certificates:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ...certificates.map((certificate) => ListTile(title: Text(certificate.certificate))),
              ],
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
