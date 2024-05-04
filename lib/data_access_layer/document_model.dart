import 'package:tao_cat/data_access_layer/segment_model.dart';

class DocumentModel {
  DocumentModel({required this.id, required this.segments});
  String id;
  List<SegmentModel> segments;
}
