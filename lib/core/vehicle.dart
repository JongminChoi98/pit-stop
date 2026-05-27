enum VehicleBodyType {
  sedan,
  suv,
  hatchback,
  wagon,
  coupe,
  pickup,
  van,
  mpv,
}

enum VehicleFuel {
  gasoline,
  diesel,
  lpg,
  hev,
  phev,
  bev,
  hydrogen,
}

enum VehicleTransmission {
  manual,
  automatic,
  dct,
  cvt,
  singleSpeed,
}

enum VehicleIssueSeverity {
  low,
  medium,
  high,
}

enum KoreaMarketPopularity {
  veryHigh,
  high,
  medium,
  low,
  niche,
}

class VehicleYearRange {
  const VehicleYearRange({
    required this.start,
    this.end,
  })  : assert(start >= 1980),
        assert(end == null || end >= start);

  final int start;
  final int? end;

  bool includes(int year) {
    return year >= start && (end == null || year <= end!);
  }
}

class VehicleEngineOption {
  const VehicleEngineOption({
    required this.fuel,
    this.displacementCc,
    this.powerPs,
    this.engineCode,
  });

  final VehicleFuel fuel;
  final int? displacementCc;
  final int? powerPs;
  final String? engineCode;
}

class VehicleCommonIssue {
  const VehicleCommonIssue({
    required this.description,
    required this.severity,
    this.mileageRangeKm,
    this.source,
  }) : assert(
          mileageRangeKm == null || mileageRangeKm.length == 2,
          'mileageRangeKm must be [min, max] when provided.',
        );

  final String description;
  final VehicleIssueSeverity severity;
  final List<int>? mileageRangeKm;
  final String? source;
}

class Vehicle {
  const Vehicle({
    required this.id,
    required this.make,
    required this.model,
    required this.generationCode,
    required this.yearRange,
    required this.bodyType,
    required this.popularityInKorea,
    this.trims = const [],
    this.engineOptions = const [],
    this.transmissionOptions = const [],
    this.commonIssues = const [],
    this.marketNotes,
    this.references = const [],
  })  : assert(id.length > 0),
        assert(make.length > 0),
        assert(model.length > 0),
        assert(generationCode.length > 0);

  final String id;
  final String make;
  final String model;
  final String generationCode;
  final VehicleYearRange yearRange;
  final VehicleBodyType bodyType;
  final KoreaMarketPopularity popularityInKorea;
  final List<String> trims;
  final List<VehicleEngineOption> engineOptions;
  final List<VehicleTransmission> transmissionOptions;
  final List<VehicleCommonIssue> commonIssues;
  final String? marketNotes;
  final List<String> references;

  String get displayName => '$make $model $generationCode';

  bool supportsFuel(VehicleFuel fuel) {
    return engineOptions.any((option) => option.fuel == fuel);
  }
}
