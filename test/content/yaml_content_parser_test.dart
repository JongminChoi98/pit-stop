import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pit_stop/content/content.dart';

void main() {
  const parser = YamlContentParser();

  test('parses vehicle example into a normalized document', () {
    final source = File(
      '.codex/examples/vehicles/hyundai-avante-ad.yaml',
    ).readAsStringSync();

    final document = parser.parseDocument(
      source: source,
      path: 'assets/content/vehicles/hyundai-avante-ad.yaml',
    );

    expect(document.type, ContentType.vehicles);
    expect(document.id, 'hyundai-avante-ad');
    expect(document.value<String>('make'), '현대');
    expect(document.data['year_range'], isA<Map<String, Object?>>());
    expect(document.data['engine_options'], isA<List<Object?>>());
  });

  test('validates required fields and id shape', () {
    final document = parser.parseDocument(
      source: '''
id: bad id
make: 현대
''',
      path: 'assets/content/vehicles/bad.yaml',
    );

    final result = const ContentValidator().validateDocument(document);

    expect(result.isValid, isFalse);
    expect(
      result.issues.map((issue) => issue.message),
      contains('Invalid id "bad id" for vehicles.'),
    );
  });

  test('detects duplicate ids within the same content type', () {
    const bundle = ContentBundle([
      ContentDocument(
        type: ContentType.customers,
        path: 'assets/content/customers/a.yaml',
        data: {
          'id': 'same-id',
          'display_name': 'A',
          'age_range': '30s',
          'region': '부산',
          'vehicle_owned_id': 'hyundai-avante-ad',
          'communication_style': ['polite'],
          'difficulty': 1,
        },
      ),
      ContentDocument(
        type: ContentType.customers,
        path: 'assets/content/customers/b.yaml',
        data: {
          'id': 'same-id',
          'display_name': 'B',
          'age_range': '40s',
          'region': '울산',
          'vehicle_owned_id': 'hyundai-avante-ad',
          'communication_style': ['patient'],
          'difficulty': 2,
        },
      ),
    ]);

    final result = bundle.validate();

    expect(result.isValid, isFalse);
    expect(
      result.issues.last.message,
      'Duplicate id "same-id"; first seen in assets/content/customers/a.yaml.',
    );
  });
}
