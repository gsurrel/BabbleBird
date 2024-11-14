import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tao_cat/domain_layer/document_repository.dart';
import 'package:tao_cat/domain_layer/document_service.dart';
import 'package:tao_cat/domain_layer/use_cases.dart';
import 'package:tao_cat/my_business_layer/document_bloc.dart';
import 'package:tao_cat/presentation_layer/source_selection_screen.dart';
import 'package:yaru/yaru.dart';

/// The main function that sets up the application.
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

/// The root widget of the application.
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
