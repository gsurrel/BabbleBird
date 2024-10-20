import 'package:flutter/material.dart';
import 'package:tao_cat/domain_layer/segment_entity.dart';

/// Builds a card for the source text of a segment.
class SourceTextCard extends StatelessWidget {
  final SegmentEntity segment;

  const SourceTextCard({super.key, required this.segment});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(segment.sourceText),
          ),
        ),
      );
}
