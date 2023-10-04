import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app_theme/app_theme.dart';
import 'direction.dart';

class TopBar extends StatelessWidget {
  final VoidCallback onTap;
  final String? title;
  final bool showBackButton;

  const TopBar({
    Key? key,
    required this.onTap,
    required this.showBackButton,
    this.title
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66.h,
      width: double.infinity,
      padding: EdgeInsets.only(right: isRTL ? 0 : 20.w, left: isRTL ? 20.w : 0),
      alignment: Alignment.center,
      child: Row(
        children: [
          if(showBackButton)... [InkWell(
            onTap: onTap,
            child: Icon(
              Icons.arrow_back,
              size: 20.w,
              color: kBlackColor,
            ),
          ),],
          // const Spacer(),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                title ?? '',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline1!.copyWith(fontWeight: FontWeight.normal),
              ),
            ),
          ),
          // const Spacer(),
        ],
      ),
    );
  }
}