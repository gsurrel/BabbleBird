import 'package:meta/meta.dart';

import 'package:flutter/foundation.dart';
import 'package:tao_cat/main.dart';

sealed class DocumentEvent {}

@immutable
class LoadDocumentEvent extends DocumentEvent {
  LoadDocumentEvent(this.source);

  final Source source;
}

@immutable
class EditDocumentEvent extends DocumentEvent {
  EditDocumentEvent(this.newText, this.segmentIndex);

  final String newText;
  final int segmentIndex;
}

@immutable
class SaveDocumentEvent extends DocumentEvent {
  SaveDocumentEvent();
}
