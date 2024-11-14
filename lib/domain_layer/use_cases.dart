import 'package:tao_cat/domain_layer/document_entity.dart';
import 'package:tao_cat/domain_layer/document_repository.dart';
import 'package:tao_cat/domain_layer/segment_entity.dart';
import 'package:tao_cat/main.dart';

class LoadDocument {
  final DocumentRepository repository;

  LoadDocument(this.repository);

  Future<DocumentEntity> execute(Source source) async {
    final documentModel = await repository.loadDocument(source);

    final segments = documentModel.segments
        .map(
          (segmentModel) => SegmentEntity(
            type: switch (segmentModel.isTitle) {
              true => SegmentType.title,
              false => SegmentType.body,
            },
            sourceText: segmentModel.sourceText,
          ),
        )
        .toList();

    return DocumentEntity(segments: segments, model: documentModel);
  }
}

class EditDocument {
  Future<DocumentEntity> execute(
    DocumentEntity document,
    String newText,
    int segmentIndex,
  ) async {
    // Validate the segment index
    if (segmentIndex < 0 || segmentIndex >= document.segments.length) {
      throw RangeError('Segment index out of range');
    }

    document.segments[segmentIndex].sourceText = newText;

    // Return the updated document
    return document;
  }
}

class SaveDocument {
  final DocumentRepository repository;

  SaveDocument(this.repository);

  Future<void> execute(DocumentEntity document) async {
    print('Future<void> execute');
    await repository.saveDocument(document.model);
  }
}
