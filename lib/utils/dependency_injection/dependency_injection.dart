import 'package:happiness_club_merchant/src/features/screens/offer_by_business/usecases/get_offers_by_business.dart';
import 'package:happiness_club_merchant/src/features/screens/create_product/usecases/delete_product_attachments.dart';
import 'package:happiness_club_merchant/src/features/screens/create_product/usecases/get_business_locations.dart';
import 'package:happiness_club_merchant/src/features/screens/business/create_business/usecases/delete_branch_location.dart';
import 'package:happiness_club_merchant/src/features/screens/create_offer/usecases/edit_offer.dart';
import 'package:happiness_club_merchant/src/features/screens/create_offer/usecases/get_products_by_business.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:images_picker/images_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../app/app_usecase/access_token_delete.dart';
import '../../app/app_usecase/change_language_usecase.dart';
import '../../app/app_usecase/clear_secure_storage.dart';
import '../../app/app_usecase/firbase/generate_dynamic_link.dart';
import '../../app/app_usecase/first_time_using_app.dart';
import '../../app/app_usecase/generate_udid.dart';
import '../../app/app_usecase/get_access_token.dart';
import '../../app/app_usecase/get_app_info.dart';
import '../../app/app_usecase/get_app_udid.dart';
import '../../app/app_usecase/get_current_user_details.dart';
import '../../app/app_usecase/get_image_from_camera.dart';
import '../../app/app_usecase/google_map/google_map_latlang_details_get.dart';
import '../../app/app_usecase/google_map/google_map_place_details_get.dart';
import '../../app/app_usecase/google_map/google_map_place_get.dart';
import '../../app/app_usecase/handle_dynamic_link.dart';
import '../../app/app_usecase/locale_save.dart';
import '../../app/app_usecase/pick_file_from_gallery.dart';
import '../../app/app_usecase/pick_image_from_gallery.dart';
import '../../app/app_usecase/save_app_state.dart';
import '../../app/app_usecase/save_culture_usecase.dart';
import '../../app/app_usecase/save_access_token.dart';
import '../../app/models/select_location_view_model.dart';
import '../../app/models/user_runtime_config.dart';
import '../../app/providers/account_provider.dart';
import '../../app/providers/cart_provider.dart';
import '../../app/providers/languages.dart';
import '../../services/api_constants.dart';
import '../../services/datasource/local_data_source/local_data_source.dart';
import '../../services/datasource/local_data_source/local_data_source_imp.dart';
import '../../services/datasource/remote_datasource/remote_datasource.dart';
import '../../services/datasource/remote_datasource/remote_datasource_imp.dart';
import '../../services/dynamic_link_core_logic/dynamic_link_logic.dart';
import '../../services/dynamic_link_core_logic/usecases/verify_email.dart';
import '../../services/repository/repository.dart';
import '../../services/repository/repository_imp.dart';
import '../../services/third_party_plugins/cache_manager/cache_manager.dart';
import '../../services/third_party_plugins/cache_manager/cache_manager_imp.dart';
import '../../services/third_party_plugins/local_image_picker/local_image_picker.dart';
import '../../services/third_party_plugins/local_image_picker/local_image_picker_impl.dart';
import '../../services/third_party_plugins/locator/locator_service.dart';
import '../../services/third_party_plugins/locator/locator_service_imp.dart';
import '../../services/third_party_plugins/udid_generator.dart';
import '../../app/app_usecase/pick_multi_images_from_gallery.dart';
import '../../src/features/drawer/menu_drawer_view_model.dart';
import '../../src/features/drawer/usecases/send_logout.dart';
import '../../src/features/home/model/home_view_model.dart';
import '../../src/features/no_internet_screen/check_internet_connection.dart';
import '../../src/features/screens/activate_account/model/activate_account_view_model.dart';
import '../../src/features/screens/activate_account/usecases/activate_account_verify_otp.dart';
import '../../src/features/screens/activate_account/usecases/send_activate_account_otp.dart';
import '../../src/features/screens/business/all_business/model/get_all_businesses_view_model.dart';
import '../../src/features/screens/business/all_business/usecases/get_all_businesses.dart';
import '../../src/features/screens/business/business_detail/model/business_detail_view_model.dart';
import '../../src/features/screens/create_product/usecases/add_business_product.dart';
import '../../src/features/screens/business/business_detail/usecases/delete_business.dart';
import '../../src/features/screens/products_by_business/usecase/get_all_products.dart';
import '../../src/features/screens/business/business_detail/usecases/get_business_detail.dart';
import '../../src/features/screens/create_product/model/create_product_view_model.dart';
import '../../src/features/screens/create_product/usecases/delete_location_attachment.dart';
import '../../src/features/screens/business/create_business/model/create_business_view_model.dart';
import '../../src/features/screens/business/create_business/usecases/create_new_business.dart';
import '../../src/features/screens/business/create_business/usecases/get_business_categories.dart';
import '../../src/features/screens/product_detail/model/product_detail_view_model.dart';
import '../../src/features/screens/product_detail/usecases/delete_product.dart';
import '../../src/features/screens/product_detail/usecases/get_product_detail.dart';
import '../../src/features/screens/create_offer/model/create_offer_view_model.dart';
import '../../src/features/screens/create_offer/usecases/delete_product_offer.dart';
import '../../src/features/screens/create_offer/usecases/create_offer.dart';
import '../../src/features/screens/offer_detail_screen/models/offer_detail_view_model.dart';
import '../../src/features/screens/offer_detail_screen/usecases/get_offer_detail.dart';
import '../../src/features/screens/forget_password/model/forget_password_view_model.dart';
import '../../src/features/screens/forget_password/model/reset_password_view_model.dart';
import '../../src/features/screens/forget_password/usecases/forget_password_verify_otp.dart';
import '../../src/features/screens/forget_password/usecases/send_reset_password.dart';
import '../../src/features/screens/login_register/model/login_register_view_model.dart';
import '../../src/features/screens/notifications/model/notificatiiion_view_model.dart';
import '../../src/features/screens/notifications/usecases/get_user_notifications.dart';
import '../../src/features/screens/notifications/usecases/send_read_notification.dart';
import '../../src/features/screens/personal_info/model/personal_info_view_model.dart';
import '../../src/features/screens/personal_info/usecases/update_personal_info.dart';
import '../../src/features/screens/settings/model/settings_view_model.dart';
import '../../src/features/screens/settings/usecases/send_settings.dart';
import '../../src/features/screens/signin_screen/model/signin_view_model.dart';
import '../../src/features/screens/signin_screen/usecases/send_forget_password_otp.dart';
import '../../src/features/screens/signin_screen/usecases/send_login.dart';
import '../../src/features/screens/signup_screen/model/signup_view_model.dart';
import '../../src/features/screens/signup_screen/usecases/register_user.dart';
import '../../src/features/splash_screen/model/splash_screen_view_model.dart';
import '../../src/features/splash_screen/usecases/clear_shared_preferences.dart';
import '../../src/features/splash_screen/usecases/get_app_state.dart';
import '../../src/features/splash_screen/usecases/get_link_on_app_opened.dart';
import '../../src/features/splash_screen/usecases/get_customer_currency.dart';
import '../../src/features/splash_screen/usecases/logout_user.dart';
import '../../src/features/splash_screen/usecases/user_location.dart';
import '../globals.dart';
import '../network/network_info.dart';
import '../network/network_info_imp.dart';
import '../permission/permission_engine.dart';
import '../permission/permission_service.dart';
import '../router/app_state.dart';
import '../router/back_button_dispatcher.dart';

/// This method is used for initializing all the dependencies
Future<void> init() async {
  registerExternalDependencies();
  registerUseCases();
  registerRepository();
  registerDataSources();
  registerViewModel();
  registerConfigs();
}

/// This method will signup external dependencies for ajwaae
void registerExternalDependencies() {
  sl.registerLazySingleton(() => Dio(BaseOptions(
      receiveTimeout: 60000, connectTimeout: 60000, sendTimeout: 60000)));

  sl.registerLazySingleton(() => const FlutterSecureStorage());

  sl.registerLazySingleton<InternetConnectionChecker>(
      () => InternetConnectionChecker());
  sl.registerLazySingleton(() => ImagePicker());
  sl.registerLazySingleton(() => ImagesPicker());
  sl.registerLazySingleton(() => FilePicker.platform);
  // sl.registerSingletonAsync<SharedPreferences>(
  //     () => SharedPreferences.getInstance());
  // sl.registerLazySingleton(() => FirebaseRemoteConfig.instance);

  // sl.registerLazySingleton<FirebaseMessaging>(() => FirebaseMessaging.instance);

  // sl.registerLazySingleton<FirebaseDynamicLinks>(
  //     () => FirebaseDynamicLinks.instance);

  // sl.registerLazySingleton<RemoteNotificationsService>(() =>
  //     RemoteNotificationsServiceImp(
  //         firebaseMessaging: sl(),
  //         log: sl(),
  //         flutterLocalNotificationsPlugin: sl()));
}

/// This method will signup ajwaae config
void registerConfigs() {
  sl.registerLazySingleton(() => UserRuntimeConfig.initial());
}

/// Repository
///\\
void registerRepository() {
  //

  sl.registerLazySingleton<Repository>(
    () => RepositoryImp(
      networkInfo: sl(),
      //  dynamicLinkSource: sl(),
      log: sl(),
      localDataSource: sl(),
      remoteDataSource: sl(),
    ),
  );
}

/// This method will signup all the ajwaae data sources
void registerDataSources() {
  sl.registerLazySingleton(() => BaseUrl(dotenv.env["url"]!));

  sl.registerLazySingleton<RemoteDataSource>(() => RemoteDataSourceImp(
        dio: sl(),
        log: sl(),
        baseUrl: sl(),
      ));

  sl.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImp(
        flutterSecureStorage: sl(),
        imagePicker: sl(),
        cacheManager: sl(),
        // sharedPreferences: sl(),
        //  dynamicLinkHelper: sl(),
        udidGenerator: sl(),
        locator: sl(),
      ));

  sl.registerLazySingleton<LocalImagePicker>(() => LocalImagePickerImpl(
      imagePicker: sl(), filePicker: sl(), newImagesPicker: sl()));

  sl.registerLazySingleton<PermissionService>(() => PermissionsServiceImp());

  // sl.registerLazySingleton<DynamicLinkHelper>(() => DynamicLinkHelperImpl(
  //     firebaseDynamicLinks: sl(),
  //     uriPrefix: dotenv.env["uriPrefix"]!,
  //     androidPackage: dotenv.env["androidAppId"]!,
  //     iosPackage: dotenv.env["iosAppId"]!,
  //     url: dotenv.env["url"]!));

  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImp(connectionChecker: sl()));

  sl.registerLazySingleton<PermissionEngine>(() => PermissionEngineImp(sl()));

  sl.registerLazySingleton<CacheManager>(() => CacheManagerImp());

  sl.registerLazySingleton<DynamicLinkHandlerFactory>(
      () => DynamicLinkHandlerFactoryImp());

  sl.registerLazySingleton<UDIDGenerator>(() => UDIDGeneratorImp());
  sl.registerLazySingleton(() => GeolocatorPlatform.instance);
  sl.registerLazySingleton(() => GeocodingPlatform.instance);

  sl.registerLazySingleton<LocatorService>(() =>
      LocatorServiceImp(geolocatorPlatform: sl(), geocodingPlatform: sl()));

  // sl.registerLazySingleton<RemoteConfigService>(
  //     () => RemoteConfigServiceImp(sl()));
}

/// This method will signup all the viewModels
void registerViewModel() {
  sl.registerLazySingleton(() => SplashScreenViewModelDependencies(
        getAppStateUseCase: sl(),
        getAppLinkOnAppOpened: sl(),
        handleDynamicLink: sl(),
        //  remoteConfigService: sl(),
        getAppInfo: sl(),
        getCurrentUserRemote: sl(),
        isFirstTimeUsingTheApp: sl(),
        clearSecureStorage: sl(),
        appState: sl(),
        logoutUser: sl(),
        // remoteNotificationsService: sl(),
        getAllBusinesses: sl(),
        getUserNotification: sl(),
      ));

  sl.registerLazySingleton(
      () => SplashScreenViewModel(splashScreenViewModelDependencies: sl()));

  sl.registerLazySingleton(() => MenuDrawerViewModel(
      appState: sl(), clearSecureStorage: sl(), sendLogout: sl()));

  sl.registerLazySingleton(() => HomeViewModel(
        appState: sl(),
      ));

  sl.registerLazySingleton(() => AccountProvider());

  sl.registerLazySingleton(() => CartProvider());

  sl.registerLazySingleton(() => LanguageProvider());

  sl.registerLazySingleton(() => LoginRegisterViewModel(appState: sl()));

  sl.registerLazySingleton(() => SignInViewModel(
        appState: sl(),
        sendLogin: sl(),
        saveLoginToken: sl(),
        sendForgetPasswordOtp: sl(),
      ));
  sl.registerLazySingleton(() => SignUpViewModel(
        appState: sl(),
        googleMapPlaceDetailsGet: sl(),
        googleMapPlaceGet: sl(),
        googleMapLatLngDetailsGet: sl(),
        registerUser: sl(),
        saveLoginToken: sl(),
        getCurrentUserRemote: sl(),
      ));

  sl.registerLazySingleton(() => SelectLocationViewModel(
      googleMapPlaceDetailsGet: sl(),
      googleMapPlaceGet: sl(),
      googleMapLatLngDetailsGet: sl()));

  sl.registerLazySingleton(() => PersonalInfoViewModel(
      appState: sl(),
      updatePersonalInfo: sl(),
      pickImageFromGallery: sl(),
      getCurrentUserDetails: sl()));

  sl.registerLazySingleton(() => ForgetPasswordViewModel(
      appState: sl(),
      sendForgetPasswordVerifyOtp: sl(),
      sendForgetPasswordOtp: sl()));
  sl.registerLazySingleton(
      () => ResetPasswordViewModel(appState: sl(), sendResetPassword: sl()));

  sl.registerLazySingleton(() => CreateBusinessViewModel(
      createNewBusiness: sl(),
      getCurrentUserDetails: sl(),
      deleteBranchLocationAttachments: sl(),
      pickImageFromGallery: sl(),
      appState: sl(),
      getBusinessCategories: sl()));
  sl.registerLazySingleton(
      () => AllBusinessesViewModel(getAllBusinesses: sl(), appState: sl()));

  sl.registerLazySingleton(() => BusinessDetailViewModel(
      getBusinessDetail: sl(),
      addBusinessProduct: sl(),
      allOffersByBusiness: sl(),
      pickImageFromGallery: sl(),
      getAllProducts: sl(),
      appState: sl(),
      deleteBusiness: sl(),
      getBusinessCategories: sl()));
  sl.registerLazySingleton(() => ProductDetailViewModel(
      getProductDetail: sl(),
      appState: sl(),
      deleteProduct: sl(),
      generateDynamicLink: sl()));
  sl.registerLazySingleton(() => CreateProductViewModel(
      deleteProductLocationAttachments: sl(),
      deleteProductAttachments: sl(),
      appState: sl(),
      pickImageFromGallery: sl(),
      getBusinessLocations: sl(),
      addBusinessProduct: sl(),
      getAllProducts: sl()));

  sl.registerLazySingleton(() => OfferDetailViewModel(
        getOfferDetail: sl(),
        appState: sl(),
      ));
  sl.registerLazySingleton(() => CreateOfferViewModel(
        editProductOffer: sl(),
        getProductsByBusiness: sl(),
        deleteProductOfferAttachments: sl(),
        createOfferResponse: sl(),
        pickImageFromGallery: sl(),
        appState: sl(),
      ));

  sl.registerLazySingleton(() => NotificationViewModel(
      getUserNotification: sl(),
      appState: sl(),
      sendReadNotification: sl(),
      generateDynamicLink: sl()));
  sl.registerLazySingleton(() => SettingsViewModel(
      sendSettings: sl(),
      sendLogout: sl(),
      appState: sl(),
      clearSecureStorage: sl()));
  sl.registerLazySingleton(() => ActivateAccountViewModel(
      appState: sl(),
      sendActivateAccountOtp: sl(),
      sendActivateAccountVerifyOtp: sl()));
}

/// This method will signup all the happiness club merchant use cases
void registerUseCases() {
  sl.registerLazySingleton(() => CheckInternetConnection(sl()));
  sl.registerLazySingleton(() => AppState());
  sl.registerLazySingleton(() => GetAllOffersByBusiness(sl()));
  sl.registerLazySingleton(() => AppBackButtonDispatcher(sl()));
  sl.registerLazySingleton(() => GetImageFromCamera(sl()));
  sl.registerLazySingleton(() => GetUserCountryISO(sl()));
  sl.registerLazySingleton(() => GetAppState(sl()));

  sl.registerLazySingleton(() => HandleDynamicLink(sl()));
  sl.registerLazySingleton(() => GetAppLinkOnAppOpened(sl()));
  sl.registerLazySingleton(() => SaveAppState(sl()));
  sl.registerLazySingleton(() => VerifyEmail(sl()));
  sl.registerLazySingleton(() => GetAppInfo(sl()));
  sl.registerLazySingleton(() => GenerateUDID(sl()));
  sl.registerLazySingleton(() => GetAppUDID(sl()));
  sl.registerLazySingleton(() => IsFirstTimeUsingTheApp(sl()));
  sl.registerLazySingleton(() => ClearSecureStorage(sl()));
  sl.registerLazySingleton(() => GetCurrentUserDetails(sl()));
  sl.registerLazySingleton(() => ClearSharedPreferences(sl()));
  sl.registerLazySingleton(() => LogoutUser(sl()));
  sl.registerLazySingleton(() => CustomerCurrencyGet(sl()));
  sl.registerLazySingleton(() => LocaleSave(sl()));
  sl.registerLazySingleton(() => PickMultipleImagesFromGallery(sl()));
  sl.registerLazySingleton(() => SwitchCulture(sl()));
  sl.registerLazySingleton(() => CultureSave(sl()));
  sl.registerLazySingleton(() => PickFileFromGallery(sl()));
  sl.registerLazySingleton(() => AccessTokenDelete(sl()));
  sl.registerLazySingleton(() => GoogleMapPlaceDetailsGet(sl()));
  sl.registerLazySingleton(() => GoogleMapLatLngDetailsGet(sl()));
  sl.registerLazySingleton(() => GoogleMapPlaceGet(sl()));
  sl.registerLazySingleton(() => SendLogin(sl()));
  sl.registerLazySingleton(() => GetBusinessLocations(sl()));
  sl.registerLazySingleton(() => SaveAccessToken(sl()));
  sl.registerLazySingleton(() => GetSavedAccessToken(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));

  sl.registerLazySingleton(() => GenerateDynamicLink(sl()));

  sl.registerLazySingleton(() => UpdatePersonalInfo(sl()));

  sl.registerLazySingleton(() => PickImageFromGallery(sl()));
  sl.registerLazySingleton(() => SendForgetPasswordOtp(sl()));
  sl.registerLazySingleton(() => SendForgetPasswordVerifyOtp(sl()));
  sl.registerLazySingleton(() => SendLogout(sl()));
  sl.registerLazySingleton(() => SendResetPassword(sl()));
  sl.registerLazySingleton(() => CreateNewBusiness(sl()));
  sl.registerLazySingleton(() => GetBusinessCategories(sl()));
  sl.registerLazySingleton(() => GetAllProducts(sl()));
  sl.registerLazySingleton(() => GetAllBusinesses(sl()));
  sl.registerLazySingleton(() => GetBusinessDetail(sl()));
  sl.registerLazySingleton(() => AddBusinessProduct(sl()));
  sl.registerLazySingleton(() => GetProductDetail(sl()));
  sl.registerLazySingleton(() => DeleteBusiness(sl()));
  sl.registerLazySingleton(() => DeleteProduct(sl()));
  sl.registerLazySingleton(() => GetOfferDetail(sl()));

  sl.registerLazySingleton(() => CreateOfferResponse(sl()));

  sl.registerLazySingleton(() => GetUserNotification(sl()));
  sl.registerLazySingleton(() => SendReadNotification(sl()));
  sl.registerLazySingleton(() => SendSettings(sl()));
  sl.registerLazySingleton(() => SendActivateAccountOtp(sl()));
  sl.registerLazySingleton(() => SendActivateAccountVerifyOtp(sl()));
  sl.registerLazySingleton(() => GetProductsByBusiness(sl()));
  sl.registerLazySingleton(() => DeleteProductAttachments(sl()));
  sl.registerLazySingleton(() => DeleteProductLocationAttachments(sl()));
  sl.registerLazySingleton(() => DeleteProductOfferAttachments(sl()));
  sl.registerLazySingleton(() => EditProductOffer(sl()));
  sl.registerLazySingleton(() => DeleteBranchLocationAttachments(sl()));
}
