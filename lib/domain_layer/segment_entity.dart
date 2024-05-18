class SegmentEntity {
  SegmentType type;
  String id;
  String sourceText;
  String translationText;
  String notes;

  SegmentEntity({
    required this.type,
    required this.id,
    required this.sourceText,
    required this.translationText,
    required this.notes,
  });

  void updateTranslation(String newTranslation) {
    translationText = newTranslation;
  }

  void setNotes(String newNotes) {
    notes = newNotes;
  }
}

enum SegmentType {
  title,
  body,
}
