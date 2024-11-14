// Define an abstract class for a data source

import 'package:meta/meta.dart';
import 'package:tao_cat/data_access_layer/document_model.dart';

abstract interface class DataSource {
  @useResult
  Future<DocumentModel> loadDocument();
  Future<void> saveDocument(DocumentModel document);
}
