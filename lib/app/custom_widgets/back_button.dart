

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:happiness_club_merchant/app/app_theme/app_theme.dart';

class AppBackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const AppBackButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      width: 50.h,
      alignment: Alignment.centerLeft,
      child: InkResponse(
        radius: 20.w,
        onTap: onPressed,
        child: Icon(
          Icons.arrow_back,
          size: 20.w,
          color: kBlackColor,
        ),
      ),
    );
  }
}