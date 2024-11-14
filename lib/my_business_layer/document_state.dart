import 'package:meta/meta.dart';
import 'package:tao_cat/domain_layer/document_entity.dart';

@immutable
sealed class DocumentState {}

class DocumentInitial extends DocumentState {}

class DocumentLoading extends DocumentState {}

class DocumentLoaded extends DocumentState {
  DocumentLoaded(this.document);

  final DocumentEntity document;
}
