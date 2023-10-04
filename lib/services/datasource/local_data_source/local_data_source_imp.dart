import 'dart:convert';
import 'package:camera_platform_interface/src/types/camera_description.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:images_picker/images_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:happiness_club_merchant/app/app_usecase/get_culture_usecase.dart';
import 'package:happiness_club_merchant/app/app_usecase/save_culture_usecase.dart';
import 'package:happiness_club_merchant/app/models/get_app_info.dart';
import 'package:happiness_club_merchant/services/third_party_plugins/locator/locator_service.dart';

import '../../../app/app_usecase/get_image_from_camera.dart';
import '../../../app/app_usecase/locale_save.dart';
import '../../../app/app_usecase/otp_usecase/otp_requirements_save.dart';
import '../../../app/app_usecase/pick_multi_images_from_gallery.dart';
import '../../../utils/constants/app_state_enum.dart';
import '../../../utils/constants/app_strings.dart';
import '../../third_party_plugins/cache_manager/cache_manager.dart';
import '../../third_party_plugins/local_image_picker/local_image_picker.dart';
import '../../third_party_plugins/udid_generator.dart';
import '../../usecases/usecase.dart';
import 'local_data_source.dart';

class LocalDataSourceImp implements LocalDataSource {
  final FlutterSecureStorage _flutterSecureStorage;
  // final SharedPreferences _sharedPreferences;
  final CacheManager _cacheManager;
  // final DynamicLinkHelper _dynamicLinkHelperImpl;
  final UDIDGenerator _udidGenerator;
  final LocatorService _locator;
  final LocalImagePicker _imagePickerHelper;

  LocalDataSourceImp({
    required FlutterSecureStorage flutterSecureStorage,
    required LocalImagePicker imagePicker,
    required CacheManager cacheManager,
    // required SharedPreferences sharedPreferences,
    // required DynamicLinkHelper dynamicLinkHelper,
    required UDIDGenerator udidGenerator,
    required LocatorService locator,
  })  : _flutterSecureStorage = flutterSecureStorage,
        _cacheManager = cacheManager,
        _imagePickerHelper = imagePicker,
        // _sharedPreferences = sharedPreferences,
        //   _dynamicLinkHelperImpl = dynamicLinkHelper,
        _udidGenerator = udidGenerator,
        _locator = locator;

  final String twoFactorAuthorization = '2FA';
  final String authTokenKey = 'auth-token';
  final String phoneNumber = 'phone_number';
  final String email = 'email';
  final String refereToken = 'refereToken';
  final String passcode = 'passcode';
  final String firstNameAndLastName = 'first_name_and_last_name';
  final String loginToken = 'login_token';
  final String passCodeToken = 'pass_code_token';
  final String authToken = 'auth_token';
  final String biometricStatus = 'biometric_status';
  final String userLanguage = 'user-language';
  final String countryCode = 'countryCode';
  final String dialingCode = 'dialingCode';
  final String appStatKey = 'appstate';
  final String pendingAction = 'saved_pending_action';
  final String udid = 'udid';
  final String appLocale = 'app_locale';
  final String accessToken = 'access_token';
  final String otpRequirements = 'otp_requirements';
  final String currentCulture = 'current_culture';

  @override
  Future<AppStateEnum> getAppState() async {
    var value = await _flutterSecureStorage.read(key: appStatKey);
    return handleNullAppStateFromStorage(value);
  }

  AppStateEnum handleNullAppStateFromStorage(String? value) {
    if (value == null) {
      return AppStateEnum.NONE;
    }
    return value.toAppStateEnum();
  }

  @override
  Future<bool> saveAppState(AppStateEnum appStateEnum) async {
    await _flutterSecureStorage.write(
        key: appStatKey, value: appStateEnum.toStringAppState());
    return true;
  }

  @override
  Future<String> getSavedAccessToken() async {
    var value = await _flutterSecureStorage.read(key: accessToken);

    if (value == null) {
      throw SOMETHING_WENT_WRONG;
    }

    // if (value.isTokenExpired()) {
    //   throw LoginTokenExpiredFailure('login_token_expired'.tr());
    // }

    return value;
  }

  @override
  Future<bool> saveAccessToken(String token) async {
    await _flutterSecureStorage.write(key: accessToken, value: token);
    return true;
  }

  @override
  String getUserLanguage() {
    var value = _cacheManager.getString(key: userLanguage);

    if (value.isEmpty) {
      throw SOMETHING_WENT_WRONG;
    }
    return value;
  }

  @override
  bool saveUserLanguage(String language) {
    _cacheManager.setString(key: userLanguage, value: language);
    return true;
  }

  @override
  Future<bool> clearsSecureStorage() async {
    await _flutterSecureStorage.deleteAll();
    return true;
  }

  @override
  Future<AppInfo> getAppInfo() async {
    var packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.getAppInfo();
  }

  @override
  Future<bool> getIsFirstTimeUserUsingApp() async {
    // var isfirstTimeUsing = _sharedPreferences.getBool(isFirstTimeUsing);
    var tokenExist = await _flutterSecureStorage.read(key: accessToken);

    if (tokenExist == null) {
      return false;
    }

    return true;
  }

  bool handleNullOnBoardingValue(String? value) {
    if (value == null) {
      return true;
    }
    return false;
  }

  @override
  Future<bool> clearSharePreferences() async {
    // await _sharedPreferences.clear();

    /// After logout user shouldn't see the onboarding screen
    // await _sharedPreferences.setBool(isFirstTimeUsing, false);

    return true;
  }

  @override
  String getPendingAction(NoParams params) {
    var pendingActionString = _cacheManager.getString(key: pendingAction);
    return pendingActionString;
  }

  @override
  NoParams savePendingAction(String pendingAction) {
    _cacheManager.setString(key: pendingAction, value: pendingAction);
    return NoParams();
  }

  @override
  Future<String> getUDID() async {
    var value = await _flutterSecureStorage.read(key: udid);
    return handleUDIDNull(value);
  }

  String handleUDIDNull(String? value) {
    if (value == null) {
      throw SOMETHING_WENT_WRONG;
    }
    return value;
  }

  @override
  Future<String> generateUDID() async {
    var udid = await _udidGenerator.getUDID();
    await savesUDID(udid);
    return udid;
  }

  Future<bool> savesUDID(String udid) async {
    await _flutterSecureStorage.write(key: udid, value: udid);
    return true;
  }

  @override
  Future<String> getUserCountryISO() async {
    var permissionGranted = await _locator.hasPermission();

    if (permissionNotGranted(permissionGranted)) {
      // throw PERMISSION_NOT_GIVEN;
      return '';
    }

    var isoCode = await _locator.getUserCountryLocationISOCode();

    return isoCode;
  }

  bool permissionNotGranted(bool permissionGranted) => !permissionGranted;

  @override
  Future<Map<String, dynamic>> getLocale() async {
    var getAppLocale = await _flutterSecureStorage.read(key: appLocale);
    if (getAppLocale == null || getAppLocale.isEmpty) {
      throw SOMETHING_WENT_WRONG;
    }
    return jsonDecode(getAppLocale);
  }

  @override
  Future<bool> saveLocale(JsonProps params) async {
    await _flutterSecureStorage.write(
        key: appLocale, value: jsonEncode(params));
    return true;
  }

  @override
  Future<bool> deleteAccessToken() async {
    if (await _flutterSecureStorage.containsKey(key: accessToken)) {
      await _flutterSecureStorage.delete(key: accessToken);
    }
    return true;
  }

  @override
  Future<List<MediaResponse>> pickMultipleImagesFromGallery(
      PickType params) async {
    var imagePath =
        await _imagePickerHelper.getMultipleImagesFromGallery(params);
    if (imagePath.isNotEmpty) {
      return imagePath;
    }
    throw SOMETHING_WENT_WRONG;
  }

  @override
  Future<List<MediaResponse>> getImageFromCamera(
      GetImageFromCameraParams params) async {
    return await _imagePickerHelper.getImageFromCamera(params);
  }

  @override
  Future<OtpRequirementsData> otpRequirementsGet() async {
    var otpRequirementsRes =
        await _flutterSecureStorage.read(key: otpRequirements);
    if (otpRequirementsRes == null || otpRequirementsRes.isEmpty) {
      throw SOMETHING_WENT_WRONG;
    }
    return OtpRequirementsData.fromJson(jsonDecode(otpRequirementsRes));
  }

  @override
  Future<bool> otpRequirementsSave(OtpRequirementsData params) async {
    await _flutterSecureStorage.write(
        key: otpRequirements, value: jsonEncode(params));
    return true;
  }

  @override
  Future<CultureGetResponse> cultureGet() async {
    var currentCultureRes =
        await _flutterSecureStorage.read(key: currentCulture);
    if (currentCultureRes == null || currentCultureRes.isEmpty) {
      throw SOMETHING_WENT_WRONG;
    }
    return CultureGetResponse.fromJson(jsonDecode(currentCultureRes));
  }

  @override
  Future<bool> cultureSave(CultureSaveParams params) async {
    await _flutterSecureStorage.write(
        key: currentCulture, value: jsonEncode(params));
    return true;
  }

  @override
  Future<List<CameraDescription>> getAvailableCameras() async {
    return await _imagePickerHelper.getAvailableCameras();
  }

  @override
  Future<String> pickMultipleFilesFromGallery(NoParams params) async {
    return await _imagePickerHelper.pickMultipleFilesFromGallery();
  }

  @override
  Future<String> pickImageFromGallery(NoParams params) async {
    var imagePath = await _imagePickerHelper.pickImage();
    if (imagePath.isNotEmpty) {
      return imagePath;
    }
    return '';
  }
}
