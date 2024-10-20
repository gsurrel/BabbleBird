import 'package:flutter/material.dart';
import 'package:flutter_list_view/flutter_list_view.dart';
import 'package:provider/provider.dart';
import 'package:tao_cat/domain_layer/document_entity.dart';
import 'package:tao_cat/domain_layer/document_provider.dart';
import 'package:tao_cat/presentation_layer/document_list_view.dart';
import 'package:tao_cat/presentation_layer/navigation_panel.dart';

/// Displays a document.
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

  late final DocumentProvider _documentProvider =
      Provider.of<DocumentProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();
    // Add a listener to the list view controller
    _listViewController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    // Remove the listener when the state object is disposed
    _listViewController.removeListener(_handleScroll);
    super.dispose();
  }

  void _handleScroll() {
    // Call setState to trigger a repaint of the widget
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _documentProvider.fetchDocument('documentId');
  }

  @override
  Widget build(BuildContext context) => Consumer<DocumentProvider>(
        builder: (
          context,
          documentProvider,
          child,
        ) =>
            switch (documentProvider.document) {
          final DocumentEntity doc => Row(
              children: [
                Expanded(child: DocumentListView(document: doc)),
                NavigationPanel(document: doc),
              ],
            ),
          null => const CircularProgressIndicator(),
        },
      );
}
