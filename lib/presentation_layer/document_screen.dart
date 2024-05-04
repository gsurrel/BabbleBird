import 'package:flutter/material.dart';
import 'package:flutter_list_view/flutter_list_view.dart';
import 'package:provider/provider.dart';
import 'package:tao_cat/domain_layer/document_entity.dart';
import 'package:tao_cat/domain_layer/document_provider.dart';
import 'package:tao_cat/domain_layer/segment_entity.dart';

/// A screen that displays a document.
///
/// The document is fetched from a [DocumentProvider] and displayed in a list view.
class DocumentScreen extends StatefulWidget {
  const DocumentScreen({super.key});

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  final FlutterListViewController _listViewController =
      FlutterListViewController();

  @override
  void initState() {
    super.initState();
    final documentProvider =
        Provider.of<DocumentProvider>(context, listen: false);
    documentProvider.fetchDocument('documentId');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DocumentProvider>(
      builder: (context, documentProvider, child) {
        return _buildDocumentView(documentProvider.document);
      },
    );
  }

  /// Builds the view for the document.
  ///
  /// If the document is null, a loading indicator is shown.
  /// Otherwise, the document is displayed in a list view.
  Widget _buildDocumentView(DocumentEntity? document) {
    return switch (document) {
      null => const CircularProgressIndicator(),
      DocumentEntity() => Row(
          children: [
            _buildDocumentListView(document),
            _buildNavigationPanel(document),
          ],
        ),
    };
  }

  /// Builds the list view for the document.
  ///
  /// Each segment of the document is displayed in a row with the source text and a text field for the translation.
  Widget _buildDocumentListView(DocumentEntity document) {
    return Expanded(
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: FlutterListView.builder(
          controller: _listViewController,
          itemCount: document.segments.length,
          itemBuilder: (context, index) {
            final segment = document.segments[index];
            return _buildSegmentRow(segment);
          },
        ),
      ),
    );
  }

  /// Builds a row for a segment.
  ///
  /// The row contains the source text in a card and a text field for the translation.
  Widget _buildSegmentRow(SegmentEntity segment) {
    return Row(
      children: [
        _buildSourceTextCard(segment),
        _buildTranslationTextField(segment),
      ],
    );
  }

  /// Builds a card for the source text of a segment.
  Widget _buildSourceTextCard(SegmentEntity segment) {
    return Expanded(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(segment.sourceText),
        ),
      ),
    );
  }

  /// Builds a text field for the translation of a segment.
  Widget _buildTranslationTextField(SegmentEntity segment) {
    return Expanded(
      child: TextField(
        controller: TextEditingController(text: segment.translationText),
        onChanged: segment.updateTranslation,
        maxLines: null,
      ),
    );
  }

  /// Builds a navigation panel for the document.
  ///
  /// The panel allows the user to tap on a position to scroll to the corresponding segment in the document.
  Widget _buildNavigationPanel(DocumentEntity document) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (details) => _handleTapOnNavigationPanel(details, document),
      child: SizedBox(
        width: 20,
        height: double.infinity,
        child: SizedBox.expand(
          child: CustomPaint(
            painter: _BarPainter(
                itemsHeights:
                    document.segments.map((e) => e.sourceText.codeUnits.length),
                controller: _listViewController),
          ),
        ),
      ),
    );
  }

  /// Handles a tap on the navigation panel.
  ///
  /// The tapped position is used to calculate the index of the segment to scroll to.
  void _handleTapOnNavigationPanel(
      TapDownDetails details, DocumentEntity document) {
    final heights = document.segments.map((e) => e.sourceText.codeUnits.length);
    final totalHeight = heights.fold(0, (sum, val) => sum + val);
    final scaling = context.size!.height / totalHeight;

    double tappedPosition = details.localPosition.dy / scaling;

    final before = heights.takeWhile((height) {
      if (height < tappedPosition) {
        tappedPosition -= height;
        return true;
      }
      return false;
    });

    _listViewController.sliverController.animateToIndex(
      before.length,
      duration: Durations.medium1,
      curve: Curves.elasticInOut,
    );
  }
}

/// A custom painter for the navigation panel.
///
/// The panel is painted with alternating colors for each segment of the document.
class _BarPainter extends CustomPainter {
  final Iterable<num> itemsHeights;
  final FlutterListViewController controller;

  _BarPainter({required this.itemsHeights, required this.controller});

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()..color = Colors.grey.withOpacity(0.2);
    final paint2 = Paint()..color = Colors.grey.withOpacity(0.3);
    final paint3 = Paint()..color = Colors.amber;

    final scaling = size.height / itemsHeights.fold(0, (sum, val) => sum + val);
    final scaledHeights = itemsHeights.map((h) => h * scaling);
    double previousPosition = 0;

    print(controller.offset);
    scaledHeights.toList().asMap().forEach((i, height) {
      final isInView = controller.offset >= previousPosition &&
          controller.offset <= previousPosition + size.height;

      final paint = isInView
          ? paint3
          : i % 2 == 0
              ? paint1
              : paint2;

      canvas.drawRect(
        Rect.fromLTWH(0, previousPosition, size.width, height),
        paint,
      );
      previousPosition += height;
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
