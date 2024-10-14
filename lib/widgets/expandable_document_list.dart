// widgets/expandable_document_list.dart
import 'package:flutter/material.dart';
class ExpandableDocumentList<T> extends StatelessWidget {
  final String title;
  final List<T> documents;
  final Widget Function(T) itemBuilder;
  final Function(T) onEdit; // Change from VoidCallback Function(T) to Function(T)

  const ExpandableDocumentList({
    Key? key,
    required this.title,
    required this.documents,
    required this.itemBuilder,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      children: documents.map((doc) {
        return ListTile(
          title: itemBuilder(doc),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              print('Editing document with ID: ${doc}');
              onEdit(doc); // Correctly call the onEdit function with the document
            },
          ),
        );
      }).toList(),
    );
  }
}
