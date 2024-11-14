import 'package:tao_cat/domain_layer/document_entity.dart';
import 'package:tao_cat/domain_layer/document_repository.dart';
import 'package:tao_cat/domain_layer/segment_entity.dart';
import 'package:tao_cat/domain_layer/source.dart';

/// For loading a document from a repository.
class LoadDocument {
  LoadDocument(this.repository);

  final DocumentRepository repository;

  /// Executes the use case to load a document from the specified source.
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

/// For editing a segment within a document.
class EditDocument {
  /// Executes the use case to edit the specified segment in the document.
  Future<DocumentEntity> execute(
    DocumentEntity document,
    String newText,
    int segmentIndex,
  ) async {
    // Validate the segment index
    if (segmentIndex < 0 || segmentIndex >= document.segments.length) {
      throw RangeError('Segment index out of range');
    }

    final segmentToEdit = document.segments[segmentIndex];
    final editedDocument = DocumentEntity(
      segments: List<SegmentEntity>.from(document.segments), // Deep-copy
      model: document.model,
    )..segments[segmentIndex] = SegmentEntity(
        type: segmentToEdit.type,
        sourceText: newText,
      );

    // Return the updated document
    return editedDocument;
  }
}

/// For saving a document to a repository.
class SaveDocument {
  SaveDocument(this.repository);

  final DocumentRepository repository;

  /// Executes the use case to save the document.
  Future<void> execute(DocumentEntity document) async {
    await repository.saveDocument(document.model);
  }
}