import 'content_document.dart';
import 'content_type.dart';
import 'content_validator.dart';

class ContentBundle {
  const ContentBundle(this.documents);

  final List<ContentDocument> documents;

  Iterable<ContentDocument> byType(ContentType type) {
    return documents.where((document) => document.type == type);
  }

  ContentDocument? findById(ContentType type, String id) {
    for (final document in byType(type)) {
      if (document.id == id) {
        return document;
      }
    }
    return null;
  }

  ContentValidationResult validate({
    ContentValidator validator = const ContentValidator(),
  }) {
    return validator.validateBundle(this);
  }
}
