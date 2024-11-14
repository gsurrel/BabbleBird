import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:tao_cat/data_access_layer/segment_model.dart';

@immutable
class DocumentModel {
  const DocumentModel({required this.segments, required this.originalContent});

  final List<SegmentModel> segments;
  final Uint8List originalContent;
}
