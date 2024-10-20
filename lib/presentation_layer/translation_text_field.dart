import 'package:flutter/material.dart';
import 'package:tao_cat/domain_layer/segment_entity.dart';

/// Builds a text field for the translation of a segment.
class TranslationTextField extends StatelessWidget {
  final SegmentEntity segment;
  final TextEditingController _controller;

  TranslationTextField({super.key, required this.segment})
      : _controller = TextEditingController(text: segment.translationText);

  @override
  Widget build(BuildContext context) => Expanded(
        child: TextField(
          controller: _controller,
          onChanged: segment.updateTranslation,
          maxLines: null,
        ),
      );
}
