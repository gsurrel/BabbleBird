import 'package:flutter/material.dart';
import 'package:tao_cat/domain_layer/segment_entity.dart';
import 'package:tao_cat/presentation_layer/source_chapter_title.dart';
import 'package:tao_cat/presentation_layer/source_text_card.dart';
import 'package:tao_cat/presentation_layer/translation_text_field.dart';

/// Builds a row for a segment.
///
/// The row contains the source text in a card and a text field for the translation.
class SegmentRow extends StatelessWidget {
  final SegmentEntity segment;

  const SegmentRow({super.key, required this.segment});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          segment.type == SegmentType.title
              ? SourceChapterTitle(segment: segment)
              : SourceTextCard(segment: segment),
          TranslationTextField(segment: segment),
        ],
      );
}
