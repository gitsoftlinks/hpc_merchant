import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class AppDivider extends StatelessWidget {
  final double? height;
  final bool? hasIntend;
  final double? thickness;
  const AppDivider({Key? key, this.height, this.hasIntend = true, this.thickness}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
        height: height ?? 0,
        thickness: thickness ??0.5.h,
        // indent: hasIntend! ? 16.w : 0,
        // endIndent: hasIntend! ? 16.w : 0,
        color: Theme.of(context).dividerColor
    );
  }
}