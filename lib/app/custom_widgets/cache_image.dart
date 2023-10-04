import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageContainer extends StatelessWidget {
  final ImageProvider imageProvider;
  final double height;
  final double width;

  const ImageContainer(
      {Key? key,
      required this.imageProvider,
      required this.height,
      required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class AppProgressIndicator extends StatelessWidget {
  final DownloadProgress? downloadProgress;
  final double height;
  final double width;
  final Color progressIndicatorColor;

  const AppProgressIndicator(
      {Key? key,
      this.downloadProgress,
      required this.height,
      required this.width,
      required this.progressIndicatorColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: height.h,
        width: width.h,
        child: Center(
            child: CircularProgressIndicator.adaptive(
          value: downloadProgress?.progress,
          valueColor: AlwaysStoppedAnimation<Color>(progressIndicatorColor),
        )));
  }
}

class AppErrorWidget extends StatelessWidget {
  final double height;
  final double width;

  const AppErrorWidget({Key? key, required this.height, required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
    );
    // child: SvgPicture.asset(
    //   SvgAssetsPaths.kDepositTwoPath,
    //   fit: BoxFit.contain,
    // ));
  }
}
