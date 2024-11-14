import 'package:flutter/material.dart';
import 'package:tao_cat/domain_layer/document_entity.dart';
import 'package:tao_cat/domain_layer/use_cases.dart';
import 'package:tao_cat/main.dart';

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

  Future<DocumentEntity> loadDocument(Source source) async {
    return await loadDocumentUseCase.execute(source);
  }

  Future<DocumentEntity> editDocument(
    DocumentEntity document,
    String newText,
    int segmentIndex,
  ) async {
    return await editDocumentUseCase.execute(document, newText, segmentIndex);
  }

  Future<void> saveDocument(DocumentEntity document) async {
    print('Future<void> saveDocument');
    await saveDocumentUseCase.execute(document);
  }
}
