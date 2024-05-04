// Define an abstract class for a data source

import 'package:flutter/material.dart';
import 'package:tao_cat/data_access_layer/document_model.dart';

// Lint ignore as the interface currently has a single method but others will
// come later.
@immutable
// ignore: one_member_abstracts
abstract interface class DataSource {
  Future<DocumentModel> fetchDocument(String id);
}
