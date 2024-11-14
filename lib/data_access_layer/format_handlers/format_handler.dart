import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:tao_cat/data_access_layer/document_model.dart';
import 'package:tao_cat/data_access_layer/segment_model.dart';

/// An interface for format handlers that parse and serialize document content.
abstract interface class FormatHandler {
  @useResult
  DocumentModel parse(Uint8List content);

  @useResult
  Uint8List serialize(DocumentModel document);

  @useResult
  List<SegmentModel> extractSegments(Uint8List content);
}
