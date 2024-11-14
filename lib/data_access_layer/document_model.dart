import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:tao_cat/data_access_layer/segment_model.dart';

/// Represents a document.
@immutable
class DocumentModel {
  const DocumentModel({
    required List<SegmentModel> segments,
    required this.originalContent,
  }) : _segments = segments;

  /// The parsed segments in the document.
  List<SegmentModel> get segments => List.unmodifiable(_segments);
  final List<SegmentModel> _segments;

  /// The original binary content of the document.
  final Uint8List originalContent;
}
