/// These are the current appstate our app supports
enum AppStateEnum {
  NONE,
  accountVerification,
  registerVerifyOtp,
  LOGIN_REGISTER,
  EMAIL_VERIFICATION,
  EMAIL_VERIFIED,
  POST_DETAIL,
}

extension AppStateEnumPar on String {
  AppStateEnum toAppStateEnum() {
    return AppStateEnum.values.firstWhere(
        (e) => e.toString().toLowerCase() == 'AppStateEnum.$this'.toLowerCase(),
        orElse: () => AppStateEnum.NONE); //return null if not found
  }
}

extension AppStateEnumDePar on AppStateEnum {
  String toStringAppState() {
    return toString().split('.').last; //return null if not found
  }
}
