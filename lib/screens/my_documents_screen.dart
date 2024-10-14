// screens/my_documents_page.dart
import 'package:flutter/material.dart';
import 'package:onehr/widgets/bottom_navigation_bar.dart';
import '../services/document_service.dart';
import '../models/document_model.dart';
import '../widgets/header_bar.dart';

class MyDocumentsPage extends StatefulWidget {
  @override
  _MyDocumentsPageState createState() => _MyDocumentsPageState();
}

class _MyDocumentsPageState extends State<MyDocumentsPage> {
  late Future<Map<String, dynamic>> documentsFuture;

  @override
  void initState() {
    super.initState();
    documentsFuture = DocumentService().fetchDocuments();
  }

  // This method handles navigation to the Edit Document screen
  void _navigateToEditDocument(BuildContext context, String documentType, int documentId) {
    Navigator.pushNamed(
      context,
      '/edit_document',
      arguments: {
        'documentType': documentType,
        'documentId': documentId,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderBar(),
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

            return SingleChildScrollView(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // IDs Section
                  Text(
                    'IDs',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...ids.map((id) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 4.0),
                      child: ListTile(
                        title: Text(id.name),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                           Navigator.pushNamed(
      context,
      '/edit_document',
      arguments: {
        'documentType': 'Onboarding',
        'documentId': id.id ,
      },
    );
                          },
                        ),
                      ),
                    );
                  }).toList(),

                  // Onboardings Section
                  SizedBox(height: 16),
                  Text(
                    'Onboardings',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...onboardings.map((onboarding) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 4.0),
                      child: ListTile(
                        title: Text(onboarding.name),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _navigateToEditDocument(context, 'onboarding', onboarding.id);
                          },
                        ),
                      ),
                    );
                  }).toList(),

                  // Supervisions Section
                  SizedBox(height: 16),
                  Text(
                    'Supervisions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...supervisions.map((supervision) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 4.0),
                      child: ListTile(
                        title: Text(supervision.month),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _navigateToEditDocument(context, 'supervision', supervision.id);
                          },
                        ),
                      ),
                    );
                  }).toList(),

                  // Certificates Section
                  SizedBox(height: 16),
                  Text(
                    'Certificates',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...certificates.map((certificate) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 4.0),
                      child: ListTile(
                        title: Text(certificate.certificate),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _navigateToEditDocument(context, 'certificate', certificate.id);
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: 3,
      ),
    );
  }
}
