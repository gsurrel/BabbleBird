import 'package:meta/meta.dart';

import 'package:flutter/foundation.dart';
import 'package:tao_cat/domain_layer/source.dart';

/// The base class for all document-related events.
sealed class DocumentEvent {}

/// Event for loading a document from a specified source.
@immutable
class LoadDocumentEvent extends DocumentEvent {
  LoadDocumentEvent(this.source);

  /// The source from which the document should be loaded.
  final Source source;
}

/// Event for editing a segment of a document.
@immutable
class EditDocumentEvent extends DocumentEvent {
  EditDocumentEvent(this.newText, this.segmentIndex);

  /// The new text for the segment.
  final String newText;

  /// The index of the segment to be edited.
  final int segmentIndex;
}

/// Event for saving the current document.
@immutable
class SaveDocumentEvent extends DocumentEvent {
  SaveDocumentEvent();
}
