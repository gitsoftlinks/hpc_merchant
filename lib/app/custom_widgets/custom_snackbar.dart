import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:happiness_club_merchant/app/app_theme/app_theme.dart';

showSnackBarMessage(
    {required BuildContext context,
    required String content,
    Color backgroundColor = kPrimaryColor,
    Color contentColor = canvasColor}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 250,
        left: 10.w,
        right: 10.w,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5.r), topRight: Radius.circular(5.r))),
      backgroundColor: backgroundColor,
      content: Text(
        content,
        style: Theme.of(context)
            .textTheme
            .displaySmall!
            .copyWith(fontWeight: FontWeight.w700, color: contentColor),
        overflow: TextOverflow.visible,
      )));
}
