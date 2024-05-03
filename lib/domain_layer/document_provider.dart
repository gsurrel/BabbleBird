import 'package:tao_cat/data_access_layer/document_model.dart';
import 'package:tao_cat/data_access_layer/document_repository.dart';
import 'package:tao_cat/domain_layer/document_entity.dart';
import 'package:tao_cat/domain_layer/segment_entity.dart';
import 'package:flutter/material.dart';

class DocumentProvider extends ChangeNotifier {
  final DocumentRepository documentRepository;
  DocumentEntity? _document;

  DocumentProvider({required this.documentRepository});

  DocumentEntity? get document => _document;

  Future<void> fetchDocument(String id) async {
    DocumentModel documentModel = await documentRepository.getDocument(id);
    List<SegmentEntity> segments = documentModel.segments
        .map(
          (segmentModel) => SegmentEntity(
            id: segmentModel.id,
            sourceText: segmentModel.sourceText,
            translationText: segmentModel.translationText,
            notes: segmentModel.notes,
          ),
        )
        .toList();
    _document = DocumentEntity(id: documentModel.id, segments: segments);
    notifyListeners();
  }
}
