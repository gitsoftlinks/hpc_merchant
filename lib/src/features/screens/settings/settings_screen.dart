import 'dart:async';

import 'package:happiness_club_merchant/app/app_theme/app_theme.dart';
import 'package:happiness_club_merchant/src/features/screens/settings/widgets/deactivate_account_bottomsheet.dart';
import 'package:happiness_club_merchant/src/features/screens/settings/widgets/delete_account_bottomsheet.dart';
import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_asset_path/images_util.dart';
import '../../../../app/custom_widgets/continue_button.dart';
import '../../../../app/custom_widgets/direction.dart';
import '../../../../app/custom_widgets/show_loader.dart';
import '../../../../app/toast_messages/toast_messages.dart';
import '../../../../utils/globals.dart';
import 'model/settings_view_model.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  SettingsViewModel get viewModel => sl();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: const SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: SettingsScreenContents(),
            ),
          ),
        ),
      ),
    );
  }
}

class SettingsScreenContents extends StatefulWidget {
  const SettingsScreenContents({Key? key}) : super(key: key);

  @override
  State<SettingsScreenContents> createState() => _SettingsScreenContentsState();
}

class _SettingsScreenContentsState extends State<SettingsScreenContents> {
  late ShowLoader showLoader;

  @override
  void initState() {
    super.initState();
    context.read<SettingsViewModel>().init();

    scheduleMicrotask(() {
      showLoader = ShowLoader(context);
    });
    context.read<SettingsViewModel>().errorMessages =
        (message) => showErrorToast(context, message);
    context.read<SettingsViewModel>().successMessage =
        (message) => showSuccessToast(context, message);
    context.read<SettingsViewModel>().toggleShowLoader =
        () => showLoader.toggle();
  }

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<SettingsViewModel>();
    return Container(
        padding: EdgeInsets.only(left: 16.w, right: 16.w),
        height: double.infinity,
        child: Stack(
          children: [
            Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                top: 0,
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: IntrinsicHeight(
                            child: Stack(
                              children: [
                                Positioned(
                                  right: isRTL ? 0 : null,
                                  left: isRTL ? null : 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      width: 32.h,
                                      height: 32.h,
                                      alignment: Alignment.center,
                                      child: SvgPicture.asset(
                                        SvgAssetsPaths.cancelSvg,
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "settings".ntr(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1!
                                        .copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 35.h,
                        ),
                        Text(
                          "post".ntr(),
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: kToastTextColor),
                          // textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        ListTile(
                          shape: const Border(
                            bottom: BorderSide(color: kDisabledColor, width: 1),
                          ),
                          contentPadding: EdgeInsets.zero,
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 35.h,
                                height: 35.h,
                                child: SvgPicture.asset(
                                  SvgAssetsPaths.notificationSvg,
                                ),
                              ),
                            ],
                          ),
                          title: Text(
                            textAlign: TextAlign.start,
                            "push_notification".ntr(),
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: Text('allow_push_notification_msg'.ntr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(color: kDisabledTextColor)),
                          ),
                          trailing: Switch(
                            value: viewModel.allowNotifications,
                            activeColor: kPrimaryColor,
                            onChanged: (bool value) {
                              viewModel.toggleAllowNotifications(value);
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          onTap: () {
                            var bottomSheet = DeactivateAccountBottomSheet();
                            bottomSheet.show();
                          },
                          leading: Column(
                            children: [
                              SizedBox(
                                width: 35.h,
                                height: 35.h,
                                child: SvgPicture.asset(
                                  SvgAssetsPaths.deleteSvg,
                                ),
                              ),
                            ],
                          ),
                          title: Text(
                            textAlign: TextAlign.start,
                            "deactivated_account".ntr(),
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: Text('account_is_deactivated_msg'.ntr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(color: kDisabledTextColor)),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          onTap: () {
                            var bottomSheet = DeleteAccountBottomSheet();
                            bottomSheet.show();
                          },
                          leading: Column(
                            children: [
                              SizedBox(
                                width: 35.h,
                                height: 35.h,
                                child: SvgPicture.asset(
                                  SvgAssetsPaths.bannedSvg,
                                ),
                              ),
                            ],
                          ),
                          title: Text(
                            textAlign: TextAlign.start,
                            "delete_account".ntr(),
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: Text('account_is_deleted_msg'.ntr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(color: kDisabledTextColor)),
                          ),
                        ),
                        SizedBox(
                          height: 50.h,
                        ),
                        Text(
                          "general".ntr(),
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: kToastTextColor),
                          // textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        ListTile(
                          shape: const Border(
                            bottom: BorderSide(color: kDisabledColor, width: 1),
                          ),
                          contentPadding: EdgeInsets.zero,
                          leading: Column(
                            children: [
                              SizedBox(
                                width: 35.h,
                                height: 35.h,
                                child: SvgPicture.asset(
                                  SvgAssetsPaths.visibilitySvg,
                                ),
                              ),
                            ],
                          ),
                          title: Text(
                            textAlign: TextAlign.start,
                            "profile_visibility".ntr(),
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: Text('allow_profile_visibility_msg'.ntr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(color: kDisabledTextColor)),
                          ),
                          trailing: Switch(
                            value: viewModel.allowPageVisibility,
                            activeColor: kPrimaryColor,
                            onChanged: (bool value) {
                              viewModel.toggleAllowProfileVisibility(value);
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Column(
                            children: [
                              SizedBox(
                                width: 35.h,
                                height: 35.h,
                                child: SvgPicture.asset(
                                  SvgAssetsPaths.deletingSvg,
                                ),
                              ),
                            ],
                          ),
                          title: Padding(
                            padding: EdgeInsets.only(bottom: 15.h),
                            child: Text(
                              textAlign: TextAlign.start,
                              "delete_page".ntr(),
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(fontWeight: FontWeight.w500),
                            ),
                          ),
                          // subtitle: Container(
                          //   decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: kDisabledColor, width: 1))),
                          // ),
                        ),
                        SizedBox(
                          height: 60.h,
                        ),
                      ]),
                )),
          ],
        ));
  }

  Future<String> getBuildNum() async {
    //

    PackageInfo info = await PackageInfo.fromPlatform();

    return "${info.version} (${info.buildNumber})";
  }
}
