class PlaceObject {
  final String? locationId;
  final String locationName;
  final String city;
  final double latitude;
  final double longitude;

  PlaceObject(
      {required this.locationId,
      required this.locationName,
      required this.latitude,
      required this.longitude,
      required this.city});

  factory PlaceObject.empty() {
    return PlaceObject(
        locationId: '0', locationName: '', latitude: 0, longitude: 0, city: '');
  }

  factory PlaceObject.fromJson(Map<String, dynamic> json) {
    return PlaceObject(
        locationId: json['locationId'],
        locationName: json['locationName'],
        latitude: json['latitude'],
        city: json['city'],
        longitude: json['longitude']);
  }

  Map<String, dynamic> toJson() => {
        'locationId': locationId,
        'locationName': locationName,
        'latitude': latitude,
        'city': city,
        'longitude': longitude
      };
}
