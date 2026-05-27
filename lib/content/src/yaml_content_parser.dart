import 'package:yaml/yaml.dart';

import 'content_document.dart';
import 'content_type.dart';

class YamlContentParser {
  const YamlContentParser();

  ContentDocument parseDocument({
    required String source,
    required String path,
    ContentType? type,
  }) {
    final resolvedType = type ?? ContentType.fromPath(path);
    if (resolvedType == null) {
      throw ContentParseException(path, 'Cannot infer content type from path.');
    }

    final loaded = loadYaml(source);
    final normalized = _normalize(loaded);
    if (normalized is! Map<String, Object?>) {
      throw ContentParseException(path, 'Top-level YAML value must be a map.');
    }

    return ContentDocument(type: resolvedType, path: path, data: normalized);
  }

  Object? _normalize(Object? value) {
    if (value is YamlMap) {
      return {
        for (final entry in value.entries)
          entry.key.toString(): _normalize(entry.value),
      };
    }
    if (value is YamlList) {
      return [for (final item in value) _normalize(item)];
    }
    return value;
  }
}

class ContentParseException implements Exception {
  const ContentParseException(this.path, this.message);

  final String path;
  final String message;

  @override
  String toString() => 'ContentParseException($path): $message';
}
