// models/id_document.dart
class IDDocument {
  final int id;
  final String name;
  final String idNumber;
  final String issueDate;
  final String expiryDate;
  final String file;

  IDDocument({
    required this.id,
    required this.name,
    required this.idNumber,
    required this.issueDate,
    required this.expiryDate,
    required this.file,
  });

  factory IDDocument.fromJson(Map<String, dynamic> json) {
    return IDDocument(
      id: json['id'],
      name: json['name'],
      idNumber: json['id_number'],
      issueDate: json['issue_date'],
      expiryDate: json['expiry_date'],
      file: json['file'],
    );
  }
}
