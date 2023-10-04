import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app_theme/app_theme.dart';

InputDecoration customDropdownDecoration(
    {required BuildContext context,
    required String hintText,
    required String labelText}) {
  return InputDecoration(
    hintText: hintText,
    labelText: labelText,
    hintStyle: Theme.of(context)
        .textTheme
        .bodyText2!
        .copyWith(color: Theme.of(context).disabledColor, fontSize: 16.sp),
    labelStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
          color: Theme.of(context).disabledColor,
          fontSize: 16.sp,
        ),
    contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 13.h),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.all(fieldRadius),
        borderSide: const BorderSide(color: kBorderColor)),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Theme.of(context).disabledColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(fieldRadius),
      borderSide: const BorderSide(color: focusedInputFieldBorderColor),
    ),
    focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).errorColor)),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 1.0, color: Theme.of(context).errorColor),
    ),
    errorStyle: TextStyle(fontSize: 10.sp, height: 0.3),
  );
}
