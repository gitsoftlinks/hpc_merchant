import 'package:happiness_club_merchant/app/app_theme/app_theme.dart';
import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_asset_path/images_util.dart';
import '../../../../app/custom_widgets/continue_button.dart';
import '../../../../utils/globals.dart';
import 'model/login_register_view_model.dart';

class LoginRegisterScreen extends StatelessWidget {
  const LoginRegisterScreen({Key? key}) : super(key: key);

  LoginRegisterViewModel get viewModel => sl();

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: viewModel,
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: const SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: LoginRegisterScreenContent(),
          ),
        ),
      ),
    );
  }
}

class LoginRegisterScreenContent extends StatefulWidget {
  const LoginRegisterScreenContent({Key? key}) : super(key: key);

  @override
  State<LoginRegisterScreenContent> createState() =>
      _LoginRegisterScreenContentState();
}

class _LoginRegisterScreenContentState
    extends State<LoginRegisterScreenContent> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        const Spacer(
          flex: 3,
        ),
        SizedBox(
          height: 180.h,
          child: Image.asset(
            PngAssetsPath.logoImage,
            height: 180.h,
          ),
        ),
        const Spacer(
          flex: 3,
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(left: 16.0.w, right: 16.0.w),
              child: ContinueButton(
                text: 'Sign In'.ntr(),
                style: Theme.of(context).textTheme.button!.copyWith(
                    color: kPrimaryColor, fontWeight: FontWeight.w600),
                backgroundColor: Theme.of(context).canvasColor,
                borderSides: const BorderSide(
                  width: 2.0,
                  color: kPrimaryColor,
                ),
                onPressed: () {
                  context.read<LoginRegisterViewModel>().moveToSignInScreen();
                },
              ),
            )),
        SizedBox(
          height: 15.h,
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(left: 16.0.w, right: 16.0.w),
              child: ContinueButton(
                text: 'Sign Up'.ntr(),
                onPressed: () {
                  context.read<LoginRegisterViewModel>().moveToSignUpScreen();
                },
              ),
            )),
        SizedBox(
          height: 30.h,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Privacy Policy'.ntr(),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: kPrimaryColor, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                  height: 20.h,
                  width: 30.w,
                  child: const VerticalDivider(
                    width: 2,
                    color: kDisabledTextColor,
                  )),
              Text('Terms & Conditions'.ntr(),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: kPrimaryColor, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
      ]),
    );
  }
}
