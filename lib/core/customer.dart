enum CustomerAgeRange {
  twenties,
  thirties,
  forties,
  fifties,
  sixties,
  seventiesPlus,
}

enum CustomerGender {
  male,
  female,
  unspecified,
}

enum KoreanDialect {
  standard,
  busan,
  ulsan,
  daegu,
  gyeongsangOther,
  gwangju,
  jeollaOther,
  jeju,
  other,
}

enum VehicleRelationship {
  owner,
  familyCar,
  fleet,
  borrowed,
}

enum VisitFrequency {
  regular,
  occasional,
  firstTime,
}

enum CommunicationStyle {
  polite,
  terse,
  chatty,
  anxious,
  skeptical,
  aggressive,
  knowledgeable,
  confused,
  hurried,
  patient,
  bargaining,
}

class Customer {
  const Customer({
    required this.id,
    required this.displayName,
    required this.ageRange,
    required this.region,
    required this.vehicleOwnedId,
    required this.communicationStyle,
    required this.difficulty,
    this.gender = CustomerGender.unspecified,
    this.dialect = KoreanDialect.standard,
    this.occupationCategory,
    this.vehicleRelationship = VehicleRelationship.owner,
    this.visitFrequency = VisitFrequency.occasional,
    this.backstory,
    this.signaturePhrases = const [],
  })  : assert(id.length > 0),
        assert(displayName.length > 0),
        assert(region.length > 0),
        assert(vehicleOwnedId.length > 0),
        assert(communicationStyle.length >= 1),
        assert(difficulty >= 1 && difficulty <= 5);

  final String id;
  final String displayName;
  final CustomerAgeRange ageRange;
  final CustomerGender gender;
  final String region;
  final KoreanDialect dialect;
  final String? occupationCategory;
  final String vehicleOwnedId;
  final VehicleRelationship vehicleRelationship;
  final VisitFrequency visitFrequency;
  final List<CommunicationStyle> communicationStyle;
  final int difficulty;
  final String? backstory;
  final List<String> signaturePhrases;

  bool get isDifficult => difficulty >= 4;
}
