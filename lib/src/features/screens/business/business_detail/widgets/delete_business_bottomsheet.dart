import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import '../../../../../../app/app_theme/app_theme.dart';
import '../../../../../../app/custom_widgets/continue_button.dart';
import '../../../../../../app/custom_widgets/direction.dart';
import '../../../../../../utils/globals.dart';
import '../model/business_detail_view_model.dart';

class DeleteBusinessBottomSheet {
  //

  BusinessDetailViewModel get viewModel => sl();

  DeleteBusinessBottomSheet();

  Future<void> show(businessId) {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: kBottomSheetRadius,
        ),
      ),
      isDismissible: false,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: navigatorKeyGlobal.currentContext!,
      builder: (builder) {
        return SafeArea(
          child: Container(
            padding: EdgeInsets.only(
                top: 16.w, left: 16.w, right: 16.w, bottom: 30.w),
            color: Theme.of(navigatorKeyGlobal.currentContext!)
                .scaffoldBackgroundColor,
            child: Wrap(
              children: <Widget>[
                SizedBox(
                  height: 50.h,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.h, bottom: 20.h),
                  child: Text('want_to_remove_business'.ntr(),
                      style: Theme.of(navigatorKeyGlobal.currentContext!)
                          .textTheme
                          .headline5!
                          .copyWith(
                              fontWeight: FontWeight.w400, fontSize: 16.sp)),
                ),
                SizedBox(
                  height: 20.0.h,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 20.h,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                              right: isRTL ? 0 : 8.w, left: isRTL ? 8.w : 0),
                          child: ContinueButton(
                            text: 'cancel'.ntr(),
                            style: Theme.of(navigatorKeyGlobal.currentContext!)
                                .textTheme
                                .button!
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
                            onPressed: () {
                              Navigator.of(navigatorKeyGlobal.currentContext!)
                                  .pop();
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: isRTL ? 0 : 8.w, right: isRTL ? 8.w : 0),
                          child: ContinueButton(
                            backgroundColor:
                                Theme.of(navigatorKeyGlobal.currentContext!)
                                    .errorColor,
                            text: 'remove_business'.ntr(),
                            onPressed: () {
                              //

                              Navigator.of(navigatorKeyGlobal.currentContext!)
                                  .pop();

                              // viewModel.deleteBusiness(businessId,
                              //     navigatorKeyGlobal.currentState!.context);
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
