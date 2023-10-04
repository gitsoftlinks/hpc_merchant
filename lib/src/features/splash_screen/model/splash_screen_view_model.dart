import 'dart:async';
import 'dart:io';
import 'package:happiness_club_merchant/services/error/failure.dart';
import 'package:happiness_club_merchant/services/remote_config/remote_config_service.dart';
import 'package:happiness_club_merchant/services/third_party_plugins/remote_notifications_helper.dart';
import 'package:happiness_club_merchant/services/usecases/usecase.dart';
import 'package:happiness_club_merchant/utils/constants/app_state_enum.dart';
import 'package:happiness_club_merchant/utils/constants/app_strings.dart';
import 'package:happiness_club_merchant/utils/constants/string_constants.dart';
import 'package:happiness_club_merchant/utils/router/app_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../../app/app_usecase/clear_secure_storage.dart';
import '../../../../app/app_usecase/first_time_using_app.dart';
import '../../../../app/app_usecase/get_app_info.dart';
import '../../../../app/app_usecase/get_current_user_details.dart';
import '../../../../app/app_usecase/handle_dynamic_link.dart';
import '../../../../app/models/user_runtime_config.dart';
import '../../../../app/providers/account_provider.dart';
import '../../../../utils/permission/permission_engine.dart';
import '../../screens/business/all_business/usecases/get_all_businesses.dart';
import '../../screens/notifications/usecases/get_user_notifications.dart';
import '../../screens/signin_screen/usecases/send_login.dart';
import '../helper/splash_page_action_helper.dart';
import '../usecases/get_app_state.dart';
import '../usecases/get_link_on_app_opened.dart';
import '../usecases/logout_user.dart';

class SplashScreenViewModel extends ChangeNotifier {
  final SplashScreenViewModelDependencies _splashScreenViewModelDependencies;

  SplashScreenViewModel(
      {required SplashScreenViewModelDependencies
          splashScreenViewModelDependencies})
      : _splashScreenViewModelDependencies = splashScreenViewModelDependencies;

  late ValueChanged<String> errorMessages;
  late VoidCallback showInternetSnackBar;
  VoidCallback? startConfiguration;
  VoidCallback? showPermissionDialog;

  bool shouldOnBoard = false;
  AppStateEnum appStateEnum = AppStateEnum.NONE;
  bool accessTokenExpiredNeedAuth = false;
  bool userExistsOnServer = false;
  bool biometricAvailable = false;
  String userStatus = 'ENABLED';
  String appVersion = '1.0.0';
  double progressMade = 0.0;
  bool isDismissed = false;
  bool loginTokenExist = false;

  int maxSteps = 8;

  /// This method is used for doing all the configurations needed for the app
  Future getAllConfigurations() async {
    progressMade = 10;
    notifyListeners();

    /// Check is First time user using the app
    await isFirstTimeUsingApp();

    progressMade = 20;
    notifyListeners();

    /// get app version and also possible if needed move the user to update screen
    appVersion = await checkAppLatestOrNot();

    progressMade = 30;
    notifyListeners();

    /// Get AppState
    if (!await getAppState()) {
      return;
    }

    progressMade = 40;
    notifyListeners();

    progressMade = 50;
    notifyListeners();

    /// Check current user exist or not
    if (!(await checkUserExistsOrNot())) {
      return;
    }

    progressMade = 60;
    notifyListeners();

    progressMade = 70;
    notifyListeners();

    progressMade = 80;
    notifyListeners();

    _splashScreenViewModelDependencies.appState.appStateEnum = appStateEnum;

    progressMade = 100;
    notifyListeners();

    _splashScreenViewModelDependencies.appState.currentAction =
        SplashPageActionHelper().getPageAction(
      shouldOnBoard: shouldOnBoard,
      appStateEnum: appStateEnum,
      accessTokenExpiredNeedAuth: accessTokenExpiredNeedAuth,
      userExistsOnServer: userExistsOnServer,
      userStatus: userStatus,
    );

    /// Check if opened with dynamic link

    if (await setUpDynamicLink()) {
      return;
    }
  }

  Future<void> getUserNotifications() async {
    var userNotificationsEither = await _splashScreenViewModelDependencies
        .getUserNotification
        .call(NoParams());

    if (userNotificationsEither.isLeft()) {
      handleError(userNotificationsEither);
      return;
    }
    var notifications = userNotificationsEither.toOption().toNullable()!;
    int count = 0;
    for (UserNotification item in notifications) {
      if (item.notificationReadStatus == 0) {
        count++;
      }
    }
    GetIt.I.get<AccountProvider>().unreadNotifications = count;
  }

  @visibleForTesting
  Future<bool> getAppState() async {
    var appStateEither = await _splashScreenViewModelDependencies
        .getAppStateUseCase
        .call(NoParams());

    if (isError(appStateEither)) {
      handleError(appStateEither);
      return false;
    }

    if (isSuccessful(appStateEither)) {
      appStateEnum = appStateEither.getOrElse(() => throw SOMETHING_WENT_WRONG);

      return true;
    }

    return false;
  }

  @visibleForTesting
  Future<bool> setUpDynamicLink() async {
    var appLinkEither = await _splashScreenViewModelDependencies
        .getAppLinkOnAppOpened
        .call(NoParams());

    if (isSuccessful(appLinkEither)) {
      var appUri = appLinkEither.getOrElse(() => throw SOMETHING_WENT_WRONG);
    }

    return false;
  }

  Future<String> checkAppLatestOrNot() async {
    var appInfoEither =
        await _splashScreenViewModelDependencies.getAppInfo.call(NoParams());
    var appVersion = '';
    if (appInfoEither.isLeft()) {
      var failure = appInfoEither
          .swap()
          .getOrElse(() => ServerFailure(SOMETHING_WENT_WRONG));

      if (isNotInternetConnection(failure)) {
        handleError(Left(failure));
        return appVersion;
      }

      return appVersion;
    }

    if (isSuccessful(appInfoEither)) {
      appVersion = appInfoEither
          .getOrElse(() => throw SOMETHING_WENT_WRONG)
          .getCodeForRemoteConfig;
      String remoteConfigVersion;
      if (Platform.isAndroid) {
        // remoteConfigVersion = _splashScreenViewModelDependencies
        //     .remoteConfigService
        //     .getAndroidAppVersion();
      } else {
        // remoteConfigVersion = _splashScreenViewModelDependencies
        //     .remoteConfigService
        //     .getIOSAppVersion();
      }

      // if (appVersion == remoteConfigVersion) {
      //   return appVersion;
      // }

      // _splashScreenViewModelDependencies.appState.currentAction = PageAction(state: PageState.replaceAll, page: UpdateAppConfig);
      return appVersion;
    }

    return appVersion;
  }

  void handleError(Either<Failure, dynamic> response) {
    response.fold((l) {
      if (l is NetworkFailure) {
        showInternetSnackBar.call();
      } else {
        errorMessages.call(l.message);
      }
    }, (r) => null);
  }

  bool isError(Either<Failure, dynamic> response) => response.isLeft();

  bool isSuccessful(Either<Failure, dynamic> response) => response.isRight();

  Future getEssentialPermissions() async {
    var permissionEngine = GetIt.I.get<PermissionEngine>();
    await permissionEngine.hasPermission(CustomPermission.location);

    // if (isGranted || isDismissed) {
    startConfiguration?.call();
    // return;
    // }

    // showPermissionDialog?.call();
  }

  /// Checks whether the user exists or not
  /// Outputs: [bool] true if get response from the server
  /// false if no internet
  @visibleForTesting
  Future<bool> checkUserExistsOrNot() async {
    if (loginTokenExist) {
      var userInfoEither = await _splashScreenViewModelDependencies
          .getCurrentUserRemote
          .call(NoParams());
      if (userInfoEither.isLeft()) {
        var failure = userInfoEither
            .swap()
            .getOrElse(() => ServerFailure(SOMETHING_WENT_WRONG));

        if (isNotInternetConnection(failure)) {
          handleError(Left(failure));
          return false;
        }

        return true;
      }

      var getCurrentUserRemoteResponse =
          userInfoEither.toOption().toNullable()!.user;
      await setupDataIfUserExists(getCurrentUserRemoteResponse);
      //   if (getCurrentUserRemoteResponse.isBusinessCreated ==
      //       StringConstants.hasBusiness) {
      //     await getUsersBusinesses();
      //   }

      //   await getUserNotifications();
    }
    return true;
  }

  Future<void> setupDataIfUserExists(
      UserData getCurrentUserRemoteResponse) async {
    GetIt.I
        .get<AccountProvider>()
        .cacheRegisteredUserData(getCurrentUserRemoteResponse);
    userExistsOnServer = true;
  }

  Future<void> getUsersBusinesses() async {
    var getBusinessesEither = await _splashScreenViewModelDependencies
        .getAllBusinesses
        .call(NoParams());
    if (getBusinessesEither.isLeft()) {
      handleError(getBusinessesEither);
      return;
    }

    getBusinessesEither.fold((l) => [], (r) => r.business);
    //var accountProvider = GetIt.I.get<AccountProvider>();
    //  accountProvider.userBusinesses = allBusinesses;
  }

  @visibleForTesting
  Future<void> isFirstTimeUsingApp() async {
    var isFirstTimeUsingAppEither = await _splashScreenViewModelDependencies
        .isFirstTimeUsingTheApp
        .call(NoParams());
    if (isFirstTimeUsingAppEither.isLeft()) {
      if (isFirstTimeUsingAppEither is NetworkFailure) {
        showInternetSnackBar.call();
      }
      loginTokenExist = false;
      GetIt.I.get<UserRuntimeConfig>().isLogin = false;

      return;
    }

    var isFirstTime = isFirstTimeUsingAppEither.getOrElse(() => false);
    if (isFirstTime) {
      loginTokenExist = true;
      GetIt.I.get<UserRuntimeConfig>().isLogin = true;
      return;
    }

    await clearSecureStorageData();
  }

  @visibleForTesting
  Future<bool> clearSecureStorageData() async {
    var clearSecureStorageEither = await _splashScreenViewModelDependencies
        .clearSecureStorage
        .call(NoParams());

    if (clearSecureStorageEither.isRight()) {
      return true;
    }
    return false;
  }

  @visibleForTesting
  Future<bool> logoutPreviousIOSUser() async {
    var clearSecureStorageEither =
        await _splashScreenViewModelDependencies.logoutUser.call(NoParams());

    if (clearSecureStorageEither.isRight()) {
      return true;
    }
    return false;
  }

  bool isNotInternetConnection(Failure failure) => failure is NetworkFailure;

  bool isAccessTokenExpired(Failure l) => l is AccessTokenFailure;
}

/// All the dependency of the splashscreen
class SplashScreenViewModelDependencies {
  final GetAppState getAppStateUseCase;
  final GetAppLinkOnAppOpened getAppLinkOnAppOpened;
  final HandleDynamicLink handleDynamicLink;
  //final RemoteConfigService remoteConfigService;
  final GetAppInfo getAppInfo;
  final GetCurrentUserDetails getCurrentUserRemote;
  final GetAllBusinesses getAllBusinesses;
  final IsFirstTimeUsingTheApp isFirstTimeUsingTheApp;
  final ClearSecureStorage clearSecureStorage;
  final AppState appState;
  final LogoutUser logoutUser;
//  final RemoteNotificationsService remoteNotificationsService;
  final GetUserNotification getUserNotification;

  SplashScreenViewModelDependencies(
      {required this.getAppStateUseCase,
      required this.getAppLinkOnAppOpened,
      required this.handleDynamicLink,
      //  required this.remoteConfigService,
      required this.getAppInfo,
      required this.getCurrentUserRemote,
      required this.getAllBusinesses,
      required this.isFirstTimeUsingTheApp,
      required this.clearSecureStorage,
      required this.appState,
      required this.logoutUser,
      //required this.remoteNotificationsService,
      required this.getUserNotification});
}
