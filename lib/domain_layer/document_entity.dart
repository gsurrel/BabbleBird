// Entity Layer
import 'package:flutter/material.dart';
import 'package:tao_cat/data_access_layer/document_model.dart';
import 'package:tao_cat/domain_layer/segment_entity.dart';

@immutable
class DocumentEntity {
  const DocumentEntity({required this.segments, required this.model});

  final List<SegmentEntity> segments;

  final DocumentModel model;
}
