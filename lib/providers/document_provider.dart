import 'package:flutter/material.dart';
import '../services/document_service.dart';
import '../models/id_document.dart';
import '../models/onboarding_document.dart';
import '../models/supervision_document.dart';
import '../models/certificate_document.dart';

class DocumentProvider with ChangeNotifier {
  List<IDDocument> _idDocuments = [];
  List<OnboardingDocument> _onboardingDocuments = [];
  List<SupervisionDocument> _supervisionDocuments = [];
  List<CertificateDocument> _certificateDocuments = [];
  bool _isLoading = false;

  List<IDDocument> get idDocuments => _idDocuments;
  List<OnboardingDocument> get onboardingDocuments => _onboardingDocuments;
  List<SupervisionDocument> get supervisionDocuments => _supervisionDocuments;
  List<CertificateDocument> get certificateDocuments => _certificateDocuments;
  bool get isLoading => _isLoading;

  final DocumentService _documentService = DocumentService();

  Future<void> fetchDocuments() async {
    _isLoading = true;
    notifyListeners();

    try {
      _idDocuments = await _documentService.fetchIDDocuments();
      _onboardingDocuments = await _documentService.fetchOnboardingDocuments();
      _supervisionDocuments = await _documentService.fetchSupervisionDocuments();
      _certificateDocuments = await _documentService.fetchCertificateDocuments();
    } catch (e) {
      // Handle error
      print("Error fetching documents: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> uploadDocument({
    required String documentType,
    required Map<String, dynamic> documentData,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _documentService.uploadDocument(documentType, documentData);
      // Refresh the documents list after uploading
      await fetchDocuments();
    } catch (e) {
      // Handle error
      print("Error uploading document: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
