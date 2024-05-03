// Entity Layer
import 'package:tao_cat/domain_layer/segment_entity.dart';

class DocumentEntity {
  String id;
  List<SegmentEntity> segments;

  DocumentEntity({required this.id, required this.segments});
}
