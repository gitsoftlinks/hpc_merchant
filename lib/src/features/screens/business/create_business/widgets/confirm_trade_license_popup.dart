// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../../../../app/app_theme/app_theme.dart';
import '../../../../../../app/custom_widgets/continue_button.dart';
import '../../../../../../utils/globals.dart';
import '../model/create_business_view_model.dart';

showConfirmTradeLicenseAlert(context, CreateBusinessViewModel provider) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                20.r,
              ),
            ),
          ),
          contentPadding: EdgeInsets.only(
            top: 10.h,
          ),
          scrollable: true,
          content: Container(
            child: Column(children: [
              Padding(
                padding: EdgeInsets.only(left: 36.h, right: 36.h, top: 16.h),
                child: Icon(
                  Icons.upload_file,
                  color: kPrimaryColor,
                  size: 80.w,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.w, right: 16.w),
                child: Text(
                  'I agree to the processing of the document in accordance to UAE’s laws.',
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                      color: Color.fromRGBO(77, 63, 50, 1)),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Padding(
                  padding:
                      EdgeInsets.only(left: 16.w, right: 16.w, bottom: 10.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: 8.w,
                          ),
                          child: ContinueButton(
                            text: 'Cancel',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.w600),
                            backgroundColor:
                                Theme.of(navigatorKeyGlobal.currentContext!)
                                    .canvasColor,
                            borderSides: const BorderSide(
                              width: 2.0,
                              color: kPrimaryColor,
                            ),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              provider.clearLicense();
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 8.w,
                          ),
                          child: ContinueButton(
                            backgroundColor:
                                Theme.of(navigatorKeyGlobal.currentContext!)
                                    .primaryColor,
                            text: 'Upload',
                            onPressed: () {
                              Navigator.of(navigatorKeyGlobal.currentContext!)
                                  .pop();
                            },
                          ),
                        ),
                      )
                    ],
                  )),
              SizedBox(
                height: 10.h,
              )
            ]),
          ),
        );
      });
}
