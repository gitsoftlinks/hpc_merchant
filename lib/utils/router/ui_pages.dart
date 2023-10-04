// ignore_for_file: constant_identifier_names

import 'package:equatable/equatable.dart';

class PageConfiguration extends Equatable {
  final String key;
  final String path;
  final Pages uiPage;
  final Map<String, dynamic> arguments;

  const PageConfiguration(
      {required this.key,
      required this.path,
      required this.uiPage,
      this.arguments = const {}});

  factory PageConfiguration.withArguments(
      PageConfiguration pageConfiguration, Map<String, dynamic> arguments) {
    return PageConfiguration(
        uiPage: pageConfiguration.uiPage,
        key: pageConfiguration.key,
        path: pageConfiguration.path,
        arguments: arguments);
  }

  @override
  List<Object?> get props => [key, path, uiPage, arguments];
}

/// These are the pages that are currently working under Navigator 2.0
enum Pages {
  Splash,
  LoginRegister,
  EnterPasscode,
  RegisterScreen,
  HomeScreen,
  NoInternetScreen,
  UpdateApp,
  SignInScreen,
  SignUpScreen,
  ForgotPasswordScreen,
  ResetPasswordScreen,
  SettingsScreen,
  PersonalInfoScreen,

  CreateBusinessScreen,

  InsertEmailPasswordScreen,
  AllBusinessesScreen,
  BusinessDetailScreen,
  ProductDetailScreen,
  CartItemsScreen,

  NotificationScreen,

  ChatsScreen,
  CreateEventScreen,

  InsertEmailActivateAccountScreen,
  ActivateAccountScreen,

  CalenderScreen
}
