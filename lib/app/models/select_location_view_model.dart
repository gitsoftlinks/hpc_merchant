import 'dart:async';
import 'dart:ui' as ui;

import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../app/app_asset_path/images_util.dart';
import '../../../../../app/app_usecase/google_map/google_map_latlang_details_get.dart';
import '../../../../../app/app_usecase/google_map/google_map_place_details_get.dart';
import '../../../../../app/app_usecase/google_map/google_map_place_get.dart';
import '../../../../../services/error/failure.dart';
import '../../../../../utils/permission/permission_engine.dart';
import '../../../../../app/models/places_obj.dart';

class SelectLocationViewModel extends ChangeNotifier {
  final GoogleMapPlaceDetailsGet _googleMapPlaceDetailsGet;
  final GoogleMapPlaceGet _googleMapPlaceGet;
  final GoogleMapLatLngDetailsGet _googleMapLatLngDetailsGet;

  SelectLocationViewModel({
    required GoogleMapPlaceDetailsGet googleMapPlaceDetailsGet,
    required GoogleMapPlaceGet googleMapPlaceGet,
    required GoogleMapLatLngDetailsGet googleMapLatLngDetailsGet,
  })  : _googleMapPlaceDetailsGet = googleMapPlaceDetailsGet,
        _googleMapPlaceGet = googleMapPlaceGet,
        _googleMapLatLngDetailsGet = googleMapLatLngDetailsGet;

  TextEditingController interestAreaController = TextEditingController();
  ValueNotifier<PlaceObject?> interestArea = ValueNotifier(PlaceObject.empty());

  bool isSaveLocationButtonEnabled = false;

  ValueChanged<String>? errorMessages;
  VoidCallback? refreshState;
  ValueNotifier<bool> isLoadingNotifier = ValueNotifier(false);
  SuggestionsBoxController suggestionsBoxController =
      SuggestionsBoxController();
  TextEditingController selectedLocationController = TextEditingController();
  List<Prediction> placesPrediction = [];
  String placeId = '';
  Set<Marker> marker = {};
  double lat = 0.0;
  double long = 0.0;
  late Completer<GoogleMapController> googleMapCompleter = Completer();
  bool branchSelected = false;
  String cityName = '';
  VoidCallback? toggleShowLoader;
  VoidCallback? afterSaveButtonClick;

  void handleError(Either<Failure, dynamic> either) {
    toggleShowLoader?.call();
    isLoadingNotifier.value = false;
    either.fold((l) {
      l.checkAndTakeAction(onError: errorMessages);
    }, (r) => null);
  }

  void clearData() {
    interestAreaController.clear();
  }

  void clearLocationText() {
    selectedLocationController.clear();
    placeId = '';
    notifyListeners();
  }

  Future<void> clearLocation() async {
    selectedLocationController.clear();
    isSaveLocationButtonEnabled = false;
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
        CameraPosition(target: LatLng(lat, long), zoom: 16)));

    notifyListeners();

    refreshState?.call();
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

  void addLocation() {
    interestArea.value = PlaceObject(
        city: cityName,
        locationId: placeId,
        locationName: selectedLocationController.text,
        latitude: lat,
        longitude: long);
    interestAreaController.text = selectedLocationController.text;

    notifyListeners();
    interestAreaController.notifyListeners();

    afterSaveButtonClick?.call();
  }

  Future<List<Prediction>> getPlaces(String place) async {
    var getPlacesEither = await _googleMapPlaceGet.call(place);
    toggleShowLoader?.call();

    if (getPlacesEither.isLeft()) {
      handleError(getPlacesEither);
      return [];
    }
    placesPrediction =
        getPlacesEither.toOption().toNullable()?.predictions ?? [];
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
    print('searched city name : ${placeDetail.addressComponents[2].longName}');
    cityName = placeDetail.addressComponents[2].longName;
    PlaceObject placeObject = PlaceObject(
        locationId: null,
        city: cityName,
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
      handleError(getLatLngDetailEither);
      return;
    }

    selectedLocationController.text = getLatLngDetailEither
        .toOption()
        .toNullable()!
        .results
        .first
        .formattedAddress;
    cityName = getLatLngDetailEither
        .toOption()
        .toNullable()!
        .results
        .first
        .addressComponents[2]
        .longName;
    interestAreaController.text = selectedLocationController.text;

    toggleShowLoader?.call();

    selectedLocationController.notifyListeners();
    isSaveLocationButtonEnabled = true;
    notifyListeners();
    refreshState?.call();
    validateLocationTextFieldsNotEmpty();
  }

  Future<void> onTapMap(LatLng latlng) async {
    toggleShowLoader?.call();

    var getLatLngDetailEither = await _googleMapLatLngDetailsGet
        .call('${latlng.latitude},${latlng.longitude}');
    if (getLatLngDetailEither.isLeft()) {
      handleError(getLatLngDetailEither);
      return;
    }

    var res = getLatLngDetailEither.toOption().toNullable()!;
    selectedLocationController.text = res.results.first.formattedAddress;
    interestAreaController.text = selectedLocationController.text;
    cityName = res.results.first.addressComponents[2].longName;
    PlaceObject placeObject = PlaceObject(
        locationId: null,
        city: res.results.first.addressComponents[2].longName,
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
}
