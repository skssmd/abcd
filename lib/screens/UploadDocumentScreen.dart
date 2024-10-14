import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/document_provider.dart';

class IDDocumentUploadScreen extends StatefulWidget {
  @override
  _IDDocumentUploadScreenState createState() => _IDDocumentUploadScreenState();
}

class _IDDocumentUploadScreenState extends State<IDDocumentUploadScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _idNumber = '';
  DateTime? _issueDate;
  DateTime? _expiryDate;
  String _file = '';

  Future<void> _selectDate(BuildContext context, bool isIssueDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        if (isIssueDate) {
          _issueDate = picked;
        } else {
          _expiryDate = picked;
        }
      });
    }
  }

  void _uploadDocument() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Provider.of<DocumentProvider>(context, listen: false).uploadDocument(
        documentType: 'id',
        documentData: {
          'name': _name,
          'id_number': _idNumber,
          'issue_date': _issueDate?.toIso8601String(),
          'expiry_date': _expiryDate?.toIso8601String(),
          'file': _file,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload ID Document'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                onSaved: (value) => _name = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a name' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'ID Number'),
                onSaved: (value) => _idNumber = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter ID number' : null,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _issueDate == null
                          ? 'Select Issue Date'
                          : 'Issue Date: ${_issueDate.toString().split(' ')[0]}',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectDate(context, true),
                    child: Text('Pick Date'),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _expiryDate == null
                          ? 'Select Expiry Date'
                          : 'Expiry Date: ${_expiryDate.toString().split(' ')[0]}',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectDate(context, false),
                    child: Text('Pick Date'),
                  ),
                ],
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'File Path'),
                onSaved: (value) => _file = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter file path' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadDocument,
                child: Text('Upload Document'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
