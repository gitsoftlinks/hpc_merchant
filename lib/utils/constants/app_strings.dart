// ignore_for_file: non_constant_identifier_names

import 'package:happiness_club_merchant/utils/extensions/extensions.dart';

final String NO_INTERNET = 'no_internet'.ntr();
final String SOMETHING_WENT_WRONG = 'something_went_wrong'.ntr();
final String DYNAMIC_LINK_ERROR = 'something_went_wrong_with_dynamic_link'.ntr();
final String NO_IP_ADDRESS_FOUND = 'no_ip_address_found'.ntr();
final Map<String, String> deviceInfo = {"buildId": "", "device": "", "deviceId": "", "deviceUniqueId": "", "manufacturer": ""};

const String DEVICE_UNIQUE_ID = "deviceUniqueId";
const String DEVICE_ID = "deviceId";
const String DEVICE_INFO = "deviceInfo";
const String DEVICE = "device";
const String MANUFACTURER = "manufacturer";
const String BUILD_ID = "buildId";
const String SELFIE = "SELFIE";
const String ID_DOC = "ID_DOC";

final String GPS_DISABLED = 'gps_is_disabled'.ntr();
final String NO_PLACE_MARK_FOUND = 'no_placemark_found'.ntr();

const String ANDROID_VERSION_CONSTANT = '1.0.0+1';
const String IOS_VERSION_CONSTANT = '1.0.0+1';

bool userUsingFirstTimeApp = false;

const double MAX_IMAGE_HEIGHT = 480;
const double MAX_IMAGE_WIDTH = 640;
const double IMAGE_QUALITY = 0.8;
const String FAKE = 'fake-email';
const int RENTER = 1;
const int CAROWNER = 2;
