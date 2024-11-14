import 'dart:convert';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:tao_cat/data_access_layer/document_model.dart';
import 'package:tao_cat/data_access_layer/format_handlers/format_handler.dart';
import 'package:tao_cat/data_access_layer/segment_model.dart';

/// A format handler for parsing and serializing flat file documents.
@immutable
class FlatFileFormatHandler implements FormatHandler {
  @override
  DocumentModel parse(Uint8List content) => DocumentModel(
        segments: extractSegments(content),
        originalContent: content,
      );

  @override
  Uint8List serialize(DocumentModel document) {
    StringBuffer buffer = StringBuffer();

    for (final segment in document.segments.asMap().entries) {
      if (segment
          case MapEntry(key: 0) ||
              MapEntry(
                key: > 0,
                value: SegmentModel(isTitle: true),
              )) buffer.writeln();

      buffer.writeln(segment.value.sourceText);
    }

    return Uint8List.fromList(buffer.toString().codeUnits);
  }

  @override
  List<SegmentModel> extractSegments(Uint8List content) {
    String textContent = utf8.decode(content);

    List<String> lines = textContent.split('\n');
    List<SegmentModel> segments = [];

    bool previousLineEmpty = true;

    for (String line in lines) {
      if (line.trim().isEmpty) {
        previousLineEmpty = true;
        continue;
      }

      bool isHeading = previousLineEmpty || segments.isEmpty;

      segments.add(
        SegmentModel(sourceText: line, isTitle: isHeading),
      );
      previousLineEmpty = false;
    }

    return segments;
  }
}
