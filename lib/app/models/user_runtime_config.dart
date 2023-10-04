
/// This class is to cache user runtime configs
class UserRuntimeConfig  {
  String countryISO;
  bool isLogin;


  factory UserRuntimeConfig.initial() {
    return UserRuntimeConfig( countryISO: 'ARE', isLogin: false);
  }



  UserRuntimeConfig({required this.countryISO, required this.isLogin});

}
