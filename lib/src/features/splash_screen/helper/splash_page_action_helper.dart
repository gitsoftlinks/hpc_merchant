import '../../../../utils/constants/app_state_enum.dart';
import '../../../../utils/router/app_state.dart';
import '../../../../utils/router/models/page_action.dart';
import '../../../../utils/router/models/page_config.dart';


/// [SplashPageActionHelper] will decide where to move the user based on
/// previous activities
class SplashPageActionHelper {
  /// Priority level
  /// 1) Update
  /// 2) OnBoard
  /// 3) Access Token Expired Need Auth
  /// 4) Logged in user
  PageAction getPageAction(
      {required bool shouldOnBoard,
      required AppStateEnum appStateEnum,
      required bool accessTokenExpiredNeedAuth,
        required bool userExistsOnServer,
      required String userStatus,

      }) {
    if (shouldOnBoard) {
      return PageAction(state: PageState.replace, page: HomeScreenConfig);
    }

    if (!userExistsOnServer && getNonRegisteredUserRoute.containsKey(appStateEnum)) {
      return getNonRegisteredUserRoute[appStateEnum]!;
    }

    if(userExistsOnServer) {
        return PageAction(state: PageState.replaceAll, page: HomeScreenConfig);
    }


      // if (registeredUserKYCStatusRoute.containsKey(kycStatus)) {
      //   return registeredUserKYCStatusRoute[kycStatus]!;
      // }


      // if (biometricEnabledRoute.containsKey(biometricAvailable && biometricEnabled)) {
      //   return biometricEnabledRoute[biometricAvailable && biometricEnabled]!;
      // }


    return PageAction(state: PageState.replace, page: HomeScreenConfig);
  }

  Map<AppStateEnum, PageAction> getNonRegisteredUserRoute = {
    AppStateEnum.LOGIN_REGISTER: PageAction(state: PageState.replace, page: LoginRegisterConfig),
    AppStateEnum.NONE: PageAction(state: PageState.replace, page: LoginRegisterConfig),
  };


  // Map<bool, PageAction> biometricEnabledRoute = {
  //   true :    PageAction(state: PageState.replaceAll, page: LoginScreenConfig),
  //   false :    PageAction(state: PageState.replaceAll, page: RegisterScreenConfig),
  // };
}
