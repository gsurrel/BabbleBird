import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:meta/meta.dart';
import 'package:tao_cat/data_access_layer/data_sources/data_source.dart';
import 'package:tao_cat/data_access_layer/document_model.dart';
import 'package:tao_cat/data_access_layer/segment_model.dart';

typedef SplittedText = List<({int chapter, int paragraph, String text})>;

@immutable
class FileDocumentDataSource implements DataSource {
  @override
  Future<DocumentModel> fetchDocument(String path) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      dialogTitle: 'Select both the source and destination files',
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['txt'],
      withData: true,
    );

    final filesContents = switch (result) {
      FilePickerResult(
        files: [
          PlatformFile(bytes: final Uint8List source),
          PlatformFile(bytes: final Uint8List destination)
        ]
      ) =>
        (
          source: splitIntoSegments(utf8.decode(source)),
          destination: splitIntoSegments(utf8.decode(destination)),
        ),
      null => throw UnimplementedError('Not handling canceled pick'),
      FilePickerResult(files: List<PlatformFile>()) => throw UnimplementedError(
          'Not handling more or less than two selected files',
        ),
    };

    return DocumentModel(
      id: path,
      segments: mergeLists(
        filesContents.source,
        filesContents.destination,
      ),
    );
  }

  @useResult
  SplittedText splitIntoSegments(String raw) => raw
      .split('\n\n')
      .asMap()
      .map(
        (chapterNumber, block) => MapEntry(
          chapterNumber,
          block
              .split('\n')
              .asMap()
              .map(
                (paragraphNumber, text) => MapEntry(
                  paragraphNumber,
                  (
                    chapter: chapterNumber,
                    paragraph: paragraphNumber,
                    text: text,
                  ),
                ),
              )
              .values
              .toList(),
        ),
      )
      .values
      .toList()
      .expand((chapter) => chapter)
      .toList();

  @useResult
  List<SegmentModel> mergeLists(SplittedText list1, SplittedText list2) {
    List<SegmentModel> mergedList = [];
    int i = 0, j = 0;

    while (i < list1.length || j < list2.length) {
      var item1 = i < list1.length ? list1[i] : null;
      var item2 = j < list2.length ? list2[j] : null;

      // If an item is too far in advance, nullify it.
      if (item1 != null && item2 != null) {
        if (item1.chapter < item2.chapter ||
            (item1.chapter == item2.chapter &&
                item1.paragraph < item2.paragraph)) {
          item2 = null;
        } else if (item2.chapter < item1.chapter ||
            (item2.chapter == item1.chapter &&
                item2.paragraph < item1.paragraph)) {
          item1 = null;
        }
      }

      mergedList.add(SegmentModel(
        id: '${item1?.chapter ?? item2?.chapter}.'
            '${item1?.paragraph ?? item2?.paragraph}',
        sourceText: item1?.text ?? '',
        translationText: item2?.text ?? '',
        isTitle: (item1?.paragraph == 0 || item2?.paragraph == 0),
      ));

      // Advance the indices.
      if (item1 != null) i++;
      if (item2 != null) j++;
    }
    return mergedList;
  }
}
