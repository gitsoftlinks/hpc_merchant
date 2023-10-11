// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happiness_club_merchant/app/app_theme/app_theme.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../../../app/app_asset_path/images_util.dart';

class ZoomedImage extends StatelessWidget {
  String? path;
  ZoomedImage({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product Image',
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
              fontWeight: FontWeight.w600, fontSize: 20.sp, color: canvasColor),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: CachedNetworkImage(
          imageUrl: path!,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
            ),
          ),
          progressIndicatorBuilder: (context, url, downloadProgress) => Shimmer(
            color: Theme.of(context).disabledColor,
            duration: const Duration(seconds: 2),
            enabled: true,
            child: SizedBox(
              height: 0.3.sh,
              width: double.infinity,
            ),
          ),
          errorWidget: (context, url, error) => SizedBox(
            child: SvgPicture.asset(
              SvgAssetsPaths.imageSvg,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
