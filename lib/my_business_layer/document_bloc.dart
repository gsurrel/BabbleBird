import 'package:bloc/bloc.dart';
import 'package:tao_cat/domain_layer/document_service.dart';
import 'package:tao_cat/my_business_layer/document_event.dart';
import 'package:tao_cat/my_business_layer/document_state.dart';

/// Handles events and states related to document operations.
class DocumentBloc extends Bloc<DocumentEvent, DocumentState> {
  DocumentBloc(this.documentService) : super(DocumentInitial()) {
    /// Handles the event of loading a document.
    on<LoadDocumentEvent>((event, emit) async {
      emit(DocumentLoading());
      final document = await documentService.loadDocument(event.source);
      emit(DocumentLoaded(document));
    });

    /// Handles the event of editing a document.
    on<EditDocumentEvent>((event, emit) async {
      if (state case DocumentLoaded(:final document)) {
        final updatedDocument = await documentService.editDocument(
          document,
          event.newText,
          event.segmentIndex,
        );
        emit(DocumentLoaded(updatedDocument));
      }
    });

    /// Handles the event of saving a document.
    on<SaveDocumentEvent>((event, emit) async {
      if (state case DocumentLoaded(:final document)) {
        emit(DocumentSaving(document));
        await documentService.saveDocument(document);
        emit(DocumentSaved(document));
      }
    });
  }

  /// Performs document-related operations.
  final DocumentService documentService;
}
