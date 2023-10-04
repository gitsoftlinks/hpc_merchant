import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../../../../services/error/failure.dart';
import '../../../../../utils/router/app_state.dart';
import '../../../../../utils/router/models/page_action.dart';
import '../../../../../utils/router/models/page_config.dart';
import '../../../../../utils/router/ui_pages.dart';
import '../usecases/get_offers_by_business.dart';

class OffersByBusinessViewModel extends ChangeNotifier {
  final GetAllOffersByBusiness _allOffersByBusiness;
  final AppState _appState;

  OffersByBusinessViewModel(
      {required GetAllOffersByBusiness getAllOffersByBusiness,
      required AppState appState})
      : _allOffersByBusiness = getAllOffersByBusiness,
        _appState = appState;

  bool isLoading = true;

  ValueChanged<String>? errorMessages;
  List<Offer> offersByBusiness = [];

  void handleError(Either<Failure, dynamic> either) {
    isLoading = false;
    notifyListeners();
    either.fold((l) {
      l.checkAndTakeAction(onError: errorMessages);
    }, (r) => null);
  }

  Future<void> getOfferByBusiness({required int businessId}) async {
    isLoading = true;
    notifyListeners();
    var params =
        GetAllOffersByBusinessParams(accessToken: '', businessId: businessId);
    var getBusinessEither = await _allOffersByBusiness.call(params);
    if (getBusinessEither.isLeft()) {
      handleError(getBusinessEither);
      return;
    }
    offersByBusiness = getBusinessEither.toOption().toNullable()!.offers;
    isLoading = false;
    notifyListeners();
    return;
  }

  moveToCreateOffer() {
    _appState.currentAction =
        PageAction(state: PageState.addPage, page: CalenderScreenConfig);
  }

  void onTapOffer(int id) {
    _appState.currentAction = PageAction(
        state: PageState.addPage,
        page: PageConfiguration.withArguments(CreateEventScreenConfig, {
          'id': id,
        }));

    return;
  }
}
