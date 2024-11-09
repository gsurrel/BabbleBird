import 'package:flutter/material.dart';
import 'package:tao_cat/data_access_layer/document_repository.dart';
import 'package:tao_cat/domain_layer/document_entity.dart';
import 'package:tao_cat/domain_layer/segment_entity.dart';

class DocumentProvider extends ChangeNotifier {
  DocumentProvider({required this.documentRepository});
  final DocumentRepository documentRepository;
  DocumentEntity? _document;

  DocumentEntity? get document => _document;

  Future<void> fetchDocument(String id) async {
    final documentModel = await documentRepository.getDocument(id);
    final segments = documentModel.segments
        .map(
          (segmentModel) => SegmentEntity(
            type: switch (segmentModel.isTitle) {
              null => segmentModel.sourceText.split(' ').length <= 10
                  ? SegmentType.title
                  : SegmentType.body,
              true => SegmentType.title,
              false => SegmentType.body,
            },
            id: segmentModel.id,
            sourceText: segmentModel.sourceText,
            translationText: segmentModel.translationText,
          ),
        )
        .toList();
    _document = DocumentEntity(id: documentModel.id, segments: segments);
    notifyListeners();
  }
}
