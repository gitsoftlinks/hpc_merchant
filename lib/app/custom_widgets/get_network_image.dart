import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/extensions/extensions.dart';
import '../app_theme/app_theme.dart';
import 'cache_image.dart';

class GetNetworkImage extends StatelessWidget {
  final String imageUrl;
  final ImageExtension imageType;
  final double height;
  final double width;
  final double indicatorHeight;
  final double indicatorWidth;
  final double? errorWidgetHeight;
  final double? errorWidgetWidth;

  const GetNetworkImage(
      {Key? key,
      required this.imageType,
      required this.imageUrl,
      required this.height,
      required this.width,
      required this.indicatorHeight,
      required this.indicatorWidth,
      this.errorWidgetHeight,
      this.errorWidgetWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (imageType) {
      case ImageExtension.SVG:
        return FittedBox(
          fit: BoxFit.contain,
          child: SvgPicture.network(
            imageUrl,
            placeholderBuilder: (context) => AppProgressIndicator(height: indicatorHeight, width: indicatorWidth, progressIndicatorColor: kPrimaryColor),
          ),
        );
      case ImageExtension.PNG:
        return CachedNetworkImage(
          imageUrl: imageUrl,
          imageBuilder: (context, imageProvider) => ImageContainer(
            imageProvider: imageProvider,
            height: height,
            width: width,
          ),
          progressIndicatorBuilder: (context, url, progress) =>
              AppProgressIndicator(downloadProgress: progress, height: indicatorHeight, width: indicatorWidth, progressIndicatorColor: kPrimaryColor),
          errorWidget: (context, __, _) => AppErrorWidget(
            height: errorWidgetHeight ?? 0,
            width: errorWidgetWidth ?? 0,
          ),
        );
    }
  }
}
