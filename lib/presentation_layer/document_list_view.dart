import 'package:flutter/material.dart';
import 'package:flutter_list_view/flutter_list_view.dart';
import 'package:tao_cat/domain_layer/document_entity.dart';
import 'package:tao_cat/domain_layer/segment_entity.dart';
import 'package:tao_cat/presentation_layer/segment_row.dart';

/// Displays a list view for the document.
class DocumentListView extends StatelessWidget {
  final DocumentEntity document;
  final FlutterListViewController _listViewController =
      FlutterListViewController();

  DocumentListView({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: FlutterListView.builder(
        controller: _listViewController,
        itemCount: document.segments.length,
        itemBuilder: (context, index) {
          final SegmentEntity segment = document.segments[index];
          return SegmentRow(segment: segment);
        },
      ),
    );
  }
}
