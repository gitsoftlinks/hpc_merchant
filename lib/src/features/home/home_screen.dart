import 'dart:async';

import 'package:happiness_club_merchant/app/app_theme/app_theme.dart';
import 'package:happiness_club_merchant/src/features/screens/business/all_business/all_business_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import '../../../app/app_asset_path/images_util.dart';
import '../../../app/custom_widgets/show_loader.dart';
import '../../../app/providers/account_provider.dart';
import '../../../app/toast_messages/toast_messages.dart';
import '../../../utils/router/app_state.dart';
import '../screens/business/manage_business.dart';
import '../screens/products_by_business/products_by_business.dart';
import '../screens/offer_by_business/offers_by_business.dart';
import 'model/home_view_model.dart';

class HomeScreen extends StatefulWidget {
  final HomeViewModel viewModel;

  const HomeScreen({Key? key, required this.viewModel}) : super(key: key);

  static HomeScreenState? of(BuildContext context) {
    return context.findAncestorStateOfType<HomeScreenState>();
  }

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  //

  AccountProvider get accountsProvider => GetIt.I.get();

  var appState = GetIt.I.get<AppState>();

  late GlobalKey<ScaffoldState> _scaffoldKey;

  late ShowLoader showLoader;

  @override
  void initState() {
    super.initState();

    _scaffoldKey = GlobalKey<ScaffoldState>();

    // widget.viewModel.getAllConfigurations();

    widget.viewModel.errorMessages =
        (message) => showErrorToast(context, message);
    widget.viewModel.toggleShowLoader = () => showLoader.toggle();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: accountsProvider,
        builder: (context, snapshot) {
          return Consumer<AccountProvider>(builder: (context, model, child) {
            return PersistentTabView(
              context,
              controller: widget.viewModel.controller,
              padding: NavBarPadding.only(
                top: 5.h,
              ),
              margin: EdgeInsets.only(bottom: 5.h),
              screens: getBody(),
              navBarHeight: widget.viewModel.showAppBar ? 55.0.h : 0.h,
              items: _navBarsItems(),
              onItemSelected: (value) {
                // if (value == 0) {
                //   widget.viewModel.scrollController.animateTo(
                //     0,
                //     duration: Duration(milliseconds: 500),
                //     curve: Curves.easeInOut,
                //   );
                // }
              },
              confineInSafeArea: true,
              handleAndroidBackButtonPress: false,
              resizeToAvoidBottomInset: true,
              stateManagement: true,
              hideNavigationBarWhenKeyboardShows: true,
              popAllScreensOnTapOfSelectedTab: true,
              popActionScreens: PopActionScreensType.all,
              decoration: NavBarDecoration(
                borderRadius: BorderRadius.circular(10.0),
                colorBehindNavBar: Theme.of(context).canvasColor,
              ),
              itemAnimationProperties: const ItemAnimationProperties(
                duration: Duration(milliseconds: 200),
                curve: Curves.ease,
              ),
              screenTransitionAnimation: const ScreenTransitionAnimation(
                animateTabTransition: false,
                curve: Curves.ease,
                duration: Duration(milliseconds: 200),
              ),
              navBarStyle: NavBarStyle.style8,
            );
          });
        });
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          SvgAssetsPaths.homeActiveSvg,
          height: 20.w,
          color: kPrimaryColor,
        ),
        inactiveIcon: SvgPicture.asset(
          SvgAssetsPaths.homeInactiveSvg,
          height: 20.w,
          color: kDisabledTextColor,
        ),
        title: ('Home'),
        textStyle:
            Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12.sp),
        activeColorPrimary: Theme.of(context).primaryColor,
        inactiveColorPrimary: kDisabledTextColor,
      ),
      PersistentBottomNavBarItem(
        icon: SizedBox(
          height: 20.h,
          width: 50.h,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  SvgAssetsPaths.drawerShoppingCartSvg,
                  height: 25.w,
                  color: kPrimaryColor,
                ),
              ),
            ],
          ),
        ),
        inactiveIcon: SizedBox(
          height: 20.h,
          width: 50.h,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  SvgAssetsPaths.drawerShoppingCartSvg,
                  height: 20.w,
                ),
              ),
            ],
          ),
        ),
        title: ('Offers'),
        textStyle:
            Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12.sp),
        activeColorPrimary: Theme.of(context).primaryColor,
        inactiveColorPrimary: kDisabledTextColor,
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          SvgAssetsPaths.calendarInactiveSvg,
          height: 20.w,
          color: kPrimaryColor,
        ),
        inactiveIcon: SvgPicture.asset(
          SvgAssetsPaths.calendarInactiveSvg,
          height: 20.w,
        ),
        title: ('Products'),
        textStyle:
            Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12.sp),
        activeColorPrimary: Theme.of(context).primaryColor,
        inactiveColorPrimary: kDisabledTextColor,
      ),
    ];
  }

  List<Widget> getBody() {
    return [
      buildBusinessesScreen(),
      buildNotificationScreen(),
      buildAccountScreen(),
    ];
  }

  Widget buildComingSoonText() {
    return Center(
      child: Text('coming_soon'.ntr()),
    );
  }

  Widget buildHomeScreen() {
    return MangeBusinessScreen();
  }

  Widget buildAccountScreen() {
    return ProductsByBusinessScreen(
      comingFromHome: true,
      toHome: false,
    );
  }

  Widget buildNotificationScreen() {
    return OffersByBusinessScreen(
      comingFromHome: true,
      toHome: false,
    );
  }

  Widget buildBusinessesScreen() {
    return const AllBusinessesScreen(
      comingFromHome: true,
    );
  }

  OpenCreateBottomSheet() {
    return buildComingSoonText();
  }
}
