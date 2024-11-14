class SegmentEntity {
  SegmentEntity({
    required this.type,
    required this.sourceText,
  });

  SegmentType type;
  String sourceText;
}

enum SegmentType {
  title,
  body,
}
