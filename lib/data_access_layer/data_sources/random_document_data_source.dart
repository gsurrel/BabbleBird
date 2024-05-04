import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:tao_cat/data_access_layer/data_sources/data_source.dart';
import 'package:tao_cat/data_access_layer/document_model.dart';
import 'package:tao_cat/data_access_layer/segment_model.dart';

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
  Future<DocumentModel> fetchDocument(String id) async {
    // Use the document id to seed the random number generator
    final random = Random(id.hashCode);

    final segments = List<SegmentModel>.generate(
      numParagraphs,
      (index) {
        final numWords = minWordsPerParagraph +
            random.nextInt(
              maxWordsPerParagraph - minWordsPerParagraph + 1,
            );
        final sourceText = _faker.lorem.words(numWords).join(' ');
        return SegmentModel(
          id: 'segment_$index',
          sourceText: sourceText,
          translationText: '',
        );
      },
    );

    // Insert chapter titles
    for (var i = 0; i < 10; i++) {
      final insertAt = (i * segments.length / 10).floor();
      final chapterTitleText = _faker.lorem.words(8).join(' ');
      segments.insert(
        insertAt,
        SegmentModel(
          id: 'chapter_$i',
          sourceText: chapterTitleText,
          translationText: '',
        ),
      );
    }

    return DocumentModel(id: id, segments: segments);
  }
}
