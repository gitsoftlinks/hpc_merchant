

enum AccountStatusEnum{
  PendingVerification(1),
  Verified(2),
  Unverified(3);

  const AccountStatusEnum(this.value);
  final num value;
}

extension AccountStatusEnumPar on String {
  AccountStatusEnum toAccountStatusEnum() {
    return AccountStatusEnum.values.firstWhere((e) => e.toString().toLowerCase() == 'AccountStatus.$this'.toLowerCase(), orElse: () => AccountStatusEnum.Unverified); //return null if not found
  }
}