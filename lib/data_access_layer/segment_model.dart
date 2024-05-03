class SegmentModel {
  String id;
  String sourceText;
  String translationText;
  String notes;

  SegmentModel({required this.id, required this.sourceText, required this.translationText, this.notes = ''});
}
