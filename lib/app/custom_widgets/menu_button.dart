import 'package:happiness_club_merchant/app/app_asset_path/images_util.dart';
import 'package:happiness_club_merchant/app/custom_widgets/direction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MenuButton {
  MenuButton();

  // @override
  Widget show(BuildContext context) {
    return Container(
      width: 32.h,
      height: 32.h,
      margin: EdgeInsets.only(left: 16.w, top: 16.w, bottom: 5.h),
      child: SvgPicture.asset(
        SvgAssetsPaths.menuSvg,
        height: 32.h,
        width: 32.h,
      ),
    );
  }
}
