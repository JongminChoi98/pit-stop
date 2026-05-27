enum ContentType {
  vehicles('vehicles'),
  dtc('dtc'),
  customers('customers'),
  scenarios('scenarios'),
  procedures('procedures'),
  services('services'),
  parts('parts');

  const ContentType(this.directoryName);

  final String directoryName;

  static ContentType? fromDirectoryName(String directoryName) {
    for (final type in ContentType.values) {
      if (type.directoryName == directoryName) {
        return type;
      }
    }
    return null;
  }

  static ContentType? fromPath(String path) {
    final normalized = path.replaceAll('\\', '/');
    final segments = normalized.split('/');
    for (final segment in segments) {
      final type = fromDirectoryName(segment);
      if (type != null) {
        return type;
      }
    }
    return null;
  }
}
