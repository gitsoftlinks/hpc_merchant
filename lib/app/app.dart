import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:happiness_club_merchant/app/settings/settings_controller.dart';
import 'package:happiness_club_merchant/src/features/home/model/home_view_model.dart';
import 'package:happiness_club_merchant/src/features/screens/business/all_business/model/get_all_businesses_view_model.dart';
import 'package:happiness_club_merchant/src/features/screens/create_product/model/create_product_view_model.dart';
import 'package:happiness_club_merchant/src/features/screens/business/create_business/model/create_business_view_model.dart';
import 'package:happiness_club_merchant/src/features/screens/offer_by_business/models/offer_by_business_view_model.dart';
import 'package:happiness_club_merchant/src/features/screens/offer_detail_screen/models/offer_detail_view_model.dart';
import 'package:happiness_club_merchant/src/features/screens/products_by_business/models/products_by_business_view_model.dart';
import 'package:happiness_club_merchant/src/features/screens/products_by_business/products_by_business.dart';
import 'package:provider/provider.dart';
import '../src/features/screens/business/business_detail/model/business_detail_view_model.dart';
import '../src/features/screens/product_detail/model/product_detail_view_model.dart';
import '../utils/globals.dart';
import '../utils/router/back_button_dispatcher.dart';
import '../utils/router/app_route_parser.dart';
import '../utils/router/app_router_delegate.dart';
import 'app_theme/app_theme.dart';
import 'models/select_location_view_model.dart';

/// The Widget that configures your application.
class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  final SettingsController settingsController;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  //

  late AppRouterDelegate delegate;

  late AppBackButtonDispatcher backButtonDispatcher;

  late AppParser parser = AppParser();

  @override
  void initState() {
    super.initState();

    // setUpNotifications();

    isAndroid = Platform.isAndroid;

    delegate = AppRouterDelegate(sl());

    backButtonDispatcher = sl<AppBackButtonDispatcher>();

    WidgetsBinding.instance.addObserver(this);

    setUpNotifications();
  }

  void removeFocus(BuildContext context) {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The AnimatedBuilder Widget listens to the SettingsController for changes.

    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => CreateBusinessViewModel(
                getCurrentUserDetails: sl(),
                deleteBranchLocationAttachments: sl(),
                getBusinessContract: sl(),
                appState: sl(),
                createNewBusiness: sl(),
                getBusinessCategories: sl(),
                pickImageFromGallery: sl())),
        ChangeNotifierProvider(
            create: (context) => SelectLocationViewModel(
                googleMapLatLngDetailsGet: sl(),
                googleMapPlaceDetailsGet: sl(),
                googleMapPlaceGet: sl())),
        ChangeNotifierProvider(
            create: (_) => CreateProductViewModel(
                deleteProductLocationAttachments: sl(),
                deleteProductAttachments: sl(),
                addBusinessProduct: sl(),
                appState: sl(),
                getAllProducts: sl(),
                getBusinessLocations: sl(),
                pickImageFromGallery: sl())),
        ChangeNotifierProvider(
            create: (_) => BusinessDetailViewModel(
                allOffersByBusiness: sl(),
                getBusinessContractDownload: sl(),
                getBusinessDetail: sl(),
                addBusinessProduct: sl(),
                pickImageFromGallery: sl(),
                getAllProducts: sl(),
                appState: sl(),
                deleteBusiness: sl(),
                getBusinessCategories: sl())),
        ChangeNotifierProvider(
            create: (_) => ProductDetailViewModel(
                appState: sl(),
                deleteProduct: sl(),
                generateDynamicLink: sl(),
                getProductDetail: sl())),
        ChangeNotifierProvider(
            create: (_) => OfferDetailViewModel(
                  getOfferDetail: sl(),
                  appState: sl(),
                )),
        ChangeNotifierProvider(
            create: (_) => HomeViewModel(
                  appState: sl(),
                )),
        ChangeNotifierProvider(
            create: (_) => AllBusinessesViewModel(
                  getAllBusinesses: sl(),
                  getCurrentUserDetails: sl(),
                  appState: sl(),
                )),
        ChangeNotifierProvider(
            create: (_) => OffersByBusinessViewModel(
                  getAllOffersByBusiness: sl(),
                  appState: sl(),
                )),
        ChangeNotifierProvider(
            create: (_) => ProductsByBusinessViewModel(
                  getAllProducts: sl(),
                  appState: sl(),
                )),
        ChangeNotifierProvider(
            create: (_) => BusinessDetailViewModel(
                allOffersByBusiness: sl(),
                appState: sl(),
                getBusinessContractDownload: sl(),
                addBusinessProduct: sl(),
                deleteBusiness: sl(),
                getAllProducts: sl(),
                getBusinessCategories: sl(),
                getBusinessDetail: sl(),
                pickImageFromGallery: sl())),
      ],
      child: ScreenUtilInit(
        builder: (context, child) => AnimatedBuilder(
          animation: widget.settingsController,
          builder: (BuildContext context, Widget? child) {
            return GestureDetector(
              onTap: () {},
              child: MaterialApp.router(
                scaffoldMessengerKey: scaffoldMessengerGlobal,
                routerDelegate: delegate,
                localizationsDelegates: [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                supportedLocales: [
                  const Locale('en', 'US'), // English
                  const Locale('th', 'TH'), // Thai
                ],
                backButtonDispatcher: backButtonDispatcher,
                routeInformationParser: parser,
                // localizationsDelegates: [
                //   ...context.localizationDelegates,
                //   GlobalMaterialLocalizations.delegate,
                //   GlobalWidgetsLocalizations.delegate,
                //   GlobalCupertinoLocalizations.delegate,
                // ],
                // supportedLocales: context.supportedLocales,
                // locale: context.locale,
                debugShowCheckedModeBanner: false,
                builder: (context, widget) {
                  // ScreenUtil.setContext(context);
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: widget ?? Container(),
                  );
                },
                title: 'Happiness Club Merchant',
                theme: AppTheme().lightTheme(),
              ),
            );
          },
        ),
      ),
    );
  }

  void setUpNotifications() async {
    //   var remoteNotificationService = sl<RemoteNotificationsService>();

    //   await remoteNotificationService.getNotificationsPermission();

    // await remoteNotificationService.getToken();

    //  remoteNotificationService.listenToForegroundNotification();
  }
}
