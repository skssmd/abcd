// models/onboarding_document.dart
class OnboardingDocument {
  final int id;
  final String name;
  final String file;

  OnboardingDocument({
    required this.id,
    required this.name,
    required this.file,
  });

  factory OnboardingDocument.fromJson(Map<String, dynamic> json) {
    return OnboardingDocument(
      id: json['id'],
      name: json['name'],
      file: json['file'],
    );
  }
}
