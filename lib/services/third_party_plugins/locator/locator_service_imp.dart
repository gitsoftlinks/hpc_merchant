


import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:happiness_club_merchant/services/third_party_plugins/locator/locator_service.dart';

import '../../../utils/constants/app_strings.dart';
import '../../error/failure.dart';

class LocatorServiceImp implements LocatorService {
  GeolocatorPlatform geolocatorPlatform;
  GeocodingPlatform geocodingPlatform;

  LocatorServiceImp(
      {required this.geolocatorPlatform, required this.geocodingPlatform});

  @override
  Future<bool> hasPermission() async {
    var _permissionGranted = await geolocatorPlatform.checkPermission();

    // LocationPermission.whileInUse != LocationPermission.whileInUse && LocationPermission.whileInUse != LocationPermission.always
    // false && true => false

    // LocationPermission.always != LocationPermission.whileInUse && LocationPermission.always != LocationPermission.always
    // true && false => false

    if (_permissionGranted != LocationPermission.whileInUse &&
        _permissionGranted != LocationPermission.always) {
      return false;
    }

    return true;
  }

  @override
  Future<String> getUserCountryLocationISOCode() async {
    try {
      var position = await geolocatorPlatform.getLastKnownPosition();

      position ??= await geolocatorPlatform.getCurrentPosition();

      var list = await geocodingPlatform.placemarkFromCoordinates(
          position.latitude, position.longitude,
          localeIdentifier: 'en_US');

      if (list.isEmpty || list.first.isoCountryCode == null) {
        throw NO_PLACE_MARK_FOUND;
      }

      return list.first.isoCountryCode!;
    } on LocationServiceDisabledException catch (_) {
      throw GPSOffFailure(GPS_DISABLED);
    } on NoResultFoundException catch (_) {
      throw NoResultsFoundFailure(SOMETHING_WENT_WRONG);
    } on PlatformException catch (e) {
      if (e.code == 'IO_ERROR') {
        throw NetworkFailure(NO_INTERNET);
      }
      throw SOMETHING_WENT_WRONG;
    } catch (e) {
      throw SOMETHING_WENT_WRONG;
    }
  }
}
