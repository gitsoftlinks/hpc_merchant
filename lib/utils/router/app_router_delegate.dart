import 'dart:async';
import 'package:happiness_club_merchant/src/features/screens/activate_account/activate_account_screen.dart';
import 'package:happiness_club_merchant/src/features/screens/business/all_business/all_business_screen.dart';
import 'package:happiness_club_merchant/src/features/screens/business/business_detail/business_detail_screen.dart';
import 'package:happiness_club_merchant/src/features/screens/create_product/create_product.dart';
import 'package:happiness_club_merchant/src/features/screens/create_offer/create_offer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:happiness_club_merchant/src/features/screens/offer_by_business/offers_by_business.dart';
import 'package:happiness_club_merchant/utils/router/ui_pages.dart';
import '../../src/features/home/home_screen.dart';
import '../../src/features/home/model/home_view_model.dart';
import '../../src/features/no_internet_screen/no_internet_screen.dart';
import '../../src/features/screens/activate_account/insert_email_activate_account.dart';
import '../../src/features/screens/business/create_business/create_business.dart';
import '../../src/features/screens/product_detail/product_details_screen.dart';
import '../../src/features/screens/forget_password/forgot_password.dart';
import '../../src/features/screens/forget_password/insert_email_forget_password.dart';
import '../../src/features/screens/forget_password/reset_password.dart';
import '../../src/features/screens/login_register/login_register_screen.dart';
import '../../src/features/screens/notifications/notification_screen.dart';
import '../../src/features/screens/personal_info/personal_info_screen.dart';
import '../../src/features/screens/settings/settings_screen.dart';
import '../../src/features/screens/signin_screen/signin_screen.dart';
import '../../src/features/screens/signup_screen/signup_screen.dart';
import '../../src/features/splash_screen/splash_screen.dart';
import '../../src/features/splash_screen/update_available_screen.dart';
import '../extensions/extensions.dart' as scaffold_helper;
import '../globals.dart';
import 'app_state.dart';
import 'back_button_dispatcher.dart';

class AppRouterDelegate extends RouterDelegate<PageConfiguration>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<PageConfiguration> {
  late final AppState appState;

  late AppBackButtonDispatcher backButtonDispatcher;

  AppRouterDelegate(this.appState) {
    appState.addListener(() {
      notifyListeners();
    });
  }

  @override
  Widget build(BuildContext context) {
    /// Faulty Code will need to find a way to solve it
    appState.globalErrorShow = (value) {
      context.show(message: value);
    };

    return Container(
      key: ValueKey(appState.pages.last.name),
      child: Navigator(
        key: navigatorKeyGlobal,
        onPopPage: _onPopPage,
        pages: buildPages(),
      ),
    );
  }

  List<Page> buildPages() {
    switch (appState.currentAction.state) {
      case PageState.none:
        break;
      case PageState.addPage:
        addPage(appState.currentAction.page!);
        break;
      case PageState.pop:
        pop();
        break;
      case PageState.addAll:
        // TODO: Handle this case.
        break;
      case PageState.addWidget:
        break;
      case PageState.replace:
        replace(appState.currentAction.page!);
        break;
      case PageState.replaceAll:
        replaceAll(appState.currentAction.page!);
        break;
    }
    return List.of(appState.pages);
  }

  void replaceAll(PageConfiguration newRoute) {
    appState.pages.clear();
    setNewRoutePath(newRoute);
  }

  void replace(PageConfiguration newRoute) {
    if (appState.pages.isNotEmpty) {
      appState.pages.removeLast();
    }
    addPage(newRoute);
  }

  /// This method adds pages based on the pageconfig received
  /// [Input]: [PageConfiguration]
  void addPage(PageConfiguration pageConfig) {
    final shouldAddPage =
        appState.pages.isEmpty || (appState.pages.last.name != pageConfig.path);

    if (shouldAddPage) {
      switch (pageConfig.uiPage) {
        case Pages.Splash:
          _addPageData(const SplashPage(), pageConfig);
          break;
        case Pages.HomeScreen:
          _addPageData(
              HomeScreen(
                viewModel: sl.get<HomeViewModel>(),
              ),
              pageConfig);
          break;
        case Pages.EnterPasscode:
          break;
        case Pages.RegisterScreen:
          break;
        case Pages.NoInternetScreen:
          _addPageData(const NoInternetScreen(), pageConfig);
          break;
        case Pages.UpdateApp:
          _addPageData(const UpdateAvailableScreen(), pageConfig);
          break;
        case Pages.LoginRegister:
          _addPageData(const LoginRegisterScreen(), pageConfig);
          break;

        case Pages.SignInScreen:
          _addPageData(const SignInScreen(), pageConfig);
          break;
        case Pages.SignUpScreen:
          _addPageData(const SignUpScreen(), pageConfig);
          break;

        case Pages.ForgotPasswordScreen:
          _addPageData(const ForgotPasswordScreen(), pageConfig);
          break;
        case Pages.ResetPasswordScreen:
          _addPageData(const ResetPasswordScreen(), pageConfig);
          break;
        case Pages.SettingsScreen:
          _addPageData(const SettingScreen(), pageConfig);
          break;
        case Pages.PersonalInfoScreen:
          _addPageData(const PersonalInfoScreen(), pageConfig);
          break;

        case Pages.CreateBusinessScreen:
          _addPageData(CreateBusinessScreen(), pageConfig);
          break;

        case Pages.InsertEmailPasswordScreen:
          _addPageData(const InsertEmailForgetPasswordScreen(), pageConfig);
          break;
        case Pages.AllBusinessesScreen:
          _addPageData(
              const AllBusinessesScreen(
                comingFromHome: false,
              ),
              pageConfig);
          break;
        case Pages.BusinessDetailScreen:
          _addPageData(BusinessDetailScreen(isCreated: false), pageConfig);
          break;
        case Pages.ProductDetailScreen:
          _addPageData(const ProductDetailsScreen(), pageConfig);
          break;
        case Pages.NotificationScreen:
          _addPageData(const NotificationScreen(), pageConfig);
          break;
        case Pages.CartItemsScreen:
          _addPageData(CreateProductScreen(), pageConfig);
          break;

        case Pages.ChatsScreen:
          _addPageData(
              OffersByBusinessScreen(
                toHome: false,
                comingFromHome: true,
              ),
              pageConfig);
          break;

        case Pages.InsertEmailActivateAccountScreen:
          _addPageData(const InsertEmailActivateAccountScreen(), pageConfig);
          break;
        case Pages.ActivateAccountScreen:
          _addPageData(const ActivateAccountScreen(), pageConfig);
          break;
        case Pages.CalenderScreen:
          _addPageData(CreateOfferScreen(), pageConfig);
          break;
      }
    }
  }

  void _addPageData(Widget child, PageConfiguration pageConfig) {
    appState.pages.add(
      _createPage(child, pageConfig),
    );
  }

  MaterialPage _createPage(Widget child, PageConfiguration pageConfig) {
    return MaterialPage(
        child: child,
        key: ValueKey(pageConfig.key),
        name: pageConfig.path,
        arguments: pageConfig);
  }

  bool _onPopPage(Route<dynamic> route, result) {
    final didPop = route.didPop(result);
    if (!didPop) {
      return false;
    }
    if (canPop()) {
      pop();
      return true;
    } else {
      return false;
    }
  }

  void pop() {
    if (canPop()) {
      _removePage(appState.pages.last as MaterialPage);
    }
  }

  void _removePage(MaterialPage page) {
    appState.pages.remove(page);
  }

  bool canPop() {
    return appState.pages.length > 1;
  }

  @override
  Future<bool> popRoute() {
    if (canPop()) {
      _removePage(appState.pages.last as MaterialPage);
      return Future.value(true);
    }
    return Future.value(false);
  }

  @override
  Future<void> setNewRoutePath(PageConfiguration configuration) {
    final shouldAddPage = appState.pages.isEmpty ||
        (appState.pages.last.name != configuration.path);

    if (!shouldAddPage) {
      return SynchronousFuture(null);
    }
    appState.pages.clear();
    addPage(configuration);

    return SynchronousFuture(null);
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => navigatorKeyGlobal;
}
