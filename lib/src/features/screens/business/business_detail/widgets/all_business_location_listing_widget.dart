// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:happiness_club_merchant/src/features/screens/business/business_detail/model/business_detail_view_model.dart';

import '../../../../../../app/app_theme/app_theme.dart';

class BusinessLocationWidget extends StatelessWidget {
  BusinessDetailViewModel viewModel;
  BusinessLocationWidget({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: viewModel.businessDetail.businessBranches.length > 2
          ? 2
          : viewModel.businessDetail.businessBranches.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(top: 3.h),
          child: Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: kBorderColor,
                size: 20.h,
              ),
              SizedBox(
                width: 3.w,
              ),
              Text(
                '${viewModel.businessDetail.businessBranches[index].branchName},',
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(fontWeight: FontWeight.w400, color: kBorderColor),
              ),
              Expanded(
                child: Text(
                  viewModel.businessDetail.businessBranches[index].cityName,
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontWeight: FontWeight.w400, color: kBorderColor),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
