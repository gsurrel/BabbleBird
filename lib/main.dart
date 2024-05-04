import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tao_cat/data_access_layer/data_sources/random_document_data_source.dart';
import 'package:tao_cat/data_access_layer/document_repository.dart';
import 'package:tao_cat/domain_layer/document_provider.dart';
import 'package:tao_cat/presentation_layer/document_screen.dart';
import 'package:yaru/yaru.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DocumentProvider(
        documentRepository: DocumentRepository(
          dataSource: RandomDocumentDataSource(
            numParagraphs: 100,
            minWordsPerParagraph: 15,
            maxWordsPerParagraph: 300,
          ),
        ),
      ),
      child: MaterialApp(
        theme: const YaruThemeData().darkTheme,
        home: const Scaffold(
          body: MyHomePage(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DocumentScreen();
  }
}
