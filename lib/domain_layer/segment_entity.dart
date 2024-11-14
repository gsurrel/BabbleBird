import 'package:meta/meta.dart';

/// Represents a segment within a document.
@immutable
class SegmentEntity {
  const SegmentEntity({
    required this.type,
    required this.sourceText,
  });

  /// The type of the segment (title or body).
  final SegmentType type;

  /// The original text of the segment.
  final String sourceText;
}

/// An enumeration of segment types.
enum SegmentType {
  title,
  body,
}
