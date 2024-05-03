import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tao_cat/domain_layer/document_entity.dart';
import 'package:tao_cat/domain_layer/document_provider.dart';
import 'package:tao_cat/domain_layer/segment_entity.dart';

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({super.key});

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<DocumentProvider>(context, listen: false)
        .fetchDocument('documentId');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DocumentProvider>(
      builder: (context, documentProvider, child) {
        return switch (documentProvider.document) {
          null => const CircularProgressIndicator(),
          (DocumentEntity document) => ListView.builder(
              itemCount: document.segments.length,
              itemBuilder: (context, index) {
                SegmentEntity segment =
                    documentProvider.document!.segments[index];
                return ListTile(
                  title: Text(segment.sourceText),
                  subtitle: Text(segment.translationText),
                );
              },
            ),
        };
      },
    );
  }
}
