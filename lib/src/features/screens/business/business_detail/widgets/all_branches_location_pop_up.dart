// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:happiness_club_merchant/app/app_asset_path/images_util.dart';
import 'package:provider/provider.dart';
import '../../../../../../app/app_theme/app_theme.dart';
import '../model/business_detail_view_model.dart';

showBranchesAlert(context) {
  showDialog(
      context: context,
      builder: (context) {
        var model = context.read<BusinessDetailViewModel>();
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
                child: Image.asset(PngAssetsPath.branchesImage),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                'All Branches',
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(77, 63, 50, 1)),
                textAlign: TextAlign.start,
              ),
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 36.h, right: 16.h),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: model.businessDetail.businessBranches.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(top: 5.h),
                      child: Row(
                        children: [
                          Icon(
                            Icons.circle,
                            color: kPrimaryColor,
                            size: 8.h,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            '${model.businessDetail.businessBranches[index].branchName},',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: kBorderColor),
                          ),
                          Expanded(
                            child: Text(
                              model.businessDetail.businessBranches[index]
                                  .cityName,
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: kBorderColor),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Divider(
                thickness: 1.w,
                color: kDisabledColor,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'CANCEL',
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor),
                ),
              ),
              SizedBox(
                height: 10.h,
              )
            ]),
          ),
        );
      });
}
