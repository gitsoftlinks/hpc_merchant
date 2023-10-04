import 'dart:async';

import 'package:happiness_club_merchant/app/validator/text_field_validator.dart';
import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../../app/custom_widgets/direction.dart';
import '../../../../app/app_asset_path/images_util.dart';
import '../../../../app/app_theme/app_theme.dart';
import '../../../../app/custom_widgets/continue_button.dart';
import '../../../../app/custom_widgets/custom_text_field.dart';
import '../../../../app/custom_widgets/show_loader.dart';
import '../../../../app/toast_messages/toast_messages.dart';
import '../../../../utils/globals.dart';
import '../../../../utils/router/ui_pages.dart';
import 'model/activate_account_view_model.dart';

class ActivateAccountScreen extends StatelessWidget {
  const ActivateAccountScreen({Key? key}) : super(key: key);

  ActivateAccountViewModel get viewModel => sl();

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
              body: ActivateAccountScreenContents(),
            ),
          ),
        ),
      ),
    );
  }
}

class ActivateAccountScreenContents extends StatefulWidget {
  const ActivateAccountScreenContents({Key? key}) : super(key: key);

  @override
  State<ActivateAccountScreenContents> createState() => _ActivateAccountScreenContentsState();
}

class _ActivateAccountScreenContentsState extends State<ActivateAccountScreenContents> {
  late ShowLoader showLoader;

  @override
  void initState() {
    super.initState();
    getArguments();

    scheduleMicrotask(() {
      showLoader = ShowLoader(context);
      context.read<ActivateAccountViewModel>().init();
    });
    context.read<ActivateAccountViewModel>().toggleShowLoader = () => showLoader.toggle();
    context.read<ActivateAccountViewModel>().errorMessages = (message) => showErrorToast(context, message);
    context.read<ActivateAccountViewModel>().successMessage = (message) => showSuccessToast(context, message);
  }

  void getArguments() {
    scheduleMicrotask(() {
      if (!mounted) {
        return;
      }

      var pageConfiguration = ModalRoute.of(context)?.settings.arguments as PageConfiguration?;

      if (pageConfiguration == null) {
        return;
      }

      var map = pageConfiguration.arguments;

      if (map.isEmpty) {
        return;
      }

      context.read<ActivateAccountViewModel>().email = map['email'];
    });
  }

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<ActivateAccountViewModel>();
    return Container(
      padding: EdgeInsets.only(left: 16.w, right: 16.w),
      height: double.infinity,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
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
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.only(top: 12.h),
                            child: Text(
                              "verify_email".ntr(),
                              style: Theme.of(context).textTheme.headline1!.copyWith(fontWeight: FontWeight.w600),
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
                      "verify_email_otp_description".ntr(),
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
                CustomTextField(
                  inputType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  textEditingController: viewModel.otpController,
                  textFieldMaxLength: 40,
                  hintText: 'enter_otp'.ntr(),
                  labelText: 'enter_otp'.ntr(),
                  prefixIcon: Container(
                    height: kButtonHeight,
                    width: kButtonHeight,
                    decoration: BoxDecoration(
                        border:
                            Border(right: isRTL ? BorderSide.none : const BorderSide(width: 1, color: kBorderColor), left: isRTL ? const BorderSide(width: 1, color: kBorderColor) : BorderSide.none)),
                    margin: EdgeInsets.only(right: isRTL ? 0 : 10.w, left: isRTL ? 5.w : 0),
                    padding: EdgeInsets.only(right: isRTL ? 5.w : 13.w, left: isRTL ? 13.w : 5.w),
                    child: SvgPicture.asset(
                      SvgAssetsPaths.fieldSmsSvg,
                    ),
                  ),
                  onChanged: (val) {
                    viewModel.validateTextFieldsNotEmpty();
                  },
                  validator: TextFieldValidator.validateText,
                ),
                SizedBox(
                  height: 20.h,
                ),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(text: 'did_not_receive'.ntr(), style: Theme.of(context).textTheme.bodyText2!.copyWith(color: kDisabledTextColor)),
                  const TextSpan(text: ' '),
                  TextSpan(
                      text: 'resend'.ntr(),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          viewModel.sendActivateAccountOtp();
                        },
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight: FontWeight.bold, color: kPrimaryColor))
                ])),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10.h,
            child: ContinueButton(
                loadingNotifier: viewModel.isLoadingNotifier,
                text: 'verify'.ntr(),
                onPressed: viewModel.isButtonEnabled
                    ? () {
                        FocusScope.of(context).unfocus();
                        viewModel.verifyOtp();
                      }
                    : null),
          )
        ],
      ),
    );
  }
}
