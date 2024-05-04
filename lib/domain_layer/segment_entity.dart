class SegmentEntity {
  String id;
  String sourceText;
  String translationText;
  String notes;

  SegmentEntity({
    required this.id,
    required this.sourceText,
    required this.translationText,
    this.notes = '',
  });

  void updateTranslation(String newTranslation) {
    translationText = newTranslation;
  }

  void setNotes(String newNotes) {
    notes = newNotes;
  }
}
