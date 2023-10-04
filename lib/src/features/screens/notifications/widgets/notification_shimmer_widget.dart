import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../../../../app/app_asset_path/images_util.dart';
import '../../../../../../app/app_theme/app_theme.dart';

Column buildNotificationShimmer(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        height: 20.h,
      ),
      Padding(
          padding: EdgeInsets.only(left: 16.w, right: 16.w),
          child: ListView.builder(
              itemCount: 5,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 15.h),
                  child: ClipRRect(
                    borderRadius: fieldBorderRadius,
                    child: Shimmer(
                        enabled: true,
                        duration: const Duration(seconds: 2),
                        color: Theme.of(context).disabledColor,
                        child: SizedBox(
                          height: 80.h,
                          width: double.infinity,
                        )),
                  ),
                );
              }),),
    ],
  );
}
