import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../app_asset_path/images_util.dart';

class AppLoadingWidget extends StatelessWidget {
  final double height;
  final double width;

  const AppLoadingWidget({
    Key? key,
    required this.height,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: height,
        width: width,
        child: Lottie.asset(LottieFiles.kAppLoaderLottie, animate: true),
      ),
    );
  }
}
