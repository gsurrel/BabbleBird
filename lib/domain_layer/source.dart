import 'package:file_picker/file_picker.dart';

/// A base class for different types of document sources.
sealed class Source {}

/// A source representing a random document generator.
class RandomSource extends Source {
  RandomSource({
    required this.numParagraphs,
    required this.minWordsPerParagraph,
    required this.maxWordsPerParagraph,
  });

  /// The number of paragraphs in the document.
  final int numParagraphs;

  /// The minimum number of words per paragraph.
  final int minWordsPerParagraph;

  /// The maximum number of words per paragraph.
  final int maxWordsPerParagraph;
}

/// A source representing a file-based document.
class FileSource extends Source {
  FileSource(this.filePickerResult);

  /// The result of the file picker.
  final FilePickerResult? filePickerResult;
}
