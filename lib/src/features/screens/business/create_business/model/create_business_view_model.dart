import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geocoding/geocoding.dart';
import 'package:happiness_club_merchant/app/app_theme/app_theme.dart';
import 'package:happiness_club_merchant/app/app_usecase/get_current_user_details.dart';
import 'package:happiness_club_merchant/app/custom_widgets/custom_snackbar.dart';
import 'package:happiness_club_merchant/app/models/select_location_view_model.dart';
import 'package:happiness_club_merchant/app/providers/account_provider.dart';
import 'package:happiness_club_merchant/src/features/screens/business/all_business/all_business_screen.dart';
import 'package:happiness_club_merchant/src/features/screens/business/all_business/model/get_all_businesses_view_model.dart';
import 'package:happiness_club_merchant/src/features/screens/business/create_business/widgets/confirm_trade_license_popup.dart';
import 'package:happiness_club_merchant/src/features/screens/business/create_business/usecases/get_contract_usecase.dart';
import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import 'package:happiness_club_merchant/utils/globals.dart';
import 'package:happiness_club_merchant/utils/router/models/page_action.dart';
import 'package:happiness_club_merchant/utils/router/models/page_config.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../../../app/app_usecase/pick_image_from_gallery.dart';
import '../../../../../../app/models/places_obj.dart';
import '../../../../../../services/error/failure.dart';
import '../../../../../../services/usecases/usecase.dart';
import '../../../../../../utils/router/app_state.dart';
import '../../../../home/model/home_view_model.dart';
import '../../../signin_screen/usecases/send_login.dart';
import '../../business_detail/usecases/get_business_detail.dart';
import '../usecases/create_new_business.dart';
import '../usecases/delete_branch_location.dart';
import '../usecases/get_business_categories.dart';
import 'package:flutter_html/flutter_html.dart';

class CreateBusinessViewModel extends ChangeNotifier {
  final CreateNewBusiness _createNewBusiness;
  final GetCurrentUserDetails _getCurrentUserDetails;
  final PickImageFromGallery _pickImageFromGallery;
  final AppState _appState;
  final GetBusinessCategories _getBusinessCategories;
  final DeleteBranchLocationAttachments _deleteBranchLocationAttachments;
  final GetBusinessContract _getBusinessContract;
  bool isEdit = false;

  CreateBusinessViewModel(
      {required CreateNewBusiness createNewBusiness,
      required PickImageFromGallery pickImageFromGallery,
      required AppState appState,
      required GetBusinessContract getBusinessContract,
      required DeleteBranchLocationAttachments deleteBranchLocationAttachments,
      required GetCurrentUserDetails getCurrentUserDetails,
      required GetBusinessCategories getBusinessCategories})
      : _createNewBusiness = createNewBusiness,
        _pickImageFromGallery = pickImageFromGallery,
        _appState = appState,
        _getBusinessContract = getBusinessContract,
        _deleteBranchLocationAttachments = deleteBranchLocationAttachments,
        _getCurrentUserDetails = getCurrentUserDetails,
        _getBusinessCategories = getBusinessCategories;

  bool isButtonEnabled = false;
  bool isLogoImageRequired = false;
  bool isCoverImageRequired = false;

  ValueNotifier<bool> isLoadingNotifier = ValueNotifier(false);
  ValueChanged<String>? errorMessages;
  TextEditingController businessNameController = TextEditingController();
  TextEditingController businessLegalNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController branchNameController = TextEditingController();
  TextEditingController tradeNumberController = TextEditingController();
  TextEditingController tradeExpiryDateController = TextEditingController();
  TextEditingController trnController = TextEditingController();
  TextEditingController branchController = TextEditingController();
  ValueNotifier<Category?> selectedCategory = ValueNotifier(null);
  ValueNotifier<List<Widget>> branchFields = ValueNotifier([]);
  List<TextEditingController> branchControllers = [];
  List<TextEditingController> editBranchControllers = [];
  List<TextEditingController> branchNameControllers = [];
  List<TextEditingController> editBranchNameControllers = [];
  UserData get userDetail => GetIt.I.get<AccountProvider>().user;
  List<Object> list = [];
  File? logoImage;
  File? coverImage;
  bool isLoading2 = false;
  File? businessCoverImage;
  bool isBranch = false;
  String? logoImageUrl;

  int? businessId;

  String? coverImageUrl;

  PlaceObject? placeObject;

  List<Category> businessCategories = [];
  String lat = '';
  String lng = '';

  late int categoryId;

  List<String> location = [];

  PlaceObject interestArea = PlaceObject.empty();
  BranchLocation branchLocation = BranchLocation();
  List<BranchLocation> branchLocationList = [];

  final createBusinessFormKey = GlobalKey<FormState>();
  String editLng = '';
  String editLat = '';
  String editCity = '';
  String editBranchName = '';
  String city = '';
  String? contractContent;
  bool isCanceled = false;
  Widget? data;
  CreateNewBusinessParams? createBusinessParams;
  FocusNode branchFocus = FocusNode();
  List<FocusNode> subBranchFocus = [];
  void handleError(Either<Failure, dynamic> either) {
    isLoadingNotifier.value = false;

    either.fold((l) {
      l.checkAndTakeAction(onError: errorMessages);
    }, (r) => null);
  }

  void init(businessData) async {
    isLoading2 = true;
    notifyListeners();
    clearData();

    businessCategories = await getBusinessCategory();

    await editData(businessData);
  }

  Future<void> getBusinessContract() async {
    if (logoImage == null) {
      showSnackBarMessage(
          context: navigatorKeyGlobal.currentState!.context,
          content: "Please select Business Logo",
          backgroundColor: kErrorColor);
      notifyListeners();
      return;
    }

    if (coverImage == null) {
      showSnackBarMessage(
          context: navigatorKeyGlobal.currentState!.context,
          content: "Please select Trade License",
          backgroundColor: kErrorColor);
      notifyListeners();
      return;
    }
    isLoadingNotifier.value = true;
    var params = GetBusinessContractParams(
        accessToken: '', businessLegalName: businessLegalNameController.text);
    var getBusinessEither = await _getBusinessContract.call(params);
    if (getBusinessEither.isLeft()) {
      handleError(getBusinessEither);
      return;
    }
    var text = getBusinessEither.toOption().toNullable()!.content;
    ;
    data = Html(
      shrinkWrap: true,
      data: text,
    );

    print("content : $data");
    final body = {
      "city_name": city,
      "lat": lat,
      "lng": lng,
      'branch_name': branchNameController.text
    };
    print("object $body");
    await getBranches();
    createBusinessParams = CreateNewBusinessParams(
      trn: trnController.text,
      licenseNumber: tradeNumberController.text,
      licenseExpiryDate: tradeExpiryDateController.text,
      logoImage: logoImage!,
      tradeLicense: coverImage!,
      businessDisplayName: businessNameController.text,
      accessToken: '',
      businessCategory: categoryId,
      businessLocation: jsonEncode(body),
      businessLegalName: businessLegalNameController.text,
      businessDescription: descriptionController.text,
      businessBranches: list,
    );
    print("Business Params : $createBusinessParams");
    isLoadingNotifier.value = false;
    notifyListeners();
    return;
  }

  editData(BusinessDetail? businessData) async {
    dp("Edit data call", businessData.toString());

    if (businessData != null) {
      isBranch = false;

      GetIt.I.get<SelectLocationViewModel>().interestArea.value = null;
      var latitude = double.tryParse(businessData.businessLat);
      var longitude = double.tryParse(businessData.businessLng);
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude!, longitude!);

      if (placemarks != null && placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        var address =
            "${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.country}";
        locationController.text = address ?? '';
      }
      isEdit = true;
      businessId = businessData.id;
      businessNameController.text = businessData.branchName ?? '';
      editCity = businessData.businessCity;
      editLat = businessData.businessLat;
      editLng = businessData.businessLng;
      descriptionController.text = businessData.businessDescription ?? '';
      businessLegalNameController.text = businessData.businessLegalName ?? '';

      logoImageUrl = businessData.businessLogoPath;
      editBranchName = businessData.businessDescription;
      coverImageUrl = businessData.tradeLicensePath;
      branchNameController.text = businessData.branchName;
      categoryId = businessData.businessCategory ?? 0;
      trnController.text = businessData.trn;
      tradeNumberController.text = businessData.licenseNumber;
      tradeExpiryDateController.text =
          DateFormat('yyyy-MM-dd').format(businessData.licenseExpiryDate);
      selectedCategory.value =
          businessCategories.where((element) => element.id == categoryId).first;
      businessId = businessData.id;

      var lat;
      var lng;
      location = [];
      for (var i = 0; i < businessData.businessBranches.length; i++) {
        lat = double.tryParse(businessData.businessBranches[i].lat);
        lng = double.tryParse(businessData.businessBranches[i].lng);
        List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
        if (placemarks != null && placemarks.isNotEmpty) {
          Placemark placemark = placemarks[0];
          var address =
              "${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.country}";
          editBranchControllers.add(TextEditingController(text: address));
          editBranchNameControllers.add(TextEditingController(
              text: businessData.businessBranches[i].branchName));
        }
      }
      branchLocationList = [];
      isLoading2 = false;
      notifyListeners();
    } else {
      clearData();
      isLoading2 = false;
      isEdit = false;
      notifyListeners();
    }
  }

  Future<void> deleteAttachments(
      {required int attachmentId, required BusinessDetail? data}) async {
    var params = DeleteBranchLocationAttachmentsParams(
        accessToken: '', attachmentId: attachmentId);
    var deleteEventEither = await _deleteBranchLocationAttachments.call(params);
    if (deleteEventEither.isLeft()) {
      handleError(deleteEventEither);
      return;
    }
    data!.businessBranches.removeWhere((element) => element.id == attachmentId);
    notifyListeners();
  }

  void addBranchField(
      {required field, required branch, required branchName, required focus}) {
    branchControllers.add(branch);
    branchNameControllers.add(branchName);
    branchFields.value.add(field);
    subBranchFocus.add(focus);
    notifyListeners();
  }

  void removeBranchField(
      {required field, required branch, required branchName}) {
    branchFields.value.remove(field);
    branchNameControllers.remove(branchName);
    branchControllers.remove(branch);
    print("object1 :   $branchControllers");
    notifyListeners();
  }

  void clearLicense() {
    coverImage = null;
    notifyListeners();
  }

  void clearData() {
    GetIt.I.get<SelectLocationViewModel>().interestArea.value = null;

    isButtonEnabled = false;

    isLoadingNotifier.value = false;

    businessNameController.clear();

    descriptionController.clear();

    locationController.clear();

    businessLegalNameController.clear();
    branchControllers = [];

    logoImage = null;

    coverImage = null;

    selectedCategory.value = null;

    coverImageUrl = null;

    logoImageUrl = null;
    branchLocationList = [];
    branchLocation = BranchLocation();
    lat = '';
    lng = '';
    branchFields = ValueNotifier([]);
    location = [];
    editBranchControllers = [];
    editBranchNameControllers = [];
    branchNameController.clear();
    branchNameControllers = [];
    trnController.clear();
    tradeNumberController.clear();
    tradeExpiryDateController.clear();
    notifyListeners();
  }

  bool validateTextFieldsNotEmptyForUpdate() {
    if (businessNameController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty) {
      isButtonEnabled = true;
      notifyListeners();

      return true;
    }

    isButtonEnabled = false;
    notifyListeners();
    return false;
  }

  /// This method check requirements for the api call
  bool validateTextFieldsNotEmpty() {
    if (businessNameController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty) {
      isButtonEnabled = true;
      notifyListeners();
      return true;
    }
    isButtonEnabled = false;
    notifyListeners();
    return false;
  }

  void changeSelectedCategory(String newValue) async {
    if (selectedCategory.value != null &&
        selectedCategory.value!.categoryName == newValue) {
      return;
    }
    selectedCategory.value = businessCategories
        .where((element) => element.categoryName == newValue)
        .first;

    notifyListeners();
  }

  void callSave(controller, nameController) async {
    var location = GetIt.I.get<SelectLocationViewModel>();
    interestArea = location.interestArea.value!;

    var object;
    if (isBranch) {
      object = BranchLocation(
          city: location.interestArea.value!.city,
          branchName: nameController.text,
          lat: location.interestArea.value!.latitude.toString(),
          lng: location.interestArea.value!.longitude.toString());
      branchLocationList.add(object);
      print('branch city : ${location.interestArea.value!.city} ');
      print("list $branchLocationList");
      controller.text = location.interestArea.value!.locationName;
    } else {
      locationController.text = location.interestArea.value!.locationName;
      lat = location.interestArea.value!.latitude.toString();
      lng = location.interestArea.value!.longitude.toString();
      city = location.interestArea.value!.city;
    }

    isBranch = false;
    interestArea = PlaceObject.empty();

    branchController.notifyListeners();
    locationController.notifyListeners();
  }

  void getProfilePicture() async {
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

    isLogoImageRequired = false;
    String dynamicImageType = getImagePath.split('.').last;
    final result = await FlutterImageCompress.compressAndGetFile(
      getImagePath,
      '$tempPath/${DateTime.now().millisecondsSinceEpoch}.$dynamicImageType',
      quality: 85,
    );

    if (result != null) {
      logoImage = File(result.path);
      print('Compressed image saved to: ${result.path}');
    } else {
      print('Compression failed.');
      showSnackBarMessage(
          context: navigatorKeyGlobal.currentContext!,
          content: 'Logo failed to upload',
          backgroundColor: kErrorColor);
    }

    final mb = logoImage!.path.calculateFileSize();
    final compress = result!.path.calculateFileSize();

    print(mb);
    print("compress path $compress");
    print(logoImage);
    notifyListeners();
  }

  void getCoverPicture(context) async {
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
      coverImage = File(result.path);
      print('Compressed image saved to: ${result.path}');
    } else {
      print('Compression failed.');
      showSnackBarMessage(
          context: navigatorKeyGlobal.currentContext!,
          content: 'Trade license failed to upload',
          backgroundColor: kErrorColor);
    }

    final mb = coverImage!.path.calculateFileSize();
    final compress = result!.path.calculateFileSize();

    print(mb);
    print("compress path $compress");
    print(coverImage);
    showConfirmTradeLicenseAlert(context, this);
    notifyListeners();
  }

  void getBusinessCoverPicture(id) async {
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
    print('image saved to: ${getImagePath}');
    String dynamicImageType = getImagePath.split('.').last;
    final result = await FlutterImageCompress.compressAndGetFile(
      getImagePath,
      '$tempPath/${DateTime.now().millisecondsSinceEpoch}.$dynamicImageType',
      quality: 85,
    );

    if (result != null) {
      businessCoverImage = File(result.path);
      print('Compressed image saved to: ${result.path}');
    } else {
      print('Compression failed.');
      showSnackBarMessage(
          context: navigatorKeyGlobal.currentContext!,
          content: 'Business banner failed to upload',
          backgroundColor: kErrorColor);
    }

    final mb = businessCoverImage!.path.calculateFileSize();
    final compress = result!.path.calculateFileSize();

    print(mb);
    print("compress path $compress");
    print(coverImage);

    isCoverImageRequired = false;

    if (businessCoverImage != null) {
      var params = UpdateNewBusinessCoverParams(
        businessId: id,
        businessCover: businessCoverImage!,
        accessToken: '',
      );

      var createBusinessEither =
          await _createNewBusiness.updateBusinessCover(params);

      if (createBusinessEither.isLeft()) {
        handleError(createBusinessEither);
        return;
      }

      isLoadingNotifier.value = false;
      showSnackBarMessage(
          context: navigatorKeyGlobal.currentState!.context,
          content: "Business cover updated successfully",
          backgroundColor: kSuccessColor);
      GetIt.I.get<HomeViewModel>().controller.index = 0;
      GetIt.I.get<AllBusinessesViewModel>().init();
      notifyListeners();
    } else {
      showSnackBarMessage(
          context: navigatorKeyGlobal.currentState!.context,
          content: "Please select image to update",
          backgroundColor: kErrorColor);
    }
    notifyListeners();
  }

  updateBusiness() async {
    if (validateTextFieldsNotEmpty()) {
      notifyListeners();
    }

    isLoadingNotifier.value = true;
    var data;
    if (editLat.isEmpty && editLng.isEmpty && editCity.isEmpty) {
      placeObject = GetIt.I.get<SelectLocationViewModel>().interestArea.value;
      lat = placeObject!.latitude.toString();

      lng = placeObject!.longitude.toString();
      var cityName = placeObject!.city;
      getBranches();
      data = {
        "city_name": cityName,
        "lat": lat,
        "lng": lng,
        "branch_name": branchNameController.text
      };
    } else {
      getBranches();
      data = {
        "city_name": editCity,
        "lat": editLat,
        "lng": editLng,
        "branch_name": editBranchName
      };
    }

    var params = UpdateBusiness(
      trn: trnController.text,
      licenseNumber: tradeNumberController.text,
      licenseExpiryDate: tradeExpiryDateController.text,
      id: businessId!,
      logoImage: logoImage,
      tradeLicense: coverImage,
      businessDisplayName: businessNameController.text,
      accessToken: '',
      businessCategory: categoryId,
      businessLocation: jsonEncode(data),
      businessLegalName: businessLegalNameController.text,
      businessDescription: descriptionController.text,
      businessBranches: list,
    );

    var createBusinessEither = await _createNewBusiness.updateBusiness(params);

    if (createBusinessEither.isLeft()) {
      handleError(createBusinessEither);
      return;
    }
    isEdit = false;
    _appState.moveToBackScreen();
    showSnackBarMessage(
        context: navigatorKeyGlobal.currentState!.context,
        content: "Business updated successfully",
        backgroundColor: kSuccessColor);
    isLoadingNotifier.value = false;

    notifyListeners();

    createBusinessFormKey.currentState?.reset();

    clearData();
  }

  getBranches() {
    for (var i = 0; i < branchLocationList.length; i++) {
      print(
          "Object$i = ${branchLocationList[i].lat} , ${branchLocationList[i].lng}");

      var body = {
        "city_name": branchLocationList[i].city,
        "lat": branchLocationList[i].lat,
        "lng": branchLocationList[i].lng,
        'branch_name': branchLocationList[i].branchName
      };
      var data = jsonEncode(body);
      list.add(data);
      print('body: $body');
    }
  }

  createNewBusiness({required CreateNewBusinessParams params}) async {
    var createBusinessEither = await _createNewBusiness.call(params);

    if (createBusinessEither.isLeft()) {
      handleError(createBusinessEither);
      return;
    }
    await getUserDetails();
    GetIt.I.get<HomeViewModel>().controller.index = 0;

    _appState.currentAction =
        PageAction(state: PageState.replaceAll, page: HomeScreenConfig);
    notifyListeners();

    // Navigator.pushReplacement(
    //     navigatorKeyGlobal.currentContext!,
    //     MaterialPageRoute(
    //         builder: (c) => AllBusinessesScreen(comingFromHome: true)));

    createBusinessFormKey.currentState?.reset();

    clearData();
  }

  getBusinessCategory() async {
    var getCategoriesEither = await _getBusinessCategories.call(NoParams());
    if (getCategoriesEither.isLeft()) {
      handleError(getCategoriesEither);
      return [];
    }

    var res = getCategoriesEither.toOption().toNullable()!.categories;
    return res;
  }

  Future<void> getUserDetails() async {
    isLoadingNotifier.value = true;
    notifyListeners();

    var userInfoEither = await _getCurrentUserDetails.call(NoParams());

    if (userInfoEither.isLeft()) {
      handleError(userInfoEither);
      return;
    }

    var user = userInfoEither.toOption().toNullable()!.user;
    GetIt.I.get<AccountProvider>().cacheRegisteredUserData(user);

    notifyListeners();
  }
  // Future<void> callSubCategories() async {
  //   subCategories =
  //       await getBusinessCategory(parentId: selectedCategory.value!.id);
  //   if (subCategories.isEmpty) {
  //     isButtonEnabled = true;
  //   } else if (subCategories.isNotEmpty) {
  //     isButtonEnabled = false;
  //   }
  //   notifyListeners();
  // }

  Future<bool> checkIfAlreadySelectedLocation() async {
    if (interestArea.latitude != 0 && interestArea.longitude != 0) {
      var locationModel = GetIt.I.get<SelectLocationViewModel>();
      locationModel.selectedLocationController.text = interestArea.locationName;
      locationModel.lat = interestArea.latitude;
      locationModel.long = interestArea.longitude;
      return true;
    }
    return false;
  }
}
