// models/document_models.dart

class Document {
  final List<IDDocument> ids;
  final List<OnboardingDocument> onboardings;
  final List<SupervisionDocument> supervisions;
  final List<CertificateDocument> certificates;

  Document({
    required this.ids,
    required this.onboardings,
    required this.supervisions,
    required this.certificates,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      ids: (json['ids'] as List)
          .map((i) => IDDocument.fromJson(i))
          .toList(),
      onboardings: (json['onboardings'] as List)
          .map((i) => OnboardingDocument.fromJson(i))
          .toList(),
      supervisions: (json['supervisions'] as List)
          .map((i) => SupervisionDocument.fromJson(i))
          .toList(),
      certificates: (json['certificates'] as List)
          .map((i) => CertificateDocument.fromJson(i))
          .toList(),
    );
  }
}

class IDDocument {
  final int id;
  final String name;
  final String idNumber;
  final String issueDate;
  final String expiryDate;
  final String file;
  final String message;
  final DateTime uploadedAt;
  final bool undeletable;
  final bool approved;
  final bool declined;
  final bool pending;
  final int staff;

  IDDocument({
    required this.id,
    required this.name,
    required this.idNumber,
    required this.issueDate,
    required this.expiryDate,
    required this.file,
    required this.message,
    required this.uploadedAt,
    required this.undeletable,
    required this.approved,
    required this.declined,
    required this.pending,
    required this.staff,
  });

  factory IDDocument.fromJson(Map<String, dynamic> json) {
    return IDDocument(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      idNumber: json['id_number'] ?? 'N/A',
      issueDate: json['issue_date'] ?? 'N/A',
      expiryDate: json['expiry_date'] ?? 'N/A',
      file: json['file'] ?? 'N/A',
      message: json['message'] ?? '',
      uploadedAt: DateTime.parse(json['uploaded_at'] ?? DateTime.now().toString()),
      undeletable: json['undeletable'] ?? false,
      approved: json['approved'] ?? false,
      declined: json['declined'] ?? false,
      pending: json['pending'] ?? false,
      staff: json['staff'] ?? 0,
    );
  }
}

class OnboardingDocument {
  final int id;
  final String name;
  final String file;
  final String message;
  final DateTime uploadedAt;
  final bool approved;
  final bool needsSignature;
  final bool declined;
  final bool undeletable;
  final bool pending;
  final int staff;

  OnboardingDocument({
    required this.id,
    required this.name,
    required this.file,
    required this.message,
    required this.uploadedAt,
    required this.approved,
    required this.needsSignature,
    required this.declined,
    required this.undeletable,
    required this.pending,
    required this.staff,
  });

  factory OnboardingDocument.fromJson(Map<String, dynamic> json) {
    return OnboardingDocument(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      file: json['file'] ?? 'N/A',
      message: json['message'] ?? '',
      uploadedAt: DateTime.parse(json['uploaded_at'] ?? DateTime.now().toString()),
      approved: json['approved'] ?? false,
      needsSignature: json['needs_signature'] ?? false,
      declined: json['declined'] ?? false,
      undeletable: json['undeletable'] ?? false,
      pending: json['pending'] ?? false,
      staff: json['staff'] ?? 0,
    );
  }
}

class SupervisionDocument {
  final int id;
  final String name;
  final String month;
  final String file;
  final String message;
  final DateTime uploadedAt;
  final bool approved;
  final bool needsSignature;
  final bool declined;
  final bool undeletable;
  final bool pending;
  final int staff;

  SupervisionDocument({
    required this.id,
    required this.name,
    required this.month,
    required this.file,
    required this.message,
    required this.uploadedAt,
    required this.approved,
    required this.needsSignature,
    required this.declined,
    required this.undeletable,
    required this.pending,
    required this.staff,
  });

  factory SupervisionDocument.fromJson(Map<String, dynamic> json) {
    return SupervisionDocument(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      month: json['month'] ?? 'N/A',
      file: json['file'] ?? 'N/A',
      message: json['message'] ?? '',
      uploadedAt: DateTime.parse(json['uploaded_at'] ?? DateTime.now().toString()),
      approved: json['approved'] ?? false,
      needsSignature: json['needs_signature'] ?? false,
      declined: json['declined'] ?? false,
      undeletable: json['undeletable'] ?? false,
      pending: json['pending'] ?? false,
      staff: json['staff'] ?? 0,
    );
  }
}

class CertificateDocument {
  final int id;
  final String name;
  final String certificate;
  final String issueDate;
  final String expiryDate;
  final String file;
  final String message;
  final DateTime uploadedAt;
  final bool approved;
  final bool declined;
  final bool undeletable;
  final bool pending;
  final int staff;

  CertificateDocument({
    required this.id,
    required this.name,
    required this.certificate,
    required this.issueDate,
    required this.expiryDate,
    required this.file,
    required this.message,
    required this.uploadedAt,
    required this.approved,
    required this.declined,
    required this.undeletable,
    required this.pending,
    required this.staff,
  });

  factory CertificateDocument.fromJson(Map<String, dynamic> json) {
    return CertificateDocument(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      certificate: json['certificate'] ?? 'N/A',
      issueDate: json['issue_date'] ?? 'N/A',
      expiryDate: json['expiry_date'] ?? 'N/A',
      file: json['file'] ?? 'N/A',
      message: json['message'] ?? '',
      uploadedAt: DateTime.parse(json['uploaded_at'] ?? DateTime.now().toString()),
      approved: json['approved'] ?? false,
      declined: json['declined'] ?? false,
      undeletable: json['undeletable'] ?? false,
      pending: json['pending'] ?? false,
      staff: json['staff'] ?? 0,
    );
  }
}
