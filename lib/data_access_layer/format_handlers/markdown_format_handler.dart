import 'dart:typed_data';

import 'package:tao_cat/data_access_layer/document_model.dart';
import 'package:tao_cat/data_access_layer/format_handlers/format_handler.dart';
import 'package:tao_cat/data_access_layer/segment_model.dart';

class MarkdownFormatHandler implements FormatHandler {
  @override
  DocumentModel parse(Uint8List content) {
    String textContent = String.fromCharCodes(content);

    List<SegmentModel> segments = _parseMarkdown(textContent);

    return DocumentModel(segments: segments, originalContent: content);
  }

  @override
  Uint8List serialize(DocumentModel document) {
    String markdownContent = _serializeToMarkdown(document.segments);

    return Uint8List.fromList(markdownContent.codeUnits);
  }

  @override
  List<SegmentModel> extractSegments(Uint8List content) {
    throw UnimplementedError();
  }

  // Helper methods for parsing and serializing Markdown
  List<SegmentModel> _parseMarkdown(String content) {
    throw UnimplementedError();
  }

  String _serializeToMarkdown(List<SegmentModel> segments) {
    throw UnimplementedError();
  }
}
