import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:tao_cat/data_access_layer/document_model.dart';
import 'package:tao_cat/data_access_layer/segment_model.dart';

/// An interface for format handlers that parse and serialize document content.
abstract interface class FormatHandler {
  /// Parses binary content into a document model.
  @useResult
  DocumentModel parse(Uint8List content);

  /// Serializes a document model into binary format.
  @useResult
  Uint8List serialize(DocumentModel document);

  /// Extracts segments from binary content.
  @useResult
  List<SegmentModel> extractSegments(Uint8List content);
}
