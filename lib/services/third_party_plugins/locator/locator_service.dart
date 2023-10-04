abstract class LocatorService {
  /// This method checks if the location is enabled or not
  /// [Output] : [bool] tells whether the permission is granted or not
  Future<bool> hasPermission();

  /// This method returns the user current country code ISO
  /// [Output]: [String] ISO of the country
  /// [Exceptions]: throws [NO_PLACE_MARK_FOUND] if no country found
  /// [GPS_DISABLED] if GPS service is off
  /// [SOMETHING_WENT_WRONG] for all other exceptions
  Future<String> getUserCountryLocationISOCode();
}
