import 'dart:math';

import 'package:faker/faker.dart';
import 'package:tao_cat/data_access_layer/data_sources/data_source.dart';
import 'package:tao_cat/data_access_layer/document_model.dart';
import 'package:tao_cat/data_access_layer/segment_model.dart';

import 'package:flutter/foundation.dart';

@immutable
class RandomDocumentDataSource implements DataSource {
  RandomDocumentDataSource({
    required this.numParagraphs,
    required this.minWordsPerParagraph,
    required this.maxWordsPerParagraph,
  });

  final int numParagraphs;
  final int minWordsPerParagraph;
  final int maxWordsPerParagraph;

  final Faker _faker = Faker();

  @override
  Future<DocumentModel> loadDocument() async {
    final random = Random(
      (numParagraphs + minWordsPerParagraph + maxWordsPerParagraph).hashCode,
    );

    // Generate the text
    final segments = List<SegmentModel>.generate(
      numParagraphs,
      (index) {
        final numWords = minWordsPerParagraph +
            random.nextInt(
              maxWordsPerParagraph - minWordsPerParagraph + 1,
            );
        final sourceText = _faker.lorem.words(numWords).join(' ');
        return SegmentModel(
          sourceText: sourceText,
          isTitle: false,
        );
      },
    );

    // Insert chapter titles
    for (int i = 0; i < 10; i++) {
      final insertAt = (i * segments.length / 10).floor();
      final chapterTitleText = _faker.lorem.words(8).join(' ');
      segments.insert(
        insertAt,
        SegmentModel(
          sourceText: chapterTitleText,
          isTitle: true,
        ),
      );
    }

    return DocumentModel(segments: segments, originalContent: Uint8List(0));
  }

  @override
  Future<void> saveDocument(DocumentModel document) async {
    throw UnimplementedError('Saving random documents is not supported.');
  }
}
