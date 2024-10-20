import 'dart:math';
import 'package:tao_cat/data_access_layer/data_sources/data_source.dart';
import 'package:tao_cat/data_access_layer/document_model.dart';
import 'package:tao_cat/data_access_layer/segment_model.dart';
import 'package:faker/faker.dart';

class RandomDocumentDataSource implements DataSource {
  final int numParagraphs;
  final int minWordsPerParagraph;
  final int maxWordsPerParagraph;
  final Faker _faker = Faker();

  RandomDocumentDataSource({
    required this.numParagraphs,
    required this.minWordsPerParagraph,
    required this.maxWordsPerParagraph,
  });

  @override
  Future<DocumentModel> fetchDocument(String id) async {
    // Use the document id to seed the random number generator
    final random = Random(id.hashCode);

    List<SegmentModel> segments = List.generate(
      numParagraphs,
      (index) {
        final numWords = minWordsPerParagraph +
            random.nextInt(
              maxWordsPerParagraph - minWordsPerParagraph + 1,
            );
        String sourceText = _faker.lorem.words(numWords).join(' ');
        return SegmentModel(
          id: 'segment_$index',
          sourceText: sourceText,
          translationText: '',
        );
      },
    );

    // Insert chapter titles
    for (int i = 0; i < 10; i++) {
      final insertAt = (i * segments.length / 10).floor();
      String chapterTitleText = _faker.lorem.words(8).join(' ');
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
