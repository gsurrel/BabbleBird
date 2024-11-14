import 'package:meta/meta.dart';

import 'package:flutter/foundation.dart';
import 'package:tao_cat/domain_layer/source.dart';

/// The base class for all document-related events.
sealed class DocumentEvent {}

/// Event emitted when a document needs to be loaded from a [Source].
@immutable
class LoadDocumentEvent extends DocumentEvent {
  LoadDocumentEvent(this.source);

  /// The original from which the document should be loaded.
  final Source source;
}

/// Event emitted when a segment of the document needs to be edited.
@immutable
class EditDocumentEvent extends DocumentEvent {
  EditDocumentEvent(this.newText, this.segmentIndex);

  /// The new text for the segment.
  final String newText;

  /// The index of the segment to be edited.
  final int segmentIndex;
}

/// Event emitted when the current document state needs to be persisted.
@immutable
class SaveDocumentEvent extends DocumentEvent {
  SaveDocumentEvent();
}
