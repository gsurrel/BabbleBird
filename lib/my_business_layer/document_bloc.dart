import 'package:bloc/bloc.dart';
import 'package:tao_cat/domain_layer/document_service.dart';
import 'package:tao_cat/my_business_layer/document_event.dart';
import 'package:tao_cat/my_business_layer/document_state.dart';

class DocumentBloc extends Bloc<DocumentEvent, DocumentState> {
  DocumentBloc(this.documentService) : super(DocumentInitial()) {
    on<LoadDocumentEvent>((event, emit) async {
      emit(DocumentLoading());
      final document = await documentService.loadDocument(event.source);
      emit(DocumentLoaded(document));
    });

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

    on<SaveDocumentEvent>((event, emit) async {
      if (state case DocumentLoaded(:final document)) {
        print('on<SaveDocumentEvent>');
        await documentService.saveDocument(document);
      }
    });
  }

  final DocumentService documentService;
}
