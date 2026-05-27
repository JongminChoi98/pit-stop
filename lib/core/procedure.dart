import 'vehicle.dart';

enum ProcedureCategory {
  oilChange,
  filterChange,
  brake,
  battery,
  tire,
  belt,
  coolant,
  transmission,
  suspension,
  electrical,
  diagnostic,
  body,
  hvac,
  emission,
  other,
}

class ApplicableVehicleFilter {
  const ApplicableVehicleFilter({
    this.vehicleIds = const [],
    this.makes = const [],
    this.bodyTypes = const [],
    this.fuels = const [],
    this.all = false,
  });

  final List<String> vehicleIds;
  final List<String> makes;
  final List<VehicleBodyType> bodyTypes;
  final List<VehicleFuel> fuels;
  final bool all;

  bool matches(Vehicle vehicle) {
    if (all) {
      return true;
    }
    if (vehicleIds.isNotEmpty) {
      return vehicleIds.contains(vehicle.id);
    }
    var hasFilter = false;
    if (makes.isNotEmpty) {
      hasFilter = true;
      if (!makes.contains(vehicle.make)) {
        return false;
      }
    }
    if (bodyTypes.isNotEmpty) {
      hasFilter = true;
      if (!bodyTypes.contains(vehicle.bodyType)) {
        return false;
      }
    }
    if (fuels.isNotEmpty) {
      hasFilter = true;
      if (!fuels.any(vehicle.supportsFuel)) {
        return false;
      }
    }
    return hasFilter;
  }
}

class RequiredPart {
  const RequiredPart({
    required this.partRef,
    this.quantity = 1,
  })  : assert(partRef.length > 0),
        assert(quantity >= 1);

  final String partRef;
  final int quantity;
}

class ProcedureStep {
  const ProcedureStep({
    required this.step,
    required this.action,
    this.torqueNm,
    this.warning,
  })  : assert(step >= 1),
        assert(action.length > 0);

  final int step;
  final String action;
  final double? torqueNm;
  final String? warning;

  bool get hasSafetyWarning => warning != null && warning!.isNotEmpty;
}

class Procedure {
  const Procedure({
    required this.id,
    required this.title,
    required this.category,
    required this.estimatedDurationMin,
    required this.difficulty,
    required this.steps,
    this.applicableVehicles = const ApplicableVehicleFilter(),
    this.requiredTools = const [],
    this.requiredParts = const [],
    this.safetyNotes = const [],
    this.references = const [],
  })  : assert(id.length > 0),
        assert(title.length > 0),
        assert(estimatedDurationMin >= 1 && estimatedDurationMin <= 120),
        assert(difficulty >= 1 && difficulty <= 5),
        assert(steps.length >= 1);

  final String id;
  final String title;
  final ProcedureCategory category;
  final ApplicableVehicleFilter applicableVehicles;
  final int estimatedDurationMin;
  final int difficulty;
  final List<String> requiredTools;
  final List<RequiredPart> requiredParts;
  final List<ProcedureStep> steps;
  final List<String> safetyNotes;
  final List<String> references;

  bool get fitsFiveMinuteGameCycle => steps.length <= 12 && difficulty <= 3;
}
