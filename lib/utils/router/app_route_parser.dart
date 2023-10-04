import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../constants/app_paths.dart';
import 'models/page_config.dart';
import 'ui_pages.dart';

class AppParser extends RouteInformationParser<PageConfiguration> {
  @override
  Future<PageConfiguration> parseRouteInformation(
      RouteInformation routeInformation) {
    //

    final uri = Uri.parse(routeInformation.location ?? '');

    if (uri.pathSegments.isEmpty) {
      return SynchronousFuture(SplashPageConfig);
    }

    final path = '/${uri.pathSegments[0]}';

    switch (path) {
      case splashPath:
        return SynchronousFuture(SplashPageConfig);
      case homeScreenPath:
        return SynchronousFuture(HomeScreenConfig);
      // case RegisterScreenPath:
      //   return SynchronousFuture(RegisterScreenConfig);
      default:
        return SynchronousFuture(SplashPageConfig);
    }
  }

  @override
  RouteInformation restoreRouteInformation(PageConfiguration configuration) {
    switch (configuration.uiPage) {
      case Pages.Splash:
        return const RouteInformation(location: splashPath);
      case Pages.EnterPasscode:
        return const RouteInformation(location: EnterPasscodePath);
      case Pages.HomeScreen:
        return const RouteInformation(location: homeScreenPath);
      case Pages.RegisterScreen:
        return const RouteInformation(location: registerScreenPath);
      case Pages.NoInternetScreen:
        return const RouteInformation(location: noInternetScreenPath);
      case Pages.UpdateApp:
        return const RouteInformation(location: UpdateAppPath);
      case Pages.LoginRegister:
        return const RouteInformation(location: otpScreenPath);

      case Pages.SignInScreen:
        return const RouteInformation(location: signInScreenPath);
      case Pages.SignUpScreen:
        return const RouteInformation(location: signUpScreenPath);

      case Pages.ForgotPasswordScreen:
        return const RouteInformation(location: ForgotPasswordScreenPath);
      case Pages.ResetPasswordScreen:
        return const RouteInformation(location: ResetPasswordScreenPath);
      case Pages.SettingsScreen:
        return const RouteInformation(location: createResetPasswordScreenPath);
      case Pages.PersonalInfoScreen:
        return const RouteInformation(location: PersonalInfoScreenPath);

      case Pages.CreateBusinessScreen:
        return const RouteInformation(location: CreateBusinessScreenPath);

      case Pages.InsertEmailPasswordScreen:
        return const RouteInformation(location: InsertEmailPasswordScreenPath);
      case Pages.AllBusinessesScreen:
        return const RouteInformation(location: AllBusinessesScreenPath);
      case Pages.BusinessDetailScreen:
        return const RouteInformation(location: BusinessDetailScreenPath);
      case Pages.ProductDetailScreen:
        return const RouteInformation(location: ProductDetailScreenPath);
      case Pages.NotificationScreen:
        return const RouteInformation(location: NotificationScreenPath);
      case Pages.CartItemsScreen:
        return const RouteInformation(location: CartItemsScreenPath);

      case Pages.CreateEventScreen:
        return const RouteInformation(location: CreateEventScreenPath);
      case Pages.ChatsScreen:
        return const RouteInformation(location: ChatsScreenPath);

      case Pages.InsertEmailActivateAccountScreen:
        return const RouteInformation(
            location: insertEmailActivateAccountScreenPath);
      case Pages.ActivateAccountScreen:
        return const RouteInformation(location: activateAccountScreenPath);

      case Pages.CalenderScreen:
        return const RouteInformation(location: calenderScreenPath);
    }
  }
}
