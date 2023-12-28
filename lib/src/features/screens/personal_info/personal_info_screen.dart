import 'dart:async';
import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
import '../../../../app/providers/account_provider.dart';
import '../../../../app/toast_messages/toast_messages.dart';
import '../../../../app/validator/text_field_validator.dart';
import '../../../../utils/globals.dart';
import 'model/personal_info_view_model.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({Key? key}) : super(key: key);

  PersonalInfoViewModel get viewModel => sl();
  AccountProvider get accountProvider => sl();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: viewModel,
        ),
        ChangeNotifierProvider.value(
          value: accountProvider,
        ),
      ],
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: const SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              body: PersonalInfoScreenContents(),
            ),
          ),
        ),
      ),
    );
  }
}

class PersonalInfoScreenContents extends StatefulWidget {
  const PersonalInfoScreenContents({Key? key}) : super(key: key);

  @override
  State<PersonalInfoScreenContents> createState() =>
      _PersonalInfoScreenContentsState();
}

class _PersonalInfoScreenContentsState
    extends State<PersonalInfoScreenContents> {
  String? valueChoose;

  var personalInfoKey = GlobalKey<FormState>();

  @override
  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() {
      context.read<PersonalInfoViewModel>().init();
    });

    context.read<PersonalInfoViewModel>().errorMessages =
        (message) => showErrorToast(context, message);
    context.read<PersonalInfoViewModel>().successMessage =
        (message) => showSuccessToast(context, message);
  }

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<PersonalInfoViewModel>();
    return Container(
      padding: EdgeInsets.only(left: 16.w, right: 16.w),
      // height: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20.h,
            ),
            SizedBox(
              width: double.infinity,
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: SizedBox(
                      width: 32.h,
                      height: 32.h,
                      child: Transform.rotate(
                        angle: isRTL ? math.pi : 0,
                        child: SvgPicture.asset(
                          SvgAssetsPaths.backIconSvg,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Personal Info".ntr(),
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40.h,
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 100.h,
                        width: 100.h,
                        child: Stack(
                          children: <Widget>[
                            if (viewModel.profileImage != null) ...[
                              CircleAvatar(
                                  radius: 50.r,
                                  backgroundColor: kWhiteColor,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50.r),
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(50.r),
                                        child: Container(
                                            height: 100.h,
                                            width: 100.h,
                                            color: Colors.red,
                                            child: Image.file(
                                              viewModel.profileImage!,
                                              fit: BoxFit.fill,
                                            ))),
                                  ))
                            ] else if (context
                                .read<AccountProvider>()
                                .profileImage
                                .value
                                .isNotEmpty) ...[
                              buildProfileNetworkImage(),
                            ] else ...[
                              CircleAvatar(
                                radius: 50.r,
                                backgroundColor: kWhiteColor,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50.r),
                                    child: SvgPicture.asset(
                                      SvgAssetsPaths.userSvg,
                                    )),
                              )
                            ],
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                height: 30.h,
                                width: 30.h,
                                decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary
                                            .withOpacity(0.1),
                                        width: 1.0)),
                                child: Center(
                                  heightFactor: 15.h,
                                  widthFactor: 15.h,
                                  child: InkResponse(
                                    onTap: () {
                                      viewModel.getProfilePicture(context);
                                    },
                                    child: Icon(
                                      Icons.camera_alt_rounded,
                                      color: kWhiteColor,
                                      size: ScreenUtil().setSp(13.h),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            CustomTextField(
              inputType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              textEditingController: viewModel.fullNameController,
              textFieldMaxLength: 40,
              hintText: 'Full Name'.ntr(),
              labelText: 'Full Name'.ntr(),
              prefixIcon: Container(
                height: kButtonHeight,
                width: kButtonHeight,
                decoration: BoxDecoration(
                    border: Border(
                        right: isRTL
                            ? BorderSide.none
                            : const BorderSide(width: 1, color: kBorderColor),
                        left: isRTL
                            ? const BorderSide(width: 1, color: kBorderColor)
                            : BorderSide.none)),
                margin: EdgeInsets.only(
                    right: isRTL ? 0 : 10.w, left: isRTL ? 5.w : 0),
                padding: EdgeInsets.only(right: 13.w, left: 13.w),
                child: SvgPicture.asset(
                  SvgAssetsPaths.personSvg,
                ),
              ),
              onChanged: (val) {
                viewModel.validatePersonalTextFieldsNotEmpty();
              },
              validator: TextFieldValidator.validateFullName,
            ),
            SizedBox(
              height: 20.h,
            ),
            CustomTextField(
              inputType: TextInputType.number,
              textCapitalization: TextCapitalization.sentences,
              textEditingController: viewModel.contactNumberController,
              textFieldMaxLength: 40,
              hintText: 'Phone Number'.ntr(),
              labelText: 'Phone Number'.ntr(),
              prefixIcon: Container(
                height: kButtonHeight,
                width: kButtonHeight,
                decoration: BoxDecoration(
                    border: Border(
                        right: isRTL
                            ? BorderSide.none
                            : const BorderSide(width: 1, color: kBorderColor),
                        left: isRTL
                            ? const BorderSide(width: 1, color: kBorderColor)
                            : BorderSide.none)),
                margin: EdgeInsets.only(
                    right: isRTL ? 0 : 10.w, left: isRTL ? 5.w : 0),
                padding: EdgeInsets.only(right: 13.w, left: 13.w),
                child: SvgPicture.asset(
                  SvgAssetsPaths.fieldMobileSvg,
                ),
              ),
              onChanged: (val) {
                viewModel.validatePersonalTextFieldsNotEmpty();
              },
              validator: TextFieldValidator.validatePhoneNumber,
            ),
            SizedBox(
              height: 20.h,
            ),
            CustomTextField(
              //enableInteractiveSelection: false, // will disable paste operation
              focusNode: AlwaysDisabledFocusNode(),
              inputType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              textEditingController: viewModel.emailController,
              textFieldMaxLength: 40,
              hintText: 'Email'.ntr(),
              labelText: 'Email'.ntr(),
              prefixIcon: Container(
                height: kButtonHeight,
                width: kButtonHeight,
                decoration: BoxDecoration(
                    border: Border(
                        right: isRTL
                            ? BorderSide.none
                            : const BorderSide(width: 1, color: kBorderColor),
                        left: isRTL
                            ? const BorderSide(width: 1, color: kBorderColor)
                            : BorderSide.none)),
                margin: EdgeInsets.only(
                    right: isRTL ? 0 : 10.w, left: isRTL ? 5.w : 0),
                padding: EdgeInsets.only(right: 13.w, left: 13.w),
                child: SvgPicture.asset(
                  SvgAssetsPaths.fieldSmsSvg,
                ),
              ),
              onChanged: (val) {
                viewModel.validatePersonalTextFieldsNotEmpty();
              },

              validator: TextFieldValidator.validateEmail,
            ),
            SizedBox(
              height: 20.h,
            ),

            ContinueButton(
                loadingNotifier: viewModel.isPersonalLoadingNotifier,
                text: 'Save'.ntr(),
                onPressed: () async {
              
                    FocusScope.of(context).unfocus();
                    viewModel.isPersonalLoadingNotifier.value = true;
                    await viewModel.updateUserInfo();
                 
                }),
            SizedBox(
              height: 30.h,
            ),
            Divider(
              thickness: 4.h,
              color: kDisabledColor,
            ),
            // SizedBox(
            //   height: 10.h,
            // ),
          ],
        ),
      ),
    );
  }

  CircleAvatar buildProfileNetworkImage() {
    return CircleAvatar(
      radius: 50.r,
      backgroundColor: kWhiteColor,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50.r),
        child: CachedNetworkImage(
          key: UniqueKey(),
          imageUrl:
              context.read<PersonalInfoViewModel>().userDetail.profileImage,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              SizedBox(
                  height: 60.h,
                  width: 60.h,
                  child: Center(
                    child: CircularProgressIndicator.adaptive(
                      value: downloadProgress.progress,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    ),
                  )),
          errorWidget: (context, url, error) => SvgPicture.asset(
            SvgAssetsPaths.userSvg,
            height: 100.h,
            width: 100.h,
          ),
        ),
      ),
    );
  }
}
