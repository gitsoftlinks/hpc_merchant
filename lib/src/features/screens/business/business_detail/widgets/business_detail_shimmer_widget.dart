import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../../../../app/app_asset_path/images_util.dart';
import '../../../../../../app/app_theme/app_theme.dart';

class Shimming extends StatelessWidget {
  const Shimming({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          child: Stack(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Shimmer(
                      enabled: true,
                      duration: const Duration(seconds: 2),
                      color: Theme.of(context).disabledColor,
                      child: SizedBox(
                        height: 0.3.sh,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 20.h,
                top: 70.h,
                child: InkResponse(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: SvgPicture.asset(
                    SvgAssetsPaths.backSvg,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 0.3.sh - 60.h),
                child: Card(
                    margin: EdgeInsets.all(20.h),
                    shape:
                        RoundedRectangleBorder(borderRadius: fieldBorderRadius),
                    elevation: 0,
                    child: ClipRRect(
                      borderRadius: fieldBorderRadius,
                      child: Shimmer(
                        enabled: true,
                        duration: const Duration(seconds: 2),
                        color: Theme.of(context).disabledColor,
                        child: Center(
                            child: SizedBox(
                          height: 80.h,
                          width: 0.8.sw,
                        )),
                      ),
                    )),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ClipRRect(
                      borderRadius: fieldBorderRadius,
                      child: Shimmer(
                        enabled: true,
                        duration: const Duration(seconds: 2),
                        color: Theme.of(context).disabledColor,
                        child: SizedBox(
                          height: 20.h,
                        ),
                      )),
                ),
                SizedBox(
                  width: 50.w,
                ),
                Expanded(
                  child: ClipRRect(
                      borderRadius: fieldBorderRadius,
                      child: Shimmer(
                        enabled: true,
                        duration: const Duration(seconds: 2),
                        color: Theme.of(context).disabledColor,
                        child: SizedBox(
                          height: 20.h,
                        ),
                      )),
                )
              ],
            )),
        SizedBox(
          height: 20.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 5.w,
              childAspectRatio: 1 / 1.5,
              mainAxisSpacing: 5.h,
              crossAxisCount: 2,
            ),
            itemCount: 2,
            itemBuilder: (context, index) {
              return GestureDetector(
                child: Card(
                  elevation: 0,
                  shape:
                      RoundedRectangleBorder(borderRadius: fieldBorderRadius),
                  child: Column(
                    children: [
                      ClipRRect(
                          borderRadius: fieldBorderRadius,
                          child: Shimmer(
                            enabled: true,
                            duration: const Duration(seconds: 2),
                            color: Theme.of(context).disabledColor,
                            child: SizedBox(
                              height: 140.h,
                              width: double.infinity,
                            ),
                          )),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.h),
                        child: ClipRRect(
                            borderRadius: fieldBorderRadius,
                            child: Shimmer(
                              enabled: true,
                              duration: const Duration(seconds: 2),
                              color: Theme.of(context).disabledColor,
                              child: SizedBox(
                                height: 20.h,
                                width: double.infinity,
                              ),
                            )),
                      ),
                      // ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 10.w, top: 3.h, right: 10.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                  borderRadius: fieldBorderRadius,
                                  child: Shimmer(
                                    enabled: true,
                                    duration: const Duration(seconds: 2),
                                    color: Theme.of(context).disabledColor,
                                    child: SizedBox(
                                      height: 20.h,
                                      // width: double.infinity,
                                    ),
                                  )),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Expanded(
                              child: ClipRRect(
                                  borderRadius: fieldBorderRadius,
                                  child: Shimmer(
                                    enabled: true,
                                    duration: const Duration(seconds: 2),
                                    color: Theme.of(context).disabledColor,
                                    child: SizedBox(
                                      height: 20.h,
                                      // width: double.infinity,
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}
