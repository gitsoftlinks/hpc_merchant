import 'package:camera/camera.dart';
import 'package:happiness_club_merchant/app/app_usecase/save_culture_usecase.dart';
import 'package:images_picker/images_picker.dart';
import '../../../app/app_usecase/get_culture_usecase.dart';
import '../../../app/app_usecase/get_image_from_camera.dart';
import '../../../app/app_usecase/locale_save.dart';
import '../../../app/app_usecase/otp_usecase/otp_requirements_save.dart';
import '../../../app/app_usecase/pick_multi_images_from_gallery.dart';
import '../../../app/models/get_app_info.dart';
import '../../../utils/constants/app_state_enum.dart';
import '../../usecases/usecase.dart';

abstract class LocalDataSource {
  ///This method will clear all the shared preferences
  ///[Output] : [bool] returns true on successful operation and false on failure
  Future<bool> clearSharePreferences();

  /// This method get the login token from local storage
  /// Output : [String] returns login token
  /// if unsuccessful the response will be [Failure]
  Future<String> getSavedAccessToken();

  /// This method saves the login token in local storage
  /// Input : [String] contains token
  /// Output : [bool] specifies whether the saving operation is successful or not
  Future<bool> saveAccessToken(String token);

  /// This method saves the user language in local storage
  /// Input: [language] user language
  /// Output : if operation successful returns true
  /// if unsuccessful the response will be [Failure]
  bool saveUserLanguage(String language);

  /// This method get the user language from local storage
  /// Output : [String] returns user language
  /// if unsuccessful the response will be [Failure]
  String getUserLanguage();

  /// This method retrieves the appstate from the secure storage
  /// [Output] : [AppStateEnum] which specifies state of the app
  Future<AppStateEnum> getAppState();

  /// This method saves the app state in the secure storage
  /// [Input] : [AppStateEnum] specifies the state of the app
  /// [Output] : [bool] specifies whether the saving operation is successful or not
  Future<bool> saveAppState(AppStateEnum appStateEnum);

  /// This method returns the info about the app
  /// [Output] : [AppInfo] info about the app
  Future<AppInfo> getAppInfo();

  /// This method checks if the user is using the app first time or not
  /// [Output] : [bool] this method returns true if using first time
  Future<bool> getIsFirstTimeUserUsingApp();

  /// This method clears the secure storage
  /// [Output] : [bool] specifies whether the saving operation is successful or not
  Future<bool> clearsSecureStorage();

  /// This method is used for getting the pending action
  /// Output : if operation successful returns [String] which contains the pending action
  /// if unsuccessful the response will be [Failure]
  String getPendingAction(NoParams params);

  /// This method is used for saving the Pending action
  /// Input: [pendingAction] the action to save in the local cache
  /// if unsuccessful the response will be [Failure]
  NoParams savePendingAction(String pendingAction);

  /// This method gives save user udid
  /// [Output] : [String] gives user udid
  Future<String> getUDID();

  /// This method generates new udid to the user
  /// [Output] : [String] gives user udid
  Future<String> generateUDID();

  /// This method gives user location
  /// [Output] : [String] gives user location iso
  Future<String> getUserCountryISO();

  /// This method get locale from local storage
  /// Output: [Map<String, dynamic>] contains the locale key and value
  /// Else throws error
  Future<Map<String, dynamic>> getLocale();

  /// This method will save locale to local storage
  /// Input: [params] contains the locale key and value
  /// Output: [bool] if successful return true else false
  /// Else throws error
  Future<bool> saveLocale(JsonProps params);

  /// This method deletes the auth token of the user from local storage
  /// Output : [bool] return whether operation performed successfully or not
  /// if unsuccessful the response will be [Failure]
  Future<bool> deleteAccessToken();

  /// This method returns path of the image selected by user
  /// [Output] : [List<MediaResponse>] specifies the path of the file
  Future<List<MediaResponse>> pickMultipleImagesFromGallery(PickType params);

  /// This method returns the image path taken from camera
  /// Input: [params] contains camera preference which is rear or front cameras.
  /// Output : if operation successful returns [String] tells image is taken successfully
  /// if unsuccessful the response will be [Failure]
  Future<List<MediaResponse>> getImageFromCamera(
      GetImageFromCameraParams params);

  /// This usecase will get otp required data from local storage
  /// Output: [OtpRequirementsData] contains userId and phoneNumber
  /// if unsuccessful the response will be [Failure]
  Future<OtpRequirementsData> otpRequirementsGet();

  /// This usecase will save otp required data in local storage
  /// Input: [params] contains userId and phoneNumber
  /// Output: [bool] will return true on success
  /// if unsuccessful the response will be [Failure]
  Future<bool> otpRequirementsSave(OtpRequirementsData params);

  /// This method will get selected language of the user from local storage.
  /// Output: [CultureGetResponse] contains culture and uiCulture
  /// if unsuccessful the response will be [Failure]
  Future<CultureGetResponse> cultureGet();

  /// This method will save the selected language of the user to localStorage.
  /// Input: [CultureSaveParams] contains culture and uiCulture
  /// Output: if operation successful returns [bool] tells user that language has been changed successfully.
  /// if unsuccessful the response will be [Failure]
  Future<bool> cultureSave(CultureSaveParams params);

  /// This usecase will get the avilable cameras of device
  /// Output: List<[CameraDescription]> contains the list of available camera
  Future<List<CameraDescription>> getAvailableCameras();

  /// This method returns path of the image selected by user
  /// [Output] : [String] specifies the path of the file
  Future<String> pickMultipleFilesFromGallery(NoParams params);

  /// This method returns the path of the image selected by the user
  /// Output : if operation successful returns [String] path of the user selected file
  /// if unsuccessful the response will be [Failure]
  Future<String> pickImageFromGallery(NoParams params);

  /// This method returns user contact list
  /// [Output] : [List<Contact>] returns user contact list
}
