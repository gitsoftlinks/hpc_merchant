import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:images_picker/images_picker.dart';
import 'package:mime/mime.dart';

import '../../app/custom_widgets/direction.dart';
import '../../services/error/failure.dart';
import '../constants/selected_currency_enum.dart';
import '../globals.dart';
import '../router/app_state.dart';

extension TranslationTesting on String {
  String ntr({Map<String, String>? args}) {
    try {
      return this.tr(namedArgs: args);
    } catch (e) {
      return this;
    }
  }
}

extension ScaffoldHelper on BuildContext? {
  void show(
      {required String message,
      SnackBarBehavior? snackBarBehavior = SnackBarBehavior.fixed}) {
    if (this == null) {
      return;
    }

    ScaffoldMessenger.maybeOf(this!)
      ?..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        behavior: snackBarBehavior,
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        duration: Duration(seconds: 2),
      ));
  }

  void showMainScreenSnack(
      {required String message,
      SnackBarBehavior? snackBarBehavior = SnackBarBehavior.fixed}) {
    if (this == null) {
      return;
    }

    ScaffoldMessenger.maybeOf(this!)
      ?..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        padding: EdgeInsetsDirectional.only(
            bottom: AppBar().preferredSize.height * 0.85, top: 10),
        backgroundColor: Colors.black,
        duration: Duration(seconds: 2),
        content: Text(
          message,
          style: TextStyle(
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ));
  }
}

enum ImageExtension { SVG, PNG }

extension ColorExtension on String {
  toColor() {
    var hexColor = replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}

extension FileSizeCalculator on String {
  // This method gets the size of image
  double calculateFileSize() {
    var file = File(this);
    final bytes = file.lengthSync();
    final kb = bytes / 1024;
    final mb = kb / 1024;
    return mb;
  }
}

extension PhoneNumberFormatter on String {
  String formatPhoneNumber() {
    var phoneNumber = this;

    if (phoneNumber.split('').first == '0') {
      phoneNumber = phoneNumber.substring(1);
    }

    return phoneNumber;
  }
}

extension LocaleHelper on Locale {
  String getLocaleStringFromLocaleObject() =>
      "${languageCode}${countryCode == null ? "" : "-${countryCode}"}";
}

extension FixedLengthString on num {
  String truncateToDecimalPlaces(int fractionalDigits) {
    var value = (this * pow(10, fractionalDigits)).truncate() /
        pow(10, fractionalDigits);
    return value.toStringAsFixed(fractionalDigits);
  }

  double truncateToDecimalPlacesDouble(int fractionalDigits) {
    var value = (this * pow(10, fractionalDigits)).truncate() /
        pow(10, fractionalDigits);
    return double.parse(value.toStringAsExponential(fractionalDigits));
  }
}

extension NoInternetConnectionHelper on Failure {
  void checkAndTakeAction({required ValueChanged<String>? onError}) {
    var appState = GetIt.I.get<AppState>();
    if (this is NetworkFailure) {
      appState.moveToNoInternetScreen();
    }
    if (this is LoginTokenExpiredFailure || this is TooManyAttemptsFailure) {
      // appState.moveToPasscodeBiometricScreen();
    } else {
      onError?.call(message);
    }
  }
}

/// to get total number of days in a month
extension DaysInMonthExtension on DateTime {
  int get daysInMonth {
    return DateTime(year, month + 1, 1)
        .difference(DateTime(year, month, 1))
        .inDays;
  }
}

extension FormatDate on String {
  DateTime formatRF822Time() {
    var offsetDuration = DateTime.now().timeZoneOffset;

    var parsedTime = DateTime.parse(this);

    offsetDuration.isNegative
        ? parsedTime = parsedTime.subtract(offsetDuration)
        : parsedTime = parsedTime.add(offsetDuration);

    return parsedTime;
  }
}

extension DateTimeX on DateTime {
  bool isUnderage() =>
      (DateTime(DateTime.now().year, month, day).isAfter(DateTime.now())
          ? DateTime.now().year - year - 1
          : DateTime.now().year - year) <
      18;

  bool expiresIn2Month() {
    var now = DateTime.now();
    var result = isAfter(DateTime(now.year, now.month + 2, now.day));
    return result;
  }

  bool expiresIn6Month() {
    var now = DateTime.now();
    var result = isAfter(DateTime(now.year, now.month + 6, now.day));
    return result;
  }
}

extension FormatWithCurrentDay on String {
  String formatWithCurrentDay() {
    var formattedDate = '';
    var now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day);

    var date = formatRF822Time();
    date = DateTime(date.year, date.month, date.day);

    if (date == today) {
      formattedDate = formatRF822Time().showTodayDateTime();
    } else {
      var format = DateFormat('MMM dd HH:mm');
      formattedDate = format.format(formatRF822Time());
    }
    return formattedDate;
  }
}

extension FormatISOTime on DateTime {
  ///converts date into the following format:
  /// or 2019-06-04T12:08:56-0700
  String formatISOTime() {
    var duration = timeZoneOffset;
    var formatDate = DateFormat('yyyy-MM-dd', 'en_US').add_Hms();
    var date = formatDate.format(this);
    if (duration.isNegative) {
      return (date +
          "-${duration.inHours.toString().padLeft(2, '0')}${(duration.inMinutes - (duration.inHours * 60)).toString().padLeft(2, '0')}");
    } else {
      return (date +
          "+${duration.inHours.toString().padLeft(2, '0')}${(duration.inMinutes - (duration.inHours * 60)).toString().padLeft(2, '0')}");
    }
  }

  String formatEventDateTimeWithCurrentDay() {
    var now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day);

    // var date = formatRF822Time();
    var date = DateTime(year, month, day);

    if (date == today) {
      if (minute >= 0 && minute < 10) {
        return '${'today_at'.ntr()} $hour:0$minute';
      }
      return '${'today_at'.ntr()} $hour:$minute';
    } else {
      var time = '';
      if (minute >= 0 && minute < 10) {
        time = '$hour:0$minute';
      } else {
        time = '$hour:$minute';
      }
      var formattedDate = '${DateFormat(
        'dd MMM',
        EasyLocalization.of(navigatorKeyGlobal.currentContext!)
            ?.currentLocale
            .toString(),
      ).format(this)} ${'at'.ntr()} $time';

      return formattedDate;
    }
  }

  String showTodayDateTime() {
    var dateTime = this;
    if (dateTime.minute >= 0 && dateTime.minute < 10) {
      return '${'today'.ntr()}, ${dateTime.hour}:0${dateTime.minute}';
    }
    return '${'today'.ntr()}, ${dateTime.hour}:${dateTime.minute}';
  }

  String showTimeOnly() {
    var format = DateFormat('HH:mm', currentLocale);
    return format.format(this);
  }

  String serializeServerDateTime() {
    var utcTime = toUtc();
    return utcTime.formatISOTime();
  }

  String serializeServerEndDateTime() {
    var utcTime = toUtc();
    utcTime = utcTime.add(Duration(seconds: 5));
    return utcTime.formatISOTime();
  }

  ///converts date into the following format:
  /// or 2019-06-04
  String getDateOnly() {
    if (currentLocale.contains('ar')) {
      var format = DateFormat('dd MMMM yyyy', currentLocale);
      return format.format(this);
    } else {
      var format = DateFormat('dd MMM yyyy', currentLocale);
      return format.format(this);
    }
  }
}

extension ToDateTime on String {
  DateTime toDateTime() {
    if (currentLocale.contains('ar')) {
      var format = DateFormat('ddd MMMM yyyy', currentLocale);
      return format.parse(this);
    } else {
      var format = DateFormat('dd MMM yyyy', currentLocale);
      return format.parse(this);
    }
  }

  String toDateTimeForAPI() {
    if (currentLocale.contains('ar')) {
      var format = DateFormat('ddd MMMM yyyy', currentLocale);
      var parsedDate = format.parse(this);
      var formatDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss", 'en_US');

      return formatDate.format(parsedDate);
    } else {
      var format = DateFormat('dd MMM yyyy', currentLocale);
      var parsedDate = format.parse(this);
      var formatDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss", 'en_US');

      return formatDate.format(parsedDate);
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

extension GetWeekChar on num {
  String getWeekChar() {
    var day = '';
    switch (this) {
      case 1:
        day = 'mon';
        break;
      case 2:
        day = 'tue';
        break;
      case 3:
        day = 'wed';
        break;
      case 4:
        day = '${'thu'} ';
        break;
      case 5:
        day = ' ${'fri'}';
        break;
      case 6:
        day = '${'sat'} ';
        break;
      case 7:
        day = 'sun';
        break;
    }
    return '$day';
  }
}

enum DurationEnum { week, month, year }

extension ScheduleTypeEnumPar on String {
  DurationEnum toDurationEnum() {
    return DurationEnum.values.firstWhere(
        (e) => e.toString().toLowerCase() == 'DurationEnum.$this'.toLowerCase(),
        orElse: () => DurationEnum.week); //return null if not found
  }
}

extension ScheduleTypeEnumDePar on DurationEnum {
  String toStringDuration() {
    return toString().split('.').last; //return null if not found
  }
}

extension ChartMaxYxis on int {
  double getMaxValue() {
    var maxValue = 0.0;
    switch (this) {
      case 1:
        maxValue = 10;
        break;
      case 2:
        maxValue = 100;
        break;
      case 3:
        maxValue = 1000;
        break;
      case 4:
        maxValue = 10000;
        break;
      case 5:
        maxValue = 100000;
        break;
      case 6:
        maxValue = 1000000;
        break;
      case 7:
        maxValue = 10000000;
        break;
      case 8:
        maxValue = 100000000;
        break;
      default:
        maxValue = 10000;
    }
    return maxValue;
  }
}

extension GetJsonFromJWT on String {
  bool isTokenExpired() {
    var splittedString = split('.')[1];
    var normalizedSource = base64Url.normalize(splittedString);
    var jsonString = utf8.decode(base64Url.decode(normalizedSource));

    final expirationDate = DateTime.fromMillisecondsSinceEpoch(0)
        .add(Duration(seconds: jsonDecode(jsonString)['exp'].toInt()));

    final thresholdDate = DateTime.now().add(Duration(seconds: 30));

    return thresholdDate.isAfter(expirationDate);
  }

  bool isRefreshNeeded() {
    var splittedString = split('.')[1];
    var normalizedSource = base64Url.normalize(splittedString);
    var jsonString = utf8.decode(base64Url.decode(normalizedSource));

    final expirationDate = DateTime.fromMillisecondsSinceEpoch(0)
        .add(Duration(seconds: jsonDecode(jsonString)['exp'].toInt()));

    final thresholdDate = DateTime.now().add(Duration(minutes: 2));

    return thresholdDate.isAfter(expirationDate);
  }
}

extension SelectedCurrecnyFlag on SelectedCurrencyEnum {
  String getSelectedCurrencyFlag() {
    switch (this) {
      case SelectedCurrencyEnum.USD:
        return 'SvgAssetsPaths.flagUSAPng';
      case SelectedCurrencyEnum.JOD:
        return 'SvgAssetsPaths.flagEUPng';
      case SelectedCurrencyEnum.SAR:
        return 'SvgAssetsPaths.flagGBPPng';
    }
  }
}

extension LocaleString on Locale? {
  String getLocaleForHelpCenter() {
    var easyLocalizationLocale = this ?? Locale('en', 'US');
    var countryCode = easyLocalizationLocale.countryCode ?? '';

    var locale =
        "${easyLocalizationLocale.languageCode}${countryCode.isEmpty ? "" : "-${countryCode.toLowerCase()}"}";

    return locale;
  }
}

extension PickTypePar on String {
  PickType toSelectedMediaTypeEnum() {
    return PickType.values.firstWhere(
        (e) => e.toString().toLowerCase() == 'PickType.$this'.toLowerCase(),
        orElse: () => PickType.all);
  }
}

extension FileTypePar on String {
  bool isVideoType() {
    String? mimeStr = lookupMimeType(this);
    var fileType = mimeStr!.split('/');
    var filePickType = fileType[0].toSelectedMediaTypeEnum();
    switch (filePickType) {
      case PickType.all:
      case PickType.image:
        return false;
      case PickType.video:
        return true;
    }
  }
}

extension FilePar on File {
  Object getFile() {
    Object fileData = <Object>{};
    fileData = MultipartFile.fromFileSync(path);

    return fileData;
  }
}
