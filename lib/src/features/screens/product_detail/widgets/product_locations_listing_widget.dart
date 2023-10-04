// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happiness_club_merchant/src/features/screens/product_detail/model/product_detail_view_model.dart';

import '../../../../../app/app_asset_path/images_util.dart';
import '../../../../../app/app_theme/app_theme.dart';

class ProductLocationListingWidget extends StatelessWidget {
  ProductDetailViewModel viewModel;
  ProductLocationListingWidget({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: viewModel.productLocations.length,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        print("builder length : ${viewModel.productLocations.length}");
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(
              SvgAssetsPaths.locationPinSvg,
              height: 15.h,
            ),
            SizedBox(
              width: 3.w,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: 20.h),
                child: Text(
                  viewModel.productLocations[index].toString(),
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(fontWeight: FontWeight.w600, fontSize: 9.sp),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 0.h, top: 15.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (viewModel.postDetail.productLocations[index]
                          ['quantity_count'] !=
                      0) ...[
                    Text(
                      'QTY: ',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(
                              fontWeight: FontWeight.w400, fontSize: 12.sp),
                    ),
                  ],
                  Text(
                    viewModel.postDetail.productLocations[index]
                                ['quantity_count'] ==
                            0
                        ? 'Available'
                        : viewModel.postDetail
                            .productLocations[index]['quantity_count']
                            .toString(),
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                        color: kPrimaryColor),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
