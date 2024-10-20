import 'package:flutter/material.dart';
import 'package:flutter_list_view/flutter_list_view.dart';
import 'package:tao_cat/domain_layer/segment_entity.dart';

/// Custom painter for the navigation panel.
///
/// The panel is painted with alternating colors for each segment of the document.
class BarPainter extends CustomPainter {
  final List<SegmentEntity> items;
  final FlutterListViewController controller;

  BarPainter({required this.items, required this.controller});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paintEven = Paint()..color = Colors.grey.withOpacity(0.2);
    final Paint paintOdd = Paint()..color = Colors.grey.withOpacity(0.3);
    final Paint paintTitle = Paint()..color = Colors.amber;
    final charLengths = items.map(
      (segment) =>
          segment.sourceText.codeUnits.length *
          (segment.type == SegmentType.title ? 10 : 1),
    );
    final scaling = size.height / charLengths.fold(0, (sum, val) => sum + val);
    final scaledHeights = charLengths.map((h) => h * scaling);
    double previousPosition = 0;
    scaledHeights.toList().asMap().forEach((i, height) {
      final Paint paint = items[i].type == SegmentType.title
          ? paintTitle
          : i % 2 == 0
              ? paintEven
              : paintOdd;
      canvas.drawRect(
        Rect.fromLTWH(0, previousPosition, size.width, height),
        paint,
      );
      previousPosition += height;
    });
  }

  @override
  bool shouldRepaint(covariant BarPainter oldDelegate) {
    return items != oldDelegate.items ||
        controller.offset != oldDelegate.controller.offset;
  }
}
