import 'package:happiness_club_merchant/services/error/failure.dart';
import 'package:happiness_club_merchant/src/features/screens/activate_account/usecases/activate_account_verify_otp.dart';
import 'package:happiness_club_merchant/src/features/screens/business/business_detail/usecases/get_download_contract_url.dart';
import 'package:happiness_club_merchant/src/features/screens/business/create_business/usecases/get_contract_usecase.dart';
import 'package:happiness_club_merchant/src/features/screens/create_product/usecases/add_business_product.dart';
import 'package:happiness_club_merchant/src/features/screens/business/business_detail/usecases/delete_business.dart';
import 'package:happiness_club_merchant/src/features/screens/products_by_business/usecase/get_all_products.dart';
import 'package:happiness_club_merchant/src/features/screens/business/business_detail/usecases/get_business_detail.dart';
import 'package:happiness_club_merchant/src/features/screens/business/create_business/usecases/get_business_categories.dart';
import 'package:happiness_club_merchant/src/features/screens/product_detail/usecases/delete_product.dart';
import 'package:happiness_club_merchant/src/features/screens/product_detail/usecases/get_product_detail.dart';
import 'package:happiness_club_merchant/src/features/screens/offer_detail_screen/usecases/get_offer_detail.dart';
import 'package:happiness_club_merchant/src/features/screens/forget_password/usecases/forget_password_verify_otp.dart';
import 'package:happiness_club_merchant/src/features/screens/forget_password/usecases/send_reset_password.dart';
import 'package:happiness_club_merchant/src/features/screens/notifications/usecases/send_read_notification.dart';
import 'package:happiness_club_merchant/src/features/screens/personal_info/usecases/update_personal_info.dart';
import 'package:happiness_club_merchant/src/features/screens/settings/usecases/send_settings.dart';
import 'package:happiness_club_merchant/src/features/screens/signin_screen/usecases/send_login.dart';
import 'package:happiness_club_merchant/src/features/screens/signup_screen/usecases/register_user.dart';
import '../../../app/app_usecase/change_language_usecase.dart';
import '../../../app/app_usecase/change_password/change_password_send.dart';
import '../../../app/app_usecase/change_password/password_reset_send.dart';
import '../../../app/app_usecase/change_password/password_reset_verify_otp.dart';
import '../../../app/app_usecase/google_map/google_map_latlang_details_get.dart';
import '../../../app/app_usecase/google_map/google_map_place_details_get.dart';
import '../../../app/app_usecase/google_map/google_map_place_get.dart';
import '../../../app/app_usecase/otp_usecase/signup_resend_otp.dart';
import '../../../app/app_usecase/otp_usecase/signup_verify_otp.dart';
import '../../../src/features/screens/business/all_business/usecases/get_all_businesses.dart';
import '../../../src/features/screens/offer_by_business/usecases/get_offers_by_business.dart';
import '../../../src/features/screens/create_product/usecases/delete_location_attachment.dart';
import '../../../src/features/screens/create_product/usecases/delete_product_attachments.dart';
import '../../../src/features/screens/create_product/usecases/get_business_locations.dart';
import '../../../src/features/screens/business/create_business/usecases/create_new_business.dart';
import '../../../src/features/screens/business/create_business/usecases/delete_branch_location.dart';
import '../../../src/features/screens/create_offer/usecases/delete_product_offer.dart';
import '../../../src/features/screens/create_offer/usecases/edit_offer.dart';
import '../../../src/features/screens/create_offer/usecases/get_products_by_business.dart';
import '../../../src/features/screens/create_offer/usecases/create_offer.dart';
import '../../../src/features/screens/notifications/usecases/get_user_notifications.dart';
import '../../../src/features/splash_screen/usecases/get_customer_currency.dart';
import '../../usecases/usecase.dart';

abstract class RemoteDataSource {
  /// This method calls the user login
  /// Output : [void] returns null
  /// Else it will throw errors
  Future<void> userLogin(String noParams);

  /// This method logs out the user from the app
  /// Input: [params] contains login token
  /// Output: if operation successful returns [bool] true
  /// if unsuccessful the response will be [Failure]
  Future<bool> logout(String params);

  /// This method returns the supported currencies from server
  /// Input: [params] contains the user's location country code and accessToken
  /// Output : [CustomerCurrencyGetResponse] contains the supported currency response
  /// if unsuccessful the response will be [Failure]
  Future<CustomerCurrencyGetResponse> getSupportedCurrency(
      CustomerCurrencyGetParams params);

  /// This method calls the change language api
  /// Output : [bool] shows operation successful or not
  /// Else it will throw errors
  Future<bool> switchCulture(SwitchCultureParams params);

  /// This usecase will send password reset to server
  /// Input: [params] contains userId, resetToken and new password
  /// Output: [bool] return true if otp is send successfully to user's phoneNumber else false
  /// if unsuccessful the response will be [Failure]
  Future<bool> changePasswordSend(ChangePasswordSendParams params);

  /// This usecase will send password reset to server
  /// Input: [params] contains user's phone number, region and token
  /// Output: [PasswordResetVerifyOtpSendResponse] contains userId and resetToken
  /// if unsuccessful the response will be [Failure]
  Future<PasswordResetVerifyOtpSendResponse> passwordResetVerifyOtpSend(
      PasswordResetVerifyOtpSendParams params);

  /// This usecase will send password reset to server
  /// Input: [params] contains userId, resetToken and new password
  /// Output: [bool] return true if otp is send successfully to user's phoneNumber else false
  /// if unsuccessful the response will be [Failure]
  Future<bool> passwordResetSend(PasswordResetSendParams params);

  /// This usecase will send password reset to server
  /// Input: [SignupVerifyOtpSendParams] contains userId and token
  /// Output: [bool] true if successful else false
  /// if unsuccessful the response will be [Failure]
  Future<bool> signupVerifyOtpSend(SignupVerifyOtpSendParams params);

  /// This usecase will send password reset to server
  /// Input: [params] contains userId and phoneNumber
  /// Output: [bool] true if successful else false
  /// if unsuccessful the response will be [Failure]
  Future<bool> signupResendOtpSend(SignupResendOtpSendParams params);

  /// This use case will get place result from google place api depends on search querry
  /// Input: [String] contains query for a place
  /// Output: [params] contains the response from google place api
  /// if unsuccessful the response will be [Failure]
  Future<GoogleMapPlaceGetResponse> googleMapPlaceGet(String params);

  /// This use case will get place result from google place api depends on place_id
  /// Input: [params] contains place_id
  /// Output: [GoogleMapPlaceDetailsGetResponse] contains the response from google place api
  /// if unsuccessful the response will be [Failure]
  Future<GoogleMapPlaceDetailsGetResponse> googleMapPlaceDetailsGet(
      String params);

  /// This use case will get place result from google place api depends on latitude and longitude
  /// Input: [params] contains latlang
  /// Output: [GoogleMapLatLngDetailsGetResponse] contains the response from google place api
  /// if unsuccessful the response will be [Failure]
  Future<GoogleMapLatLngDetailsGetResponse> googleMapLatLngDetailsGet(
      String params);

  /// This method will send login details
  /// Input: [params] contains email and password
  /// Output : [UserDetailResponse] contains user details and login token
  /// if unsuccessful the response will be [Failure]
  Future<UserDetailResponse> sendLogin(SendLoginParams params);

  Future<String> testLoginLogin(String params);

  /// This method returns the remote user account type
  /// Input: [String] is the access token of the user
  /// Output : [UserData] contains user details
  /// if unsuccessful the response will be [Failure]
  Future<UserDetailResponse> getCurrentUserDetails(String accessToken);

  /// This method will register the user
  /// Input: [params] contains fullName, phone, email, interestArea and password
  /// Output : [UserRegistrationResponse] contains user details and login token
  /// if unsuccessful the response will be [Failure]
  Future<UserRegistrationResponse> registerUser(RegisterUserParams params);

  /// This method will update user info
  /// Input: [params] contains accessToken and personal info
  /// Output : [bool] return true if response is successful
  /// if unsuccessful the response will be [Failure]
  Future<bool> updatePersonalInfo(UpdatePersonalInfoParams params);

  /// This method will send otp to an email on forget password
  /// Input: [params] contains email address
  /// Output : [bool] returns true if operation is successful
  /// if unsuccessful the response will be [Failure]
  Future<bool> sendForgetPasswordOtp(String params);

  /// This method will send otp and email to server for verification
  /// Input: [params] contains email, otp and password
  /// Output : [bool] returns true if operation is successful
  /// if unsuccessful the response will be [Failure]
  Future<bool> sendForgetPasswordVerifyOtp(
      SendForgetPasswordVerifyOtpParams params);

  /// This method will send logout to server
  /// Output : [bool] returns true if operation is successful
  /// if unsuccessful the response will be [Failure]
  Future<bool> sendLogout(String accessToken);

  /// This method will send email, password and confirm password to server for password change
  /// Input: [params] contains email, password and confirm password
  /// Output : [bool] returns true if operation is successful
  /// if unsuccessful the response will be [Failure]
  Future<bool> sendResetPassword(SendResetPasswordParams params);

  /// This method will create new business
  /// Input: [params] contains accessToken and new business params
  /// Output : [bool] returns true if operation is successful
  /// if unsuccessful the response will be [Failure]
  Future<bool> createNewBusiness(CreateNewBusinessParams params);

  /// This method will get all business categories
  /// Output : [GetBusinessCategoriesResponse] contains category response
  /// if unsuccessful the response will be [Failure]
  Future<GetBusinessCategoriesResponse> getBusinessCategories(accessToken);

  /// This method will get all products bu businesses of the user
  /// Input: [params] contains GetProductByBusinessParams
  /// Output : [GetAllBusinessesResponse] contains Business response
  /// if unsuccessful the response will be [Failure]
  Future<GetProductByBusinessResponse> getProductsByBusiness(
      GetProductByBusinessParams params);

  /// This method will get all businesses of the user
  /// Output : [GetAllBusinessesResponse] contains Business response
  /// if unsuccessful the response will be [Failure]
  Future<GetAllBusinessesResponse> getAllBusinesses(String accessToken);

  /// This method will get businesses Locations from server
  /// Input: [params] GetBusinessLocationParams
  /// Output : [GetBusinessLocationsResponse] contains Business response
  /// if unsuccessful the response will be [Failure]

  Future<GetBusinessLocationsResponse> getBusinessLocations(
      GetBusinessLocationParams params);

  /// This method will get businesses detail by business id from server
  /// Input: [params] contains accessToken and businessId
  /// Output : [GetBusinessDetailResponse] contains Business response
  /// if unsuccessful the response will be [Failure]
  Future<GetBusinessDetailResponse> getBusinessDetail(
      GetBusinessDetailParams params);

  /// This method will add new product on server
  /// Input: [params] contains accessToken and businessId
  /// Output : [bool] return true if operation is successful
  /// if unsuccessful the response will be [Failure]
  Future<bool> addBusinessProduct(AddBusinessProductParams params);

  /// This method will get all products related to business by businessId from server
  /// Input: [params] contains accessToken and businessId
  /// Output : [GetAllProductsResponse] contains Business response
  /// if unsuccessful the response will be [Failure]
  Future<GetAllProductsResponse> getAllProducts(GetAllProductsParams params);

  /// This method will get all offers related to business by businessId from server
  /// Input: [params] contains accessToken and businessId
  /// Output : [GetAllOffersByBusinessResponse] contains Offer response
  /// if unsuccessful the response will be [Failure]
  Future<GetAllOffersByBusinessResponse> getOffersByBusiness(
      GetAllOffersByBusinessParams params);

  /// This method will get product detail by productId from server
  /// Input: [params] contains accessToken and productId
  /// Output : [GetProductDetailResponse] contains Product response
  /// if unsuccessful the response will be [Failure]
  Future<GetProductDetailResponse> getProductDetail(
      GetProductDetailParams params);

  /// This method will get offer detail by offerId from server
  /// Input: [params] contains accessToken and offerId
  /// Output : [GetOfferDetailResponse] contains Offer response
  /// if unsuccessful the response will be [Failure]
  Future<GetOfferDetailResponse> getOfferDetail(GetOfferDetailParams params);

  /// This method will remove business  to server
  /// Input: [params] contains accessToken and businessId
  /// Output : [bool] return true if operation is successful
  /// if unsuccessful the response will be [Failure]

  Future<bool> deleteBusiness(DeleteBusinessParams params);

  /// This method will remove product on server
  /// Input: [params] contains accessToken and productId
  /// Output : [bool] returns true if operation is successful
  /// if unsuccessful the response will be [Failure]
  Future<bool> deleteProduct(DeleteProductParams params);

  /// This method will create offer on server
  /// Input: [params] contains accessToken and new offer params
  /// Output : [bool] returns true if operation is successful
  /// if unsuccessful the response will be [Failure]
  Future<bool> createOffer(CreateOfferParams params);

  /// This method will remove business branch locations on server
  /// Input: [params] contains accessToken and attachmentId
  /// Output : [bool] returns true if operation is successful
  /// if unsuccessful the response will be [Failure]
  Future<bool> deleteBranchLocation(
      DeleteBranchLocationAttachmentsParams params);

  /// This method will remove product Images on server
  /// Input: [params] contains accessToken and attachmentId
  /// Output : [bool] returns true if operation is successful
  /// if unsuccessful the response will be [Failure]
  Future<bool> deleteProductAttachments(DeleteProductAttachmentsParams params);

  /// This method will remove product locations on server
  /// Input: [params] contains accessToken and attachmentId
  /// Output : [bool] returns true if operation is successful
  /// if unsuccessful the response will be [Failure]
  Future<bool> deleteProductLocationAttachments(
      DeleteProductLocationAttachmentsParams params);

  /// This method will remove products  in offer on server
  /// Input: [params] contains accessToken and attachmentId
  /// Output : [bool] returns true if operation is successful
  /// if unsuccessful the response will be [Failure]
  Future<bool> deleteProductOfferAttachments(
      DeleteProductOfferAttachmentsParams params);

  /// This method will get all notifications of the user
  /// Input: [NoParams] contains accessToken later on
  /// Output : List[UserNotification] contains list of all notifications
  /// if unsuccessful the response will be [Failure]
  Future<List<UserNotification>> getUserNotifications(String accessToken);

  /// This method will send read status on notification to server
  /// Input: [params] contains notificationId and accessToken
  /// Output : [bool] return true if successful else false
  /// if unsuccessful the response will be [Failure]
  Future<bool> sendReadNotification(SendReadNotificationParams params);

  /// This method will send settings data to server
  /// Input: [params] contains email and password
  /// Output : [bool] return true if successful
  /// if unsuccessful the response will be [Failure]
  Future<bool> sendSettings(SendSettingsParams params);

  /// This method will send otp to an email on activate account
  /// Input: [params] contains email address
  /// Output : [bool] returns true if operation is successful
  /// if unsuccessful the response will be [Failure]
  Future<bool> sendActivateAccountOtp(String params);

  /// This method will send otp and email to server for verification
  /// Input: [params] contains email, otp and password
  /// Output : [bool] returns true if operation is successful
  /// if unsuccessful the response will be [Failure]
  Future<bool> sendActivateAccountVerifyOtp(
      SendActivateAccountVerifyOtpParams params);

  /// This method will edit business   on server
  /// Input: [params] contains accessToken and edit business params
  /// Output : [bool] returns true if operation is successful
  /// if unsuccessful the response will be [Failure]
  Future<bool> updateBusiness(UpdateBusiness paramsWithAccessToken);

  /// This method will edit business cover image  on server
  /// Input: [params] contains accessToken and  business cover image
  /// Output : [bool] returns true if operation is successful
  /// if unsuccessful the response will be [Failure]
  Future<bool> updateBusinessCover(
      UpdateNewBusinessCoverParams paramsWithAccessToken);

  /// This method will edit product   on server
  /// Input: [params] contains accessToken and edit product params
  /// Output : [bool] returns true if operation is successful
  /// if unsuccessful the response will be [Failure]
  Future<bool> updateProduct(EditProductParams productParams);

  /// This method will edit offer   on server
  /// Input: [params] contains accessToken and edit offer params
  /// Output : [bool] returns true if operation is successful
  /// if unsuccessful the response will be [Failure]
  Future<bool> updateOffer(EditsProductOfferParams offerParams);

  /// This method will get businesses contract by business legal Name from server
  /// Input: [params] contains accessToken and business Legal Name
  /// Output : [GetBusinessContractResponse] contains Business response
  /// if unsuccessful the response will be [Failure]
  Future<GetBusinessContractResponse> getBusinessContract(
      GetBusinessContractParams params);

  /// This method will get businesses contract download link by business id from server
  /// Input: [params] contains accessToken and businessId
  /// Output : [GetBusinessContractDownloadResponse] contains Business response
  /// if unsuccessful the response will be [Failure]
  Future<GetBusinessContractDownloadResponse> getBusinessContractDownload(
      GetBusinessContractDownloadParams params);
}
