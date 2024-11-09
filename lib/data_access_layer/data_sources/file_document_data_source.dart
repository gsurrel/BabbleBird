import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:tao_cat/data_access_layer/data_sources/data_source.dart';
import 'package:tao_cat/data_access_layer/document_model.dart';
import 'package:tao_cat/data_access_layer/segment_model.dart';

@immutable
class FileDocumentDataSource implements DataSource {
  @override
  Future<DocumentModel> fetchDocument(String path) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['txt'],
      withData: true,
    );

    final contents = switch (result) {
      FilePickerResult(files: [PlatformFile(bytes: final Uint8List bytes)]) =>
        utf8.decode(bytes),
      null => throw UnimplementedError('Not handling canceled pick'),
      FilePickerResult(files: []) =>
        throw UnimplementedError('Not handling zero picked file'),
      FilePickerResult(files: [_, ...]) =>
        throw UnimplementedError('Not handling more than one picked file'),
    };

    return DocumentModel(
      id: path,
      segments: contents
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
                      SegmentModel(
                        id: '$chapterNumber.$paragraphNumber',
                        sourceText: text,
                        translationText: '',
                        isTitle: paragraphNumber == 0,
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
          .toList(),
    );
  }
}
