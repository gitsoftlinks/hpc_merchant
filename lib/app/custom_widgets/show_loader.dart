import 'package:happiness_club_merchant/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import '../app_theme/app_theme.dart';

class ShowLoader {
  BuildContext buildContext;
  bool isShowing = false;

  ShowLoader(this.buildContext);

  //rainy

  void toggle() {
    if (isShowing) {
      isShowing = false;
      Navigator.of(navigatorKeyGlobal.currentState!.context,
              rootNavigator: true)
          .pop();
      return;
    }

    var alert = AlertDialog(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const CircularProgressIndicator.adaptive(
            valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
          ),
          SizedBox(width: 10.w),
          Text(
            'loading'.ntr(),
            style: Theme.of(navigatorKeyGlobal.currentState!.context)
                .textTheme
                .bodyText1,
          ),
        ],
      ),
    );
    showDialog(
        barrierDismissible: false,
        context: navigatorKeyGlobal.currentState!.context,
        useRootNavigator: true,
        builder: (_) {
          return WillPopScope(onWillPop: () async => false, child: alert);
        });
    isShowing = true;
  }

  void showLoading(bool show) {
    if (show) {
      if (isShowing) {
        return;
      }
      var alert = AlertDialog(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const CircularProgressIndicator.adaptive(
              valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
            ),
            SizedBox(width: 10.w),
            Text('loading'.ntr()),
          ],
        ),
      );
      showDialog(
          barrierDismissible: false,
          context: navigatorKeyGlobal.currentState!.context,
          useRootNavigator: true,
          builder: (_) {
            return WillPopScope(onWillPop: () async => false, child: alert);
          });
      isShowing = true;
      return;
    }
    if (isShowing) {
      isShowing = false;
      Navigator.of(navigatorKeyGlobal.currentState!.context,
              rootNavigator: true)
          .pop();
    }
  }
}
