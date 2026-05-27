import 'content_bundle.dart';
import 'content_document.dart';
import 'content_type.dart';

class ContentValidator {
  const ContentValidator();

  static final RegExp _kebabIdPattern = RegExp(r'^[a-z0-9-]+$');
  static final RegExp _dtcIdPattern = RegExp(r'^[PCBU][0-9A-F]{4}$');

  static const Map<ContentType, Set<String>> _requiredFields = {
    ContentType.vehicles: {
      'id',
      'make',
      'model',
      'generation_code',
      'year_range',
      'body_type',
      'popularity_in_korea',
    },
    ContentType.dtc: {
      'id',
      'type',
      'title',
      'description',
      'possible_causes',
      'diagnostic_steps',
    },
    ContentType.customers: {
      'id',
      'display_name',
      'age_range',
      'region',
      'vehicle_owned_id',
      'communication_style',
      'difficulty',
    },
    ContentType.scenarios: {
      'id',
      'title',
      'customer_id',
      'vehicle_id',
      'presented_problem',
      'actual_issues',
      'estimated_duration_min',
    },
    ContentType.procedures: {
      'id',
      'title',
      'category',
      'estimated_duration_min',
      'difficulty',
      'steps',
    },
    ContentType.services: {
      'id',
      'name',
      'category',
      'base_price_krw',
      'base_duration_min',
    },
    ContentType.parts: {'id', 'name', 'category', 'brand_type', 'price_krw'},
  };

  ContentValidationResult validateDocument(ContentDocument document) {
    final issues = <ContentValidationIssue>[];
    final requiredFields = _requiredFields[document.type] ?? const <String>{};

    for (final field in requiredFields) {
      if (!document.data.containsKey(field) || document.data[field] == null) {
        issues.add(
          ContentValidationIssue(
            document.path,
            'Missing required field "$field".',
          ),
        );
      }
    }

    _validateId(document, issues);
    _validateScenarioDuration(document, issues);

    return ContentValidationResult(issues);
  }

  ContentValidationResult validateBundle(ContentBundle bundle) {
    final issues = <ContentValidationIssue>[];
    final seenIds = <String, String>{};

    for (final document in bundle.documents) {
      issues.addAll(validateDocument(document).issues);
      final id = document.id;
      if (id == null) {
        continue;
      }

      final scopedId = '${document.type.directoryName}:$id';
      final firstPath = seenIds[scopedId];
      if (firstPath != null) {
        issues.add(
          ContentValidationIssue(
            document.path,
            'Duplicate id "$id"; first seen in $firstPath.',
          ),
        );
      } else {
        seenIds[scopedId] = document.path;
      }
    }

    return ContentValidationResult(issues);
  }

  void _validateId(
    ContentDocument document,
    List<ContentValidationIssue> issues,
  ) {
    final id = document.data['id'];
    if (id is! String || id.isEmpty) {
      issues.add(ContentValidationIssue(document.path, 'Missing string id.'));
      return;
    }

    final pattern = document.type == ContentType.dtc
        ? _dtcIdPattern
        : _kebabIdPattern;
    if (!pattern.hasMatch(id)) {
      issues.add(
        ContentValidationIssue(
          document.path,
          'Invalid id "$id" for ${document.type.directoryName}.',
        ),
      );
    }
  }

  void _validateScenarioDuration(
    ContentDocument document,
    List<ContentValidationIssue> issues,
  ) {
    if (document.type != ContentType.scenarios) {
      return;
    }

    final duration = document.data['estimated_duration_min'];
    if (duration is int && duration > 5) {
      issues.add(
        ContentValidationIssue(
          document.path,
          'Scenario duration must fit within 5 minutes.',
        ),
      );
    }
  }
}

class ContentValidationResult {
  const ContentValidationResult(this.issues);

  final List<ContentValidationIssue> issues;

  bool get isValid => issues.isEmpty;

  void throwIfInvalid() {
    if (!isValid) {
      throw ContentValidationException(issues);
    }
  }
}

class ContentValidationIssue {
  const ContentValidationIssue(this.path, this.message);

  final String path;
  final String message;

  @override
  String toString() => '$path: $message';
}

class ContentValidationException implements Exception {
  const ContentValidationException(this.issues);

  final List<ContentValidationIssue> issues;

  @override
  String toString() => 'ContentValidationException(${issues.join(', ')})';
}
