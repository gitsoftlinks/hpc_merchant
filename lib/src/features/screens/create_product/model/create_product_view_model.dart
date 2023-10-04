// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:geocoding/geocoding.dart';
import 'package:happiness_club_merchant/app/providers/account_provider.dart';
import 'package:happiness_club_merchant/src/features/screens/products_by_business/usecase/get_all_products.dart';
import 'package:happiness_club_merchant/src/features/screens/signin_screen/usecases/send_login.dart';
import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import 'package:happiness_club_merchant/utils/globals.dart';
import 'package:happiness_club_merchant/utils/permission/permission_service.dart';
import 'package:happiness_club_merchant/utils/router/app_state.dart';
import 'package:happiness_club_merchant/utils/router/models/page_action.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:images_picker/images_picker.dart';
import 'package:mime/mime.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../../../../app/app_theme/app_theme.dart';
import '../../../../../app/app_usecase/pick_multi_images_from_gallery.dart';
import '../../../../../app/custom_widgets/custom_snackbar.dart';
import '../../../../../services/error/failure.dart';
import '../../../../../utils/router/models/page_config.dart';
import '../../../../../utils/router/ui_pages.dart';
import '../../../home/model/home_view_model.dart';
import '../usecases/add_business_product.dart';
import '../../product_detail/usecases/get_product_detail.dart';
import '../usecases/delete_location_attachment.dart';
import '../usecases/delete_product_attachments.dart';
import '../usecases/get_business_locations.dart';

class CreateProductViewModel extends ChangeNotifier {
  final AppState _appState;
  final DeleteProductAttachments _deleteProductAttachments;
  final DeleteProductLocationAttachments _deleteProductLocationAttachments;
  final GetAllProducts _getAllProducts;
  final AddBusinessProduct _addBusinessProduct;
  final PickMultipleImagesFromGallery _pickImageFromGallery;
  final GetBusinessLocations _getBusinessLocations;
  CreateProductViewModel(
      {required AppState appState,
      required AddBusinessProduct addBusinessProduct,
      required GetAllProducts getAllProducts,
      required DeleteProductLocationAttachments
          deleteProductLocationAttachments,
      required DeleteProductAttachments deleteProductAttachments,
      required GetBusinessLocations getBusinessLocations,
      required PickMultipleImagesFromGallery pickImageFromGallery})
      : _appState = appState,
        _addBusinessProduct = addBusinessProduct,
        _deleteProductAttachments = deleteProductAttachments,
        _getAllProducts = getAllProducts,
        _deleteProductLocationAttachments = deleteProductLocationAttachments,
        _pickImageFromGallery = pickImageFromGallery,
        _getBusinessLocations = getBusinessLocations;
  ValueChanged<String>? errorMessages;
  ValueChanged<String>? successMessage;
  ValueNotifier<bool> isLoadingNotifier = ValueNotifier(false);
  ValueNotifier<bool> isLoadingNotifier2 = ValueNotifier(false);
  TextEditingController noteController = TextEditingController();
  Set<String> imageAssets = {};
  List<File> uploadableFiles = [];
  PickType selectedPhotoVideoType = PickType.all;
  PickType selectedCameraType = PickType.all;
  ValueNotifier<List<MediaResponse>> mediaFiles = ValueNotifier([]);
  ValueNotifier<List<MediaResponse>> cameraFiles = ValueNotifier([]);
  TextEditingController quantityController = TextEditingController();
  UserData get user => GetIt.I.get<AccountProvider>().user;
  final createProductsFormKey = GlobalKey<FormState>();
  List<BusinessLocation> businessLocations = [];
  int? categoryId;
  bool isQuantity = false;
  bool isLoading = true;
  bool isLoading2 = true;
  ProductLocation object = ProductLocation();
  ValueNotifier<BusinessLocation?> selectedLocation = ValueNotifier(null);
  TextEditingController titleController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  List<ProductLocation> objectList = [];
  List<ProductLocation> editList = [];
  List<BusinessProduct> products = [];
  bool isExit = false;
  String address = '';
  List<String> Locations = [];
  bool isEdit = false;
  List<File> editImages = [];
  int? productId;
  bool isProduct = false;
  bool permissionGranted = false;
  int? id;
  List<XFile> selectedImages = [];
  Future init(id, data) async {
    isLoading = true;
    notifyListeners();
    if (createProductsFormKey.currentState != null) {
      createProductsFormKey.currentState!.reset();
    }
    await clearData();
    businessLocations = await getBusinessLocations(id);

    await editProductData(data, id);

    notifyListeners();
  }

  moveBack() {
    _appState.moveToBackScreen();
  }

  moveBack2() {
    GetIt.I.get<HomeViewModel>().controller.index = 0;
    _appState.currentAction =
        PageAction(state: PageState.replaceAll, page: HomeScreenConfig);
  }

  void handleError(Either<Failure, dynamic> either) {
    isLoadingNotifier.value = false;
    notifyListeners();
    either.fold((l) {
      l.checkAndTakeAction(onError: errorMessages);
    }, (r) => null);
  }

  getBranchesAddressFromCoordinates(ProductDetail? data) async {
    var lat;
    var lng;
    Locations = [];
    for (var i = 0; i < data!.productLocations.length; i++) {
      lat = double.tryParse(data.productLocations[i]['lat']);
      lng = double.tryParse(data.productLocations[i]['lng']);
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks != null && placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        address =
            "${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.country}";
        Locations.add(address);
      }
    }

    notifyListeners();
  }

  Future<void> deleteAttachments(
      {required int attachmentId, required ProductDetail? data}) async {
    var params = DeleteProductAttachmentsParams(
        accessToken: '', attachmentId: attachmentId);
    var deleteEventEither = await _deleteProductAttachments.call(params);
    if (deleteEventEither.isLeft()) {
      handleError(deleteEventEither);
      return;
    }
    data!.productImages.removeWhere((element) => element.id == attachmentId);
    notifyListeners();
  }

  Future<void> deleteLocationAttachments(
      {required int attachmentId, required ProductDetail? data}) async {
    var params = DeleteProductLocationAttachmentsParams(
        accessToken: '', attachmentId: attachmentId);
    var deleteEventEither =
        await _deleteProductLocationAttachments.call(params);
    if (deleteEventEither.isLeft()) {
      handleError(deleteEventEither);
      return;
    }
    data!.productLocations
        .removeWhere((element) => element['id'] == attachmentId);
    notifyListeners();
  }

  void changeSelectedLocation(String newValue) async {
    if (selectedLocation.value != null &&
        selectedLocation.value!.cityName == newValue) {
      return;
    }
    selectedLocation.value = businessLocations
        .where((element) => element.cityName == newValue)
        .first;

    notifyListeners();
  }

  getBusinessLocations(id) async {
    var params = GetBusinessLocationParams(accessToken: '', businessId: id);
    var getCategoriesEither = await _getBusinessLocations.call(params);
    if (getCategoriesEither.isLeft()) {
      handleError(getCategoriesEither);
      return [];
    }

    var res = getCategoriesEither.toOption().toNullable()!.businessLocations;
    return res;
  }

  Future<List<XFile>?> getGalleryImages() async {
    await _getStoragePermission();
    if (permissionGranted) {
      ImagePicker imagePicker = ImagePicker();
      var assets = await imagePicker.pickMultiImage(imageQuality: 40);
      List<File> fileList = [];
      if (assets.isNotEmpty) {
        for (var i = 0; i < assets.length; i++) {
          var file = File(assets[i].path);
          fileList.add(file);
        }
        notifyListeners();
        uploadableFiles.addAll(fileList);
      }
      return assets;
    } else {
      await Permission.storage.request();
      showSnackBarMessage(
          context: navigatorKeyGlobal.currentContext!,
          content: "Please allow permission to continue",
          backgroundColor: kErrorColor);
      return null;
    }
  }

  Future<void> _getStoragePermission() async {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    AndroidDeviceInfo android = await plugin.androidInfo;
    if (android.version.sdkInt < 33) {
      if (await Permission.storage.request().isGranted) {
        permissionGranted = true;
        notifyListeners();
      } else if (await Permission.storage.request().isPermanentlyDenied) {
        await openAppSettings();
      } else if (await Permission.audio.request().isDenied) {
        await Permission.storage.request();
        permissionGranted = false;
        notifyListeners();
      }
    } else {
      if (await Permission.photos.request().isGranted) {
        permissionGranted = true;
        notifyListeners();
      } else if (await Permission.photos.request().isPermanentlyDenied) {
        await openAppSettings();
      } else if (await Permission.photos.request().isDenied) {
        await Permission.storage.request();
        permissionGranted = false;
        notifyListeners();
      }
    }
  }

  // Future<bool> pickImagesFromGallery() async {
  //   await _getStoragePermission();

  //   if (permissionGranted) {
  //     List<File> photoVideoFiles =
  //         List<File>.from(mediaFiles.value.map((e) => File(e.filePath)));

  //     List<File> camFiles =
  //         List<File>.from(cameraFiles.value.map((e) => File(e.filePath)));

  //     uploadableFiles = [...photoVideoFiles, ...camFiles];

  //     if (uploadableFiles.length > 10) {
  //       errorMessages?.call('maximum upload files count'.ntr());
  //       return false;
  //     }

  //     getGalleryImages();

  //     String? mimeStr = lookupMimeType(mediaFiles.value.last.filePath);

  //     var fileType = mimeStr!.split('/');

  //     selectedPhotoVideoType = fileType[0].toSelectedMediaTypeEnum();

  //     if (mediaFiles.value.isEmpty) {
  //       return false;
  //     }
  //   } else {
  //     showSnackBarMessage(
  //         context: navigatorKeyGlobal.currentContext!,
  //         content: 'permission denied',
  //         backgroundColor: kErrorColor);
  //   }

  //   return true;
  // }

  void removePhotoVideoFile(File value) {
    uploadableFiles.removeWhere((element) => element.path == value.path);
    if (mediaFiles.value.isEmpty) {
      selectedPhotoVideoType = PickType.all;
    }

    notifyListeners();
  }

  addingFileImage(String assets) {
    if (uploadableFiles.length > 10) {
      errorMessages?.call('maximum upload only 10 images'.ntr());
      return false;
    }
    mediaFiles.value
        .add(MediaResponse(filePath: assets, thumbPath: assets, size: 0));

    notifyListeners();
  }

  void removeCameraFile(MediaResponse value) {
    cameraFiles.value
        .removeWhere((element) => element.filePath == value.filePath);
    if (cameraFiles.value.isEmpty) {
      selectedCameraType = PickType.all;
    }

    notifyListeners();
  }

  void removeProductAt(int id) {
    // cartProvider.items.removeWhere((element) => element.id == id);

    // if (cartProvider.items.isEmpty) {
    //   Navigator.pop(navigatorKeyGlobal.currentState!.context);
    // }

    notifyListeners();
  }

  clearData() {
    titleController.clear();
    detailController.clear();
    priceController.clear();
    selectedLocation = ValueNotifier(null);
    quantityController.clear();
    categoryId = 0;
    object = ProductLocation();
    isQuantity = false;
    objectList = [];
    uploadableFiles = [];
    mediaFiles.value.clear();
    cameraFiles.value.clear();
    selectedPhotoVideoType = PickType.all;
    selectedCameraType = PickType.all;
    imageAssets.clear();

    isEdit = false;
    notifyListeners();
  }

  Future<bool> addNewProduct(businessId) async {
    var list = [];
    if (objectList.isEmpty) {
      Fluttertoast.showToast(msg: "Please add product location".ntr());
      return false;
    } else {
      for (var i = 0; i < objectList.length; i++) {
        var body;
        var quantity = int.tryParse(objectList[i].quantity);
        body = {
          "location_id": objectList[i].id,
          "lat": objectList[i].lat,
          "lng": objectList[i].lng,
          "city_name": objectList[i].city,
          "is_quantity_applicable": objectList[i].quantityApplicable,
          "branch_name": objectList[i].branchName,
          "quantity_count": quantity,
          "is_available": objectList[i].isAvailable
        };
        var data = jsonEncode(body);
        list.add(data);
      }
    }

    if (isExit) {
      isLoadingNotifier.value = true;
    } else {
      isLoadingNotifier2.value = true;
    }
    notifyListeners();

    var params = AddBusinessProductParams(
      accessToken: '',
      businessId: businessId!,
      price: priceController.text,
      productLocations: list,
      productImages: uploadableFiles,
      title: titleController.text,
      description: detailController.text,
    );

    dp("Create product ", params.toJson());

    var addProductEither = await _addBusinessProduct.call(params);
    if (addProductEither.isLeft()) {
      isLoadingNotifier.value = false;
      isLoadingNotifier2.value = false;
      handleError(addProductEither);
      return false;
    }

    isLoadingNotifier.value = false;
    isLoadingNotifier2.value = false;

    successMessage?.call('Product Created Successfully'.ntr());
    list = [];

    if (isExit == false) {
      _appState.moveToBackScreen();
    }

    isLoadingNotifier.value = false;

    notifyListeners();
    await getProducts(businessId);
    await clearData();
    isExit = false;
    notifyListeners();
    return true;
  }

  Future<bool> editProductPost(businessId, productId) async {
    isLoadingNotifier2.value = true;
    var list = [];
    if (objectList.isNotEmpty) {
      for (var i = 0; i < objectList.length; i++) {
        var body;
        var quantity = int.tryParse(objectList[i].quantity);
        body = {
          "location_id": objectList[i].id,
          "lat": objectList[i].lat,
          "lng": objectList[i].lng,
          "city_name": objectList[i].city,
          "is_quantity_applicable": objectList[i].quantityApplicable,
          "quantity_count": quantity,
          "branch_name": objectList[i].branchName,
          "is_available": objectList[i].isAvailable
        };
        var data = jsonEncode(body);
        list.add(data);
      }
    }

    if (uploadableFiles.length > 10) {
      errorMessages?.call('Can\'t upload more than 10 images'.ntr());
    }
    isLoadingNotifier2.value = true;

    notifyListeners();

    var params = EditProductParams(
      id: productId,
      price: priceController.text,
      productImages: uploadableFiles,
      productLocations: list,
      accessToken: '',
      businessId: businessId!,
      title: titleController.text,
      description: detailController.text,
    );

    dp("Product params edit", params);

    var addProductEither = await _addBusinessProduct.updateProduct(params);

    if (addProductEither.isLeft()) {
      handleError(addProductEither);
      return false;
    }

    isLoadingNotifier2.value = false;

    Navigator.of(navigatorKeyGlobal.currentState!.context).pop();

    await Future.delayed(const Duration(milliseconds: 50));

    navigatorKeyGlobal.currentState!.context;

    notifyListeners();

    await getProducts(businessId);

    successMessage?.call('product successfully updated'.ntr());

    await clearData();

    notifyListeners();
    return true;
  }

  onTapBusiness(id) {
    if (id != null) {
      _appState.currentAction = PageAction(
          state: PageState.replace,
          page: PageConfiguration.withArguments(
              BusinessDetailScreenConfig, {'businessId': id}));
    }
  }

  editProductData(ProductDetail? productData, businessId) async {
    if (productData != null) {
      notifyListeners();
      isEdit = true;

      titleController.text = productData.productTitle;

      businessId = productData.businessId;

      priceController.text = productData.productPrice;

      detailController.text = productData.productDetails;

      productId = productData.id;
      await getBranchesAddressFromCoordinates(productData);
      isLoading = false;
      notifyListeners();
    } else {
      clearData();
      isEdit = false;
      isLoading = false;

      notifyListeners();
    }
  }

  Future<void> getProducts(businessId) async {
    isLoading2 = true;
    notifyListeners();
    var params = GetAllProductsParams(accessToken: '', businessId: businessId!);
    var getProductsEither = await _getAllProducts.call(params);
    if (getProductsEither.isLeft()) {
      handleError(getProductsEither);
      return;
    }
    products = getProductsEither
        .toOption()
        .toNullable()!
        .businessProducts
        .reversed
        .toList();
    isLoading2 = false;
    notifyListeners();
    return;
  }

  void onTapProduct(int id, List<BusinessProduct> productList) {
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

class ProductLocation {
  int id;
  String lat;
  String lng;
  int quantityApplicable;
  String quantity;
  int isAvailable;
  String branchName;
  String city;
  int businessId;
  DateTime? createdAt;
  DateTime? updatedAt;
  ProductLocation(
      {this.id = 0,
      this.lat = '',
      this.lng = '',
      this.branchName = '',
      this.isAvailable = 0,
      this.city = '',
      this.quantity = '',
      this.businessId = 0,
      this.createdAt,
      this.updatedAt,
      this.quantityApplicable = 0});
}
