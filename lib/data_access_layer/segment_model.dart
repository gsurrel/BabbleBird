/// A model representing a segment within a document.
class SegmentModel {
  SegmentModel({
    required this.sourceText,
    required this.isTitle,
  });

  /// The source text of the segment.
  String sourceText;

  /// Indicates if the segment is a title.
  bool isTitle;
}
