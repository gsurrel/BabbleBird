import 'package:flutter/material.dart';
import 'package:tao_cat/data_access_layer/data_sources/data_source.dart';
import 'package:tao_cat/data_access_layer/document_model.dart';

@immutable
class DocumentRepository {
  const DocumentRepository({required this.dataSource});

  Future<DocumentModel> getDocument(String id) {
    return dataSource.fetchDocument(id);
  }

  final DataSource dataSource;
}
