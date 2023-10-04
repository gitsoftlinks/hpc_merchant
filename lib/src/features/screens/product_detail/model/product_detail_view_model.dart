import 'package:geocoding/geocoding.dart';
import 'package:happiness_club_merchant/app/providers/account_provider.dart';
import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import 'package:happiness_club_merchant/utils/router/app_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../../../app/app_usecase/firbase/generate_dynamic_link.dart';
import '../../../../../services/error/failure.dart';
import '../../../../../services/usecases/usecase.dart';
import '../../../../../utils/router/models/page_action.dart';
import '../../../../../utils/router/models/page_config.dart';
import '../../../../../utils/router/ui_pages.dart';
import '../../../home/model/home_view_model.dart';
import '../../offer_detail_screen/usecases/get_offer_detail.dart';
import '../../business/business_detail/model/business_detail_view_model.dart';
import '../../products_by_business/usecase/get_all_products.dart';
import '../usecases/delete_product.dart';
import '../usecases/get_product_detail.dart';

class ProductDetailViewModel extends ChangeNotifier {
  final GetProductDetail _getProductDetail;
  final AppState _appState;
  final DeleteProduct _deleteProduct;
  final GenerateDynamicLink _generateDynamicLink;

  List<BusinessProduct> productList = [];

  AccountProvider get accountProvider => GetIt.I.get<AccountProvider>();

  BusinessDetailViewModel get productViewModel =>
      GetIt.I.get<BusinessDetailViewModel>();

  ProductDetailViewModel({
    required GetProductDetail getProductDetail,
    required AppState appState,
    required DeleteProduct deleteProduct,
    required GenerateDynamicLink generateDynamicLink,
  })  : _getProductDetail = getProductDetail,
        _appState = appState,
        _generateDynamicLink = generateDynamicLink,
        _deleteProduct = deleteProduct;

  ValueChanged<String>? errorMessages;
  ValueChanged<String>? successMessage;
  late int productId;
  bool isNotInCart = true;
  ProductData productDetail = ProductData.empty();
  ValueNotifier<bool> isLoadingNotifier = ValueNotifier(false);
  ProductDetail postDetail = ProductDetail.empty();
  bool isLoading = true;
  List<String> productLocations = [];
  bool fromHome = false;
  List<Products> product = [];
  bool fromOffer = false;
  bool isProduct = false;
  void handleError(Either<Failure, dynamic> either) {
    isLoading = false;
    notifyListeners();
    either.fold((l) {
      l.checkAndTakeAction(onError: errorMessages);
    }, (r) => null);
  }

  init() async {
    isLoading = true;
    isNotInCart = true;
    fromHome = false;
    fromOffer = false;

    productLocations = [];

    await gerProductDetails(productId: productId);
    await getBranchesAddressFromCoordinates();
    notifyListeners();
  }

  Future<void> gerProductDetails({required int productId}) async {
    var params = GetProductDetailParams(accessToken: '', productId: productId);

    var getProductDetailEither = await _getProductDetail.call(params);

    if (getProductDetailEither.isLeft()) {
      handleError(getProductDetailEither);
      return;
    }

    postDetail = getProductDetailEither.toOption().toNullable()!.productDetail;

    isLoading = false;

    notifyListeners();

    return;
  }

  getBranchesAddressFromCoordinates() async {
    var lat;
    var lng;
    productLocations = [];
    for (var i = 0; i < postDetail.productLocations.length; i++) {
      print("product locations : ${postDetail.productLocations.length}");
      lat = double.tryParse(postDetail.productLocations[i]['lat']);
      lng = double.tryParse(postDetail.productLocations[i]['lng']);
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks != null && placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        var address =
            "${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.country}";
        productLocations.add(address);
      }
    }
    notifyListeners();
  }

  void moveToCartScreen() {
    _appState.currentAction =
        PageAction(state: PageState.replace, page: CartItemsScreenConfig);
  }

  void onTapEdit(int id, ProductDetail data) {
    _appState.currentAction = PageAction(
        state: PageState.addPage,
        page: PageConfiguration.withArguments(CartItemsScreenConfig, {
          'productId': id,
          'productList':
              productList.where((element) => element.id != id).toList()
        }));

    return;
  }

  onTapBusiness(business) {
    if (business.id != null) {
      _appState.currentAction = PageAction(
          state: PageState.addPage,
          page: PageConfiguration.withArguments(
              BusinessDetailScreenConfig, {'businessId': business.id}));
    }
  }

  moveBack() {
    GetIt.I.get<HomeViewModel>().controller.index = 0;
    _appState.currentAction =
        PageAction(state: PageState.replaceAll, page: HomeScreenConfig);
    notifyListeners();
  }
}
