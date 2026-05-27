enum DtcKind {
  generic,
  manufacturerSpecific,
}

enum AffectedVehicleSystem {
  emissions,
  fuel,
  ignition,
  transmission,
  abs,
  srs,
  hvac,
  body,
  network,
  hybrid,
  evBattery,
  other,
}

enum CauseLikelihood {
  veryCommon,
  common,
  occasional,
  rare,
}

class DtcPossibleCause {
  const DtcPossibleCause({
    required this.cause,
    required this.likelihood,
    this.notes,
  }) : assert(cause.length > 0);

  final String cause;
  final CauseLikelihood likelihood;
  final String? notes;
}

class DtcDiagnosticStep {
  const DtcDiagnosticStep({
    required this.step,
    required this.action,
    this.ifPass,
    this.ifFail,
  })  : assert(step >= 1),
        assert(action.length > 0);

  final int step;
  final String action;
  final String? ifPass;
  final String? ifFail;
}

class RepairCostRange {
  const RepairCostRange({
    required this.minKrw,
    required this.maxKrw,
  })  : assert(minKrw >= 0),
        assert(maxKrw >= minKrw);

  final int minKrw;
  final int maxKrw;
}

class Dtc {
  const Dtc({
    required this.id,
    required this.kind,
    required this.title,
    required this.description,
    required this.possibleCauses,
    required this.diagnosticSteps,
    this.manufacturer,
    this.affectedSystems = const [],
    this.typicalRepairCost,
    this.references = const [],
  })  : assert(id.length == 5),
        assert(title.length > 0),
        assert(description.length > 0),
        assert(possibleCauses.length >= 2),
        assert(diagnosticSteps.length >= 1);

  final String id;
  final DtcKind kind;
  final String title;
  final String description;
  final String? manufacturer;
  final List<AffectedVehicleSystem> affectedSystems;
  final List<DtcPossibleCause> possibleCauses;
  final List<DtcDiagnosticStep> diagnosticSteps;
  final RepairCostRange? typicalRepairCost;
  final List<String> references;

  bool get isGeneric => kind == DtcKind.generic;
}
