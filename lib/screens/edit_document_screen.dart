// screens/edit_document_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class EditDocumentScreen extends StatefulWidget {
  @override
  _EditDocumentScreenState createState() => _EditDocumentScreenState();
}

class _EditDocumentScreenState extends State<EditDocumentScreen> {
  final _formKey = GlobalKey<FormState>();
  String documentType = '';
  int documentId = 0;
  Map<String, dynamic> formData = {};

  @override
  void initState() {
    super.initState();
    _loadDocumentData();
  }

  void _loadDocumentData() async {
  final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
  if (args == null) {
    print('No arguments found');
    return;
  }
  setState(() {
    documentType = args['documentType'];
    documentId = args['documentId'];
  });
  
  await _fetchDocumentDetails();
}

  Future<void> _fetchDocumentDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    final url = 'http://127.0.0.1:8000/api/edit-document/$documentType/$documentId/'; // Replace with your actual API URL
    
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        formData = data;
      });
    } else {
      print('Failed to fetch document details');
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    final url = 'http://127.0.0.1:8000/api/edit-document/$documentType/$documentId/';
    
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(formData),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$documentType document updated successfully.')),
      );
      Navigator.pop(context);
    } else {
      print('Failed to update document');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update document.')),
      );
    }
  }

  Widget _buildFormFields() {
    switch (documentType) {
      case 'id':
        return Column(
          children: [
            TextFormField(
              initialValue: formData['name'] ?? '',
              decoration: InputDecoration(labelText: 'Name'),
              onSaved: (value) => formData['name'] = value,
              validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
            ),
            TextFormField(
              initialValue: formData['id_number'] ?? '',
              decoration: InputDecoration(labelText: 'ID Number'),
              onSaved: (value) => formData['id_number'] = value,
              validator: (value) => value!.isEmpty ? 'Please enter an ID number' : null,
            ),
            TextFormField(
              initialValue: formData['issue_date'] ?? '',
              decoration: InputDecoration(labelText: 'Issue Date'),
              onSaved: (value) => formData['issue_date'] = value,
            ),
            TextFormField(
              initialValue: formData['expiry_date'] ?? '',
              decoration: InputDecoration(labelText: 'Expiry Date'),
              onSaved: (value) => formData['expiry_date'] = value,
            ),
          ],
        );
      case 'onboarding':
        return Column(
          children: [
            TextFormField(
              initialValue: formData['name'] ?? '',
              decoration: InputDecoration(labelText: 'Onboarding Name'),
              onSaved: (value) => formData['name'] = value,
              validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
            ),
            TextFormField(
              initialValue: formData['file'] ?? '',
              decoration: InputDecoration(labelText: 'File Path'),
              onSaved: (value) => formData['file'] = value,
            ),
          ],
        );
      case 'supervision':
        return Column(
          children: [
            TextFormField(
              initialValue: formData['month'] ?? '',
              decoration: InputDecoration(labelText: 'Month'),
              onSaved: (value) => formData['month'] = value,
              validator: (value) => value!.isEmpty ? 'Please enter the month' : null,
            ),
            TextFormField(
              initialValue: formData['file'] ?? '',
              decoration: InputDecoration(labelText: 'File Path'),
              onSaved: (value) => formData['file'] = value,
            ),
          ],
        );
      case 'certificate':
        return Column(
          children: [
            TextFormField(
              initialValue: formData['certificate'] ?? '',
              decoration: InputDecoration(labelText: 'Certificate Name'),
              onSaved: (value) => formData['certificate'] = value,
              validator: (value) => value!.isEmpty ? 'Please enter a certificate name' : null,
            ),
            TextFormField(
              initialValue: formData['issue_date'] ?? '',
              decoration: InputDecoration(labelText: 'Issue Date'),
              onSaved: (value) => formData['issue_date'] = value,
            ),
            TextFormField(
              initialValue: formData['expiry_date'] ?? '',
              decoration: InputDecoration(labelText: 'Expiry Date'),
              onSaved: (value) => formData['expiry_date'] = value,
            ),
          ],
        );
      default:
        return Center(child: Text('Unknown document type'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit $documentType Document'),
      ),
      body: formData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    _buildFormFields(),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text('Update Document'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
