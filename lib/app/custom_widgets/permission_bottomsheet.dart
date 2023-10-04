import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:happiness_club_merchant/utils/extensions/extensions.dart';

import '../../src/features/splash_screen/model/splash_screen_view_model.dart';
import '../../utils/globals.dart';
import '../../utils/permission/permission_engine.dart';
import '../app_asset_path/images_util.dart';
import '../app_theme/app_theme.dart';
import 'continue_button.dart';

class ShowPermissionDialog {
  BuildContext context;
  SplashScreenViewModel get viewModel => sl();
  ShowPermissionDialog(this.context);

  Future show() async {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: kBottomSheetRadius,
          ),
        ),
        isDismissible: false,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        isScrollControlled: true,
enableDrag: false,
        builder: (context) {
          return Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        splashRadius: 20.r,
                        onPressed: () {
                          Navigator.of(context).pop();
                          viewModel.isDismissed = true;
                          viewModel.startConfiguration?.call();
                        },
                        icon: const Icon(
                          Icons.close,
                          color: kBlackColor,
                        )),
                  ),
                  SizedBox(
                    height: 140,
                    child: SvgPicture.asset(
                      SvgAssetsPaths.locationSvg,
                      // height: 300.h,
                      width: double.infinity,
                    ),
                  ),
                  Text(
                    'enable_location'.ntr(),
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w300),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    'enable_location_msg'.ntr(),
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w300),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  ContinueButton(
                      text: 'allow_while_using_app'.ntr(),
                      style: Theme.of(context).textTheme.button!.copyWith(color: Theme.of(context).canvasColor, fontWeight: FontWeight.w400),
                      onPressed: () async {
                        var engine = GetIt.I.get<PermissionEngine>();

                        var isGranted = await engine
                            .resolvePermission(CustomPermission.location);

                        if (isGranted) {
                          Navigator.of(context).pop();
                        }
                      }),
                  TextButton(
                    child: Text('do_not_allow'.ntr(), style: Theme.of(context).textTheme.headline6!.copyWith(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w500),),
                    onPressed: () {
                      Navigator.pop(context);
                      viewModel.isDismissed = true;
                      viewModel.startConfiguration?.call();
                    },
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
