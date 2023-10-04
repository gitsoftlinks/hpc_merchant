import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app_theme/app_theme.dart';

class ContinueButton extends StatelessWidget {
  final String text;
  final String? subText;
  final TextStyle? style;
  final double _height;
  final Color? backgroundColor;
  final BorderSide? borderSides;
  final VoidCallback? onPressed;
  final ValueNotifier<bool>? loadingNotifier;
  final ValueNotifier<bool> _isEnabledNotifier;
  final EdgeInsets _padding;

  ContinueButton(
      {Key? key,
      required this.text,
      this.style,
      this.backgroundColor,
      this.borderSides,
      required this.onPressed,
      this.loadingNotifier,
      ValueNotifier<bool>? isEnabledNotifier,
      EdgeInsets? padding,
        double? height,
      this.subText})
      : _isEnabledNotifier = isEnabledNotifier ?? ValueNotifier(true),
        _padding = padding ?? EdgeInsets.zero,
        _height = height ?? fieldHeight,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (loadingNotifier == null) {
      return Container(
        height: _height,
        padding: _padding,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: backgroundColor,
              side: borderSides,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(fieldRadius),
              )),
          child: subText != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      style: style ?? Theme.of(context).textTheme.button!.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      subText!,
                      style: style!.copyWith(fontWeight: FontWeight.w300, fontSize: 14.sp),
                    )
                  ],
                )
              : Text(
                  text,
                  style: style ?? Theme.of(context).textTheme.button!.copyWith(fontWeight: FontWeight.w600),
                ),
        ),
      );
    }

    return Container(
      padding: _padding,
      height: _height,
      child: ValueListenableBuilder<bool>(
          valueListenable: _isEnabledNotifier,
          builder: (context, isEnabled, child) {
            return ValueListenableBuilder<bool>(
                valueListenable: loadingNotifier!,
                builder: (context, isLoading, child) {
                  return ElevatedButton(
                    onPressed: shouldButtonBeEnabled(isEnabled, isLoading) ? onPressed : () {},
                    style: ElevatedButton.styleFrom(elevation: 0, backgroundColor: backgroundColor, side: borderSides),
                    child: (isLoading)
                        ? CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).scaffoldBackgroundColor))
                        : Text(
                            text,
                      style: Theme.of(context).textTheme.button!.copyWith(height: 1.5),
                          ),
                  );
                });
          }),
    );
  }

  bool shouldButtonBeEnabled(bool isEnabled, bool isLoading) => isEnabled && !isLoading;
}
