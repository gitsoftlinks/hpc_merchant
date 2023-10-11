import 'dart:convert';
import 'package:happiness_club_merchant/src/features/screens/activate_account/usecases/activate_account_verify_otp.dart';
import 'package:happiness_club_merchant/src/features/screens/business/all_business/usecases/get_all_businesses.dart';
import 'package:happiness_club_merchant/src/features/screens/business/business_detail/usecases/get_download_contract_url.dart';
import 'package:happiness_club_merchant/src/features/screens/business/create_business/usecases/get_contract_usecase.dart';
import 'package:happiness_club_merchant/src/features/screens/create_product/usecases/add_business_product.dart';
import 'package:happiness_club_merchant/src/features/screens/business/business_detail/usecases/delete_business.dart';
import 'package:happiness_club_merchant/src/features/screens/products_by_business/usecase/get_all_products.dart';
import 'package:happiness_club_merchant/src/features/screens/business/business_detail/usecases/get_business_detail.dart';
import 'package:happiness_club_merchant/src/features/screens/offer_by_business/usecases/get_offers_by_business.dart';
import 'package:happiness_club_merchant/src/features/screens/create_product/usecases/delete_location_attachment.dart';
import 'package:happiness_club_merchant/src/features/screens/create_product/usecases/delete_product_attachments.dart';
import 'package:happiness_club_merchant/src/features/screens/business/create_business/usecases/create_new_business.dart';
import 'package:happiness_club_merchant/src/features/screens/business/create_business/usecases/delete_branch_location.dart';
import 'package:happiness_club_merchant/src/features/screens/business/create_business/usecases/get_business_categories.dart';
import 'package:happiness_club_merchant/src/features/screens/product_detail/usecases/delete_product.dart';
import 'package:happiness_club_merchant/src/features/screens/product_detail/usecases/get_product_detail.dart';
import 'package:happiness_club_merchant/src/features/screens/create_offer/usecases/delete_product_offer.dart';
import 'package:happiness_club_merchant/src/features/screens/create_offer/usecases/edit_offer.dart';
import 'package:happiness_club_merchant/src/features/screens/create_offer/usecases/get_products_by_business.dart';
import 'package:happiness_club_merchant/src/features/screens/offer_detail_screen/usecases/get_offer_detail.dart';
import 'package:happiness_club_merchant/src/features/screens/forget_password/usecases/forget_password_verify_otp.dart';
import 'package:happiness_club_merchant/src/features/screens/forget_password/usecases/send_reset_password.dart';
import 'package:happiness_club_merchant/src/features/screens/notifications/usecases/get_user_notifications.dart';
import 'package:happiness_club_merchant/src/features/screens/notifications/usecases/send_read_notification.dart';
import 'package:happiness_club_merchant/src/features/screens/personal_info/usecases/update_personal_info.dart';
import 'package:happiness_club_merchant/src/features/screens/settings/usecases/send_settings.dart';
import 'package:happiness_club_merchant/src/features/screens/signin_screen/usecases/send_login.dart';
import 'package:happiness_club_merchant/src/features/screens/signup_screen/usecases/register_user.dart';
import 'package:happiness_club_merchant/utils/globals.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:happiness_club_merchant/app/app_usecase/change_language_usecase.dart';
import 'package:happiness_club_merchant/services/datasource/remote_datasource/remote_datasource.dart';
import 'package:happiness_club_merchant/src/features/splash_screen/usecases/get_customer_currency.dart';
import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import '../../../app/app_usecase/change_password/change_password_send.dart';
import '../../../app/app_usecase/change_password/password_reset_send.dart';
import '../../../app/app_usecase/change_password/password_reset_verify_otp.dart';
import '../../../app/app_usecase/google_map/google_map_latlang_details_get.dart';
import '../../../app/app_usecase/google_map/google_map_place_details_get.dart';
import '../../../app/app_usecase/google_map/google_map_place_get.dart';
import '../../../app/app_usecase/otp_usecase/signup_resend_otp.dart';
import '../../../app/app_usecase/otp_usecase/signup_verify_otp.dart';
import '../../../src/features/screens/create_product/usecases/get_business_locations.dart';
import '../../../src/features/screens/create_offer/usecases/create_offer.dart';
import '../../../utils/constants/app_strings.dart';
import '../../api_constants.dart';
import '../../error/failure.dart';

class RemoteDataSourceImp extends RemoteDataSource {
  //

  final Dio _dio;
  final Logger _log;
  final BaseUrl _baseUrl;
  // final RemoteNotificationsService _remoteNotificationsHelper;

  RemoteDataSourceImp({
    required Dio dio,
    required Logger log,
    required BaseUrl baseUrl,
    //required RemoteNotificationsService remoteNotificationsService,
  })  : _dio = dio,
        _log = log,
        _baseUrl = baseUrl;
  //  _remoteNotificationsHelper = remoteNotificationsService;

  @override
  Future<void> userLogin(String noParams) async {
    throw SOMETHING_WENT_WRONG;
  }

  void handleResponse(Response<dynamic> response) {
    if (response.statusCode == 401) {}
    if (response.data['message'] != null) {
      showFailure(response.requestOptions.path, response.statusCode,
          response.data['message']);
    } else {
      showGenericError(response.requestOptions.path, response.statusCode,
          response.data['message']);
    }
  }

  void showFailure(path, statusCode, message) {
    path = path.split('?')[0];
    switch (statusCode) {
      case 400:
        if (path == _baseUrl.account.login) {
          throw NotFoundFailure('invalid username password'.ntr());
        } else if (path == _baseUrl.account.resetPasswordVerifyOtp) {
          throw BadRequestFailure('invalid email'.ntr());
        } else if (path == _baseUrl.user.registerUser) {
          throw UserAlreadyExistFailure('email already exist'.ntr());
        } else {
          throw BadRequestFailure('bad request failure'.ntr());
        }
      case 401:
        throw UnauthorizedFailure('unauthorized failure'.ntr());
      case 403:
        throw ForbiddenFailure('forbidden failure'.ntr());
      case 404:
        if (path == _baseUrl.account.login) {
          throw NotFoundFailure('invalid username password'.ntr());
        } else if (path == _baseUrl.account.forgetPasswordSendOtp) {
          throw BadRequestFailure('provided email not found'.ntr());
        } else if (path == _baseUrl.account.forgetPasswordVerifyOtp) {
          throw BadRequestFailure('invalid code provided'.ntr());
        } else if (path == _baseUrl.account.resetPasswordVerifyOtp) {
          throw BadRequestFailure('password does not match'.ntr());
        } else {
          throw BadRequestFailure('bad request failure'.ntr());
        }
      case 500:
        throw InternalServerErrorFailure('internal server error failure'.ntr());
      case 501:
        throw NotImplementedFailure('no implement failure'.ntr());
      default:
        throw NotImplementedFailure('no implement failure'.ntr());
    }
  }

  void showGenericError(path, statusCode, message) {
    path = path.split('?')[0];
    switch (statusCode) {
      case 400:
        if (path == _baseUrl.account.resetPasswordVerifyOtp) {
          throw BadRequestFailure('password does not match'.ntr());
        }
        if (path == _baseUrl.post.savePost) {
          throw BadRequestFailure('past already saved'.ntr());
        } else if (path == _baseUrl.business.createOrder) {
          throw BadRequestFailure('something went wrong'.ntr());
        } else if (path == _baseUrl.post.createNewPost) {
          throw BadRequestFailure('bad_ equest failure'.ntr());
        } else if (path == _baseUrl.post.saveSharedPost) {
          throw AlreadySharedFailure('post alreadyShared'.ntr());
        } else {
          throw BadRequestFailure('invalid username password'.ntr());
        }
      case 401:
        throw UnauthorizedFailure('unauthorized failure'.ntr());
      case 403:
        throw ForbiddenFailure('forbidden failure'.ntr());
      case 404:
        throw NotFoundFailure('not found failure'.ntr());
      case 500:
        throw InternalServerErrorFailure('internal serve error failure'.ntr());
      case 501:
        throw NotImplementedFailure('not implement failure'.ntr());
      default:
        throw NotImplementedFailure('not implement failure'.ntr());
    }
  }

  @override
  Future<bool> logout(String params) async {
    _dio.options.headers.addAll({'requestVerificationToken': params});

    try {
      final response = await _dio.post('/logout');

      _log.i("[Remote Repository | logout] $response");
      return true;
    } on DioError catch (dioError) {
      _log.i('[dioError : logout] ${dioError.response!}');
      handleResponse(dioError.response!);
    } catch (error) {
      _log.i('[error : logout] $error');
      throw SOMETHING_WENT_WRONG;
    }
    throw SOMETHING_WENT_WRONG;
  }

  @override
  Future<CustomerCurrencyGetResponse> getSupportedCurrency(
      CustomerCurrencyGetParams params) async {
    // var api = _baseUrl.app.supportedCurrency(countryCode: params.countryCode);
    // _dio.options.headers = {'authorization': 'Bearer ${params.accessToken}', 'accept': 'text/plain'};
    //
    // try {
    //   final response = await _dio.get(api);
    //
    //   _log.i("[ajwaae Remote Repository | getSupportedCurrency] $response");
    //
    //   if (response.statusCode == 200 && response.data != null) {
    //     return CustomerCurrencyGetResponse.fromJson(response.data);
    //   }
    // } on DioError catch (dioError) {
    //   _log.i('[dioError : getSupportedCurrency] ${dioError.response!}');
    //   handleResponse(dioError.response!);
    // } catch (error) {
    //   _log.i('[error : getSupportedCurrency] $error');
    //   throw SOMETHING_WENT_WRONG;
    // }
    throw SOMETHING_WENT_WRONG;
  }

  @override
  Future<bool> switchCulture(SwitchCultureParams params) async {
    // var api = _baseUrl.app.switchCulture(culture: params.culture, uiCulture: params.uiCulture);
    //
    // try {
    //   final response = await _dio.get(api);
    //
    //   _log.i('[remote data source : switchCulture] $response');
    //   return true;
    // } on DioError catch (dioError) {
    //   _log.i('[dioError : switchCulture] ${dioError.response!}');
    //   handleResponse(dioError.response!);
    // } catch (error) {
    //   _log.i('[error : switchCulture] $error');
    //   throw SOMETHING_WENT_WRONG;
    // }
    throw SOMETHING_WENT_WRONG;
  }

  @override
  Future<bool> passwordResetSend(PasswordResetSendParams params) async {
    var api = '_baseUrl.account.sendPasswordResetToken';
    _dio.options.headers = {'Content-Type': 'application/json'};

    try {
      final response = await _dio.post(api, data: jsonEncode(params));

      _log.i('[remote data source : passwordResetSend] $response');
      return true;
    } on DioError catch (dioError) {
      _log.i('[dioError : passwordResetSend] ${dioError.response!}');
      handleResponse(dioError.response!);
    } catch (error) {
      _log.i('[error : passwordResetSend] $error');
      throw SOMETHING_WENT_WRONG;
    }
    throw SOMETHING_WENT_WRONG;
  }

  @override
  Future<PasswordResetVerifyOtpSendResponse> passwordResetVerifyOtpSend(
      PasswordResetVerifyOtpSendParams params) async {
    var api = '_baseUrl.account.confirmPasswordResetToken';
    _dio.options.headers = {'Content-Type': 'application/json'};

    try {
      final response = await _dio.post(api, data: jsonEncode(params));

      _log.i('[remote data source : passwordResetVerifyOtpSend] $response');
      if (response.statusCode == 200 && response.data != null) {
        return PasswordResetVerifyOtpSendResponse.fromJson(response.data);
      }
    } on DioError catch (dioError) {
      _log.i('[dioError : passwordResetVerifyOtpSend] ${dioError.response!}');
      handleResponse(dioError.response!);
    } catch (error) {
      _log.i('[error : passwordResetVerifyOtpSend] $error');
      throw SOMETHING_WENT_WRONG;
    }
    throw SOMETHING_WENT_WRONG;
  }

  @override
  Future<bool> changePasswordSend(ChangePasswordSendParams params) async {
    var api = '_baseUrl.account.resetPassword';
    _dio.options.headers = {'Content-Type': 'application/json'};

    try {
      final response = await _dio.post(api, data: jsonEncode(params));

      _log.i('[remote data source : changePasswordSend] $response');
      return true;
    } on DioError catch (dioError) {
      _log.i('[dioError : changePasswordSend] ${dioError.response!}');
      handleResponse(dioError.response!);
    } catch (error) {
      _log.i('[error : changePasswordSend] $error');
      throw SOMETHING_WENT_WRONG;
    }
    throw SOMETHING_WENT_WRONG;
  }

  @override
  Future<bool> signupResendOtpSend(SignupResendOtpSendParams params) async {
    var api = '_baseUrl.account.sendPhoneNumberConfirmationToken';
    _dio.options.headers = {'Content-Type': 'application/json'};

    try {
      final response = await _dio.post(api, data: jsonEncode(params));

      _log.i('[remote data source : signupResendOtpSend] $response');
      return true;
    } on DioError catch (dioError) {
      _log.i('[dioError : signupResendOtpSend] ${dioError.response!}');
      handleResponse(dioError.response!);
    } catch (error) {
      _log.i('[error : signupResendOtpSend] $error');
      throw SOMETHING_WENT_WRONG;
    }
    throw SOMETHING_WENT_WRONG;
  }

  @override
  Future<bool> signupVerifyOtpSend(SignupVerifyOtpSendParams params) async {
    var api = '_baseUrl.account.';
    _dio.options.headers = {'Content-Type': 'application/json'};

    try {
      final response = await _dio.post(api, data: jsonEncode(params));

      _log.i('[remote data source : signupVerifyOtpSend] $response');
      return true;
    } on DioError catch (dioError) {
      _log.i('[dioError : signupVerifyOtpSend] ${dioError.response!}');
      handleResponse(dioError.response!);
    } catch (error) {
      _log.i('[error : signupVerifyOtpSend] $error');
      throw SOMETHING_WENT_WRONG;
    }
    throw SOMETHING_WENT_WRONG;
  }

  @override
  Future<GoogleMapPlaceGetResponse> googleMapPlaceGet(String params) async {
    var api = _baseUrl.googleMapLocation.searchPlace(input: params);

    try {
      final response = await _dio.get(api);

      _log.i('[remote data source : googleMapPlaceGet] $response');
      var status = response.data['status'];
      if (status == 'OK') {
        return GoogleMapPlaceGetResponse.fromJson(response.data);
      } else {
        throw '${response.data['error_message']}';
      }
    } on DioError catch (dioError) {
      _log.i('[dioError : googleMapPlaceGet] ${dioError.response!}');
      handleResponse(dioError.response!);
    } catch (error) {
      _log.i('[error : googleMapPlaceGet] $error');
      throw SOMETHING_WENT_WRONG;
    }
    throw SOMETHING_WENT_WRONG;
  }

  @override
  Future<GoogleMapPlaceDetailsGetResponse> googleMapPlaceDetailsGet(
      String params) async {
    var api = _baseUrl.googleMapLocation.placeDetails(placeId: params);

    try {
      final response = await _dio.get(api);

      _log.i('[remote data source : googleMapPlaceDetailsGet] $response');
      var status = response.data['status'];
      if (status == 'OK') {
        return GoogleMapPlaceDetailsGetResponse.fromJson(
            response.data['result']);
      } else {
        throw '${response.data['error_message']}';
      }
    } on DioError catch (dioError) {
      _log.i('[dioError : googleMapPlaceDetailsGet] ${dioError.response!}');
      handleResponse(dioError.response!);
    } catch (error) {
      _log.i('[error : googleMapPlaceDetailsGet] $error');
      throw SOMETHING_WENT_WRONG;
    }
    throw SOMETHING_WENT_WRONG;
  }

  @override
  Future<GoogleMapLatLngDetailsGetResponse> googleMapLatLngDetailsGet(
      String params) async {
    var api = _baseUrl.googleMapLocation.latlngDetails(latlng: params);

    try {
      final response = await _dio.get(api);

      _log.i('[remote data source : googleMapLatLngDetailsGet] $response');
      var status = response.data['status'];
      if (status == 'OK') {
        return GoogleMapLatLngDetailsGetResponse.fromJson(response.data);
      } else {
        throw '${response.data['error_message']}';
      }
    } on DioError catch (dioError) {
      _log.i('[dioError : googleMapLatLngDetailsGet] ${dioError.response!}');
      handleResponse(dioError.response!);
    } catch (error, s) {
      _log.i('[error : googleMapLatLngDetailsGet] $error', s);
      throw SOMETHING_WENT_WRONG;
    }

    throw SOMETHING_WENT_WRONG;
  }

  @override
  Future<String> testLoginLogin(String params) async {
    var response =
        await _dio.get('https://jsonplaceholder.typicode.com/todos/1');

    return jsonEncode(response.data);
  }

  @override
  Future<UserDetailResponse> sendLogin(SendLoginParams params) async {
    var api = 'https://hpcstaging.happinessclub.ae/api/auth/login';

    var formData = FormData.fromMap(params.toJson());

    try {
      //

      final response = await _dio.post(api, data: formData);

      _log.i('[remote data source : sendLogin] $response');
      return UserDetailResponse.fromJson(response.data);
    } on DioError catch (dioError) {
      if (dioError.response == null) {
        throw SOMETHING_WENT_WRONG;
      }
      _log.i('[dioError : sendLogin] ${dioError.response!}');
      handleResponse(dioError.response!);
    } catch (error) {
      _log.i('[error : sendLogin] $error');
      throw SOMETHING_WENT_WRONG;
    }
    throw SOMETHING_WENT_WRONG;
  }

  @override
  Future<UserDetailResponse> getCurrentUserDetails(String accessToken) async {
    var api = 'https://hpcstaging.happinessclub.ae/api/user-profile';

    _dio.options.headers = {
      'authorization': 'Bearer $accessToken',
      'accept': 'application/json',
    };

    try {
      final response = await _dio.get(api);

      dp("Current user response ", response.data);

      _log.i('[remote data source : getCurrentUserDetails] $response');

      return UserDetailResponse.fromJson(response.data);

      //
    } on DioError catch (dioError) {
      if (dioError.response == null) {
        throw SOMETHING_WENT_WRONG;
      }

      dp("Error in current user details 1", dioError);

      _log.i('[dioError : getCurrentUserDetails] ${dioError.response!}');

      handleResponse(dioError.response!);
    } catch (error) {
      //

      _log.i('[error : getCurrentUserDetails] $error');

      dp("Error in current user details 2", error);

      throw SOMETHING_WENT_WRONG;
    }
    throw SOMETHING_WENT_WRONG;
  }

  @override
  Future<UserRegistrationResponse> registerUser(
      RegisterUserParams params) async {
    var api = "https://hpcstaging.happinessclub.ae/api/auth/register";
    _dio.options.headers = {'Content-Type': 'multipart/form-data'};

    try {
      var formData = FormData.fromMap(params.toJson());
      final response = await _dio.post(api, data: formData);

      _log.i('[remote data source : registerUser] $response');
      return UserRegistrationResponse.fromJson(response.data);
    } on DioError catch (dioError) {
      if (dioError.response == null) {
        throw SOMETHING_WENT_WRONG;
      }
      _log.i('[dioError : registerUser] ${dioError.response!}');
      handleResponse(dioError.response!);
    } catch (error) {
      _log.i('[error : registerUser] $error');
      throw SOMETHING_WENT_WRONG;
    }
    throw SOMETHING_WENT_WRONG;
  }

  Future<bool> updatePersonalInfo(UpdatePersonalInfoParams params) async {
    var api = 'https://hpcstaging.happinessclub.ae/api/user-profile-update';
    _dio.options.headers = {
      'authorization': 'Bearer ${params.accessToken}',
      'accept': 'application/json',
    };
    try {
      var formData = FormData.fromMap(params.toJson());

      final response = await _dio.post(api, data: formData);

      _log.i('[remote data source : updatePersonalInfo] $response');
      return true;
    } on DioError catch (dioError) {
      if (dioError.response == null) {
        throw SOMETHING_WENT_WRONG;
      }
      _log.i('[dioError : updatePersonalInfo] ${dioError.response!}');
      handleResponse(dioError.response!);
    } catch (error) {
      _log.i('[error : updatePersonalInfo] $error');
      throw SOMETHING_WENT_WRONG;
    }
    throw SOMETHING_WENT_WRONG;
  }

  @override
  Future<bool> sendForgetPasswordOtp(String params) async {
    var api = _baseUrl.account.forgetPasswordSendOtp;
    try {
      var formData = FormData.fromMap({'email': params});

      final response = await _dio.post(api, data: formData);

      _log.i('[remote data source : sendForgetPasswordOtp] $response');
      return true;
    } on DioError catch (dioError) {
      if (dioError.response == null) {
        throw SOMETHING_WENT_WRONG;
      }
      _log.i('[dioError : sendForgetPasswordOtp] ${dioError.response!}');
      handleResponse(dioError.response!);
    } catch (error) {
      _log.i('[error : sendForgetPasswordOtp] $error');
      throw SOMETHING_WENT_WRONG;
    }
    throw SOMETHING_WENT_WRONG;
  }

  @override
  Future<bool> sendForgetPasswordVerifyOtp(
      SendForgetPasswordVerifyOtpParams params) async {
    var api = _baseUrl.account.forgetPasswordVerifyOtp;
    try {
      var formData = FormData.fromMap(params.toJson());

      final response = await _dio.post(api, data: formData);

      _log.i('[remote data source : sendForgetPasswordVerifyOtp] $response');
      return true;
    } on DioError catch (dioError) {
      if (dioError.response == null) {
        throw SOMETHING_WENT_WRONG;
      }
      _log.i('[dioError : sendForgetPasswordVerifyOtp] ${dioError.response!}');
      handleResponse(dioError.response!);
    } catch (error) {
      _log.i('[error : sendForgetPasswordVerifyOtp] $error');
      throw SOMETHING_WENT_WRONG;
    }
    throw SOMETHING_WENT_WRONG;
  }

  @override
  Future<bool> sendLogout(String accessToken) async {
    var api = _baseUrl.account.logout;
    _dio.options.headers = {
      'authorization': 'Bearer $accessToken',
      'accept': 'application/json',
    };

    try {
      final response = await _dio.post(api);

      _log.i('[remote data source : sendLogout] $response');
      return true;
    } on DioError catch (dioError) {
      if (dioError.response == null) {
        throw SOMETHING_WENT_WRONG;
      }
      _log.i('[dioError : sendLogout] ${dioError.response!}');
      handleResponse(dioError.response!);
    } catch (error) {
      _log.i('[error : sendLogout] $error');
      throw SOMETHING_WENT_WRONG;
    }
    throw SOMETHING_WENT_WRONG;
  }

  @override
  Future<bool> sendResetPassword(SendResetPasswordParams params) async {
    var api = _baseUrl.account.resetPasswordVerifyOtp;
    try {
      var formData = FormData.fromMap(params.toJson());

      final response = await _dio.post(api, data: formData);

      _log.i('[remote data source : sendResetPassword] $response');
      return true;
    } on DioError catch (dioError) {
      if (dioError.response == null) {
        throw SOMETHING_WENT_WRONG;
      }
      _log.i('[dioError : sendResetPassword] ${dioError.response!}');
      handleResponse(dioError.response!);
    } catch (error) {
      _log.i('[error : sendResetPassword] $error');
      throw SOMETHING_WENT_WRONG;
    }
    throw SOMETHING_WENT_WRONG;
  }

  @override
  Future<bool> createNewBusiness(CreateNewBusinessParams params) async {
    var api = 'https://hpcstaging.happinessclub.ae/api/create/business';
    _dio.options.headers = {
      'authorization': 'Bearer ${params.accessToken}',
      'accept': 'application/json',
    };
    try {
      var formData = FormData.fromMap(params.toJson());

      final response = await _dio.post(api, data: formData);

      _log.i('[remote data source : createNewBusiness] $response');
      return true;
    } on DioError catch (dioError) {
      if (dioError.response == null) {
        throw SOMETHING_WENT_WRONG;
      }
      _log.i('[dioError : createNewBusiness] ${dioError.response!}');
      handleResponse(dioError.response!);
    } catch (error) {
      _log.i('[error : createNewBusiness] $error');
      throw SOMETHING_WENT_WRONG;
    }
    throw SOMETHING_WENT_WRONG;
  }

  @override
  Future<bool> updateBusiness(UpdateBusiness params) async {
    var api =
        'https://hpcstaging.happinessclub.ae/api/edit/business/${params.id}';
    _dio.options.headers = {
      'authorization': 'Bearer ${params.accessToken}',
      'accept': 'application/json',
    };
    try {
      var formData = FormData.fromMap(params.toJson());

      final response = await _dio.post(api, data: formData);

      _log.i('[remote data source : update new business] $response');
      return true;
    } on DioError catch (dioError) {
      if (dioError.response == null) {
        throw SOMETHING_WENT_WRONG;
      }
      _log.i('[dioError : createNewBusiness] ${dioError.response!}');
      handleResponse(dioError.response!);
    } catch (error) {
      _log.i('[error : createNewBusiness] $error');
      throw SOMETHING_WENT_WRONG;
    }
    throw SOMETHING_WENT_WRONG;
  }

  @override
  Future<GetBusinessCategoriesResponse> getBusinessCategories(
      accessToken) async {
    var api = 'https://hpcstaging.happinessclub.ae/api/business-categories';
    _dio.options.headers = {
      'authorization': 'Bearer ${accessToken}',
      'accept': 'application/json',
    };
    try {
      final response = await _dio.get(api);

      _log.i('[remote data source : getBusinessCategories] $response');
      return GetBusinessCategoriesResponse.fromJson(response.data);
    } on DioError catch (dioError) {
      if (dioError.response == null) {
        throw SOMETHING_WENT_WRONG;
      }
      _log.i('[dioError : getBusinessCategories] ${dioError.response!}');
      handleResponse(dioError.response!);
    } catch (error) {
      _log.i('[error : getBusinessCategories] $error');
      throw SOMETHING_WENT_WRONG;
    }
    throw SOMETHING_WENT_WRONG;
  }

  @override
  Future<GetAllBusinessesResponse> getAllBusinesses(String accessToken) async {
    var api = 'https://hpcstaging.happinessclub.ae/api/user/all_business';
    _dio.options.headers = {
      'authorization': 'Bearer $accessToken',
      'accept': 'application/json',
    };
    try {
      final response = await _dio.get(api);

      _log.i('[remote data source : getAllBusinesses] $response');
      return GetAllBusinessesResponse.fromJson(response.data);
    } on DioError catch (dioError) {
      if (dioError.response == null) {
        throw SOMETHING_WENT_WRONG;
      }
      _log.i('[dioError : getAllBusinesses] ${dioError.response!}');
      handleResponse(dioError.response!);
    } catch (error) {
      _log.i('[error : getAllBusinesses] $error');
      throw SOMETHING_WENT_WRONG;
    }
    throw SOMETHING_WENT_WRONG;
  }

  @override
  Future<GetBusinessDetailResponse> getBusinessDetail(
      GetBusinessDetailParams params) async {
    var api =
        'https://hpcstaging.happinessclub.ae/api/business-detail/${params.businessId}';
    _dio.options.headers = {
      'authorization': 'Bearer ${params.accessToken}',
      'accept': 'application/json',
    };
    dp("POST ID", params.businessId);
    try {
      final response = await _dio.get(api);

      _log.i('[remote data source : getBusinessDetail] $response');
      return GetBusinessDetailResponse.fromJson(response.data);
    } on DioError catch (dioError) {
      if (dioError.response == null) {
        throw SOMETHING_WENT_WRONG;
      }
      _log.i('[dioError : getBusinessDetail] ${dioError.response!}');
      handleResponse(dioError.response!);
    } catch (error, s) {
      //

      dp("[error : getBusinessDetail]", s);

      _log.i('[error : getBusinessDetail] $error');
      throw SOMETHING_WENT_WRONG;
    }
    throw SOMETHING_WENT_WRONG;
  }

  @override
  Future<bool> addBusinessProduct(AddBusinessProductParams params) async {
    var api = 'https://hpcstaging.happinessclub.ae/api/create/product';

    _dio.options.headers = {
      'authorization': 'Bearer ${params.accessToken}',
      'accept': 'application/json',
    };
    dp("Add product", params.toJson());
    try {
      var formData = FormData.fromMap(params.toJson());

      final response = await _dio.post(api, data: formData);
      dp("Add product response", response.data);
      _log.i('[remote data source : addBusinessProduct] $response');
      if (response.statusCode == 200) {
        return true;
      }
      dp("Add product", response.data);
      _log.i('[remote data source : addBusinessProduct] $response');
    } on DioError catch (dioError) {
      if (dioError.response == null) {
        throw SOMETHING_WENT_WRONG;
      }
      _log.i('[dioError : addBusinessProduct] ${dioError.response!}');
      handleResponse(dioError.response!);
    } catch (error) {
      _log.i('[error : addBusinessProduct] $error');
      throw SOMETHING_WENT_WRONG;
    }
    throw SOMETHING_WENT_WRONG;
  }

  @override
  Future<GetAllProductsResponse> getAllProducts(
      GetAllProductsParams params) async {
    var api =
        'https://hpcstaging.happinessclub.ae/api/products-by-business?business_id=${params.businessId}';
    _dio.options.headers = {
      'authorization': 'Bearer ${params.accessToken}',
      'accept': 'application/json',
    };
    try {
      final response = await _dio.get(api);

      _log.i('[remote data source : getAllProducts] $response');
      return GetAllProductsResponse.fromJson(response.data);
    } on DioError catch (dioError) {
      if (dioError.response == null) {
        throw SOMETHING_WENT_WRONG;
      }
      _log.i('[dioError : getAllProducts] ${dioError.response!}');
      handleResponse(dioError.response!);
    } catch (error, s) {
      dp("Error in fetching product", s);
      _log.i('[error : getAllProducts] $error', s);
      throw SOMETHING_WENT_WRONG;
    }
    throw SOMETHING_WENT_WRONG;
  }

  @override
  Future<GetProductDetailResponse> getProductDetail(
      GetProductDetailParams params) async {
    var api =
        'https://hpcstaging.happinessclub.ae/api/product-detail?product_id=${params.productId}';
    _dio.options.headers = {
      'authorization': 'Bearer ${params.accessToken}',
      'accept': 'application/json',
    };
    try {
      final response = await _dio.get(api);

      _log.i('[remote data source : getProductDetail] $response');
      return GetProductDetailResponse.fromJson(response.data);
    } on DioError catch (dioError) {
      if (dioError.response == null) {
        throw SOMETHING_WENT_WRONG;
      }
      _log.i('[dioError : getProductDetail] ${dioError.response!}');
      handleResponse(dioError.response!);
    } catch (error) {
      _log.i('[error : getProductDetail] $error');
      throw SOMETHING_WENT_WRONG;
    }
    throw SOMETHING_WENT_WRONG;
  }

  @override
  Future<bool> deleteBusiness(DeleteBusinessParams params) async {
    var api = '${_baseUrl.business.deleteBusiness}?id=${params.businessId}';
    _dio.options.headers = {
      'authorization': 'Bearer ${params.accessToken}',
      'accept': 'application/json',
    };
    try {
      final response = await _dio.get(api);

      _log.i('[remote data source : deleteBusiness] $response');
      return true;
    } on DioError catch (dioError) {
      if (dioError.response == null) {
        throw SOMETHING_WENT_WRONG;
      }
      _log.i('[dioError : deleteBusiness] ${dioError.response!}');
      handleResponse(dioError.response!);
    } catch (error) {
      _log.i('[error : deleteBusiness] $error');
      throw SOMETHING_WENT_WRONG;
    }
    throw SOMETHING_WENT_WRONG;
  }

  @override
  Future<bool> deleteProduct(DeleteProductParams params) async {
    var api = '${_baseUrl.business.deleteProduct}?id=${params.productId}';
    _dio.options.headers = {
      'authorization': 'Bearer ${params.accessToken}',
      'accept': 'application/json',
    };
    try {
      final response = await _dio.post(api);

      _log.i('[remote data source : deleteProduct] $response');
      return true;
    } on DioError catch (dioError) {
      if (dioError.response == null) {
        throw SOMETHING_WENT_WRONG;
      }
      _log.i('[dioError : deleteProduct] ${dioError.response!}');
      handleResponse(dioError.response!);
    } catch (error) {
      _log.i('[error : deleteProduct] $error');
      throw SOMETHING_WENT_WRONG;
    }
    throw SOMETHING_WENT_WRONG;
  }

  @override
  Future<bool> createOffer(CreateOfferParams params) async {
    var api = 'https://hpcstaging.happinessclub.ae/api/create/offer';
    _dio.options.headers = {
      'authorization': 'Bearer ${params.accessToken}',
      'accept': 'application/json',
    };
    try {
      var formData = FormData.fromMap(params.toJson());
      final response = await _dio.post(api, data: formData);

      _log.i('[remote data source : createOffer] $response');
      return true;
    } on DioError catch (dioError) {
      if (dioError.response == null) {
        throw SOMETHING_WENT_WRONG;
      }
      _log.i('[dioError : createOffer] ${dioError.response!}');
      handleResponse(dioError.response!);
    } catch (error) {
      _log.i('[error : createOffer] $error');
      throw SOMETHING_WENT_WRONG;
    }
    throw SOMETHING_WENT_WRONG;
  }

  Future<List<UserNotification>> getUserNotifications(
      String accessToken) async {
    var api = _baseUrl.message.getUserNotification;
    _dio.options.headers = {
      'authorization': 'Bearer $accessToken',
      'accept': 'application/json',
    };
    try {
      final response = await _dio.get(api);

      _log.i('[remote data source : getUserNotifications] $response');
      return List<UserNotification>.from(response.data['data']['data']
          .map((x) => UserNotification.fromJson(x)));
    } on DioError catch (dioError) {
      if (dioError.response == null) {
        throw SOMETHING_WENT_WRONG;
      }
      _log.i('[dioError : getUserNotifications] ${dioError.response!}');
      handleResponse(dioError.response!);
    } catch (error, s) {
      _log.i('[error : getUserNotifications] $error', error, s);
      throw SOMETHING_WENT_WRONG;
    }
    throw SOMETHING_WENT_WRONG;
  }

  @override
  Future<bool> sendReadNotification(SendReadNotificationParams params) async {
    var api = _baseUrl.message.markNotificationReed;
    _dio.options.headers = {
      'authorization': 'Bearer ${params.accessToken}',
      'accept': 'application/json',
    };
    try {
      // var formData = FormData.fromMap(params.toJson().toString());

      final response = await _dio
          .post(api, data: {'notification_ids': "${params.notificationIds}"});

      _log.i('[remote data source : sendReadNotification] $response');
      return true;
    } on DioError catch (dioError) {
      if (dioError.response == null) {
        throw SOMETHING_WENT_WRONG;
      }
      _log.i('[dioError : sendReadNotification] ${dioError.response!}');
      handleResponse(dioError.response!);
    } catch (error) {
      _log.i('[error : sendReadNotification] $error');
      throw SOMETHING_WENT_WRONG;
    }
    throw SOMETHING_WENT_WRONG;
  }

  @override
  Future<bool> sendSettings(SendSettingsParams params) async {
    var api = _baseUrl.user.updateProfileSetting;
    _dio.options.headers = {
      'authorization': 'Bearer ${params.accessToken}',
      'accept': 'application/json',
    };
    try {
      var formData = FormData.fromMap(params.toJson());

      final response = await _dio.post(api, data: formData);

      _log.i('[remote data source : sendSettings] $response');
      return true;
    } on DioError catch (dioError) {
      if (dioError.response == null) {
        throw SOMETHING_WENT_WRONG;
      }
      _log.i('[dioError : sendSettings] ${dioError.response!}');
      handleResponse(dioError.response!);
    } catch (error) {
      _log.i('[error : sendSettings] $error');
      throw SOMETHING_WENT_WRONG;
    }
    throw SOMETHING_WENT_WRONG;
  }

  @override
  Future<bool> sendActivateAccountOtp(String params) async {
    var api = _baseUrl.account.activateAccountSendOtp;
    try {
      var formData = FormData.fromMap({'email': params});

      final response = await _dio.post(api, data: formData);

      _log.i('[remote data source : sendActivateAccountOtp] $response');
      return true;
    } on DioError catch (dioError) {
      if (dioError.response == null) {
        throw SOMETHING_WENT_WRONG;
      }
      _log.i('[dioError : sendActivateAccountOtp] ${dioError.response!}');
      handleResponse(dioError.response!);
    } catch (error) {
      _log.i('[error : sendActivateAccountOtp] $error');
      throw SOMETHING_WENT_WRONG;
    }
    throw SOMETHING_WENT_WRONG;
  }

  @override
  Future<bool> sendActivateAccountVerifyOtp(
      SendActivateAccountVerifyOtpParams params) async {
    var api = _baseUrl.account.activateAccountVerifyOtp;
    try {
      var formData = FormData.fromMap(params.toJson());

      final response = await _dio.post(api, data: formData);

      _log.i('[remote data source : sendActivateAccountVerifyOtp] $response');
      return true;
    } on DioError catch (dioError) {
      if (dioError.response == null) {
        throw SOMETHING_WENT_WRONG;
      }
      _log.i('[dioError : sendActivateAccountVerifyOtp] ${dioError.response!}');
      handleResponse(dioError.response!);
    } catch (error) {
      _log.i('[error : sendActivateAccountVerifyOtp] $error');
      throw SOMETHING_WENT_WRONG;
    }
    throw SOMETHING_WENT_WRONG;
  }

  @override
  Future<bool> updateProduct(EditProductParams params) async {
    var api =
        'https://hpcstaging.happinessclub.ae/api/edit/product/${params.id}';
    _dio.options.headers = {
      'authorization': 'Bearer ${params.accessToken}',
      'accept': 'application/json',
    };
    try {
      var formData = FormData.fromMap(params.toJson());

      final response = await _dio.post(api, data: formData);

      _log.i('[product update result : update] ${response.data}');

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } on DioError catch (dioError, s) {
      dp("Update product error", s);

      if (dioError.response == null) {
        throw SOMETHING_WENT_WRONG;
      }
      _log.i('[dioError : update prodect] ${dioError.response!}');
      handleResponse(dioError.response!);
    } catch (error) {
      _log.i('[error : update Product] $error');
      throw SOMETHING_WENT_WRONG;
    }
    throw SOMETHING_WENT_WRONG;
  }

  @override
  Future<GetBusinessLocationsResponse> getBusinessLocations(
      GetBusinessLocationParams params) async {
    var api =
        'https://hpcstaging.happinessclub.ae/api/locations-by-business?business_id=${params.businessId}';
    _dio.options.headers = {
      'authorization': 'Bearer ${params.accessToken}',
      'accept': 'application/json',
    };
    dp("POST ID", params.businessId);
    try {
      final response = await _dio.get(api);

      _log.i('[remote data source : getBusinessLocations] $response');
      return GetBusinessLocationsResponse.fromJson(response.data);
    } on DioError catch (dioError) {
      if (dioError.response == null) {
        throw SOMETHING_WENT_WRONG;
      }
      _log.i('[dioError : getBusinessLocations] ${dioError.response!}');
      handleResponse(dioError.response!);
    } catch (error, s) {
      //

      dp("[error : getBusinessLocations]", s);

      _log.i('[error : getBusinessLocations] $error');
      throw SOMETHING_WENT_WRONG;
    }
    throw SOMETHING_WENT_WRONG;
  }

  @override
  Future<GetProductByBusinessResponse> getProductsByBusiness(
      GetProductByBusinessParams params) async {
    var api =
        'https://hpcstaging.happinessclub.ae/api/products-by-business?business_id=${params.businessId}';
    _dio.options.headers = {
      'authorization': 'Bearer ${params.accessToken}',
      'accept': 'application/json',
    };
    dp("POST ID", params.businessId);
    try {
      final response = await _dio.get(api);

      _log.i('[remote data source : getProductsByBusiness] $response');
      return GetProductByBusinessResponse.fromJson(response.data);
    } on DioError catch (dioError) {
      if (dioError.response == null) {
        throw SOMETHING_WENT_WRONG;
      }
      _log.i('[dioError : getProductsByBusiness] ${dioError.response!}');
      handleResponse(dioError.response!);
    } catch (error, s) {
      //

      dp("[error : getProductsByBusiness]", s);

      _log.i('[error : getProductsByBusiness] $error');
      throw SOMETHING_WENT_WRONG;
    }
    throw SOMETHING_WENT_WRONG;
  }

  @override
  Future<GetAllOffersByBusinessResponse> getOffersByBusiness(
      GetAllOffersByBusinessParams params) async {
    var api =
        'https://hpcstaging.happinessclub.ae/api/all-offers-by-business?business_id=${params.businessId}';
    _dio.options.headers = {
      'authorization': 'Bearer ${params.accessToken}',
      'accept': 'application/json',
    };
    try {
      final response = await _dio.get(api);

      _log.i('[remote data source : getAllOffersByBusiness] $response');
      return GetAllOffersByBusinessResponse.fromJson(response.data);
    } on DioError catch (dioError) {
      if (dioError.response == null) {
        throw SOMETHING_WENT_WRONG;
      }
      _log.i('[dioError : getAllOffersByBusiness] ${dioError.response!}');
      handleResponse(dioError.response!);
    } catch (error, s) {
      dp("Erorr in geting product", s);
      _log.i('[error : getAllOffersByBusiness] $error', s);
      throw SOMETHING_WENT_WRONG;
    }
    throw SOMETHING_WENT_WRONG;
  }

  @override
  Future<bool> updateBusinessCover(UpdateNewBusinessCoverParams params) async {
    var api =
        'https://hpcstaging.happinessclub.ae/api/update/business/cover-pic';
    _dio.options.headers = {
      'authorization': 'Bearer ${params.accessToken}',
      'accept': 'application/json',
    };
    try {
      var formData = FormData.fromMap(params.toJson());

      final response = await _dio.post(api, data: formData);

      _log.i('[remote data source : update new business Cover] $response');
      return true;
    } on DioError catch (dioError) {
      if (dioError.response == null) {
        throw SOMETHING_WENT_WRONG;
      }
      _log.i('[dioError : updateNewBusinessCover] ${dioError.response!}');
      handleResponse(dioError.response!);
    } catch (error) {
      _log.i('[error : updateNewBusinessCover] $error');
      throw SOMETHING_WENT_WRONG;
    }
    throw SOMETHING_WENT_WRONG;
  }

  @override
  Future<GetOfferDetailResponse> getOfferDetail(
      GetOfferDetailParams params) async {
    var api =
        'https://hpcstaging.happinessclub.ae/api/offer-detail?offer_id=${params.offerId}';
    _dio.options.headers = {
      'authorization': 'Bearer ${params.accessToken}',
      'accept': 'application/json',
    };
    try {
      final response = await _dio.get(api);

      _log.i('[remote data source : getOfferDetail] $response');
      return GetOfferDetailResponse.fromJson(response.data);
    } on DioError catch (dioError) {
      if (dioError.response == null) {
        throw SOMETHING_WENT_WRONG;
      }
      _log.i('[dioError : getOfferDetail] ${dioError.response!}');
      handleResponse(dioError.response!);
    } catch (error) {
      _log.i('[error : getOfferDetail] $error');
      throw SOMETHING_WENT_WRONG;
    }
    throw SOMETHING_WENT_WRONG;
  }

  @override
  Future<bool> deleteProductAttachments(
      DeleteProductAttachmentsParams params) async {
    var api =
        'https://hpcstaging.happinessclub.ae/api/delete-product-attachment?attachment_id=${params.attachmentId}';
    _dio.options.headers = {
      'authorization': 'Bearer ${params.accessToken}',
      'accept': 'application/json',
    };
    try {
      final response = await _dio.delete(api);

      _log.i('[remote data source : deleteProductAttachments] $response');
      return true;
    } on DioError catch (dioError) {
      if (dioError.response == null) {
        throw SOMETHING_WENT_WRONG;
      }
      _log.i('[dioError : deleteProductAttachments] ${dioError.response!}');
      handleResponse(dioError.response!);
    } catch (error) {
      _log.i('[error : deleteProductAttachments] $error');
      throw SOMETHING_WENT_WRONG;
    }
    throw SOMETHING_WENT_WRONG;
  }

  @override
  Future<bool> deleteProductLocationAttachments(
      DeleteProductLocationAttachmentsParams params) async {
    var api =
        'https://hpcstaging.happinessclub.ae/api/delete-product-location?location_id=${params.attachmentId}';
    _dio.options.headers = {
      'authorization': 'Bearer ${params.accessToken}',
      'accept': 'application/json',
    };
    try {
      final response = await _dio.delete(api);

      _log.i(
          '[remote data source : deleteProductLocationAttachments] $response');
      return true;
    } on DioError catch (dioError) {
      if (dioError.response == null) {
        throw SOMETHING_WENT_WRONG;
      }
      _log.i(
          '[dioError : deleteProductLocationAttachments] ${dioError.response!}');
      handleResponse(dioError.response!);
    } catch (error) {
      _log.i('[error : deleteProductLocationAttachments] $error');
      throw SOMETHING_WENT_WRONG;
    }
    throw SOMETHING_WENT_WRONG;
  }

  @override
  Future<bool> deleteProductOfferAttachments(
      DeleteProductOfferAttachmentsParams params) async {
    var api =
        'https://hpcstaging.happinessclub.ae/api/delete-product-offer?product_offer_id=${params.attachmentId}';
    _dio.options.headers = {
      'authorization': 'Bearer ${params.accessToken}',
      'accept': 'application/json',
    };
    try {
      final response = await _dio.delete(api);

      _log.i('[remote data source : deleteProductOfferAttachments] $response');
      return true;
    } on DioError catch (dioError) {
      if (dioError.response == null) {
        throw SOMETHING_WENT_WRONG;
      }
      _log.i(
          '[dioError : deleteProductOfferAttachments] ${dioError.response!}');
      handleResponse(dioError.response!);
    } catch (error) {
      _log.i('[error : deleteProductOfferAttachments] $error');
      throw SOMETHING_WENT_WRONG;
    }
    throw SOMETHING_WENT_WRONG;
  }

  @override
  Future<bool> updateOffer(EditsProductOfferParams offerParams) async {
    var api =
        'https://hpcstaging.happinessclub.ae/api/edit/offer/${offerParams.id}';
    _dio.options.headers = {
      'authorization': 'Bearer ${offerParams.accessToken}',
      'accept': 'application/json',
    };
    try {
      var formData = FormData.fromMap(offerParams.toJson());

      final response = await _dio.post(api, data: formData);

      _log.i('[offer update result : update] ${response.data}');

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } on DioError catch (dioError, s) {
      dp("Update offer error", s);

      if (dioError.response == null) {
        throw SOMETHING_WENT_WRONG;
      }
      _log.i('[dioError : update offer] ${dioError.response!}');
      handleResponse(dioError.response!);
    } catch (error) {
      _log.i('[error : update offer] $error');
      throw SOMETHING_WENT_WRONG;
    }
    throw SOMETHING_WENT_WRONG;
  }

  @override
  Future<bool> deleteBranchLocation(
      DeleteBranchLocationAttachmentsParams params) async {
    var api =
        'https://hpcstaging.happinessclub.ae/api/business-location-delete?location_id=${params.attachmentId}';
    _dio.options.headers = {
      'authorization': 'Bearer ${params.accessToken}',
      'accept': 'application/json',
    };
    try {
      final response = await _dio.delete(api);

      _log.i(
          '[remote data source : deleteBranchLocationAttachments] $response');
      return true;
    } on DioError catch (dioError) {
      if (dioError.response == null) {
        throw SOMETHING_WENT_WRONG;
      }
      _log.i(
          '[dioError : deleteBranchLocationAttachments] ${dioError.response!}');
      handleResponse(dioError.response!);
    } catch (error) {
      _log.i('[error : deleteBranchLocationAttachments] $error');
      throw SOMETHING_WENT_WRONG;
    }
    throw SOMETHING_WENT_WRONG;
  }

  @override
  Future<GetBusinessContractResponse> getBusinessContract(
      GetBusinessContractParams params) async {
    var api =
        'https://hpcstaging.happinessclub.ae/api/contract-content?business_legal_name=${params.businessLegalName}';
    _dio.options.headers = {
      'authorization': 'Bearer ${params.accessToken}',
      'accept': 'application/json',
    };
    dp("POST name", params.businessLegalName);
    try {
      final response = await _dio.get(api);

      _log.i('[remote data source : getBusinessContract] $response');
      return GetBusinessContractResponse.fromJson(response.data);
    } on DioError catch (dioError) {
      if (dioError.response == null) {
        throw SOMETHING_WENT_WRONG;
      }
      _log.i('[dioError : getBusinessContract] ${dioError.response!}');
      handleResponse(dioError.response!);
    } catch (error, s) {
      //

      dp("[error : getBusinessContract]", s);

      _log.i('[error : getBusinessDetail] $error');
      throw SOMETHING_WENT_WRONG;
    }
    throw SOMETHING_WENT_WRONG;
  }

  @override
  Future<GetBusinessContractDownloadResponse> getBusinessContractDownload(
      GetBusinessContractDownloadParams params) async {
    var api =
        'https://hpcstaging.happinessclub.ae/api/contract-download/${params.businessId}';
    _dio.options.headers = {
      'authorization': 'Bearer ${params.accessToken}',
      'accept': 'application/json',
    };
    dp("POST id", params.businessId);
    try {
      final response = await _dio.get(api);

      _log.i('[remote data source : getBusinessContract] $response');
      return GetBusinessContractDownloadResponse.fromJson(response.data);
    } on DioError catch (dioError) {
      if (dioError.response == null) {
        throw SOMETHING_WENT_WRONG;
      }
      _log.i('[dioError : getBusinessContract] ${dioError.response!}');
      handleResponse(dioError.response!);
    } catch (error, s) {
      //

      dp("[error : getBusinessContract]", s);

      _log.i('[error : getBusinessDetail] $error');
      throw SOMETHING_WENT_WRONG;
    }
    throw SOMETHING_WENT_WRONG;
  }
}
