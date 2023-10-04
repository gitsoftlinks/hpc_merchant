import 'dart:io';
import 'package:happiness_club_merchant/src/features/screens/offer_by_business/usecases/get_offers_by_business.dart';
import 'package:happiness_club_merchant/src/features/screens/create_product/usecases/delete_location_attachment.dart';
import 'package:happiness_club_merchant/src/features/screens/create_product/usecases/delete_product_attachments.dart';
import 'package:happiness_club_merchant/src/features/screens/business/create_business/usecases/delete_branch_location.dart';
import 'package:happiness_club_merchant/src/features/screens/create_offer/usecases/delete_product_offer.dart';
import 'package:happiness_club_merchant/src/features/screens/create_offer/usecases/edit_offer.dart';
import 'package:happiness_club_merchant/src/features/screens/create_offer/usecases/get_products_by_business.dart';
import 'package:camera_platform_interface/src/types/camera_description.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:images_picker/images_picker.dart';
import 'package:logger/logger.dart';
import 'package:happiness_club_merchant/app/app_usecase/get_culture_usecase.dart';
import 'package:happiness_club_merchant/app/app_usecase/save_culture_usecase.dart';
import 'package:happiness_club_merchant/services/repository/repository.dart';
import 'package:happiness_club_merchant/src/features/screens/activate_account/usecases/activate_account_verify_otp.dart';
import 'package:happiness_club_merchant/src/features/screens/business/all_business/usecases/get_all_businesses.dart';
import 'package:happiness_club_merchant/src/features/screens/create_product/usecases/add_business_product.dart';
import 'package:happiness_club_merchant/src/features/screens/business/business_detail/usecases/delete_business.dart';
import 'package:happiness_club_merchant/src/features/screens/products_by_business/usecase/get_all_products.dart';
import 'package:happiness_club_merchant/src/features/screens/business/business_detail/usecases/get_business_detail.dart';
import 'package:happiness_club_merchant/src/features/screens/business/create_business/usecases/create_new_business.dart';
import 'package:happiness_club_merchant/src/features/screens/business/create_business/usecases/get_business_categories.dart';
import 'package:happiness_club_merchant/src/features/screens/product_detail/usecases/delete_product.dart';
import 'package:happiness_club_merchant/src/features/screens/product_detail/usecases/get_product_detail.dart';
import 'package:happiness_club_merchant/src/features/screens/offer_detail_screen/usecases/get_offer_detail.dart';
import 'package:happiness_club_merchant/src/features/screens/forget_password/usecases/forget_password_verify_otp.dart';
import 'package:happiness_club_merchant/src/features/screens/forget_password/usecases/send_reset_password.dart';
import 'package:happiness_club_merchant/src/features/screens/notifications/usecases/get_user_notifications.dart';
import 'package:happiness_club_merchant/src/features/screens/notifications/usecases/send_read_notification.dart';
import 'package:happiness_club_merchant/src/features/screens/personal_info/usecases/update_personal_info.dart';
import 'package:happiness_club_merchant/src/features/screens/settings/usecases/send_settings.dart';
import 'package:happiness_club_merchant/src/features/screens/signin_screen/usecases/send_login.dart';
import 'package:happiness_club_merchant/src/features/screens/signup_screen/usecases/register_user.dart';
import 'package:happiness_club_merchant/src/features/splash_screen/usecases/get_customer_currency.dart';
import 'package:happiness_club_merchant/utils/globals.dart';
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
import '../../src/features/screens/create_product/usecases/get_business_locations.dart';
import '../../src/features/screens/create_offer/usecases/create_offer.dart';
import '../../utils/constants/app_state_enum.dart';
import '../../utils/constants/app_strings.dart';
import '../../utils/network/network_info.dart';
import '../datasource/local_data_source/local_data_source.dart';
import '../datasource/remote_datasource/remote_datasource.dart';
import '../dynamic_link_core_logic/usecases/verify_email.dart';
import '../error/failure.dart';
import '../usecases/usecase.dart';

class RepositoryImp implements Repository {
  final LocalDataSource _localDataSource;
  final Logger _log;
  final NetworkInfo _networkInfo;
  final RemoteDataSource _remoteDataSource;
  //final DynamicLinkHelper _dynamicLinkSource;
  //final GoogleSignIn _googleSignIn;

  RepositoryImp({
    required LocalDataSource localDataSource,
    required NetworkInfo networkInfo,
    required RemoteDataSource remoteDataSource,
    required Logger log,
    //    required DynamicLinkHelper dynamicLinkSource,
  })  : _localDataSource = localDataSource,
        _log = log,
        //  _googleSignIn = googleSignIn,
        _remoteDataSource = remoteDataSource,
        _networkInfo = networkInfo;
  //  _dynamicLinkSource = dynamicLinkSource;

  Future<CultureGetResponse> getCurrentCulture() async {
    var getTokenRes = await cultureGet();

    var deviceLocale = Platform.localeName.split('_')[0];

    if (getTokenRes.isLeft()) {
      await cultureSave(
          CultureSaveParams(culture: deviceLocale, uiCulture: deviceLocale));
      return CultureGetResponse(culture: deviceLocale, uiCulture: deviceLocale);
    }

    return getTokenRes.getOrElse(() =>
        CultureGetResponse(culture: deviceLocale, uiCulture: deviceLocale));
  }

  Future<String> getAccessToken() async {
    final accessTokenEither = await getSavedAccessToken();
    if (accessTokenEither.isLeft()) {
      return '';
    }
    return accessTokenEither.getOrElse(() => '');
  }

  @override
  Future<Either<Failure, bool>> switchCulture(
      SwitchCultureParams params) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }
    try {
      return Right(await _remoteDataSource.switchCulture(params));
    } on Failure catch (e) {
      return Left(e);
    } on DioError catch (_) {
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Either<Failure, String> getUserLanguage() {
    try {
      var passCodeToken = _localDataSource.getUserLanguage();
      return right(passCodeToken);
    } catch (e) {
      return left(CacheFailure(e.toString()));
    }
  }

  @override
  Either<Failure, bool> saveUserLanguage(String token) {
    try {
      return right(_localDataSource.saveUserLanguage(token));
    } catch (e) {
      return left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }
    try {
      final accessTokenEither = await getSavedAccessToken();
      if (accessTokenEither.isLeft()) {
        return Left(accessTokenEither.swap().toOption().toNullable()!);
      }
      final accessToken = accessTokenEither.getOrElse(() => '');

      return Right(await _remoteDataSource.logout(accessToken));
    } on Failure catch (e) {
      return Left(e);
    } on DioError catch (_) {
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> clearSharedPreferences() async {
    try {
      return Right(await _localDataSource.clearSharePreferences());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppStateEnum>> getAppState() async {
    try {
      return Right(await _localDataSource.getAppState());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Uri>> getAppLinkWhichOpened() async {
    try {
      return Right(Uri());
    } catch (e) {
      return Left(DynamicLinkFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> logoutUser() async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }
    try {
      final accessTokenEither = await getSavedAccessToken();
      if (accessTokenEither.isLeft()) {
        return Left(accessTokenEither.swap().toOption().toNullable()!);
      }
      final accessToken = accessTokenEither.getOrElse(() => '');

      return Right(await _remoteDataSource.logout(accessToken));
    } on Failure catch (e) {
      return Left(e);
    } on DioError catch (_) {
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkInternetConnection(NoParams params) async {
    try {
      return Right(await _networkInfo.isConnected);
    } catch (e) {
      return Left(NetworkFailure(NO_INTERNET));
    }
  }

  @override
  Future<Either<Failure, bool>> clearSecureStorage(NoParams noParams) async {
    try {
      return Right(await _localDataSource.clearsSecureStorage());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> getIsFirstTimeUsingApp(NoParams params) async {
    try {
      return Right(await _localDataSource.getIsFirstTimeUserUsingApp());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppInfo>> getAppInfo() async {
    try {
      return Right(await _localDataSource.getAppInfo());
    } catch (e) {
      return Left(PlatformFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getUDID() async {
    try {
      return Right(await _localDataSource.getUDID());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> saveUserAppState(
      AppStateEnum appStateEnum) async {
    try {
      return Right(await _localDataSource.saveAppState(appStateEnum));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getUserCountryISO() async {
    try {
      return Right(await _localDataSource.getUserCountryISO());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(LocationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyEmail(
      VerifyEmailParams verifyEmailParams) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }

    try {
      return const Right(
          true /*await _remoteDataSource.verifyEmail(verifyEmailParams)*/);
    } on InvalidTokenFailure catch (e) {
      return Left(e);
    } on Failure catch (e) {
      return Left(e);
    } on DioError catch (_) {
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> generateUDID() async {
    try {
      return Right(await _localDataSource.generateUDID());
    } catch (e) {
      return Left(UDIDGnerationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CustomerCurrencyGetResponse>> getCustomerCurrency(
      CustomerCurrencyGetParams params) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }

    try {
      // var accessToken = await getAccessToken();
      var paramsWithAccessToken = CustomerCurrencyGetParams.withAccessToken(
          accessToken: 'accessToken', params: params);
      return Right(
          await _remoteDataSource.getSupportedCurrency(paramsWithAccessToken));
    } on InvalidTokenFailure catch (e) {
      return Left(e);
    } on Failure catch (e) {
      return Left(e);
    } on DioError catch (_) {
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getLocale(String params) async {
    try {
      return Right(await _localDataSource.getLocale());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> saveLocale(JsonProps params) async {
    try {
      return Right(await _localDataSource.saveLocale(params));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteAccessToken() async {
    try {
      return Right(await _localDataSource.deleteAccessToken());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> passwordResetSend(
      PasswordResetSendParams params) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }

    try {
      return Right(await _remoteDataSource.passwordResetSend(params));
    } on InvalidTokenFailure catch (e) {
      return Left(e);
    } on Failure catch (e) {
      return Left(e);
    } on DioError catch (_) {
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PasswordResetVerifyOtpSendResponse>>
      passwordResetVerifyOtpSend(
          PasswordResetVerifyOtpSendParams params) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }

    try {
      return Right(await _remoteDataSource.passwordResetVerifyOtpSend(params));
    } on InvalidTokenFailure catch (e) {
      return Left(e);
    } on Failure catch (e) {
      return Left(e);
    } on DioError catch (_) {
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> changePasswordSend(
      ChangePasswordSendParams params) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }

    try {
      return Right(await _remoteDataSource.changePasswordSend(params));
    } on InvalidTokenFailure catch (e) {
      return Left(e);
    } on Failure catch (e) {
      return Left(e);
    } on DioError catch (_) {
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> signupResendOtpSend(
      SignupResendOtpSendParams params) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }

    try {
      return Right(await _remoteDataSource.signupResendOtpSend(params));
    } on InvalidTokenFailure catch (e) {
      return Left(e);
    } on Failure catch (e) {
      return Left(e);
    } on DioError catch (_) {
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> signupVerifyOtpSend(
      SignupVerifyOtpSendParams params) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }

    try {
      return Right(await _remoteDataSource.signupVerifyOtpSend(params));
    } on InvalidTokenFailure catch (e) {
      return Left(e);
    } on Failure catch (e) {
      return Left(e);
    } on DioError catch (_) {
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MediaResponse>>> pickMultipleImagesFromGallery(
      PickType params) async {
    try {
      return Right(
          await _localDataSource.pickMultipleImagesFromGallery(params));
    } catch (e) {
      return Left(PlatformFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MediaResponse>>> getImageFromCamera(
      GetImageFromCameraParams params) async {
    try {
      return Right(await _localDataSource.getImageFromCamera(params));
    } catch (e) {
      return Left(ImagePickerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OtpRequirementsData>> otpRequirementsGet() async {
    try {
      return Right(await _localDataSource.otpRequirementsGet());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> otpRequirementsSave(
      OtpRequirementsData params) async {
    try {
      return Right(await _localDataSource.otpRequirementsSave(params));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CultureGetResponse>> cultureGet() async {
    try {
      return Right(await _localDataSource.cultureGet());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> cultureSave(CultureSaveParams params) async {
    try {
      return Right(await _localDataSource.cultureSave(params));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GoogleMapPlaceGetResponse>> googleMapPlaceGet(
      String params) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }

    try {
      return Right(await _remoteDataSource.googleMapPlaceGet(params));
    } on InvalidTokenFailure catch (e) {
      return Left(e);
    } on Failure catch (e) {
      return Left(e);
    } on DioError catch (_) {
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GoogleMapPlaceDetailsGetResponse>>
      googleMapPlaceDetailsGet(String params) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }

    try {
      return Right(await _remoteDataSource.googleMapPlaceDetailsGet(params));
    } on InvalidTokenFailure catch (e) {
      return Left(e);
    } on Failure catch (e) {
      return Left(e);
    } on DioError catch (_) {
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GoogleMapLatLngDetailsGetResponse>>
      googleMapLatLngDetailsGet(String params) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }

    try {
      return Right(await _remoteDataSource.googleMapLatLngDetailsGet(params));
    } on InvalidTokenFailure catch (e) {
      return Left(e);
    } on Failure catch (e) {
      return Left(e);
    } on DioError catch (_) {
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CameraDescription>>> getAvailableCameras() async {
    try {
      return Right(await _localDataSource.getAvailableCameras());
    } catch (e) {
      return Left(ImagePickerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> pickFileFromGallery(NoParams params) async {
    try {
      return Right(await _localDataSource.pickMultipleFilesFromGallery(params));
    } catch (e) {
      return Left(PlatformFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserDetailResponse>> sendLogin(
      SendLoginParams params) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }

    try {
      return Right(await _remoteDataSource.sendLogin(params));
    } on InvalidTokenFailure catch (e) {
      return Left(e);
    } on Failure catch (e) {
      return Left(e);
    } on DioError catch (_) {
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> saveAccessToken(String params) async {
    try {
      return right(await _localDataSource.saveAccessToken(params));
    } catch (e) {
      return left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getSavedAccessToken() async {
    try {
      return right(await _localDataSource.getSavedAccessToken());
    } catch (e) {
      return left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserDetailResponse>> getCurrentUserDetails() async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }
    try {
      var accessToken = await getAccessToken();
      return Right(await _remoteDataSource.getCurrentUserDetails(accessToken));
    } on Failure catch (e) {
      return Left(e);
    } on DioError catch (_) {
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserRegistrationResponse>> registerUser(
      RegisterUserParams params) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }
    try {
      return Right(await _remoteDataSource.registerUser(params));
    } on Failure catch (e) {
      return Left(e);
    } on DioError catch (_) {
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updatePersonalInfo(
      UpdatePersonalInfoParams params) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }
    try {
      var accessToken = await getAccessToken();
      var paramsWithAccessToken = UpdatePersonalInfoParams.withAccessToken(
          accessToken: accessToken, params: params);
      return Right(
          await _remoteDataSource.updatePersonalInfo(paramsWithAccessToken));
    } on Failure catch (e) {
      return Left(e);
    } on DioError catch (_) {
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> pickImageFromGallery(NoParams params) async {
    try {
      return Right(await _localDataSource.pickImageFromGallery(params));
    } catch (e) {
      return Left(PlatformFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> sendForgetPasswordOtp(String params) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }
    try {
      return Right(await _remoteDataSource.sendForgetPasswordOtp(params));
    } on Failure catch (e) {
      return Left(e);
    } on DioError catch (_) {
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> sendForgetPasswordVerifyOtp(
      SendForgetPasswordVerifyOtpParams params) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }
    try {
      return Right(await _remoteDataSource.sendForgetPasswordVerifyOtp(params));
    } on Failure catch (e) {
      return Left(e);
    } on DioError catch (_) {
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> sendLogout() async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }
    try {
      var accessToken = await getAccessToken();
      return Right(await _remoteDataSource.sendLogout(accessToken));
    } on Failure catch (e) {
      return Left(e);
    } on DioError catch (_) {
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> sendResetPassword(
      SendResetPasswordParams params) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }
    try {
      return Right(await _remoteDataSource.sendResetPassword(params));
    } on Failure catch (e) {
      return Left(e);
    } on DioError catch (_) {
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> createNewBusiness(
      CreateNewBusinessParams params) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }
    try {
      var accessToken = await getAccessToken();
      var paramsWithAccessToken = CreateNewBusinessParams.withAccessToken(
          accessToken: accessToken, params: params);
      return Right(
          await _remoteDataSource.createNewBusiness(paramsWithAccessToken));
    } on Failure catch (e) {
      return Left(e);
    } on DioError catch (_) {
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateBusiness(UpdateBusiness params) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }
    try {
      //

      var accessToken = await getAccessToken();

      var paramsWithAccessToken = UpdateBusiness.withAccessToken(
          accessToken: accessToken, params: params);

      return Right(
          await _remoteDataSource.updateBusiness(paramsWithAccessToken));

      //
    } on Failure catch (e) {
      return Left(e);
    } on DioError catch (_) {
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GetBusinessCategoriesResponse>> getBusinessCategories(
      accessToken) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }
    try {
      var accessToken = await getAccessToken();

      return Right(await _remoteDataSource.getBusinessCategories(accessToken));
    } on Failure catch (e) {
      return Left(e);
    } on DioError catch (_) {
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GetAllBusinessesResponse>> getAllBusinesses(
      NoParams params) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }
    try {
      var accessToken = await getAccessToken();
      return Right(await _remoteDataSource.getAllBusinesses(accessToken));
    } on Failure catch (e) {
      return Left(e);
    } on DioError catch (_) {
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GetBusinessDetailResponse>> getBusinessDetail(
      GetBusinessDetailParams params) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }
    try {
      var accessToken = await getAccessToken();
      var paramsWithAccessToken = GetBusinessDetailParams.withAccessToken(
          accessToken: accessToken, params: params);
      return Right(
          await _remoteDataSource.getBusinessDetail(paramsWithAccessToken));
    } on Failure catch (e) {
      return Left(e);
    } on DioError catch (_) {
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> addBusinessProduct(
      AddBusinessProductParams params) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }
    try {
      var accessToken = await getAccessToken();
      var paramsWithAccessToken = AddBusinessProductParams.withAccessToken(
          accessToken: accessToken, params: params);
      return Right(
          await _remoteDataSource.addBusinessProduct(paramsWithAccessToken));
    } on Failure catch (e) {
      return Left(e);
    } on DioError catch (_) {
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GetProductDetailResponse>> getProductDetail(
      GetProductDetailParams params) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }
    try {
      var accessToken = await getAccessToken();
      var paramsWithAccessToken = GetProductDetailParams.withAccessToken(
          accessToken: accessToken, params: params);
      return Right(
          await _remoteDataSource.getProductDetail(paramsWithAccessToken));
    } on Failure catch (e) {
      return Left(e);
    } on DioError catch (_) {
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GetAllProductsResponse>> getAllProducts(
      GetAllProductsParams params) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }
    try {
      var accessToken = await getAccessToken();
      var paramsWithAccessToken = GetAllProductsParams.withAccessToken(
          accessToken: accessToken, params: params);
      return Right(
          await _remoteDataSource.getAllProducts(paramsWithAccessToken));
    } on Failure catch (e, s) {
      dp("Error n get product$e", s);
      return Left(e);
    } on DioError catch (e, s) {
      dp("Error n get product$e", s);
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e, s) {
      dp("Error n get product$e", s);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteBusiness(
      DeleteBusinessParams params) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }
    try {
      var accessToken = await getAccessToken();
      var paramsWithAccessToken = DeleteBusinessParams.withAccessToken(
          accessToken: accessToken, params: params);
      return Right(
          await _remoteDataSource.deleteBusiness(paramsWithAccessToken));
    } on Failure catch (e) {
      return Left(e);
    } on DioError catch (_) {
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteProduct(
      DeleteProductParams params) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }
    try {
      var accessToken = await getAccessToken();
      var paramsWithAccessToken = DeleteProductParams.withAccessToken(
          accessToken: accessToken, params: params);
      return Right(
          await _remoteDataSource.deleteProduct(paramsWithAccessToken));
    } on Failure catch (e) {
      return Left(e);
    } on DioError catch (_) {
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> createOffer(CreateOfferParams params) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }
    try {
      var accessToken = await getAccessToken();
      var paramsWithAccessToken = CreateOfferParams.withAccessToken(
          accessToken: accessToken, params: params);
      return Right(await _remoteDataSource.createOffer(paramsWithAccessToken));
    } on Failure catch (e) {
      return Left(e);
    } on DioError catch (_) {
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserNotification>>> getUserNotifications() async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }
    try {
      var accessToken = await getAccessToken();
      return Right(await _remoteDataSource.getUserNotifications(accessToken));
    } on Failure catch (e) {
      return Left(e);
    } on DioError catch (_) {
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> sendReadNotification(
      SendReadNotificationParams params) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }
    try {
      var accessToken = await getAccessToken();
      var paramsWithAccessToken = SendReadNotificationParams.withAccessToken(
          accessToken: accessToken, params: params);
      return Right(
          await _remoteDataSource.sendReadNotification(paramsWithAccessToken));
    } on Failure catch (e) {
      return Left(e);
    } on DioError catch (_) {
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> sendSettings(SendSettingsParams params) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }
    try {
      var accessToken = await getAccessToken();
      var paramsWithAccessToken = SendSettingsParams.withAccessToken(
          accessToken: accessToken, params: params);
      return Right(await _remoteDataSource.sendSettings(paramsWithAccessToken));
    } on Failure catch (e) {
      return Left(e);
    } on DioError catch (_) {
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> sendActivateAccountOtp(String params) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }
    try {
      return Right(await _remoteDataSource.sendActivateAccountOtp(params));
    } on Failure catch (e) {
      return Left(e);
    } on DioError catch (_) {
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> sendActivateAccountVerifyOtp(
      SendActivateAccountVerifyOtpParams params) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }
    try {
      return Right(
          await _remoteDataSource.sendActivateAccountVerifyOtp(params));
    } on Failure catch (e) {
      return Left(e);
    } on DioError catch (_) {
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateProduct(
      EditProductParams productParams) async {
    //

    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }

    try {
      //

      var accessToken = await getAccessToken();

      var paramsWithAccessToken = EditProductParams.withAccessToken(
          accessToken: accessToken, params: productParams);

      return Right(
          await _remoteDataSource.updateProduct(paramsWithAccessToken));

      //
    } on Failure catch (e) {
      return Left(e);
    } on DioError catch (_) {
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GetBusinessLocationsResponse>> getBusinessLocations(
      GetBusinessLocationParams params) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }
    try {
      var accessToken = await getAccessToken();
      var paramsWithAccessToken = GetBusinessLocationParams.withAccessToken(
          accessToken: accessToken, params: params);
      return Right(
          await _remoteDataSource.getBusinessLocations(paramsWithAccessToken));
    } on Failure catch (e) {
      return Left(e);
    } on DioError catch (_) {
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GetProductByBusinessResponse>> getProductsByBusiness(
      GetProductByBusinessParams params) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }
    try {
      var accessToken = await getAccessToken();
      var paramsWithAccessToken = GetProductByBusinessParams.withAccessToken(
          accessToken: accessToken, params: params);
      return Right(
          await _remoteDataSource.getProductsByBusiness(paramsWithAccessToken));
    } on Failure catch (e) {
      return Left(e);
    } on DioError catch (_) {
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GetAllOffersByBusinessResponse>>
      getAllOffersByBusiness(GetAllOffersByBusinessParams params) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }
    try {
      var accessToken = await getAccessToken();
      var paramsWithAccessToken = GetAllOffersByBusinessParams.withAccessToken(
          accessToken: accessToken, params: params);
      return Right(
          await _remoteDataSource.getOffersByBusiness(paramsWithAccessToken));
    } on Failure catch (e, s) {
      dp("Error n get product$e", s);
      return Left(e);
    } on DioError catch (e, s) {
      dp("Error n get product$e", s);
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e, s) {
      dp("Error n get product$e", s);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future updateBusinessCover(UpdateNewBusinessCoverParams params) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }
    try {
      //

      var accessToken = await getAccessToken();

      var paramsWithAccessToken = UpdateNewBusinessCoverParams.withAccessToken(
          accessToken: accessToken, params: params);

      return Right(
          await _remoteDataSource.updateBusinessCover(paramsWithAccessToken));

      //
    } on Failure catch (e) {
      return Left(e);
    } on DioError catch (_) {
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GetOfferDetailResponse>> getOfferDetail(
      GetOfferDetailParams params) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }
    try {
      var accessToken = await getAccessToken();
      var paramsWithAccessToken = GetOfferDetailParams.withAccessToken(
          accessToken: accessToken, params: params);
      return Right(
          await _remoteDataSource.getOfferDetail(paramsWithAccessToken));
    } on Failure catch (e) {
      return Left(e);
    } on DioError catch (_) {
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteProductAttachments(
      DeleteProductAttachmentsParams params) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }
    try {
      var accessToken = await getAccessToken();

      var paramsWithAccessToken =
          DeleteProductAttachmentsParams.withAccessToken(
              accessToken: accessToken, params: params);
      return Right(await _remoteDataSource
          .deleteProductAttachments(paramsWithAccessToken));
    } on Failure catch (e) {
      return Left(e);
    } on DioError catch (_) {
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteProductLocationAttachments(
      DeleteProductLocationAttachmentsParams params) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }
    try {
      var accessToken = await getAccessToken();

      var paramsWithAccessToken =
          DeleteProductLocationAttachmentsParams.withAccessToken(
              accessToken: accessToken, params: params);
      return Right(await _remoteDataSource
          .deleteProductLocationAttachments(paramsWithAccessToken));
    } on Failure catch (e) {
      return Left(e);
    } on DioError catch (_) {
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteProductOfferAttachments(
      DeleteProductOfferAttachmentsParams params) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }
    try {
      var accessToken = await getAccessToken();

      var paramsWithAccessToken =
          DeleteProductOfferAttachmentsParams.withAccessToken(
              accessToken: accessToken, params: params);
      return Right(await _remoteDataSource
          .deleteProductOfferAttachments(paramsWithAccessToken));
    } on Failure catch (e) {
      return Left(e);
    } on DioError catch (_) {
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateOffer(
      EditsProductOfferParams offerParams) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }

    try {
      //

      var accessToken = await getAccessToken();

      var paramsWithAccessToken = EditsProductOfferParams.withAccessToken(
          accessToken: accessToken, params: offerParams);

      return Right(await _remoteDataSource.updateOffer(paramsWithAccessToken));

      //
    } on Failure catch (e) {
      return Left(e);
    } on DioError catch (_) {
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteBranchLocationAttachments(
      DeleteBranchLocationAttachmentsParams params) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(NO_INTERNET));
    }
    try {
      var accessToken = await getAccessToken();

      var paramsWithAccessToken =
          DeleteBranchLocationAttachmentsParams.withAccessToken(
              accessToken: accessToken, params: params);
      return Right(
          await _remoteDataSource.deleteBranchLocation(paramsWithAccessToken));
    } on Failure catch (e) {
      return Left(e);
    } on DioError catch (_) {
      return Left(ServerFailure(SOMETHING_WENT_WRONG));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
