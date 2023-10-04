import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../../../app/app_asset_path/images_util.dart';
import '../../../../../app/app_theme/app_theme.dart';

class ProductDetailShimmer extends StatelessWidget {
  const ProductDetailShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
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
                top: 30.h,
                child: InkResponse(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: SvgPicture.asset(
                    SvgAssetsPaths.backSvg,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        Padding(
          padding: EdgeInsets.only(left: 16.h, right: 16.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                  borderRadius: fieldBorderRadius,
                  child: Shimmer(
                    enabled: true,
                    duration: const Duration(seconds: 2),
                    color: Theme.of(context).disabledColor,
                    child: SizedBox(
                      height: 20.h,
                      width: 0.5.sw,
                    ),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
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
                            width: 0.5.sw,
                          ),
                        )),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(30.r),
                        child: Shimmer(
                          enabled: true,
                          duration: const Duration(seconds: 2),
                          color: Theme.of(context).disabledColor,
                          child: SizedBox(
                            height: 30.h,
                            width: 30.h,
                          ),
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              ClipRRect(
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
              SizedBox(
                height: 10.h,
              ),
              ClipRRect(
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
              SizedBox(
                height: 10.h,
              ),
              ClipRRect(
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
              SizedBox(
                height: 10.h,
              ),
              ClipRRect(
                  borderRadius: fieldBorderRadius,
                  child: Shimmer(
                    enabled: true,
                    duration: const Duration(seconds: 2),
                    color: Theme.of(context).disabledColor,
                    child: SizedBox(
                      height: 20.h,
                      width: 0.3.sw,
                    ),
                  )),
              SizedBox(
                height: 10.h,
              ),
              SizedBox(
                height: 30.h,
              ),
              ClipRRect(
                  borderRadius: fieldBorderRadius,
                  child: Shimmer(
                    enabled: true,
                    duration: const Duration(seconds: 2),
                    color: Theme.of(context).disabledColor,
                    child: SizedBox(
                      height: 20.h,
                      width: 0.5.sw,
                    ),
                  )),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20.h),
                height: 200.h,
                child: ListView.builder(
                  itemCount: 3,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return ClipRRect(
                        borderRadius: fieldBorderRadius,
                        child: Shimmer(
                          enabled: true,
                          duration: const Duration(seconds: 2),
                          color: Theme.of(context).disabledColor,
                          child: SizedBox(
                            height: 200.h,
                            // width: double.infinity,
                          ),
                        ));
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
