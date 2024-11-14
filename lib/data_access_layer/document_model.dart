import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:tao_cat/data_access_layer/segment_model.dart';

/// An immutable model representing a document.
@immutable
class DocumentModel {
  const DocumentModel({required this.segments, required this.originalContent});

  /// The list of segments in the document.
  final List<SegmentModel> segments;

  /// The original content of the document.
  final Uint8List originalContent;
}
