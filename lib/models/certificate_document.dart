// models/certificate_document.dart
class CertificateDocument {
  final int id;
  final String certificate;
  final String issueDate;
  final String expiryDate;
  final String file;

  CertificateDocument({
    required this.id,
    required this.certificate,
    required this.issueDate,
    required this.expiryDate,
    required this.file,
  });

  factory CertificateDocument.fromJson(Map<String, dynamic> json) {
    return CertificateDocument(
      id: json['id'],
      certificate: json['certificate'],
      issueDate: json['issue_date'],
      expiryDate: json['expiry_date'],
      file: json['file'],
    );
  }
}
