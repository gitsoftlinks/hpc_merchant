import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../app_theme/app_theme.dart';

getToastWidget(
        BuildContext context, Color color, String msg, bool addBottomMargin) =>
    Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      margin: addBottomMargin ? EdgeInsets.only(bottom: 190.h) : null,
      width: 0.9.sw,
      // height: 56.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0.r),
        color: color,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const RotatedBox(
            quarterTurns: 2,
            child: Icon(Icons.info),
          ),
          const SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10.h),
              child: Text(
                msg,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontSize: 16.sp, color: Theme.of(context).canvasColor),
              ),
            ),
          ),
        ],
      ),
    );

showErrorToast(BuildContext context, String msg,
    [bool addBottomMargin = false]) {
  Fluttertoast.showToast(msg: msg);
  // if (!context.mounted) return;
  // FToast fToast = FToast();
  // fToast.init(context);
  // fToast.showToast(
  //   child: getToastWidget(
  //       context, Theme.of(context).errorColor, msg, addBottomMargin),
  //   gravity: ToastGravity.BOTTOM,
  //   toastDuration: const Duration(seconds: 5),
  // );
}

showSuccessToast(BuildContext context, String msg,
    [bool addBottomMargin = false]) {
  FToast fToast = FToast();
  fToast.init(context);
  fToast.showToast(
    child: getToastWidget(context, kSuccessColor, msg, addBottomMargin),
    gravity: ToastGravity.BOTTOM,
    toastDuration: const Duration(seconds: 5),
  );
}

showSimpleToast(BuildContext context, String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    fontSize: 12.sp,
    textColor: kToastTextColor,
    backgroundColor: toastBgColor,
  );
}
