import 'package:flutter/material.dart';
import 'package:tao_cat/domain_layer/segment_entity.dart';

class SegmentWidget extends StatelessWidget {
  const SegmentWidget(this.segment, {super.key, required this.swapped});

  final SegmentEntity segment;

  final bool swapped;

  @override
  Widget build(BuildContext context) => Card(
        color: switch (segment.type) {
          SegmentType.title => Colors.amber.withAlpha(100),
          SegmentType.body => null,
        },
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: IntrinsicHeight(
            child: Row(
              textDirection: swapped ? TextDirection.rtl : TextDirection.ltr,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: TextField(
                    controller: TextEditingController(
                      text: segment.sourceText,
                    ),
                    onChanged: (text) {
                      segment.sourceText = text;
                    },
                    maxLines: null,
                    expands: true,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: TextEditingController(
                      text: segment.translationText,
                    ),
                    onChanged: (text) {
                      segment.translationText = text;
                    },
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
