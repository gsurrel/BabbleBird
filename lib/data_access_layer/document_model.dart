import 'package:tao_cat/data_access_layer/segment_model.dart';

class DocumentModel {
  String id;
  List<SegmentModel> segments;

  DocumentModel({required this.id, required this.segments});
}
