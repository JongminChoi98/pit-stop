import 'content_type.dart';

class ContentDocument {
  const ContentDocument({
    required this.type,
    required this.path,
    required this.data,
  });

  final ContentType type;
  final String path;
  final Map<String, Object?> data;

  String? get id {
    final value = data['id'];
    return value is String ? value : null;
  }

  T? value<T extends Object>(String key) {
    final value = data[key];
    return value is T ? value : null;
  }
}
