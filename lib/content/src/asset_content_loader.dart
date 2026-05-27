import 'package:flutter/services.dart';

import 'content_bundle.dart';
import 'content_type.dart';
import 'yaml_content_parser.dart';

class AssetContentLoader {
  const AssetContentLoader({
    AssetBundle? bundle,
    YamlContentParser parser = const YamlContentParser(),
  }) : _bundle = bundle,
       _parser = parser;

  final AssetBundle? _bundle;
  final YamlContentParser _parser;

  Future<ContentBundle> loadPaths(Iterable<String> paths) async {
    final bundle = _bundle ?? rootBundle;
    final documents = [
      for (final path in paths)
        if (_isYamlPath(path))
          _parser.parseDocument(
            source: await bundle.loadString(path),
            path: path,
          ),
    ];

    return ContentBundle(documents);
  }

  Future<ContentBundle> loadTypedPaths(
    Map<ContentType, Iterable<String>> pathsByType,
  ) async {
    final bundle = _bundle ?? rootBundle;
    final documents = [
      for (final entry in pathsByType.entries)
        for (final path in entry.value)
          if (_isYamlPath(path))
            _parser.parseDocument(
              source: await bundle.loadString(path),
              path: path,
              type: entry.key,
            ),
    ];

    return ContentBundle(documents);
  }

  bool _isYamlPath(String path) {
    return path.endsWith('.yaml') || path.endsWith('.yml');
  }
}
