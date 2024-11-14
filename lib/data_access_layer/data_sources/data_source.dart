import 'package:meta/meta.dart';
import 'package:tao_cat/data_access_layer/document_model.dart';

/// For data sources that load and save documents.
@immutable
abstract interface class DataSource {
  /// Loads a document from the data source.
  @useResult
  Future<DocumentModel> loadDocument();

  /// Saves the provided document to the data source.
  Future<void> saveDocument(DocumentModel document);
}
