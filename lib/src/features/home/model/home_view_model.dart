import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';
import 'package:happiness_club_merchant/src/features/screens/signin_screen/usecases/send_login.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import '../../../../app/app_asset_path/images_util.dart';
import '../../../../app/app_theme/app_theme.dart';
import '../../../../app/providers/account_provider.dart';
import '../../../../services/error/failure.dart';
import '../../../../utils/router/app_state.dart';
import '../../../../utils/router/models/page_action.dart';
import '../../../../utils/router/models/page_config.dart';

class HomeViewModel extends ChangeNotifier {
  // final GetPendingAction _getPendingAction;
  // final SavePendingAction _savePendingAction;
  final AppState _appState;

  HomeViewModel({
    // required GetPendingAction getPendingAction,
    // required SavePendingAction savePendingAction,
    required AppState appState,
  }) : _appState = appState;

  final PersistentTabController controller =
      PersistentTabController(initialIndex: 0);

  ValueChanged<String>? errorMessages;
  late ScrollController scrollController;
  int? id;
  VoidCallback? toggleShowLoader;

  bool hasNewUnreadPosts = false;

  UserData get userDetail => GetIt.I.get<AccountProvider>().user;

  late TabController tabsController;
  ValueChanged<String>? successMessage;
  bool isLoading = true;
  bool isFetchingPostType = false;
  bool isFetchingLikeDislike = false;

  ValueNotifier<bool> isMapViewSelected = ValueNotifier(false);
  VoidCallback? updateController;

  int pageNo = 1;
  bool hasNextPage = true;
  bool isFirstLoadRunning = false;
  bool isLoadMoreRunning = false;

  double lat = 0.0;
  double long = 0.0;

  double englishAlign = -1;

  double arabicAlign = 1;

  Color whiteColor = kWhiteColor;

  Color normalColor = kPrimaryColor;

  String listViewWhiteSvg = SvgAssetsPaths.menuDotWhiteSvg;
  String listViewGreenSvg = SvgAssetsPaths.menuDotGreenSvg;
  String mapViewWhiteSvg = SvgAssetsPaths.mapWhiteSvg;
  String mapViewGreenSvg = SvgAssetsPaths.mapGreenSvg;

  late double xAlign;
  late Color unSelectedColor;
  late Color selectedColor;

  late String listSvg;
  late String mapSvg;

  bool showAppBar = true;
  bool _isScrollingDown = false;
  double _scrollOffset = 0.0;

  void handleScroll() {
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (!_isScrollingDown) {
        _isScrollingDown = true;
        showAppBar = false;
        notifyListeners();
      }
    }

    if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (_isScrollingDown) {
        _isScrollingDown = false;
        showAppBar = true;
        notifyListeners();
      }
    }

    _scrollOffset = scrollController.offset;
  }

  initSwitchValues() {
    xAlign = englishAlign;
    unSelectedColor = whiteColor;
    selectedColor = normalColor;
    listSvg = listViewWhiteSvg;
    mapSvg = mapViewGreenSvg;
  }

  void handleError(Either<Failure, dynamic> either) {
    isFetchingPostType = false;
    notifyListeners();
    either.fold((l) {
      l.checkAndTakeAction(onError: errorMessages);
    }, (r) => null);
  }

  Future<void> init() async {
    pageNo = 1;

    isFirstLoadRunning = true;

    hasNextPage = true;

    if (scrollController.hasClients) {
      scrollController.animateTo(0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn);
    }

    isFirstLoadRunning = false;
    isLoading = false;

    notifyListeners();
  }

  // void getPendingAction() {
  //   var getPendingActionResponse = _getPendingAction.call(NoParams());
  //   if (getPendingActionResponse.isLeft()) {
  //     return;
  //   }

  //   var pendingAction = getPendingActionResponse.getOrElse(() => '');

  //   if (pendingAction.isEmpty) {
  //     return;
  //   }

  //   PendingActionForwarder.movePendingAction(pendingAction);
  //   _savePendingAction.call('');
  // }

  moveToAllBusinessScreen() {
    _appState.currentAction =
        PageAction(state: PageState.addPage, page: AllBusinessesScreenConfig);
  }
}
