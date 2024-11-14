import 'package:flutter/material.dart';
import 'package:tao_cat/domain_layer/document_entity.dart';
import 'package:tao_cat/domain_layer/source.dart';
import 'package:tao_cat/domain_layer/use_cases.dart';

/// A service that encapsulates document-related use cases.
@immutable
class DocumentService {
  final LoadDocument loadDocumentUseCase;
  final EditDocument editDocumentUseCase;
  final SaveDocument saveDocumentUseCase;

  const DocumentService({
    required this.loadDocumentUseCase,
    required this.editDocumentUseCase,
    required this.saveDocumentUseCase,
  });

  /// Loads a document from the specified source.
  Future<DocumentEntity> loadDocument(Source source) async {
    return await loadDocumentUseCase.execute(source);
  }

  /// Edits a document segment.
  Future<DocumentEntity> editDocument(
    DocumentEntity document,
    String newText,
    int segmentIndex,
  ) async {
    return await editDocumentUseCase.execute(document, newText, segmentIndex);
  }

  /// Saves the document.
  Future<void> saveDocument(DocumentEntity document) async {
    await saveDocumentUseCase.execute(document);
  }
}
