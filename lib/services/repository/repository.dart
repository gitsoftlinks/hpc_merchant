import 'package:happiness_club_merchant/src/features/screens/activate_account/usecases/activate_account_verify_otp.dart';
import 'package:happiness_club_merchant/src/features/screens/business/all_business/usecases/get_all_businesses.dart';
import 'package:happiness_club_merchant/src/features/screens/business/business_detail/usecases/get_download_contract_url.dart';
import 'package:happiness_club_merchant/src/features/screens/business/create_business/usecases/get_contract_usecase.dart';
import 'package:happiness_club_merchant/src/features/screens/create_product/usecases/add_business_product.dart';
import 'package:happiness_club_merchant/src/features/screens/business/business_detail/usecases/delete_business.dart';
import 'package:happiness_club_merchant/src/features/screens/products_by_business/usecase/get_all_products.dart';
import 'package:happiness_club_merchant/src/features/screens/business/business_detail/usecases/get_business_detail.dart';
import 'package:happiness_club_merchant/src/features/screens/business/create_business/usecases/create_new_business.dart';
import 'package:happiness_club_merchant/src/features/screens/business/create_business/usecases/get_business_categories.dart';
import 'package:happiness_club_merchant/src/features/screens/product_detail/usecases/delete_product.dart';
import 'package:happiness_club_merchant/src/features/screens/product_detail/usecases/get_product_detail.dart';
import 'package:happiness_club_merchant/src/features/screens/create_offer/usecases/get_products_by_business.dart';
import 'package:happiness_club_merchant/src/features/screens/offer_detail_screen/usecases/get_offer_detail.dart';
import 'package:happiness_club_merchant/src/features/screens/forget_password/usecases/forget_password_verify_otp.dart';
import 'package:happiness_club_merchant/src/features/screens/forget_password/usecases/send_reset_password.dart';
import 'package:happiness_club_merchant/src/features/screens/notifications/usecases/get_user_notifications.dart';
import 'package:happiness_club_merchant/src/features/screens/personal_info/usecases/update_personal_info.dart';
import 'package:happiness_club_merchant/src/features/screens/settings/usecases/send_settings.dart';
import 'package:happiness_club_merchant/src/features/screens/signin_screen/usecases/send_login.dart';
import 'package:happiness_club_merchant/src/features/screens/signup_screen/usecases/register_user.dart';
import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:happiness_club_merchant/app/app_usecase/get_culture_usecase.dart';
import 'package:happiness_club_merchant/app/app_usecase/save_culture_usecase.dart';
import 'package:happiness_club_merchant/src/features/splash_screen/usecases/get_customer_currency.dart';
import 'package:images_picker/images_picker.dart';
import '../../app/app_usecase/change_language_usecase.dart';
import '../../app/app_usecase/change_password/change_password_send.dart';
import '../../app/app_usecase/change_password/password_reset_send.dart';
import '../../app/app_usecase/change_password/password_reset_verify_otp.dart';
import '../../app/app_usecase/get_image_from_camera.dart';
import '../../app/app_usecase/google_map/google_map_latlang_details_get.dart';
import '../../app/app_usecase/google_map/google_map_place_details_get.dart';
import '../../app/app_usecase/google_map/google_map_place_get.dart';
import '../../app/app_usecase/locale_save.dart';
import '../../app/app_usecase/otp_usecase/otp_requirements_save.dart';
import '../../app/app_usecase/otp_usecase/signup_resend_otp.dart';
import '../../app/app_usecase/otp_usecase/signup_verify_otp.dart';
import '../../app/app_usecase/pick_multi_images_from_gallery.dart';
import '../../app/models/get_app_info.dart';
import '../../src/features/screens/offer_by_business/usecases/get_offers_by_business.dart';
import '../../src/features/screens/create_product/usecases/delete_location_attachment.dart';
import '../../src/features/screens/create_product/usecases/delete_product_attachments.dart';
import '../../src/features/screens/create_product/usecases/get_business_locations.dart';
import '../../src/features/screens/business/create_business/usecases/delete_branch_location.dart';
import '../../src/features/screens/create_offer/usecases/delete_product_offer.dart';
import '../../src/features/screens/create_offer/usecases/edit_offer.dart';
import '../../src/features/screens/create_offer/usecases/create_offer.dart';
import '../../utils/constants/app_state_enum.dart';
import '../dynamic_link_core_logic/usecases/verify_email.dart';
import '../error/failure.dart';
import '../usecases/usecase.dart';

abstract class Repository {
  /// This method changes the language of the app as selected by the user.
  /// Input: [changeLanguageParams] contains locale and login-token.
  /// Output: if operation successful returns [bool] tells user that language has been changed successfully.
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, bool>> switchCulture(
      SwitchCultureParams changeLanguageParams);

  /// This method saves the user language in local storage
  /// Input: [language] user language
  /// Output : if operation successful returns true
  /// if unsuccessful the response will be [Failure]
  Either<Failure, bool> saveUserLanguage(String language);

  /// This method get the user language from local storage
  /// Output : [String] returns user language
  /// if unsuccessful the response will be [Failure]
  Either<Failure, String> getUserLanguage();

  /// This method logs out the user from the happiness club merchant
  /// Output: if operation successful returns [bool] true
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, bool>> logout();

  /// This method will clear sharedpreferences local datasource
  /// Output : if operation successful returns [bool] tells whether the operation is successful or not
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, bool>> clearSharedPreferences();

  /// This method is used to get user app state
  /// Output: if successful the response will be [AppStateEnum]
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, AppStateEnum>> getAppState();

  /// This method gives link with which the app is opened
  /// Output : if operation successful returns [Uri] of the dynamic link
  /// else returns [DynamicLinkFailure]
  Future<Either<Failure, Uri>> getAppLinkWhichOpened();

  /// This method logout the user from the local auth
  /// Output : if operation successful returns [bool] tells whether the operation is successful or not
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, bool>> logoutUser();

  /// This method will check if internet connection is available or not
  /// output: [bool] if internet is available return true else false
  Future<Either<Failure, bool>> checkInternetConnection(NoParams params);

  /// This method cleans the secure storage of flutter
  /// Output : if operation successful returns [bool] shows whether the operation is successful or not
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, bool>> clearSecureStorage(NoParams noParams);

  /// This method returns true if the user is using app for the first time. This method should be only use for ios
  /// Output : if operation successful returns [bool] shows whether the app is used first time or not
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, bool>> getIsFirstTimeUsingApp(NoParams params);

  /// This method saves user appstate
  /// Input: [AppStateEnum] is the state of the app that we want to save
  /// Output : if operation successful returns true
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, bool>> saveUserAppState(AppStateEnum appState);

  /// This method returns Info of the app
  /// Output : if operation successful returns [AppInfo] which contains info regarding app
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, AppInfo>> getAppInfo();

  /// This method gives udid against
  /// Output : if operation successful returns [String] returns UDID for the user
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, String>> getUDID();

  /// This method returns the remote user account type
  /// Input: [String] is the accessToken of the user
  /// Output : [UserDetailResponse] contains the user details
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, UserDetailResponse>> getCurrentUserDetails();

  /// This method is used to get user location
  /// Output: if successful the response will be [String] which represents users iso code
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, String>> getUserCountryISO();

  /// This method verify Email
  /// Input: [VerifyEmailParams] contains the parameters for email verification
  /// Output : if operation successful returns true
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, bool>> verifyEmail(
      VerifyEmailParams verifyEmailParams);

  /// This method generates a new UDID and also saves it in the local storage
  /// Output : if operation successful returns [bool] shows success of failure of the operation
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, String>> generateUDID();

  /// This method returns the supported currencies from server
  /// Input: [CustomerCurrencyGetParams] contains the user's location country code and accessToken
  /// Output : [CustomerCurrencyGetResponse] contains the supported currency response
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, CustomerCurrencyGetResponse>> getCustomerCurrency(
      CustomerCurrencyGetParams params);

  /// This method get locale from local storage
  /// Input: [String] the name of locale to get e.g en or ar
  /// Output: [Map<String, dynamic>] contains the locale key and value
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, Map<String, dynamic>>> getLocale(String params);

  /// This method will save locale to local storage
  /// Input: [params] contains the locale key and value
  /// Output: [bool] if successful return true else false
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, bool>> saveLocale(JsonProps params);

  /// This method deletes the auth token of the user from local storage
  /// Output : [bool] return whether operation performed successfully or not
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, bool>> deleteAccessToken();

  /// This usecase will send password reset to server
  /// Input: [params] contains userId, resetToken and new password
  /// Output: [bool] return true if otp is send successfully to user's phoneNumber else false
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, bool>> changePasswordSend(
      ChangePasswordSendParams params);

  /// This usecase will send password reset to server
  /// Input: [params] contains user's phone number and region
  /// Output: [bool] return true if otp is send successfully to user's phoneNumber else false
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, bool>> passwordResetSend(
      PasswordResetSendParams params);

  /// This usecase will send password reset to server
  /// Input: [params] contains user's phone number, region and token
  /// Output: [PasswordResetVerifyOtpSendResponse] contains userId and resetToken
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, PasswordResetVerifyOtpSendResponse>>
      passwordResetVerifyOtpSend(PasswordResetVerifyOtpSendParams params);

  /// This usecase will send password reset to server
  /// Input: [params] contains userId and token
  /// Output: [bool] true if successful else false
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, bool>> signupVerifyOtpSend(
      SignupVerifyOtpSendParams params);

  /// This usecase will send password reset to server
  /// Input: [params] contains userId and phoneNumber
  /// Output: [bool] true if successful else false
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, bool>> signupResendOtpSend(
      SignupResendOtpSendParams params);

  /// This method returns the path of the image selected by the user
  /// Output : if operation successful returns [List<MediaResponse>] path of the user selected file
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, List<MediaResponse>>> pickMultipleImagesFromGallery(
      PickType params);

  /// This method returns the image path taken from camera
  /// Input: [params] contains camera preference which is rear or front cameras.
  /// Output : if operation successful returns [List<MediaResponse>] tells image is taken successfully
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, List<MediaResponse>>> getImageFromCamera(
      GetImageFromCameraParams params);

  /// This usecase will save otp required data in local storage
  /// Input: [params] contains userId and phoneNumber
  /// Output: [bool] will return true on success
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, bool>> otpRequirementsSave(OtpRequirementsData params);

  /// This method will save the selected language of the user to localStorage.
  /// Input: [params] contains culture and uiCulture
  /// Output: if operation successful returns [bool] tells user that language has been changed successfully.
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, bool>> cultureSave(CultureSaveParams params);

  /// This method will get selected language of the user from local storage.
  /// Output: [CultureGetResponse] contains culture and uiCulture
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, CultureGetResponse>> cultureGet();

  /// This use case will get place result from google place api depends on search querry
  /// Input: [String] contains query for a place
  /// Output: [params] contains the response from google place api
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, GoogleMapPlaceGetResponse>> googleMapPlaceGet(
      String params);

  /// This use case will get place result from google place api depends on place_id
  /// Input: [String] contains place_id
  /// Output: [GoogleMapPlaceDetailsGetResponse] contains the response from google place api
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, GoogleMapPlaceDetailsGetResponse>>
      googleMapPlaceDetailsGet(String params);

  /// This use case will get place result from google place api depends on latitude and longitude
  /// Input: [params] contains latlang
  /// Output: [GoogleMapLatLngDetailsGetResponse] contains the response from google place api
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, GoogleMapLatLngDetailsGetResponse>>
      googleMapLatLngDetailsGet(String params);

  /// This usecase will get the avilable cameras of device
  /// Output: List<[CameraDescription]> contains the list of available camera
  Future<Either<Failure, List<CameraDescription>>> getAvailableCameras();

  /// This method returns the path of the image selected by the user
  /// Output : if operation successful returns [String] path of the user selected file
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, String>> pickFileFromGallery(NoParams params);

  /// This usecase will get otp required data from local storage
  /// Output: [OtpRequirementsData] contains userId and phoneNumber
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, OtpRequirementsData>> otpRequirementsGet();

  /// This method will send login details
  /// Input: [params] contains email and password
  /// Output : [UserDetailResponse] contains user details and login token
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, UserDetailResponse>> sendLogin(SendLoginParams params);

  /// This method will save login token to local storage
  /// Input: [params] contains the login token
  /// Output: [bool] if successful return true else false
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, bool>> saveAccessToken(String params);

  /// This method will get login token from local storage
  /// Output: [String] contains the login token
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, String>> getSavedAccessToken();

  /// This method will register the user
  /// Input: [params] contains fullName, phone, email, interestArea and password
  /// Output : [UserRegistrationResponse] contains user details and login token
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, UserRegistrationResponse>> registerUser(
      RegisterUserParams params);

  /// This method will update user info
  /// Input: [params] contains accessToken and personal info
  /// Output : [bool] return true if response is successful
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, bool>> updatePersonalInfo(
      UpdatePersonalInfoParams params);

  /// This method returns the path of the image selected by the user
  /// Output : if operation successful returns [String] path of the user selected file
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, String>> pickImageFromGallery(NoParams params);

  /// This method will send otp to an email on forget password
  /// Input: [params] contains email address
  /// Output : [bool] returns true if operation is successful
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, bool>> sendForgetPasswordOtp(String params);

  /// This method will send otp and email to server for verification
  /// Input: [params] contains email, otp and password
  /// Output : [bool] returns true if operation is successful
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, bool>> sendForgetPasswordVerifyOtp(
      SendForgetPasswordVerifyOtpParams params);

  /// This method will send logout to server
  /// Output : [bool] returns true if operation is successful
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, bool>> sendLogout();

  /// This method will send email, password and confirm password to server for password change
  /// Input: [params] contains email, password and confirm password
  /// Output : [bool] returns true if operation is successful
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, bool>> sendResetPassword(
      SendResetPasswordParams params);

  /// This method will create new business
  /// Input: [params] contains accessToken and new business params
  /// Output : [bool] returns true if operation is successful
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, bool>> createNewBusiness(
      CreateNewBusinessParams params);

  /// This method will get all business categories
  /// Output : [GetBusinessCategoriesResponse] contains category response
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, GetBusinessCategoriesResponse>> getBusinessCategories(
      accessToken);

  /// This method will get all business locations
  /// Input: [params] contains accessToken and GetBusinessLocationParams
  /// Output : [GetBusinessCategoriesResponse] contains category response
  /// if unsuccessful the response will be [Failure]

  Future<Either<Failure, GetBusinessLocationsResponse>> getBusinessLocations(
      GetBusinessLocationParams params);

  /// This method will get all products by businesses of the user
  /// Input: [params] contains accessToken and businessId
  /// Output : [GetProductByBusinessResponse] contains Product response
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, GetProductByBusinessResponse>> getProductsByBusiness(
      GetProductByBusinessParams params);

  /// This method will get all businesses of the user
  /// Input: [NoParams] contains accessToken later on
  /// Output : [GetAllBusinessesResponse] contains Business response
  /// if unsuccessful the response will be [Failure]

  Future<Either<Failure, GetAllBusinessesResponse>> getAllBusinesses(
      NoParams params);

  /// This method will get businesses detail by business id from server
  /// Input: [params] contains accessToken and businessId
  /// Output : [GetBusinessDetailResponse] contains Business response
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, GetBusinessDetailResponse>> getBusinessDetail(
      GetBusinessDetailParams params);

  /// This method will add new product on server
  /// Input: [params] contains accessToken and businessId
  /// Output : [bool] return true if operation is successful
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, bool>> addBusinessProduct(
      AddBusinessProductParams params);

  /// This method will get product detail by productId from server
  /// Input: [params] contains accessToken and productId
  /// Output : [GetProductDetailResponse] contains product response
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, GetProductDetailResponse>> getProductDetail(
      GetProductDetailParams params);

  /// This method will get offer detail by offerId from server
  /// Input: [params] contains accessToken and offerId
  /// Output : [GetOfferDetailResponse] contains offer response
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, GetOfferDetailResponse>> getOfferDetail(
      GetOfferDetailParams params);

  /// This method will get all products related to business by businessId from server
  /// Input: [params] contains accessToken and businessId
  /// Output : [GetAllProductsResponse] contains Products response
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, GetAllProductsResponse>> getAllProducts(
      GetAllProductsParams params);

  /// This method will get all offers related to business by businessId from server
  /// Input: [params] contains accessToken and businessId
  /// Output : [GetAllOffersByBusinessParams] contains offers response
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, GetAllOffersByBusinessResponse>>
      getAllOffersByBusiness(GetAllOffersByBusinessParams params);

  /// This method will remove business on server
  /// Input: [params] contains accessToken and businessId
  /// Output : [bool] returns true if operation is successful
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, bool>> deleteBusiness(DeleteBusinessParams params);

  /// This method will remove product on server
  /// Input: [params] contains accessToken and productId
  /// Output : [bool] returns true if operation is successful
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, bool>> deleteProduct(DeleteProductParams params);

  /// This method will create  offer on server
  /// Input: [params] contains accessToken and create offer params
  /// Output : [bool] returns true if operation is successful
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, bool>> createOffer(CreateOfferParams params);

  /// This method will remove  branch Locations on server
  /// Input: [params] contains accessToken and attachmentId
  /// Output : [bool] returns true if operation is successful
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, bool>> deleteBranchLocationAttachments(
      DeleteBranchLocationAttachmentsParams params);

  /// This method will remove  product Images on server
  /// Input: [params] contains accessToken and attachmentId
  /// Output : [bool] returns true if operation is successful
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, bool>> deleteProductAttachments(
      DeleteProductAttachmentsParams params);

  /// This method will remove  product Locations on server
  /// Input: [params] contains accessToken and attachmentId
  /// Output : [bool] returns true if operation is successful
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, bool>> deleteProductLocationAttachments(
      DeleteProductLocationAttachmentsParams params);

  /// This method will remove  products from offer on server
  /// Input: [params] contains accessToken and attachmentId
  /// Output : [bool] returns true if operation is successful
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, bool>> deleteProductOfferAttachments(
      DeleteProductOfferAttachmentsParams params);

  /// This method will get all notifications of the user
  /// Input: [NoParams] contains accessToken later on
  /// Output : List[UserNotification] contains list of all notifications
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, List<UserNotification>>> getUserNotifications();

  /// This method will send read status on notification to server
  /// Input: [params] contains notificationId and accessToken
  /// Output : [bool] return true if successful else false
  /// if unsuccessful the response will be [Failure]
  // Future<Either<Failure, bool>> sendReadNotification(
  //     SendReadNotificationParams params);

  /// This method will send settings data to server
  /// Input: [params] contains email and password
  /// Output : [bool] return true if successful
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, bool>> sendSettings(SendSettingsParams params);

  /// This method will send otp to an email on activate account
  /// Input: [params] contains email address
  /// Output : [bool] returns true if operation is successful
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, bool>> sendActivateAccountOtp(String params);

  /// This method will send otp and email to server for verification
  /// Input: [params] contains email, otp and password
  /// Output : [bool] returns true if operation is successful
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, bool>> sendActivateAccountVerifyOtp(
      SendActivateAccountVerifyOtpParams params);

  /// This method will edit  business on server
  /// Input: [params] contains accessToken and UpdateNewBusinessCoverParams
  /// Output : [bool] returns true if operation is successful
  /// if unsuccessful the response will be [Failure]
  Future updateBusiness(UpdateBusiness params);

  /// This method will edit  business cover Image on server
  /// Input: [params] contains accessToken and cover image
  /// Output : [bool] returns true if operation is successful
  /// if unsuccessful the response will be [Failure]
  Future updateBusinessCover(UpdateNewBusinessCoverParams params);

  /// This method will edit  product on server
  /// Input: [offerParams] contains accessToken and EditProductParams
  /// Output : [bool] returns true if operation is successful
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, bool>> updateProduct(EditProductParams offerParams);

  /// This method will edit  offer on server
  /// Input: [offerParams] contains accessToken and EditsProductOfferParams
  /// Output : [bool] returns true if operation is successful
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, bool>> updateOffer(
      EditsProductOfferParams offerParams);

  /// This method will get business contract by business legal name from server
  /// Input: [params] contains accessToken and business legal name
  /// Output : [GetBusinessContractResponse] contains offer response
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, GetBusinessContractResponse>> getBusinessContract(
      GetBusinessContractParams params);

  /// This method will get business contract download link by business id from server
  /// Input: [params] contains accessToken and business id
  /// Output : [GetBusinessContractDownloadResponse] contains offer response
  /// if unsuccessful the response will be [Failure]
  Future<Either<Failure, GetBusinessContractDownloadResponse>>
      getBusinessContractDownload(GetBusinessContractDownloadParams params);
}
