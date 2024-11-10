import 'package:flutter/material.dart';
import 'package:flutter_list_view/flutter_list_view.dart';
import 'package:provider/provider.dart';
import 'package:tao_cat/data_access_layer/data_sources/file_document_data_source.dart';
import 'package:tao_cat/data_access_layer/document_repository.dart';
import 'package:tao_cat/domain_layer/document_entity.dart';
import 'package:tao_cat/domain_layer/document_provider.dart';
import 'package:tao_cat/domain_layer/segment_entity.dart';
import 'package:tao_cat/presentation_layer/segment_widget.dart';

/// Displays a document.
///
/// The document is fetched from a [DocumentProvider] and displayed in a list
/// view.
class DocumentScreen extends StatefulWidget {
  const DocumentScreen({super.key});

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  final FlutterListViewController _listViewController =
      FlutterListViewController();

  late final DocumentProvider _documentProvider =
      Provider.of<DocumentProvider>(context, listen: false);

  bool _swapped = true;

  @override
  void initState() {
    super.initState();
    _listViewController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _listViewController.removeListener(_handleScroll);
    super.dispose();
  }

  void _handleScroll() {
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _documentProvider.fetchDocument('documentId');
  }

  @override
  Widget build(BuildContext context) => Consumer<DocumentProvider>(
        builder: (context, documentProvider, child) => Column(
          children: [
            ElevatedButton.icon(
              onPressed: () => setState(() => _swapped = !_swapped),
              icon: const Icon(Icons.swap_horiz),
              label: const Text('Swap'),
            ),
            switch (documentProvider.document) {
              null => const CircularProgressIndicator(),
              final DocumentEntity document => Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context)
                              .copyWith(scrollbars: false),
                          child: FlutterListView.builder(
                            controller: _listViewController,
                            itemCount: document.segments.length,
                            itemBuilder: (context, index) =>
                                switch (document.segments[index]) {
                              final SegmentEntity segment =>
                                SegmentWidget(segment, swapped: _swapped),
                            },
                          ),
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTapDown: (details) =>
                            _handleTapOnNavigationPanel(details, document),
                        child: DocumentMap(
                          document: document,
                          listViewController: _listViewController,
                        ),
                      ),
                    ],
                  ),
                ),
            },
          ],
        ),
      );

  void _handleTapOnNavigationPanel(
    TapDownDetails details,
    DocumentEntity document,
  ) {
    final charLengths = document.segments.map(
      (segment) =>
          segment.sourceText.codeUnits.length *
          switch (segment.type) {
            SegmentType.title => 10,
            SegmentType.body => 1,
          },
    );
    final totalHeight = charLengths.fold(0, (sum, val) => sum + val);
    final scaling = context.size!.height / totalHeight;

    var tappedPosition = details.localPosition.dy / scaling;

    final before = charLengths.takeWhile((height) {
      if (height < tappedPosition) {
        tappedPosition -= height;
        return true;
      }
      return false;
    });

    _listViewController.sliverController.animateToIndex(
      before.length,
      duration: Durations.medium1,
      curve: Curves.easeInOutCubic,
    );
  }
}

class DocumentMap extends StatelessWidget {
  const DocumentMap({
    super.key,
    required this.document,
    required FlutterListViewController listViewController,
  }) : _listViewController = listViewController;

  final DocumentEntity document;
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

class _BarPainter extends CustomPainter {
  _BarPainter({required this.items, required this.controller});
  final List<SegmentEntity> items;
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
