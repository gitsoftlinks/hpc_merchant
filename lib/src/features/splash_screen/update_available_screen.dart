import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:happiness_club_merchant/utils/extensions/extensions.dart';

import '../../../app/custom_widgets/continue_button.dart';

class UpdateAvailableScreen extends StatelessWidget {
  const UpdateAvailableScreen({Key? key}) : super(key: key);

  final kSpacingUnit = 10;
  final kItemsPaddingUnit = 15;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: kItemsPaddingUnit.w,
              vertical: (kItemsPaddingUnit.h * 2).h),
          child: Column(
            children: [
              Spacer(flex: 7),
              CircleAvatar(
                radius: 50.r,
                backgroundColor: Theme.of(context).canvasColor.withOpacity(0.2),
                child: CircleAvatar(
                  radius: 46.r,
                  backgroundColor: Colors.white,
                  child: Icon(
                    CupertinoIcons.arrow_down,
                    size: 38.w,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Spacer(flex: 3),
              Text(
                'update_available'.ntr(),
                style: Theme.of(context).textTheme.headline1!,
              ),
              SizedBox(height: 10.h),
              SizedBox(
                width: 225.w,
                child: Text(
                  'update_available_description'.ntr(),
                  style: Theme.of(context).textTheme.headline2!,
                  textAlign: TextAlign.center,
                ),
              ),
              Spacer(flex: 14),
              ContinueButton(
                onPressed: () {
                  final platform = Theme.of(context).platform;

                  if (platform == TargetPlatform.android) {
                    //  launchPlayStore();
                  } else {
                    // launchAppStore();
                  }
                },
                text: 'update_app_button'.ntr(),
              )
            ],
          ),
        ),
      ),
    );
  }

  // void launchPlayStore() {
  //   _launchURL(
  //       'https://play.google.com/store/apps/details?id=ae.ajwaae.app');
  // }

  // void launchAppStore() {
  //   /// TODO change to ajwaae url in appstore
  //   _launchURL(
  //       'https://apps.apple.com/gb/app/ajwaae/appid');
  // }

  // void _launchURL(String _url) async => await canLaunchUrl(Uri.parse(_url))
  //     ? await launchUrl(Uri.parse(_url))
  //     : throw '${'could_not_launch'.ntr()} $_url';
}
