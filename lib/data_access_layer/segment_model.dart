/// Represents a text segment within a document.
class SegmentModel {
  SegmentModel({
    required this.sourceText,
    required this.isTitle,
  });

  /// The original text of this segment.
  String sourceText;

  /// Whether this segment is a title.
  bool isTitle;
}
