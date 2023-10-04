import 'dart:async';
import 'dart:io';
import 'package:happiness_club_merchant/src/features/home/home_screen.dart';
import 'package:happiness_club_merchant/src/features/screens/signin_screen/model/signin_view_model.dart';
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
import '../../../../app/custom_widgets/language_switcher.dart';
import '../../../../app/custom_widgets/show_loader.dart';
import '../../../../app/toast_messages/toast_messages.dart';
import '../../../../app/validator/text_field_validator.dart';
import '../../../../utils/globals.dart';
import '../../home/model/home_view_model.dart';

class Solution {
  //

  runningArray(List<int> a) {
    var r = [a[0]];

    for (int i = 0; i < a.length; i++) {
      r.add(a[i - 1] + a[i]);
    }
    return r;
  }
}

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  SignInViewModel get viewModel => sl();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              body: SignInScreenContents(),
            ),
          ),
        ),
      ),
    );
  }
}

class SignInScreenContents extends StatefulWidget {
  const SignInScreenContents({Key? key}) : super(key: key);

  @override
  State<SignInScreenContents> createState() => _SignInScreenContentsState();
}

class _SignInScreenContentsState extends State<SignInScreenContents> {
  late ShowLoader showLoader;

  @override
  void initState() {
    super.initState();

    context.read<SignInViewModel>().errorMessages =
        (message) => showErrorToast(context, message);

    context.read<SignInViewModel>().toggleShowLoader =
        () => showLoader.toggle();

    scheduleMicrotask(() {
      showLoader = ShowLoader(context);
      context.read<SignInViewModel>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<SignInViewModel>();
    return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Form(
            key: viewModel.signInFormKey,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.95,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            viewModel.signInFormKey.currentState?.reset();
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
                        'Sign In'.ntr(),
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    ),
                    Text(
                      'Enter the login details to continue'.ntr(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: kDisabledTextColor),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    ValueListenableBuilder<String>(
                        valueListenable: viewModel.emailErrorText,
                        builder: (context, errorMsg, _) {
                          return CustomTextField(
                            inputType: TextInputType.emailAddress,
                            textCapitalization: TextCapitalization.sentences,
                            textEditingController: viewModel.emailController,
                            inputAction: TextInputAction.next,
                            textFieldMaxLength: 40,
                            hintText: 'Email'.ntr(),
                            labelText: 'Email'.ntr(),
                            prefixIcon: Container(
                              height: 45.h,
                              width: 45.w,
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
                                  right: isRTL ? 0 : 10.w,
                                  left: isRTL ? 5.w : 0),
                              padding: EdgeInsets.only(
                                  right: isRTL ? 5.w : 13.w,
                                  left: isRTL ? 13.w : 5.w),
                              child: SvgPicture.asset(
                                SvgAssetsPaths.fieldSmsSvg,
                              ),
                            ),
                            onChanged: (val) {
                              viewModel.validateTextFieldsNotEmpty();
                              if (val.isNotEmpty) {
                                viewModel.emailErrorText.value = '';
                              }
                            },
                            validator: TextFieldValidator.validateEmail,
                            errorText: errorMsg.isNotEmpty ? errorMsg : null,
                          );
                        }),
                    SizedBox(
                      height: 15.h,
                    ),
                    ValueListenableBuilder<bool>(
                        valueListenable: viewModel.isHidden,
                        builder: (context, isHidden, _) {
                          return CustomTextField(
                              textCapitalization: TextCapitalization.sentences,
                              textEditingController:
                                  viewModel.passwordController,
                              inputAction: TextInputAction.done,
                              textFieldMaxLength: 40,
                              inputType: TextInputType.visiblePassword,
                              hintText: 'Password'.ntr(),
                              labelText: 'Password'.ntr(),
                              prefixIcon: Container(
                                height: 45.h,
                                width: 45.w,
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
                                    right: isRTL ? 0 : 10.w,
                                    left: isRTL ? 5.w : 0),
                                padding: EdgeInsets.only(
                                    right: isRTL ? 5.w : 13.w,
                                    left: isRTL ? 13.w : 5.w),
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
                              validator: TextFieldValidator.validateText);
                        }),
                    SizedBox(
                      height: 10.h,
                    ),
                    if (viewModel.invalidUserNameError) ...[
                      Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "Invalid Username Password".ntr(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: kErrorColor,
                                ),
                          )),
                    ],
                    InkWell(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        viewModel.moveToForgotPasswordScreen();
                      },
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Forgot Password?',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.bold),
                          )),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    ContinueButton(
                      loadingNotifier: viewModel.isLoadingNotifier,
                      text: 'Sign In'.ntr(),
                      onPressed: viewModel.isButtonEnabled
                          ? () {
                              if (viewModel.signInFormKey.currentState!
                                  .validate()) {
                                //
                                viewModel.init();
                                FocusScope.of(context).unfocus();

                                viewModel.signInUser();
                              }
                            }
                          : null,
                    ),
                    Spacer(),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Don’t hava an account?'.ntr(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: kDisabledTextColor),
                          ),
                          const TextSpan(text: ' '),
                          TextSpan(
                              text: 'Sign Up Now'.ntr(),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  viewModel.moveToSignUpScreen();
                                },
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: kPrimaryColor))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    )
                  ]),
            ),
          )),
    );
  }
}
