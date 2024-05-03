// Define an abstract class for a data source

import 'package:tao_cat/data_access_layer/document_model.dart';

abstract class DataSource {
  Future<DocumentModel> fetchDocument(String id);
}
