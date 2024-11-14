import 'package:flutter/material.dart';
import 'package:tao_cat/data_access_layer/document_model.dart';
import 'package:tao_cat/domain_layer/segment_entity.dart';

/// Represents a document.
@immutable
class DocumentEntity {
  const DocumentEntity({required this.segments, required this.model});

  /// The list of segments in the document.
  final List<SegmentEntity> segments;

  /// The underlying document model.
  final DocumentModel model;
}
