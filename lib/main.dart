import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tao_cat/domain_layer/document_repository.dart';
import 'package:tao_cat/domain_layer/document_service.dart';
import 'package:tao_cat/domain_layer/use_cases.dart';
import 'package:tao_cat/my_business_layer/document_bloc.dart';
import 'package:tao_cat/my_business_layer/document_event.dart';
import 'package:tao_cat/my_business_layer/document_state.dart';
import 'package:tao_cat/presentation_layer/document_screen.dart';
import 'package:yaru/yaru.dart';

sealed class Source {}

class RandomSource extends Source {
  RandomSource({
    required this.numParagraphs,
    required this.minWordsPerParagraph,
    required this.maxWordsPerParagraph,
  });

  final int numParagraphs;

  final int minWordsPerParagraph;

  final int maxWordsPerParagraph;
}

class FileSource extends Source {
  FileSource(this.filePickerResult);

  final FilePickerResult? filePickerResult;
}

void main() {
  final repo = DocumentRepository();
  final documentService = DocumentService(
    loadDocumentUseCase: LoadDocument(repo),
    editDocumentUseCase: EditDocument(),
    saveDocumentUseCase: SaveDocument(repo),
  );

  runApp(
    BlocProvider(
      create: (context) => DocumentBloc(documentService),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaoCat',
      theme: const YaruThemeData().darkTheme,
      home: const SourceSelectionScreen(),
    );
  }
}

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

                  if (result != null && result.files.isNotEmpty) {
                    if (context.mounted) {
                      context.read<DocumentBloc>().add(
                            LoadDocumentEvent(FileSource(result)),
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
