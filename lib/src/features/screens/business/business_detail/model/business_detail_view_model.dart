// ignore_for_file: unused_field

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:geocoding/geocoding.dart';
import 'package:happiness_club_merchant/app/app_theme/app_theme.dart';
import 'package:happiness_club_merchant/app/app_usecase/pick_image_from_gallery.dart';
import 'package:happiness_club_merchant/app/custom_widgets/custom_snackbar.dart';
import 'package:happiness_club_merchant/app/providers/account_provider.dart';
import 'package:happiness_club_merchant/src/features/screens/business/business_detail/pdf_view_screen.dart';
import 'package:happiness_club_merchant/src/features/screens/business/business_detail/usecases/get_download_contract_url.dart';
import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import 'package:happiness_club_merchant/utils/globals.dart';
import 'package:happiness_club_merchant/utils/router/app_state.dart';
import 'package:happiness_club_merchant/utils/router/models/page_action.dart';
import 'package:happiness_club_merchant/utils/router/ui_pages.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../../../app/models/places_obj.dart';
import '../../../../../../services/error/failure.dart';
import '../../../../../../services/usecases/usecase.dart';
import '../../../../../../utils/router/models/page_config.dart';
import '../../../../home/model/home_view_model.dart';
import '../../create_business/usecases/get_business_categories.dart';
import '../../../create_product/usecases/add_business_product.dart';
import '../usecases/delete_business.dart';
import '../../../products_by_business/usecase/get_all_products.dart';
import '../usecases/get_business_detail.dart';
import '../../../offer_by_business/usecases/get_offers_by_business.dart';

class BusinessDetailViewModel extends ChangeNotifier {
  final GetBusinessContractDownload _getBusinessContractDownload;
  final GetBusinessDetail _getBusinessDetail;
  final AddBusinessProduct _addBusinessProduct;
  final PickImageFromGallery _pickImageFromGallery;
  final GetAllOffersByBusiness _allOffersByBusiness;
  final GetAllProducts _getAllProducts;
  final AppState _appState;
  final DeleteBusiness _deleteBusiness;
  final GetBusinessCategories _getBusinessCategories;

  int? productId = 0;

  int? languageId;

  BusinessDetailViewModel(
      {required GetBusinessDetail getBusinessDetail,
      required GetBusinessContractDownload getBusinessContractDownload,
      required AddBusinessProduct addBusinessProduct,
      required PickImageFromGallery pickImageFromGallery,
      required GetAllOffersByBusiness allOffersByBusiness,
      required GetAllProducts getAllProducts,
      required AppState appState,
      required DeleteBusiness deleteBusiness,
      required GetBusinessCategories getBusinessCategories})
      : _getBusinessDetail = getBusinessDetail,
        _addBusinessProduct = addBusinessProduct,
        _getBusinessContractDownload = getBusinessContractDownload,
        _pickImageFromGallery = pickImageFromGallery,
        _getAllProducts = getAllProducts,
        _allOffersByBusiness = allOffersByBusiness,
        _appState = appState,
        _deleteBusiness = deleteBusiness,
        _getBusinessCategories = getBusinessCategories;

  bool isLoading = true;
  bool isLoading2 = true;
  bool isOwnBusiness = false;

  bool isFetching = false;

  bool isProductImageRequired = false;
  bool isButtonEnabled = false;
  ValueChanged<String>? errorMessages;

  ValueChanged<String>? successMessage;

  BusinessDetail businessDetail = BusinessDetail.empty();

  List<ProductData> products = [];

  File? productImage;
  String? productImageUrl;

  ValueNotifier<bool> isLoadingNotifier = ValueNotifier(false);
  TextEditingController titleController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  TextEditingController offerPriceController = TextEditingController();
  TextEditingController sellingPriceController = TextEditingController();
  TextEditingController businessNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  AccountProvider get accountProvider => GetIt.I.get<AccountProvider>();
  List<String> branchesLocations = [];
  String address = '';
  String branchAddress = '';
  PlaceObject interestArea = PlaceObject.empty();
  VoidCallback? refreshState;
  bool isLogoImageRequired = false;
  bool isCoverImageRequired = false;
  File? logoImage;
  File? coverImage;
  final editBusinessFormKey = GlobalKey<FormState>();
  List<Offer> offersByBusiness = [];
  var businessIdNew;
  String downloadLinkUrl = '';


  void handleError(Either<Failure, dynamic> either) {
    isLoading = false;
    isLoadingNotifier.value = false;
    isFetching = false;
    notifyListeners();
    either.fold((l) {
      l.checkAndTakeAction(onError: errorMessages);
    }, (r) => null);
  }

  Future init(businessId) async {
    dp("Current business id", businessId);
    isLoading = true;
    notifyListeners();
    await getBusinessDetails(businessId: businessId);
    await getOfferByBusiness(businessId: businessId);
    await getBusinessContractDownloadUrl(businessId: businessId);
    await getAddressFromCoordinates();
    await getBranchesAddressFromCoordinates();
    await clearData();
    isLoading = false;
    notifyListeners();
  }

  moveBack2() {
    GetIt.I.get<HomeViewModel>().controller.index = 0;
    _appState.currentAction =
        PageAction(state: PageState.replace, page: HomeScreenConfig);
  }

  clearData() {
    isLoading = true;
    isButtonEnabled = false;
    isLoadingNotifier.value = false;
    isFetching = false;
    titleController.clear();
    detailController.clear();
    offerPriceController.clear();
    sellingPriceController.clear();
    productImage = null;
    branchesLocations = [];
    notifyListeners();
  }

  moveToCreateOffer() {
    _appState.currentAction =
        PageAction(state: PageState.addPage, page: CalenderScreenConfig);
  }

  Future<String> getAddressFromCoordinates() async {
    var lat;
    var lng;

    try {
      lat = double.tryParse(businessDetail.businessLat);
      lng = double.tryParse(businessDetail.businessLng);
      print('lat $lat , lng: $lng');
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks != null && placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        address =
            "${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.country}";
        return address;
      } else {
        return "No address found";
      }
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }



  getBranchesAddressFromCoordinates() async {
    var lat;
    var lng;
    branchesLocations = [];
    for (var i = 0; i < businessDetail.businessBranches.length; i++) {
      lat = double.tryParse(businessDetail.businessBranches[i].lat);
      lng = double.tryParse(businessDetail.businessBranches[i].lng);
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks != null && placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        branchAddress =
            "${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.country}";
        branchesLocations.add(branchAddress);
      }
    }

    notifyListeners();
  }

  void clearBottomSheet() {
    productImage = null;
    isFetching = false;
    titleController.clear();
    detailController.clear();
    offerPriceController.clear();
    sellingPriceController.clear();
  }

  /// This method check requirements for the api call
  bool validateTextFieldsNotEmpty() {
    if (titleController.text.isNotEmpty &&
        detailController.text.isNotEmpty &&
        offerPriceController.text.isNotEmpty) {
      isButtonEnabled = true;
      notifyListeners();
      refreshState?.call();
      return true;
    }
    isButtonEnabled = false;
    notifyListeners();
    refreshState?.call();
    return false;
  }

  Future<void> getBusinessDetails({required int businessId}) async {
    isLoading = true;
    notifyListeners();
    var params =
        GetBusinessDetailParams(accessToken: '', businessId: businessId);
    var getBusinessEither = await _getBusinessDetail.call(params);
    if (getBusinessEither.isLeft()) {
      handleError(getBusinessEither);
      return;
    }
    businessDetail = getBusinessEither.toOption().toNullable()!.businessData;
    isLoading = false;
    notifyListeners();
    return;
  }

  Future<void> getBusinessContractDownloadUrl({required int businessId}) async {
    isLoading2 = true;
    notifyListeners();
    var params = GetBusinessContractDownloadParams(
        accessToken: '', businessId: businessId);
    var getBusinessEither = await _getBusinessContractDownload.call(params);
    if (getBusinessEither.isLeft()) {
      handleError(getBusinessEither);
      return;
    }
    downloadLinkUrl = getBusinessEither.toOption().toNullable()!.path;
    print("url : $downloadLinkUrl");
    isLoading2 = false;
    notifyListeners();
    return;
  }

  Future<void> getOfferByBusiness({required int businessId}) async {
    isLoading2 = true;
    notifyListeners();
    var params =
        GetAllOffersByBusinessParams(accessToken: '', businessId: businessId);
    var getBusinessEither = await _allOffersByBusiness.call(params);
    if (getBusinessEither.isLeft()) {
      handleError(getBusinessEither);
      return;
    }
    offersByBusiness = getBusinessEither.toOption().toNullable()!.offers;
    isLoading2 = false;
    notifyListeners();
    return;
  }

  void getProductPicture() async {
    var imagePathEither = await _pickImageFromGallery(NoParams());
    if (imagePathEither.isLeft()) {
      handleError(imagePathEither);
      return;
    }
    final getImagePath = imagePathEither.getOrElse(() => '');
    if (getImagePath.isEmpty) {
      return;
    }
    productImage = File(getImagePath);
    isProductImageRequired = false;

    final mb = productImage!.path.calculateFileSize();

    if (mb > 10) {
      errorMessages?.call('size_greater_than_10_mb'.ntr());
      return;
    }
    refreshState?.call();
    notifyListeners();
  }

  void onTapProduct(int id, productList) {
    _appState.currentAction = PageAction(
        state: PageState.addPage,
        page: PageConfiguration.withArguments(ProductDetailScreenConfig, {
          'productId': id,
          'productList':
              productList.where((element) => element.id != id).toList()
        }));

    return;
  }

  void moveToProductDetailScreen() {
    _appState.currentAction =
        PageAction(state: PageState.addPage, page: ProductDetailScreenConfig);
  }

  void moveToCartScreen() {
    _appState.currentAction =
        PageAction(state: PageState.addPage, page: CartItemsScreenConfig);
  }

  void moveToCreateOfferScreen() {
    _appState.currentAction =
        PageAction(state: PageState.addPage, page: CartItemsScreenConfig);
  }

  moveBack() {
    GetIt.I.get<HomeViewModel>().controller.index = 0;
    _appState.currentAction =
        PageAction(state: PageState.replaceAll, page: HomeScreenConfig);
    notifyListeners();
  }
}
