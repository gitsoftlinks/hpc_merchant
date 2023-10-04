

// ignore_for_file: constant_identifier_names

/// usage
/*
* const vehicleStatusEnum = VehicleStatusEnum.Draft;
* print(vehicleStatusEnum.value);
*/

enum UserTypesEnum {
  guest(1),
  registered(2);

  const UserTypesEnum(this.value);
  final int value;
}

enum StatusTypeEnum{active, inactive}

extension StatusTypeEnumPar on String {
  StatusTypeEnum toStatusTypeEnum() {
    return StatusTypeEnum.values.firstWhere((e) => e.toString().toLowerCase() == 'StatusTypeEnum.$this'.toLowerCase(), orElse: () => StatusTypeEnum.active); //return null if not found
  }
}