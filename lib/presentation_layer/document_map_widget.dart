import 'package:flutter/material.dart';
import 'package:flutter_list_view/flutter_list_view.dart';
import 'package:tao_cat/domain_layer/document_entity.dart';
import 'package:tao_cat/domain_layer/segment_entity.dart';

/// A widget that displays a map of the document segments.
class DocumentMap extends StatelessWidget {
  const DocumentMap({
    super.key,
    required this.document,
    required FlutterListViewController listViewController,
  }) : _listViewController = listViewController;

  /// The document entity containing the segments.
  final DocumentEntity document;

  /// The controller for the list view.
  final FlutterListViewController _listViewController;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(20, double.infinity),
      painter: _BarPainter(
        items: document.segments,
        controller: _listViewController,
      ),
    );
  }
}

/// A custom painter that paints a bar for each document segment.
class _BarPainter extends CustomPainter {
  _BarPainter({required this.items, required this.controller});

  /// The list of document segments to be painted.
  final List<SegmentEntity> items;

  /// The controller for the list view.
  final FlutterListViewController controller;

  @override
  void paint(Canvas canvas, Size size) {
    final paintEven = Paint()..color = Colors.grey.withOpacity(0.2);
    final paintOdd = Paint()..color = Colors.grey.withOpacity(0.3);
    final paintTitle = Paint()..color = Colors.amber;

    final charLengths = items.map(
      (segment) =>
          segment.sourceText.codeUnits.length *
          switch (segment.type) {
            SegmentType.title => 10,
            SegmentType.body => 1,
          },
    );
    final scaling = size.height / charLengths.fold(0, (sum, val) => sum + val);
    final scaledHeights = charLengths.map((h) => h * scaling);
    var previousPosition = 0.0;

    scaledHeights.toList().asMap().forEach(
      (i, height) {
        final paint = items[i].type == SegmentType.title
            ? paintTitle
            : i.isEven
                ? paintEven
                : paintOdd;
        canvas.drawRect(
          Rect.fromLTWH(0, previousPosition, size.width, height),
          paint,
        );
        previousPosition += height;
      },
    );
  }

  @override
  bool shouldRepaint(covariant _BarPainter oldDelegate) =>
      items != oldDelegate.items ||
      controller.offset != oldDelegate.controller.offset;
}
