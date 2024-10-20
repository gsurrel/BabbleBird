import 'package:flutter/material.dart';
import 'package:tao_cat/domain_layer/segment_entity.dart';

/// Builds a title for the source text of a segment.
class SourceChapterTitle extends StatelessWidget {
  final SegmentEntity segment;

  const SourceChapterTitle({super.key, required this.segment});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Card(
          color: Colors.amber,
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(segment.sourceText),
          ),
        ),
      );
}
