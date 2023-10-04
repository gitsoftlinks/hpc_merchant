import 'dart:async';

import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_asset_path/images_util.dart';
import '../../../../app/app_theme/app_theme.dart';
import '../../../../app/custom_widgets/continue_button.dart';
import '../../../../app/custom_widgets/custom_text_field.dart';
import '../../../../app/custom_widgets/direction.dart';
import '../../../../app/custom_widgets/show_loader.dart';
import '../../../../app/toast_messages/toast_messages.dart';
import '../../../../app/validator/text_field_validator.dart';
import '../../../../utils/globals.dart';
import '../../../../utils/router/ui_pages.dart';
import 'model/reset_password_view_model.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  ResetPasswordViewModel get viewModel => sl();

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
              body: ResetPasswordScreenContents(),
            ),
          ),
        ),
      ),
    );
  }
}

class ResetPasswordScreenContents extends StatefulWidget {
  const ResetPasswordScreenContents({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreenContents> createState() =>
      _ResetPasswordScreenContents();
}

class _ResetPasswordScreenContents extends State<ResetPasswordScreenContents> {
  late ShowLoader showLoader;

  @override
  void initState() {
    super.initState();
    getArguments();

    scheduleMicrotask(() {
      showLoader = ShowLoader(context);
      context.read<ResetPasswordViewModel>().init();
    });
    context.read<ResetPasswordViewModel>().toggleShowLoader =
        () => showLoader.toggle();
    context.read<ResetPasswordViewModel>().errorMessages =
        (message) => showErrorToast(context, message);
    context.read<ResetPasswordViewModel>().successMessage =
        (message) => showSuccessToast(context, message);
  }

  void getArguments() {
    scheduleMicrotask(() {
      if (!mounted) {
        return;
      }

      var pageConfiguration =
          ModalRoute.of(context)?.settings.arguments as PageConfiguration?;

      if (pageConfiguration == null) {
        return;
      }

      var map = pageConfiguration.arguments;

      if (map.isEmpty) {
        return;
      }

      context.read<ResetPasswordViewModel>().email = map['email'];
    });
  }

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<ResetPasswordViewModel>();
    return Container(
      padding: EdgeInsets.only(left: 16.w, right: 16.w),
      height: double.infinity,
      child: Stack(children: [
        SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              height: 20.h,
            ),
            SizedBox(
              width: double.infinity,
              child: IntrinsicHeight(
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 32.h,
                        height: 32.h,
                        margin: EdgeInsets.only(
                          top: 10.w,
                          right: isRTL ? 0 : 0.h,
                          left: isRTL ? 150.h : 0,
                        ),
                        child: SvgPicture.asset(
                          SvgAssetsPaths.cancelSvg,
                          height: 12,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(top: 12.h),
                        child: Text(
                          "reset_password".ntr(),
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 40.h,
            ),
            Column(
              children: [
                Text(
                  "pass_description".ntr(),
                  style: Theme.of(context).textTheme.headline3!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(
              height: 30.h,
            ),
            ValueListenableBuilder<bool>(
                valueListenable: viewModel.isHidden,
                builder: (context, isHidden, _) {
                  return CustomTextField(
                      textCapitalization: TextCapitalization.sentences,
                      inputAction: TextInputAction.next,
                      textEditingController: viewModel.newPassController,
                      textFieldMaxLength: 40,
                      inputType: TextInputType.visiblePassword,
                      hintText: 'new_password'.ntr(),
                      labelText: 'new_passwords'.ntr(),
                      prefixIcon: Container(
                        height: kButtonHeight,
                        width: kButtonHeight,
                        decoration: BoxDecoration(
                            border: Border(
                                right: isRTL
                                    ? BorderSide.none
                                    : const BorderSide(
                                        width: 1, color: kBorderColor),
                                left: isRTL
                                    ? const BorderSide(
                                        width: 1, color: kBorderColor)
                                    : BorderSide.none)),
                        margin: EdgeInsets.only(
                            right: isRTL ? 0 : 10.w, left: isRTL ? 5.w : 0),
                        padding: EdgeInsets.only(right: 13.w, left: 13.w),
                        child: SvgPicture.asset(
                          SvgAssetsPaths.keySvg,
                        ),
                      ),
                      suffixIcon: isHidden
                          ? Icon(
                              Icons.visibility_off,
                              color: Theme.of(context).disabledColor,
                              size: 25.w,
                            )
                          : Icon(
                              Icons.visibility,
                              color: Theme.of(context).disabledColor,
                              size: 25.w,
                            ),
                      onTapSuffix: () {
                        viewModel.isHidden.value = !viewModel.isHidden.value;
                      },
                      isHidden: isHidden,
                      onChanged: (val) {
                        viewModel.validateTextFieldsNotEmpty();
                      },
                      validator: TextFieldValidator.isPasswordCompliant);
                }),
            SizedBox(
              height: 20.h,
            ),
            ValueListenableBuilder<bool>(
                valueListenable: viewModel.isHidden,
                builder: (context, isHidden, _) {
                  return CustomTextField(
                      textCapitalization: TextCapitalization.sentences,
                      inputAction: TextInputAction.done,
                      textEditingController: viewModel.confirmPassController,
                      textFieldMaxLength: 40,
                      inputType: TextInputType.visiblePassword,
                      hintText: 'confirmed_password'.ntr(),
                      labelText: 'confirmed_passwords'.ntr(),
                      prefixIcon: Container(
                        height: kButtonHeight,
                        width: kButtonHeight,
                        decoration: BoxDecoration(
                            border: Border(
                                right: isRTL
                                    ? BorderSide.none
                                    : const BorderSide(
                                        width: 1, color: kBorderColor),
                                left: isRTL
                                    ? const BorderSide(
                                        width: 1, color: kBorderColor)
                                    : BorderSide.none)),
                        margin: EdgeInsets.only(
                            right: isRTL ? 0 : 10.w, left: isRTL ? 5.w : 0),
                        padding: EdgeInsets.only(right: 13.w, left: 13.w),
                        child: SvgPicture.asset(
                          SvgAssetsPaths.keySvg,
                        ),
                      ),
                      suffixIcon: isHidden
                          ? Icon(
                              Icons.visibility_off,
                              color: Theme.of(context).disabledColor,
                              size: 25.w,
                            )
                          : Icon(
                              Icons.visibility,
                              color: Theme.of(context).disabledColor,
                              size: 25.w,
                            ),
                      onTapSuffix: () {
                        viewModel.isHidden.value = !viewModel.isHidden.value;
                      },
                      isHidden: isHidden,
                      onChanged: (val) {
                        viewModel.validateTextFieldsNotEmpty();
                      },
                      validator: (value) =>
                          TextFieldValidator.validateConfirmPassword(
                              value, viewModel.newPassController.text));
                }),
          ]),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10.h,
          child: ContinueButton(
              loadingNotifier: viewModel.isLoadingNotifier,
              text: 'reset_password'.ntr(),
              onPressed: viewModel.isButtonEnabled
                  ? () {
                      FocusScope.of(context).unfocus();
                      viewModel.sendResetPassword(context);
                    }
                  : null),
        )
      ]),
    );
  }
}
