import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tao_cat/domain_layer/source.dart';
import 'package:tao_cat/my_business_layer/document_bloc.dart';
import 'package:tao_cat/my_business_layer/document_event.dart';
import 'package:tao_cat/my_business_layer/document_state.dart';
import 'package:tao_cat/presentation_layer/document_screen.dart';

/// For selecting the origin document.
class SourceSelectionScreen extends StatelessWidget {
  const SourceSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DocumentBloc, DocumentState>(
      listener: (context, state) {
        if (state is DocumentLoaded) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: BlocProvider.of<DocumentBloc>(context),
                child: const DocumentScreen(),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Select Source'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  context.read<DocumentBloc>().add(
                        LoadDocumentEvent(
                          RandomSource(
                            numParagraphs: 1,
                            minWordsPerParagraph: 2,
                            maxWordsPerParagraph: 3,
                          ),
                        ),
                      );
                },
                child: const Text('Select Random Source'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final result = await FilePicker.platform.pickFiles(
                    dialogTitle: 'Select a source file',
                    allowMultiple: false,
                    type: FileType.custom,
                    allowedExtensions: ['txt'],
                    withData: true,
                  );

                  if (context.mounted) {
                    if (result != null && result.files.isNotEmpty) {
                      context.read<DocumentBloc>().add(
                            LoadDocumentEvent(FileSource(result)),
                          );
                    } else {
                      // Notify the user that no file was selected
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No file selected.')),
                      );
                    }
                  }
                },
                child: const Text('Select File Source'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
