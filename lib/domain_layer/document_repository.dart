import 'package:tao_cat/data_access_layer/data_sources/data_source.dart';
import 'package:tao_cat/data_access_layer/data_sources/file_document_data_source.dart';
import 'package:tao_cat/data_access_layer/data_sources/random_document_data_source.dart';
import 'package:tao_cat/data_access_layer/document_model.dart';
import 'package:tao_cat/domain_layer/source.dart';

/// A repository for managing document data.
class DocumentRepository {
  DataSource? dataSource;

  /// Loads a document from the appropriate data source based on the provided source.
  /// Throws an exception if the document cannot be loaded.
  Future<DocumentModel> loadDocument(Source source) async {
    final dataSource = switch (source) {
      RandomSource(
        :final numParagraphs,
        :final minWordsPerParagraph,
        :final maxWordsPerParagraph
      ) =>
        RandomDocumentDataSource(
            numParagraphs: numParagraphs,
            minWordsPerParagraph: minWordsPerParagraph,
            maxWordsPerParagraph: maxWordsPerParagraph),
      FileSource(:final filePickerResult) =>
        FileDocumentDataSource(filePickerResult),
    };

    final document = await dataSource.loadDocument();
    this.dataSource = dataSource;

    return document;
  }

  /// Saves the provided document to the appropriate data source based on the
  /// provided source.
  Future<void> saveDocument(DocumentModel document) async {
    if (dataSource case final FileDocumentDataSource source) {
      await source.saveDocument(document);
    } else {
      throw UnsupportedError('Cannot save an unopened document');
    }
  }
}
