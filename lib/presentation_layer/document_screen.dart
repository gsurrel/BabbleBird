import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_list_view/flutter_list_view.dart';
import 'package:tao_cat/domain_layer/document_entity.dart';
import 'package:tao_cat/domain_layer/segment_entity.dart';
import 'package:tao_cat/my_business_layer/document_bloc.dart';
import 'package:tao_cat/my_business_layer/document_event.dart';
import 'package:tao_cat/my_business_layer/document_state.dart';
import 'package:tao_cat/presentation_layer/document_map_widget.dart';
import 'package:tao_cat/presentation_layer/segment_widget.dart';

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({super.key});

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  final FlutterListViewController _listViewController =
      FlutterListViewController();
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Editor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              print('Pressed save button!');
              context.read<DocumentBloc>().add(SaveDocumentEvent());
            },
          ),
        ],
      ),
      body: BlocBuilder<DocumentBloc, DocumentState>(
        builder: (context, state) {
          return switch (state) {
            DocumentInitial() => const Center(
                child: Text('Select a document to edit.'),
              ),
            DocumentLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            DocumentLoaded(:final document) => Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => setState(() => _swapped = !_swapped),
                    icon: const Icon(Icons.swap_horiz),
                    label: const Text('Swap'),
                  ),
                  Expanded(
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
                ],
              ),
          };
        },
      ),
    );
  }

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
