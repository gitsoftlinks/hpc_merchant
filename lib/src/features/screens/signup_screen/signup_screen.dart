import 'dart:async';
import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../../../../app/app_asset_path/images_util.dart';
import '../../../../app/app_theme/app_theme.dart';
import '../../../../app/custom_widgets/continue_button.dart';
import '../../../../app/custom_widgets/custom_text_field.dart';
import '../../../../app/custom_widgets/direction.dart';
import '../../../../app/custom_widgets/show_loader.dart';
import '../../../../app/toast_messages/toast_messages.dart';
import '../../../../app/validator/text_field_validator.dart';
import '../../../../utils/globals.dart';
import 'model/signup_view_model.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  SignUpViewModel get viewModel => sl();

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
              body: SignUpScreenContents(),
            ),
          ),
        ),
      ),
    );
  }
}

class SignUpScreenContents extends StatefulWidget {
  const SignUpScreenContents({Key? key}) : super(key: key);

  @override
  State<SignUpScreenContents> createState() => _SignUpScreenContentsState();
}

class _SignUpScreenContentsState extends State<SignUpScreenContents> {
  late ShowLoader showLoader;

  @override
  void initState() {
    super.initState();
    scheduleMicrotask(() {
      showLoader = ShowLoader(context);
      context.read<SignUpViewModel>().init();
    });

    context.read<SignUpViewModel>().errorMessages =
        (message) => showErrorToast(context, message);
    context.read<SignUpViewModel>().toggleShowLoader =
        () => showLoader.toggle();
  }

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<SignUpViewModel>();
    return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Form(
          key: viewModel.signUpFormKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        viewModel.signUpFormKey.currentState?.reset();
                        viewModel.clearData();
                      },
                      child: Container(
                        width: 32.h,
                        height: 32.h,
                        margin: EdgeInsets.only(top: 16.w),
                        child: Transform.rotate(
                          angle: isRTL ? math.pi : 0,
                          child: SvgPicture.asset(
                            SvgAssetsPaths.backIconSvg,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 118.h,
                  child: Image.asset(
                    PngAssetsPath.logoImage,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.h),
                  child: Text(
                    'Sign Up'.ntr(),
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
                Text(
                  'Fill the details to create account'.ntr(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: kDisabledTextColor),
                ),
                SizedBox(
                  height: 30.h,
                ),
                CustomTextField(
                  inputType: TextInputType.text,
                  inputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.sentences,
                  textEditingController: viewModel.fullNameController,
                  textFieldMaxLength: 40,
                  hintText: 'Full Name',
                  labelText: 'Full Name',
                  prefixIcon: Container(
                    height: kButtonHeight,
                    width: 48.w,
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
                      SvgAssetsPaths.fieldUserSvg,
                    ),
                  ),
                  onChanged: (val) {
                    viewModel.validateTextFieldsNotEmpty();
                  },
                  validator: TextFieldValidator.validateFullName,
                ),
                SizedBox(
                  height: 15.h,
                ),
                ValueListenableBuilder<String>(
                    valueListenable: viewModel.emailErrorText,
                    builder: (context, errorMsg, _) {
                      return CustomTextField(
                        inputType: TextInputType.text,
                        inputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.sentences,
                        textEditingController: viewModel.emailController,
                        textFieldMaxLength: 40,
                        hintText: 'Email'.ntr(),
                        labelText: 'Email'.ntr(),
                        prefixIcon: Container(
                          height: kButtonHeight,
                          width: 48.w,
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
                            SvgAssetsPaths.fieldSmsSvg,
                          ),
                        ),
                        onChanged: (val) {
                          viewModel.validateTextFieldsNotEmpty();
                        },
                        validator: TextFieldValidator.validateEmail,
                        errorText: errorMsg.isNotEmpty ? errorMsg : null,
                      );
                    }),
                SizedBox(
                  height: 15.h,
                ),
                CustomTextField(
                  inputType: TextInputType.number,
                  inputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.sentences,
                  textEditingController: viewModel.phoneNumberController,
                  textFieldMaxLength: 40,
                  hintText: 'Phone Number',
                  labelText: 'Phone Number',
                  prefixIcon: Container(
                    height: kButtonHeight,
                    width: 48.w,
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
                      SvgAssetsPaths.fieldMobileSvg,
                    ),
                  ),
                  onChanged: (val) {
                    viewModel.validateTextFieldsNotEmpty();
                  },
                  validator: TextFieldValidator.validatePhoneNumber,
                ),
                SizedBox(
                  height: 15.h,
                ),
                ValueListenableBuilder<bool>(
                    valueListenable: viewModel.isHidden,
                    builder: (context, isHidden, _) {
                      return CustomTextField(
                          textCapitalization: TextCapitalization.sentences,
                          inputAction: TextInputAction.next,
                          textEditingController: viewModel.passwordController,
                          textFieldMaxLength: 40,
                          inputType: TextInputType.visiblePassword,
                          hintText: 'Password'.ntr(),
                          labelText: 'Password'.ntr(),
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
                                  size: 20.w,
                                )
                              : Icon(
                                  Icons.visibility,
                                  color: Theme.of(context).disabledColor,
                                  size: 20.w,
                                ),
                          onTapSuffix: () {
                            viewModel.isHidden.value =
                                !viewModel.isHidden.value;
                          },
                          isHidden: isHidden,
                          onChanged: (val) {
                            viewModel.validateTextFieldsNotEmpty();
                          },
                          validator: TextFieldValidator.isPasswordCompliant);
                    }),
                SizedBox(
                  height: 15.h,
                ),
                ValueListenableBuilder<bool>(
                    valueListenable: viewModel.isHidden,
                    builder: (context, isHidden, _) {
                      return CustomTextField(
                          textCapitalization: TextCapitalization.sentences,
                          inputAction: TextInputAction.done,
                          textEditingController:
                              viewModel.confirmPasswordController,
                          textFieldMaxLength: 40,
                          inputType: TextInputType.visiblePassword,
                          hintText: 'Confirm Password',
                          labelText: 'Confirm Password',
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
                                  size: 20.w,
                                )
                              : Icon(
                                  Icons.visibility,
                                  color: Theme.of(context).disabledColor,
                                  size: 20.w,
                                ),
                          onTapSuffix: () {
                            viewModel.isHidden.value =
                                !viewModel.isHidden.value;
                          },
                          isHidden: isHidden,
                          onChanged: (val) {
                            viewModel.validateTextFieldsNotEmpty();
                          },
                          validator: (value) =>
                              TextFieldValidator.validateConfirmPassword(
                                  value, viewModel.passwordController.text));
                    }),
                SizedBox(
                  height: 20.h,
                ),
                ContinueButton(
                  loadingNotifier: viewModel.isLoadingNotifier,
                  text: 'Sign Up'.ntr(),
                  onPressed: viewModel.isButtonEnabled
                      ? () {
                          if (viewModel.signUpFormKey.currentState!
                              .validate()) {
                            FocusScope.of(context).unfocus();
                            viewModel.signup();
                          }
                        }
                      : null,
                ),
                SizedBox(
                  height: 15.h,
                ),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: 'Already hava an account?'.ntr(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: kDisabledTextColor)),
                  const TextSpan(text: ' '),
                  TextSpan(
                      text: 'Sign In'.ntr(),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          viewModel.moveToSignInScreen();
                        },
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold, color: kPrimaryColor))
                ])),
                SizedBox(
                  height: 10.h,
                ),
              ]),
        ));
  }
}
