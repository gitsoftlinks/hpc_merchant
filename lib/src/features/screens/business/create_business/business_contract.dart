// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:happiness_club_merchant/app/app_theme/app_theme.dart';
import 'package:happiness_club_merchant/app/custom_widgets/continue_button.dart';
import 'package:happiness_club_merchant/src/features/screens/business/create_business/model/create_business_view_model.dart';
import 'package:happiness_club_merchant/src/features/screens/business/create_business/usecases/create_new_business.dart';
import 'package:happiness_club_merchant/utils/globals.dart';
import 'package:provider/provider.dart';

class BusinessContractScreen extends StatefulWidget {
  Widget htmlContent;
  CreateNewBusinessParams params;

  BusinessContractScreen({
    super.key,
    required this.htmlContent,
    required this.params,
  });

  @override
  State<BusinessContractScreen> createState() => _BusinessContractScreenState();
}

class _BusinessContractScreenState extends State<BusinessContractScreen> {
  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<CreateBusinessViewModel>();
    return Scaffold(
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 10.h),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: 8.w,
                      ),
                      child: ContinueButton(
                        text: 'Cancel',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: kPrimaryColor, fontWeight: FontWeight.w600),
                        backgroundColor:
                            Theme.of(navigatorKeyGlobal.currentContext!)
                                .canvasColor,
                        borderSides: const BorderSide(
                          width: 2.0,
                          color: kPrimaryColor,
                        ),
                        onPressed: () async {
                          Navigator.of(context).pop();
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
                        text: 'Accept',
                        onPressed: () async {
                          print("parmas ${widget.params}");
                          await viewModel.createNewBusiness(
                              params: widget.params);
                        },
                      ),
                    ),
                  )
                ],
              )),
        ],
      ),
      appBar: AppBar(
        title: Text(
          'Business Contract',
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
              fontWeight: FontWeight.w600, fontSize: 20.sp, color: canvasColor),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16.h),
        child: SingleChildScrollView(
            child: Column(
          children: [
            widget.htmlContent,
            SizedBox(
              height: 50.h,
            ),
          ],
        )),
      ),
    );
  }
}
