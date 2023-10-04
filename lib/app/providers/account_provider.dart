import 'package:happiness_club_merchant/utils/constants/user_types_enum.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:happiness_club_merchant/src/features/splash_screen/usecases/get_customer_currency.dart';

import '../../src/features/screens/business/all_business/usecases/get_all_businesses.dart';
import '../../src/features/screens/signin_screen/usecases/send_login.dart';
import '../models/language.dart';

class AccountProvider extends ChangeNotifier {
  List<Language> languages = [];

  late UserData user;

  List<BusinessData> userBusinesses = [];

  ValueNotifier<String> profileImage = ValueNotifier('');
  ValueNotifier<String> userName = ValueNotifier('');

  CustomerCurrencyGetResponse currency = CustomerCurrencyGetResponse.empty();

//  List<RemoteMessage> notifications = [];

  int unreadNotifications = 0;

  void cacheSupportedCurrencyData(CustomerCurrencyGetResponse response) {
    currency = response;
  }

  void cacheRegisteredUserData(UserData response) {
    user = response;
    profileImage.value = user.profileImage;
    userName.value = user.fullName;
    notifyListeners();
  }

  void updateNotifications(message) {
    //  notifications.add(message);
    // unreadNotifications = notifications.length;
    notifyListeners();
  }

  void clearNotifications() {
    // notifications.clear();
    // unreadNotifications = notifications.length;
    notifyListeners();
  }

  void updateNotificationCounter({required int notificationCounter}) {
    unreadNotifications = notificationCounter;
    notifyListeners();
  }

  void upDateUserStatus(StatusTypeEnum status) {
    // user.status = status;
    notifyListeners();
  }

  void updateVisibility(int visibility) {
    //  user.isVisible = visibility;
    notifyListeners();
  }

  void updateShowNotifications(int showNotifications) {
    //  user.notificationsAllowed = showNotifications;
    notifyListeners();
  }
}
