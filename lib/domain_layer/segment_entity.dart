/// An entity representing a segment within a document.
class SegmentEntity {
  SegmentEntity({
    required this.type,
    required this.sourceText,
  });

  /// The type of the segment (title or body).
  SegmentType type;

  /// The source text of the segment.
  String sourceText;
}

/// An enumeration of segment types.
enum SegmentType {
  title,
  body,
}
