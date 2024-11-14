import 'package:meta/meta.dart';
import 'package:tao_cat/domain_layer/document_entity.dart';

/// The base class for all document-related states.
@immutable
sealed class DocumentState {}

/// The initial state before any document is loaded.
@immutable
class DocumentInitial extends DocumentState {}

/// The state when a document is being loaded.
@immutable
class DocumentLoading extends DocumentState {}

/// The state when a document has been successfully loaded.
@immutable
class DocumentLoaded extends DocumentState {
  DocumentLoaded(this.document);

  /// The loaded document.
  final DocumentEntity document;
}

@immutable
class DocumentSaving extends DocumentState {
  DocumentSaving(this.document);

  /// The loaded document.
  final DocumentEntity document;
}

@immutable
class DocumentSaved extends DocumentState {
  DocumentSaved(this.document);

  /// The loaded document.
  final DocumentEntity document;
}
