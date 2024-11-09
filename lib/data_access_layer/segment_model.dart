class SegmentModel {
  SegmentModel({
    required this.id,
    required this.sourceText,
    required this.translationText,
    this.isTitle,
  });

  String id;
  String sourceText;
  String translationText;
  bool? isTitle;
}
