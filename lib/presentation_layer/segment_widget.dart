import 'package:flutter/material.dart';
import 'package:tao_cat/domain_layer/segment_entity.dart';

/// Displays a segment of the document with its source text and translation.
class SegmentWidget extends StatefulWidget {
  const SegmentWidget(
    this.segment, {
    super.key,
    required this.swapped,
    required this.onTextChanged,
  });

  /// The segment to display.
  final SegmentEntity segment;

  /// Whether the text fields should be swapped.
  final bool swapped;

  /// For when the text is changed.
  final void Function(String) onTextChanged;

  @override
  State<SegmentWidget> createState() => _SegmentWidgetState();
}

class _SegmentWidgetState extends State<SegmentWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.segment.sourceText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: switch (widget.segment.type) {
        SegmentType.title => Colors.amber.withAlpha(100),
        SegmentType.body => null,
      },
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: IntrinsicHeight(
          child: Row(
            textDirection:
                widget.swapped ? TextDirection.rtl : TextDirection.ltr,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  onChanged: widget.onTextChanged,
                  maxLines: null,
                  expands: true,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: TextEditingController(
                    text: widget.segment.type.toString(),
                  ),
                  onChanged: null,
                  maxLines: null,
                  expands: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
