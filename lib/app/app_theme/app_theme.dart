import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  ThemeData lightTheme() => ThemeData(
        fontFamily: 'Inter',
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFFB5873A),
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.white,
            size: 20.w,
          ),
        ),
        primaryColor: const Color(0xFFB5873A),
        canvasColor: Colors.white,
        disabledColor: const Color(0xFF9BAFB8),
        iconTheme: IconThemeData(
          color: Colors.white,
          size: 20.w,
        ),
        cardColor: Colors.white,
        buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.normal),
        textTheme: TextTheme(
            displayLarge: TextStyle(
                color: Colors.black,
                fontSize: 24.0.sp,
                fontWeight: FontWeight.bold),
            displayMedium: TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold),
            displaySmall: TextStyle(
                color: Colors.black,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold),
            headlineMedium: TextStyle(
                color: Colors.black,
                fontSize: 8.sp,
                fontWeight: FontWeight.bold),
            headlineSmall: TextStyle(
                color: Colors.black,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold),
            titleLarge: TextStyle(
                color: Colors.black,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold),
            labelLarge: TextStyle(
                color: canvasColor,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold),
            bodyLarge: TextStyle(
                color: Colors.black,
                fontSize: 15.sp,
                fontWeight: FontWeight.normal),
            bodyMedium: TextStyle(
                color: Colors.black,
                fontSize: 13.sp,
                fontWeight: FontWeight.normal), //paragraph
            titleMedium: TextStyle(
              color: Colors.black,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
            titleSmall: TextStyle(
                color: kPrimaryColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.normal),
            labelMedium: TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500),
            labelSmall: TextStyle(
                color: Colors.black,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400),
            bodySmall: TextStyle(
                color: Colors.black,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400)),
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: const Color(0xFF6E7831).withOpacity(0.4),
          selectionHandleColor: const Color(0xFF6E7831),
          cursorColor: const Color(0xFF6E7831),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.disabled)) {
                    return const Color(0xFFB5873A).withOpacity(0.1);
                  } else {
                    return const Color(0xFFB5873A);
                  }
                }),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r))),
                minimumSize: MaterialStateProperty.all(
                    Size(double.infinity, kButtonHeight)))),
        scaffoldBackgroundColor: Colors.white,
        dividerColor: const Color(0xFFe6e6e6),
        cardTheme: const CardTheme(color: Colors.white),
        colorScheme: ColorScheme.fromSwatch(
          errorColor: Colors.red,
        ).copyWith(error: const Color(0xFFFF4444)),
      );
}

const kDisabledColor = Color(0xFFe6e6e6);
const Color kPrimaryColor = Color(0xFFB5873A);
const Color kErrorColor = Colors.red;
const Color canvasColor = Colors.white;
const Color dropdownColor = Color(0xFF292D32);
Color kLightGreenColor = kPrimaryColor.withOpacity(0.2);

const kElevationColor = Color(0xFFE5EFFD);
const kInputHintColor = Color(0xFF9BAFB8);
const kBorderColor = Color.fromRGBO(155, 175, 184, 1);
const kDisabledTextColor = Color(0xFF808080);
const kGreyTextColor = Color(0xFF666666);
const kColor = Color(0xFF6D6D6D);
const kcomment = Color(0xFF787878);
const comment = Color(0xFF9BAFB8);
const kaLightGrey = Color(0xFF9BAFB8);

const Color kWhiteColor = Colors.white;
const Color inputFieldBorderColor = Color(0xFF9BAFB8);
const Color focusedInputFieldBorderColor = Color(0xFF6E7831);
const Color kNotificationColor = Color(0xFFFF4444);
const Color kToolTipBGColor = Color(0xFFB1DAFF);

/// Toast Colors
const Color toastBgColor = Color(0xFFE5E5E5);
const Color kToastTextColor = Colors.black;

const Color kSuccessColor = Color(0xff17D85C);
const Color kFailedColor = Color(0xffFBE2E6);
const Color kBlackColor = Colors.black;

const Color kHistoryDividerColor = Color(0xffF3F3F3);
const Color kTitleColor = Color(0xffD1EBF6);
const Color kBrownTitleColor = Color(0xff7B6F72);
const Color backGroundColor = Color.fromRGBO(240, 241, 233, 1);

double fieldHeight = 48.h;
Radius fieldRadius = Radius.circular(12.r);
Radius kBottomSheetRadius = Radius.circular(20.r);
BorderRadius kBottomSheetRadius2 = BorderRadius.circular(20.r);
double fieldRadiusDouble = 12.r;
BorderRadius fieldBorderRadius = BorderRadius.circular(fieldRadiusDouble);
double kButtonHeight = 48.h;
