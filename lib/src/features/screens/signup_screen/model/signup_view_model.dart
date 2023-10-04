import 'dart:async';
import 'dart:ui' as ui;

import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import 'package:happiness_club_merchant/utils/router/app_state.dart';
import 'package:happiness_club_merchant/utils/router/models/page_action.dart';
import 'package:happiness_club_merchant/utils/router/models/page_config.dart';
import 'package:dartz/dartz.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../app/app_asset_path/images_util.dart';
import '../../../../../app/app_usecase/get_current_user_details.dart';
import '../../../../../app/app_usecase/google_map/google_map_latlang_details_get.dart';
import '../../../../../app/app_usecase/google_map/google_map_place_details_get.dart';
import '../../../../../app/app_usecase/google_map/google_map_place_get.dart';
import '../../../../../app/app_usecase/save_access_token.dart';
import '../../../../../app/models/user_runtime_config.dart';
import '../../../../../app/providers/account_provider.dart';
import '../../../../../app/validator/text_field_validator.dart';
import '../../../../../services/error/failure.dart';
import '../../../../../services/usecases/usecase.dart';
import '../../../../../utils/permission/permission_engine.dart';
import '../../../../../app/models/places_obj.dart';
import '../../../home/model/home_view_model.dart';
import '../usecases/register_user.dart';

class SignUpViewModel extends ChangeNotifier {
  final AppState _appState;
  final GoogleMapPlaceDetailsGet _googleMapPlaceDetailsGet;
  final GoogleMapPlaceGet _googleMapPlaceGet;
  final GoogleMapLatLngDetailsGet _googleMapLatLngDetailsGet;
  final RegisterUser _registerUser;
  final SaveAccessToken _saveLoginToken;
  final GetCurrentUserDetails _getCurrentUserRemote;

  SignUpViewModel({
    required AppState appState,
    required GoogleMapPlaceDetailsGet googleMapPlaceDetailsGet,
    required GoogleMapPlaceGet googleMapPlaceGet,
    required GoogleMapLatLngDetailsGet googleMapLatLngDetailsGet,
    required RegisterUser registerUser,
    required SaveAccessToken saveLoginToken,
    required GetCurrentUserDetails getCurrentUserRemote,
  })  : _appState = appState,
        _googleMapPlaceDetailsGet = googleMapPlaceDetailsGet,
        _googleMapPlaceGet = googleMapPlaceGet,
        _googleMapLatLngDetailsGet = googleMapLatLngDetailsGet,
        _registerUser = registerUser,
        _saveLoginToken = saveLoginToken,
        _getCurrentUserRemote = getCurrentUserRemote;

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController interestAreaController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  List addedLocation = [];
  // device_location.Location deviceLocation = device_location.Location();
  // device_location.Location currentLocation = device_location.Location();

  TextEditingController confirmPasswordController = TextEditingController();
  ValueNotifier<bool> isHidden = ValueNotifier(true);
  bool isButtonEnabled = false;
  bool isSaveLocationButtonEnabled = false;
  PlaceObject interestArea = PlaceObject.empty();
  VoidCallback? toggleShowLoader;
  VoidCallback? closeBottomSheet;
  ValueNotifier<String> emailErrorText = ValueNotifier('');

  ValueChanged<String>? errorMessages;
  ValueNotifier<bool> isLoadingNotifier = ValueNotifier(false);
  SuggestionsBoxController suggestionsBoxController =
      SuggestionsBoxController();
  TextEditingController selectedLocationController = TextEditingController();
  List<Prediction> placesPrediction = [];
  String placeId = '';
  Set<Marker> marker = {};
  double lat = 0.0;
  double long = 0.0;
  late Completer<GoogleMapController> googleMapCompleter;
  final signUpFormKey = GlobalKey<FormState>();

  void handleError(Either<Failure, dynamic> either) {
    toggleShowLoader?.call();
    isLoadingNotifier.value = false;
    either.fold((l) {
      l.checkAndTakeAction(onError: errorMessages);
    }, (r) => null);
  }

  Future<void> init() async {
    clearData();
  }

  void clearData() {
    interestAreaController.clear();
    passwordController.clear();
    emailController.clear();
    fullNameController.clear();
    confirmPasswordController.clear();
    phoneNumberController.clear();
    selectedLocationController.clear();
    notifyListeners();
  }

  void clearLocationText() {
    selectedLocationController.clear();
    placeId = '';
    notifyListeners();
  }

  /// This method will get the location of tapped list item
  Future<void> getTappedLocation() async {
    final Uint8List markerIcon =
        await getBytesFromAsset(PngAssetsPath.markerImage, 100);
    marker.clear();
    marker.add(Marker(
        markerId: const MarkerId(''),
        draggable: true,
        icon: BitmapDescriptor.fromBytes(markerIcon),
        onDragEnd: onMarkerDrag,
        position: LatLng(lat, long)));
    final GoogleMapController controller = await googleMapCompleter.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, long), zoom: 17)));
    notifyListeners();
  }

  /// This method will get user's current location from user
  Future<void> getUserCurrentLocation() async {
    Position? location = await _determinePosition();

    if (location == null) {
      lat = 0.0;
      long = 0.0;
    } else {
      lat = location.latitude;
      long = location.longitude;
    }

    // var location = await currentLocation.getLocation();
    // var location = await currentLocation.getLocation();
    final Uint8List markerIcon =
        await getBytesFromAsset(PngAssetsPath.markerImage, 100);

    marker.clear();
    marker.add(Marker(
        markerId: const MarkerId(''),
        draggable: true,
        icon: BitmapDescriptor.fromBytes(markerIcon),
        onDragEnd: onMarkerDrag,
        position: LatLng(lat, long)));

    final GoogleMapController controller = await googleMapCompleter.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, long), zoom: 17)));
    notifyListeners();
  }

  Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return null;
      }
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  /// This method will get location permission from user
  void initPermissionAndLocation({required bool isTappedOnLocation}) async {
    var engine = GetIt.I.get<PermissionEngine>();

    var isGranted = await engine.resolvePermission(CustomPermission.location);

    if (isGranted) {
      if (isTappedOnLocation) {
        await getTappedLocation();
      } else {
        await getUserCurrentLocation();
      }
    }
  }

  /// This method check requirements for the api call
  void validateTextFieldsNotEmpty() {
    emailErrorText.value = '';
    if (fullNameController.text.isNotEmpty &&
        phoneNumberController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty &&
        TextFieldValidator.isPasswordCompliant(passwordController.text) ==
            null &&
        TextFieldValidator.validateRequiredEmail(emailController.text) ==
            null &&
        TextFieldValidator.validateConfirmPassword(
                confirmPasswordController.text, passwordController.text) ==
            null) {
      isButtonEnabled = true;
      notifyListeners();
      return;
    }
    isButtonEnabled = false;
    notifyListeners();
  }

  Future<void> clearLocation() async {
    selectedLocationController.clear();
    notifyListeners();
  }

  void addLocation() {
    interestArea = PlaceObject(
        city: '',
        locationId: placeId,
        locationName: selectedLocationController.text,
        latitude: lat,
        longitude: long);
    interestAreaController.text = selectedLocationController.text;
    validateTextFieldsNotEmpty();
    notifyListeners();
    interestAreaController.notifyListeners();
  }

  Future<List<Prediction>> getPlaces(String place) async {
    var getPlacesEither = await _googleMapPlaceGet.call(place);
    toggleShowLoader?.call();

    if (getPlacesEither.isLeft()) {
      handleError(getPlacesEither);
      return [];
    }
    placesPrediction = getPlacesEither.toOption().toNullable()!.predictions;
    toggleShowLoader?.call();

    notifyListeners();
    return placesPrediction;
  }

  Future<void> updateGoogleMapWithPlaceId(String placeId) async {
    toggleShowLoader?.call();
    var getPlaceDetailEither = await _googleMapPlaceDetailsGet.call(placeId);

    if (getPlaceDetailEither.isLeft()) {
      handleError(getPlaceDetailEither);
      return;
    }
    var placeDetail = getPlaceDetailEither.toOption().toNullable()!;
    PlaceObject placeObject = PlaceObject(
        locationId: null,
        city: '',
        locationName: placeDetail.name,
        latitude: placeDetail.geometry.location.lat,
        longitude: placeDetail.geometry.location.lng);
    await updateMap(placeObject, false);
    placeId = placeDetail.placeId;

    toggleShowLoader?.call();
    notifyListeners();

    return;
  }

  void onMarkerDrag(LatLng latlng) async {
    toggleShowLoader?.call();

    var getLatLngDetailEither = await _googleMapLatLngDetailsGet
        .call('${latlng.latitude},${latlng.longitude}');
    if (getLatLngDetailEither.isLeft()) {
      // handleError(getLatLngDetailEither);
      toggleShowLoader?.call();
      return;
    }

    selectedLocationController.text = getLatLngDetailEither
        .toOption()
        .toNullable()!
        .results
        .first
        .formattedAddress;
    interestAreaController.text = selectedLocationController.text;
    toggleShowLoader?.call();
    selectedLocationController.notifyListeners();
    validateLocationTextFieldsNotEmpty();
  }

  Future<void> onTapMap(LatLng latlng) async {
    toggleShowLoader?.call();

    var getLatLngDetailEither = await _googleMapLatLngDetailsGet
        .call('${latlng.latitude},${latlng.longitude}');
    if (getLatLngDetailEither.isLeft()) {
      toggleShowLoader?.call();
      // handleError(getLatLngDetailEither);
      return;
    }

    var res = getLatLngDetailEither.toOption().toNullable()!;
    selectedLocationController.text = res.results.first.formattedAddress;
    interestAreaController.text = selectedLocationController.text;
    PlaceObject placeObject = PlaceObject(
        locationId: null,
        city: '',
        locationName: res.results.first.formattedAddress,
        latitude: res.results.first.geometry.location.lat,
        longitude: res.results.first.geometry.location.lng);
    await updateMap(placeObject, true);
    placeId = res.results.first.placeId;

    toggleShowLoader?.call();
    selectedLocationController.notifyListeners();
    interestAreaController.notifyListeners();
    validateLocationTextFieldsNotEmpty();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<void> updateMap(PlaceObject country, bool isTaped) async {
    final Uint8List markerIcon =
        await getBytesFromAsset(PngAssetsPath.markerImage, 100);

    if (country.latitude != 0 && country.longitude != 0) {
      lat = country.latitude;
      long = country.longitude;
      marker.clear();
      marker.add(Marker(
        draggable: true,
        markerId: MarkerId(country.locationName),
        position: LatLng(country.latitude, country.longitude),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        onDragEnd: onMarkerDrag,
      ));
      final GoogleMapController controller = await googleMapCompleter.future;
      if (isTaped) {
        controller.animateCamera(CameraUpdate.newLatLng(LatLng(lat, long)));
      } else {
        controller.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(lat, long), zoom: 17)));
      }
      notifyListeners();
    }
  }

  void validateLocationTextFieldsNotEmpty() {
    if (selectedLocationController.text.isNotEmpty) {
      isSaveLocationButtonEnabled = true;
      notifyListeners();
      return;
    }
    isSaveLocationButtonEnabled = false;
    selectedLocationController.notifyListeners();
    notifyListeners();
  }

  void signup() async {
    isLoadingNotifier.value = true;
    notifyListeners();

    var params = RegisterUserParams(
      fullName: fullNameController.text,
      email: emailController.text,
      phoneNumber: phoneNumberController.text,
      password: passwordController.text,
    );

    var registerUserEither = await _registerUser.call(params);

    //  var fcmToken = await FirebaseMessaging.instance.getToken();

    // if (fcmToken?.isNotEmpty ?? false) {
    //   _updateFcmToken
    //       .call(UpdateFcmTokenParam(fcmToken: fcmToken ?? '', accessToken: ''));
    // }

    if (registerUserEither.isLeft()) {
      isLoadingNotifier.value = false;
      registerUserEither.fold((l) {
        if (l is UserAlreadyExistFailure) {
          emailErrorText.value = 'user already exists'.ntr();
          notifyListeners();
          return;
        }
        l.checkAndTakeAction(onError: errorMessages);
      }, (r) => null);

      return;
    }

    var user = registerUserEither.toOption().toNullable()!;
    print("token : ${user.token}");
    await saveLoginToken(user.token);
    isLoadingNotifier.value = false;
    notifyListeners();

    await getUserDetails();

    isLoadingNotifier.value = false;
    signUpFormKey.currentState?.reset();
    clearData();
  }

  Future<void> saveLoginToken(String token) async {
    var saveTokenEither = await _saveLoginToken.call(token);

    if (saveTokenEither.isLeft()) {
      handleError(saveTokenEither);
      return;
    }
  }

  Future<void> getUserDetails() async {
    isLoadingNotifier.value = true;
    notifyListeners();

    var userInfoEither = await _getCurrentUserRemote.call(NoParams());

    if (userInfoEither.isLeft()) {
      handleError(userInfoEither);
      return;
    }

    var user = userInfoEither.toOption().toNullable()!.user;
    GetIt.I.get<AccountProvider>().cacheRegisteredUserData(user);
    GetIt.I.get<UserRuntimeConfig>().isLogin = true;

    isLoadingNotifier.value = false;
    GetIt.I.get<HomeViewModel>().controller.index = 0;

    _appState.currentAction =
        PageAction(state: PageState.replaceAll, page: HomeScreenConfig);
    notifyListeners();
  }

  void moveToSignInScreen() {
    _appState.currentAction =
        PageAction(state: PageState.addPage, page: SignInScreenConfig);
  }

  void initializeCloseMap() async {
    toggleShowLoader?.call();
    await Future.delayed(const Duration(seconds: 3));
    closeBottomSheet?.call();
    toggleShowLoader?.call();
  }
}
