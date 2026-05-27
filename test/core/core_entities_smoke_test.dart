import '../../lib/core/core.dart';

void main() {
  const vehicle = Vehicle(
    id: 'hyundai-avante-ad',
    make: 'Hyundai',
    model: 'Avante',
    generationCode: 'AD',
    yearRange: VehicleYearRange(start: 2015, end: 2020),
    bodyType: VehicleBodyType.sedan,
    popularityInKorea: KoreaMarketPopularity.veryHigh,
    engineOptions: [
      VehicleEngineOption(
        fuel: VehicleFuel.gasoline,
        displacementCc: 1591,
      ),
    ],
  );

  assert(vehicle.displayName == 'Hyundai Avante AD');
  assert(vehicle.yearRange.includes(2018));
  assert(vehicle.supportsFuel(VehicleFuel.gasoline));

  final dtc = Dtc(
    id: 'P0420',
    kind: DtcKind.generic,
    title: 'Catalyst efficiency below threshold',
    description: 'Bank 1 catalyst efficiency is below the expected range.',
    possibleCauses: [
      DtcPossibleCause(
        cause: 'Catalyst aging',
        likelihood: CauseLikelihood.common,
      ),
      DtcPossibleCause(
        cause: 'Rear oxygen sensor fault',
        likelihood: CauseLikelihood.occasional,
      ),
    ],
    diagnosticSteps: [
      DtcDiagnosticStep(
        step: 1,
        action: 'Check companion codes and oxygen sensor data.',
      ),
    ],
  );

  assert(dtc.isGeneric);

  final customer = Customer(
    id: 'sample-customer',
    displayName: 'Sample',
    ageRange: CustomerAgeRange.fifties,
    region: 'Busan',
    vehicleOwnedId: 'hyundai-avante-ad',
    communicationStyle: [CommunicationStyle.polite],
    difficulty: 2,
  );

  assert(!customer.isDifficult);

  final procedure = Procedure(
    id: 'oil-change-gasoline',
    title: 'Gasoline oil change',
    category: ProcedureCategory.oilChange,
    estimatedDurationMin: 25,
    difficulty: 1,
    applicableVehicles: ApplicableVehicleFilter(
      fuels: [VehicleFuel.gasoline],
    ),
    steps: [
      ProcedureStep(step: 1, action: 'Drain engine oil.'),
      ProcedureStep(step: 2, action: 'Replace oil filter.'),
    ],
  );

  assert(procedure.applicableVehicles.matches(vehicle));
  assert(procedure.fitsFiveMinuteGameCycle);
}
