import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:happiness_club_merchant/services/usecases/usecase.dart';
import 'package:happiness_club_merchant/src/features/screens/create_offer/usecases/create_offer.dart';
import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../../app/app_theme/app_theme.dart';
import '../../../../../app/app_usecase/pick_image_from_gallery.dart';
import '../../../../../app/custom_widgets/custom_snackbar.dart';
import '../../../../../services/error/failure.dart';
import '../../../../../utils/globals.dart';
import '../../../../../utils/router/app_state.dart';
import '../../offer_detail_screen/usecases/get_offer_detail.dart';
import '../usecases/delete_product_offer.dart';
import '../usecases/edit_offer.dart';
import '../usecases/get_products_by_business.dart';

class CreateOfferViewModel extends ChangeNotifier {
  final AppState _appState;

  final DeleteProductOfferAttachments _deleteProductOfferAttachments;
  final CreateOfferResponse _createOfferResponse;
  final PickImageFromGallery _pickImageFromGallery;
  final EditProductOffer _editProductOffer;
  final GetProductsByBusiness _getProductsByBusiness;
  CreateOfferViewModel({
    required AppState appState,
    required EditProductOffer editProductOffer,
    required CreateOfferResponse createOfferResponse,
    required PickImageFromGallery pickImageFromGallery,
    required GetProductsByBusiness getProductsByBusiness,
    required DeleteProductOfferAttachments deleteProductOfferAttachments,
  })  : _appState = appState,
        _editProductOffer = editProductOffer,
        _deleteProductOfferAttachments = deleteProductOfferAttachments,
        _createOfferResponse = createOfferResponse,
        _pickImageFromGallery = pickImageFromGallery,
        _getProductsByBusiness = getProductsByBusiness;
  bool isEditScreen = false;
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;
  bool isLoading = true;
  ValueChanged<String>? errorMessages;
  ValueNotifier<ProductByBusiness?> selectedProduct = ValueNotifier(null);
  ValueChanged<String>? successMessage;
  List<ProductByBusiness> productsByBusiness = [];
  List<ProductByBusiness> productsByBusinessList = [];
  List<int> productIdList = [];
  int productId = 0;
  File? offerImage;
  bool isOfferImageRequired = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  ValueNotifier<bool> isLoadingNotifier = ValueNotifier(false);
  int? offerId;
  int? businessId;
  bool isLoading2 = false;
  final createOffersFormKey = GlobalKey<FormState>();
  bool isEdit = false;
  String coverOfferImgUrl = '';
  void handleError(Either<Failure, dynamic> either) {
    either.fold((l) {
      l.checkAndTakeAction(onError: errorMessages);
    }, (r) => null);
  }

  Future init(id, data) async {
    isLoading2 = true;
    notifyListeners();
    await clearData();
    productsByBusiness = await getProductsByBusiness(id);
    id = id;
    editOfferData(data);

    notifyListeners();
  }

  moveBack2() {
    Navigator.of(navigatorKeyGlobal.currentContext!).pop();
  }

  Future init2(id) async {
    await clearData();
    productsByBusiness = await getProductsByBusiness(id);
    notifyListeners();
  }

  Future<void> deleteAttachments(
      {required int attachmentId, required OfferDetail? data}) async {
    var params = DeleteProductOfferAttachmentsParams(
        accessToken: '', attachmentId: attachmentId);
    var deleteEventEither = await _deleteProductOfferAttachments.call(params);
    if (deleteEventEither.isLeft()) {
      handleError(deleteEventEither);
      return;
    }
    data!.offersProducts.removeWhere((element) => element.id == attachmentId);
    notifyListeners();
  }

  void getOfferPicture() async {
    final tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;
    var imagePathEither = await _pickImageFromGallery(NoParams());
    if (imagePathEither.isLeft()) {
      handleError(imagePathEither);
      return;
    }

    final getImagePath = imagePathEither.getOrElse(() => '');
    if (getImagePath.isEmpty) {
      return;
    }
    String dynamicImageType = getImagePath.split('.').last;
    final result = await FlutterImageCompress.compressAndGetFile(
      getImagePath,
      '$tempPath/${DateTime.now().millisecondsSinceEpoch}.$dynamicImageType',
      quality: 85,
    );

    if (result != null) {
      offerImage = File(result.path);
      print('Compressed image saved to: ${result.path}');
    } else {
      print('Compression failed.');
      showSnackBarMessage(
          context: navigatorKeyGlobal.currentContext!,
          content: 'Offer image failed to upload',
          backgroundColor: kErrorColor);
    }

    final mb = offerImage!.path.calculateFileSize();
    final compress = result!.path.calculateFileSize();

    print(mb);
    print("compress path $compress");
    print(offerImage);

    isOfferImageRequired = false;

    notifyListeners();
  }

  clearData() {
    nameController.clear();
    descriptionController.clear();
    discountController.clear();
    productIdList = [];
    productsByBusinessList = [];
    startDateController.clear();
    endDateController.clear();
    selectedProduct = ValueNotifier(null);
    offerImage = null;
    isEdit = false;
    notifyListeners();
  }

  getProductsByBusiness(id) async {
    var params = GetProductByBusinessParams(accessToken: '', businessId: id);
    var getCategoriesEither = await _getProductsByBusiness.call(params);
    if (getCategoriesEither.isLeft()) {
      handleError(getCategoriesEither);
      return [];
    }

    var res = getCategoriesEither.toOption().toNullable()!.productsByBusiness;
    return res;
  }

  void changeSelectedProducts(String newValue) async {
    if (selectedProduct.value != null &&
        selectedProduct.value!.productTitle == newValue) {
      return;
    }
    selectedProduct.value = productsByBusiness
        .where((element) => element.productTitle == newValue)
        .first;

    notifyListeners();
  }

  moveBack() {
    _appState.moveToBackScreen();
  }

  Future createOffer() async {
    isLoadingNotifier.value = true;
    notifyListeners();
    List<int> idList = [];
    for (var i = 0; i < productsByBusinessList.length; i++) {
      idList.add(productsByBusinessList[i].id);
    }

    String startDateString = startDateController.text;
    DateFormat format = DateFormat("yyyy-MM-dd");
    DateTime startTime = format.parse(startDateString);
    String endDateString = endDateController.text;
    DateFormat format2 = DateFormat("yyyy-MM-dd");
    DateTime endTime = format2.parse(endDateString);
    var params = CreateOfferParams(
        offerDescription: descriptionController.text,
        shortDescription: descriptionController.text,
        offerDiscount: discountController.text,
        offerTitle: nameController.text,
        accessToken: '',
        startDate: startTime,
        expiryDate: endTime,
        offerImagePath: offerImage!,
        productidList: idList);
    var editEventEither = await _createOfferResponse.call(params);
    if (editEventEither.isLeft()) {
      handleError(editEventEither);
      return;
    }
    _appState.moveToBackScreen();
    successMessage?.call('offer created successfully'.ntr());
    createOffersFormKey.currentState!.reset();
    clearData();
    isLoadingNotifier.value = false;

    notifyListeners();
  }

  Future updateOffer() async {
    isLoadingNotifier.value = true;
    notifyListeners();
    List<int> idList = [];
    for (var i = 0; i < productsByBusinessList.length; i++) {
      idList.add(productsByBusinessList[i].id);
    }

    String startDateString = startDateController.text;
    DateFormat format = DateFormat("yyyy-MM-dd");
    DateTime startTime = format.parse(startDateString);
    String endDateString = endDateController.text;
    DateFormat format2 = DateFormat("yyyy-MM-dd");
    DateTime endTime = format2.parse(endDateString);
    var params = EditsProductOfferParams(
        offerDescription: descriptionController.text,
        shortDescription: descriptionController.text,
        offerDiscount: discountController.text,
        offerTitle: nameController.text,
        accessToken: '',
        startDate: startTime,
        expiryDate: endTime,
        offerImagePath: offerImage,
        productidList: idList,
        id: offerId!);
    var editEventEither = await _editProductOffer.call(params);
    if (editEventEither.isLeft()) {
      handleError(editEventEither);
      return;
    }
    successMessage?.call('offer updated successfully'.ntr());
    Navigator.of(navigatorKeyGlobal.currentState!.context).pop();
    createOffersFormKey.currentState!.reset();
    await clearData();
    isLoadingNotifier.value = false;

    isEdit = false;
    notifyListeners();
  }

  editOfferData(OfferDetail? offerData) async {
    if (offerData != null) {
      isEdit = true;
      nameController.text = offerData.offerTitle;
      discountController.text = offerData.offerDiscount.toString();
      descriptionController.text = offerData.offerDescription;
      coverOfferImgUrl = offerData.offerImagePath;
      String formattedStartDate =
          DateFormat("yyyy-MM-dd ").format(offerData.startDate);
      String formattedEndDate =
          DateFormat("yyyy-MM-dd ").format(offerData.expiryDate);
      startDateController.text = formattedStartDate;
      endDateController.text = formattedEndDate;
      offerId = offerData.id;
      isLoading2 = false;
      notifyListeners();
    } else {
      clearData();

      isEdit = false;
      isLoading2 = false;
      notifyListeners();
    }
  }
}
