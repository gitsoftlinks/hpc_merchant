import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      this.text,
      this.onPressed,
      this.backgroundColor,
      this.height = 45,
      this.child,
      this.width});

  final void Function()? onPressed;
  final String? text;
  final Color? backgroundColor;
  final double height;
  final double? width;
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: height,
        width: width,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: backgroundColor, borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: text == null
              ? child
              : Text(
                  text!,
                  style: Theme.of(context).textTheme.headline2!.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                      color: Colors.white),
                ),
        ),
      ),
    );
  }
}
