import 'package:happiness_club_merchant/app/providers/account_provider.dart';
import 'package:happiness_club_merchant/src/features/screens/create_offer/create_offer.dart';
import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import 'package:happiness_club_merchant/utils/router/models/page_action.dart';
import 'package:happiness_club_merchant/utils/router/models/page_config.dart';
import 'package:happiness_club_merchant/utils/router/ui_pages.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../../../../app/app_usecase/get_current_user_details.dart';
import '../../../../../../app/custom_widgets/custom_text_field.dart';
import '../../../../../../services/error/failure.dart';
import '../../../../../../services/usecases/usecase.dart';
import '../../../../../../utils/router/app_state.dart';
import '../../../signin_screen/usecases/send_login.dart';
import '../usecases/get_all_businesses.dart';

class AllBusinessesViewModel extends ChangeNotifier {
  final GetAllBusinesses _getAllBusinesses;
  final GetCurrentUserDetails _getCurrentUserDetails;
  final AppState _appState;

  AllBusinessesViewModel(
      {required GetAllBusinesses getAllBusinesses, required AppState appState,required  final GetCurrentUserDetails getCurrentUserDetails})
      : _getAllBusinesses = getAllBusinesses,
  _getCurrentUserDetails = getCurrentUserDetails,
        _appState = appState;

  bool isLoading = false;
  bool isFetchingNewData = false;
  ValueChanged<String>? errorMessages;
  List<Business> allBusinesses = [];
  UserData? accountProvider;
  int? hasBusiness = 0;
   UserData user = GetIt.I.get<AccountProvider>().user;
  void handleError(Either<Failure, dynamic> either) {
    isLoading = false;
    isFetchingNewData = false;
    notifyListeners();
    either.fold((l) {
      l.checkAndTakeAction(onError: errorMessages);
    }, (r) => null);
  }

  void init() async {
    isLoading = true;
    await getUserDetails();
    await getAllBusinesses();

    if (GetIt.I.get<AccountProvider>().user.hasBusiness == 0) {
      hasBusiness = 0;
      notifyListeners();
    } else {
      hasBusiness = 1;
      notifyListeners();
    }
    print('hasBusiness : $hasBusiness  ');
    isLoading = false;
    notifyListeners();
  }
  Future<void> getUserDetails() async {


    var userInfoEither = await _getCurrentUserDetails.call(NoParams());

    if (userInfoEither.isLeft()) {
      handleError(userInfoEither);
      return;
    }

     user = userInfoEither.toOption().toNullable()!.user;
    GetIt.I.get<AccountProvider>().cacheRegisteredUserData(user);

    notifyListeners();
  }
  Future<void> getAllBusinesses() async {
    var getBusinessesEither = await _getAllBusinesses.call(NoParams());
    if (getBusinessesEither.isLeft()) {
      handleError(getBusinessesEither);
      return;
    }
    allBusinesses = getBusinessesEither.fold(
        (l) => [], (r) => r.business.reversed.toList());

    // accountProvider.userBusinesses = allBusinesses;
    isLoading = false;
    isFetchingNewData = false;
    notifyListeners();

    return;
  }

   moveToCreateBusiness() {
    _appState.currentAction =
        PageAction(state: PageState.addPage, page: CreateBusinessScreenConfig);
  }

  void moveToBusinessDetail() {
    _appState.currentAction =
        PageAction(state: PageState.addPage, page: BusinessDetailScreenConfig);
  }

  void moveToEditBusiness() {
    _appState.currentAction =
        PageAction(state: PageState.addPage, page: CreateBusinessScreenConfig);
  }

  void moveToCreateProduct(Business business) {
    if (business.id != null) {
      _appState.currentAction = PageAction(
          state: PageState.addPage,
          page: PageConfiguration.withArguments(
              CartItemsScreenConfig, {'businessId': business.id}));
    }
  }

  moveToCreateOffer(Business business) {
    if (business.id != null) {
      _appState.currentAction = PageAction(
          state: PageState.addPage,
          page: PageConfiguration.withArguments(
              CalenderScreenConfig, {'businessId': business.id}));
    }
  }

  onTapBusiness(Business business) {
    if (business.id != null) {
      _appState.currentAction = PageAction(
          state: PageState.addPage,
          page: PageConfiguration.withArguments(
              BusinessDetailScreenConfig, {'businessId': business.id}));
    }
  }
}
