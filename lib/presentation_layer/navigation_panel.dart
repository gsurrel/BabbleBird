import 'package:flutter/material.dart';
import 'package:flutter_list_view/flutter_list_view.dart';
import 'package:tao_cat/domain_layer/document_entity.dart';
import 'package:tao_cat/domain_layer/segment_entity.dart';
import 'package:tao_cat/presentation_layer/bar_painter.dart';

/// Builds a navigation panel for the document.
///
/// The panel allows the user to tap on a position to scroll to the corresponding segment in the document.
class NavigationPanel extends StatelessWidget {
  final DocumentEntity document;

  const NavigationPanel({super.key, required this.document});

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: (details) => _handleTapOnNavigationPanel(
          details,
          document,
          context,
        ),
        child: CustomPaint(
          size: const Size(20, double.infinity),
          painter: BarPainter(
            items: document.segments,
            controller: FlutterListViewController(),
          ),
        ),
      );

  /// Handles a tap on the navigation panel.
  ///
  /// The tapped position is used to calculate the index of the segment to scroll to.
  void _handleTapOnNavigationPanel(
    TapDownDetails details,
    DocumentEntity document,
    BuildContext context,
  ) {
    final charLengths = document.segments.map(
      (segment) =>
          segment.sourceText.codeUnits.length *
          (segment.type == SegmentType.title ? 10 : 1),
    );
    final totalHeight = charLengths.fold(0, (sum, val) => sum + val);
    final scaling = context.size!.height / totalHeight;
    double tappedPosition = details.localPosition.dy / scaling;
    final before = charLengths.takeWhile((height) {
      if (height < tappedPosition) {
        tappedPosition -= height;
        return true;
      }
      return false;
    });
    FlutterListViewController().sliverController.animateToIndex(
          before.length,
          duration: Durations.medium1,
          curve: Curves.easeInOutCubic,
        );
  }
}
