// Entity Layer
import 'package:flutter/material.dart';
import 'package:tao_cat/domain_layer/segment_entity.dart';

@immutable
class DocumentEntity {
  const DocumentEntity({required this.id, required this.segments});

  final String id;
  final List<SegmentEntity> segments;
}
