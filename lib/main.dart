import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tao_cat/data_access_layer/data_sources/file_document_data_source.dart';
import 'package:tao_cat/data_access_layer/data_sources/random_document_data_source.dart';
import 'package:tao_cat/data_access_layer/document_repository.dart';
import 'package:tao_cat/domain_layer/document_provider.dart';
import 'package:tao_cat/presentation_layer/document_screen.dart';
import 'package:yaru/yaru.dart';

void main() {
  runApp(const MyApp());
}

enum Source { random, file }

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Source? source;
  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData.dark(),
        home: Scaffold(
            body: switch (source) {
          null => Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => setState(() => source = Source.random),
                    child: const Text('Random'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () => setState(() => source = Source.file),
                    child: const Text('File'),
                  ),
                ],
              ),
            ),
          final Source source => ChangeNotifierProvider(
              create: (context) => DocumentProvider(
                  documentRepository: switch (source) {
                Source.random => DocumentRepository(
                    dataSource: RandomDocumentDataSource(
                      numParagraphs: 100,
                      minWordsPerParagraph: 15,
                      maxWordsPerParagraph: 300,
                    ),
                  ),
                Source.file => DocumentRepository(
                    dataSource: FileDocumentDataSource(),
                  ),
              }),
              child: MaterialApp(
                theme: const YaruThemeData().darkTheme,
                home: const Scaffold(
                  body: MyHomePage(),
                ),
              ),
            ),
        }),
      );
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DocumentScreen();
  }
}
