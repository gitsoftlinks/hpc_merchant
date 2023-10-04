import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import 'package:happiness_club_merchant/utils/router/app_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../../../app/models/places_obj.dart';
import '../../../../../app/providers/account_provider.dart';
import '../../../../../services/error/failure.dart';
import '../../../../../utils/router/models/page_action.dart';
import '../../../../../utils/router/models/page_config.dart';
import '../../../../../utils/router/ui_pages.dart';
import '../../offer_by_business/usecases/get_offers_by_business.dart';
import '../../signin_screen/usecases/send_login.dart';
import '../usecases/get_offer_detail.dart';

class OfferDetailViewModel extends ChangeNotifier {
  final GetOfferDetail _getOfferDetail;
  final AppState _appState;

  OfferDetailViewModel(
      {required GetOfferDetail getOfferDetail, required AppState appState})
      : _getOfferDetail = getOfferDetail,
        _appState = appState;

  bool isButtonEnabled = false;
  bool isEditScreen = false;
  ValueChanged<String>? errorMessages;
  PlaceObject interestArea = PlaceObject.empty();
  ValueNotifier<bool> isLoadingNotifier = ValueNotifier(false);
  TextEditingController startDateTimeController = TextEditingController();
  TextEditingController endDateTimeController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  final createEventFormKey = GlobalKey<FormState>();
  ValueChanged<String>? successMessage;
  OfferDetail offerDetail = OfferDetail.empty();
  List<Offer> list = [];
  int? offerId;
  bool isLoading = true;
  bool fromOffer = false;
  void handleError(Either<Failure, dynamic> either) {
    isLoadingNotifier.value = false;
    either.fold((l) {
      l.checkAndTakeAction(onError: errorMessages);
    }, (r) => null);
  }

  void init(id) async {
    isLoading = true;
    fromOffer = false;

    await gerOfferDetails(offerId: id);
    notifyListeners();
  }

  Future<void> gerOfferDetails({required int offerId}) async {
    isLoading = true;

    notifyListeners();
    var params = GetOfferDetailParams(accessToken: '', offerId: offerId);

    var getProductDetailEither = await _getOfferDetail.call(params);

    if (getProductDetailEither.isLeft()) {
      handleError(getProductDetailEither);
      return;
    }

    offerDetail = getProductDetailEither.toOption().toNullable()!.offerDetail;

    isLoading = false;

    notifyListeners();

    return;
  }

  void onTapProduct(int id, List<Products> productList) {
    fromOffer = true;
    _appState.currentAction = PageAction(
        state: PageState.addPage,
        page: PageConfiguration.withArguments(ProductDetailScreenConfig, {
          'productId': id,
          'productList':
              productList.where((element) => element.id != id).toList()
        }));
    return;
  }
}
