// models/supervision_document.dart
class SupervisionDocument {
  final int id;
  final String month;
  final String file;

  SupervisionDocument({
    required this.id,
    required this.month,
    required this.file,
  });

  factory SupervisionDocument.fromJson(Map<String, dynamic> json) {
    return SupervisionDocument(
      id: json['id'],
      month: json['month'],
      file: json['file'],
    );
  }
}
