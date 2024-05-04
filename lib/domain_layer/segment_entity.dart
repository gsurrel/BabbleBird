class SegmentEntity {
  SegmentEntity({
    required this.type,
    required this.id,
    required this.sourceText,
    required this.translationText,
  });

  SegmentType type;
  String id;
  String sourceText;
  String translationText;
}

enum SegmentType {
  title,
  body,
}
