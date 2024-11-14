import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:tao_cat/data_access_layer/data_sources/data_source.dart';
import 'package:tao_cat/data_access_layer/document_model.dart';
import 'package:tao_cat/data_access_layer/format_handlers/flat_file_format_handler.dart';
import 'package:tao_cat/data_access_layer/format_handlers/format_handler.dart';
import 'package:tao_cat/data_access_layer/format_handlers/markdown_format_handler.dart';

/// A data source for loading and saving documents from files.
class FileDocumentDataSource implements DataSource {
  FileDocumentDataSource(this.filePickerResult);

  late final FormatHandler formatHandler;

  FilePickerResult? filePickerResult;

  @override
  Future<DocumentModel> loadDocument() async {
    // Handle the result of the file picker
    final source = switch (filePickerResult) {
      FilePickerResult(
        files: [PlatformFile(:final Uint8List bytes, :final String extension)]
      ) =>
        (
          bytes: bytes,
          extension: extension,
        ),
      FilePickerResult(files: [PlatformFile(bytes: null)]) =>
        throw UnimplementedError(
          'Not handling unread files',
        ),
      null => throw UnimplementedError('Not handling canceled pick'),
      FilePickerResult(files: List()) => throw UnimplementedError(
          'Not handling more or less than one selected file',
        ),
    };

    // Register the content parser
    formatHandler = switch (source.extension) {
      'md' => MarkdownFormatHandler(),
      'txt' => FlatFileFormatHandler(),
      final format => throw UnsupportedError('Format $format unknown')
    };

    // Return the parsed document
    return formatHandler.parse(source.bytes);
  }

  @override
  Future<void> saveDocument(DocumentModel document) async {
    // Use the handler to serialize the document
    Uint8List content = FlatFileFormatHandler().serialize(document);

    // Write the bytes back to the file
    if (filePickerResult
        case FilePickerResult(
          files: [PlatformFile(:final String path)],
        )) {
      final file = File(path);
      await file.writeAsBytes(content);
    }
  }
}
