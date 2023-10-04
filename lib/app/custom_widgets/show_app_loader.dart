import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../utils/globals.dart';
import '../app_asset_path/images_util.dart';

class ShowAppAnimatedLoader {
  BuildContext buildContext;
  bool isShowing = false;

  ShowAppAnimatedLoader(this.buildContext);

  void toggle() {
    if (isShowing) {
      isShowing = false;
      Navigator.of(buildContext, rootNavigator: true).pop();
      return;
    }

    var alert = AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          color: Colors.transparent,
          alignment: FractionalOffset.center,
          height: MediaQuery.of(navigatorKeyGlobal.currentState!.context).size.height * 0.5,
          width: 120.w,
          child: Lottie.asset(LottieFiles.kAppLoaderLottie, animate: true),
        ));
    showDialog(
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        context: buildContext,
        useRootNavigator: false,
        builder: (_) {
          return WillPopScope(onWillPop: () async => false, child: alert);
        });
    isShowing = true;
  }
}
