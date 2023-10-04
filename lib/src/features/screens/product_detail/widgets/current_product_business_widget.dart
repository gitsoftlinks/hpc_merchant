// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happiness_club_merchant/src/features/screens/product_detail/model/product_detail_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../../../app/app_asset_path/images_util.dart';
import '../../../../../app/app_theme/app_theme.dart';
import '../../../../../utils/globals.dart';
import '../../business/all_business/model/get_all_businesses_view_model.dart';
import '../../business/business_detail/business_detail_screen.dart';
import '../../business/business_detail/model/business_detail_view_model.dart';

class CurrentProductBusinessWidget extends StatefulWidget {
  ProductDetailViewModel viewModel;
  CurrentProductBusinessWidget({super.key, required this.viewModel});

  @override
  State<CurrentProductBusinessWidget> createState() =>
      _CurrentProductBusinessWidgetState();
}

class _CurrentProductBusinessWidgetState
    extends State<CurrentProductBusinessWidget> {
  @override
  Widget build(BuildContext context) {
    var businessDetail = context.watch<BusinessDetailViewModel>();
    var allBusinesses = context.watch<AllBusinessesViewModel>();
    return businessDetail.businessDetail.id == 0
        ? Padding(
            padding: EdgeInsets.only(top: 0.22.sh),
            child: InkWell(
              onTap: () {
                toNext(BusinessDetailScreen(
                  isCreated: true,
                  id: allBusinesses.allBusinesses.first.id,
                ));
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.8),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.r),
                        topRight: Radius.circular(0.r),
                        bottomLeft: Radius.circular(0.r),
                        bottomRight: Radius.circular(0.r),
                      ),
                    ),
                    height: 55.h,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 16.h, right: 16.h, top: 8.h, bottom: 8.h),
                      child: Row(
                        children: [
                          Text(
                            allBusinesses
                                .allBusinesses.first.businessDisplayName,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.sp,
                                    color: canvasColor),
                            maxLines: 2,
                          ),
                          SizedBox(
                            width: 3.w,
                          ),
                          ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.r)),
                            child: SizedBox(
                              height: 36.h,
                              width: 36.h,
                              child: CachedNetworkImage(
                                imageUrl: allBusinesses
                                    .allBusinesses.first.businessLogoPath,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: imageProvider, fit: BoxFit.fill),
                                  ),
                                ),
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) => Shimmer(
                                  color: Theme.of(context).disabledColor,
                                  duration: const Duration(seconds: 2),
                                  enabled: true,
                                  child: SizedBox(
                                    height: 0.3.sh,
                                    width: double.infinity,
                                  ),
                                ),
                                errorWidget: (context, url, error) => SizedBox(
                                  child: SvgPicture.asset(
                                    SvgAssetsPaths.imageSvg,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Padding(
            padding: EdgeInsets.only(top: 0.22.sh),
            child: InkWell(
              onTap: () {
                toNext(BusinessDetailScreen(
                  isCreated: true,
                  id: businessDetail.businessDetail.id,
                ));
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.8),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.r),
                        topRight: Radius.circular(0.r),
                        bottomLeft: Radius.circular(0.r),
                        bottomRight: Radius.circular(0.r),
                      ),
                    ),
                    height: 55.h,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 16.h, right: 16.h, top: 8.h, bottom: 8.h),
                      child: Row(
                        children: [
                          Text(
                            businessDetail
                                    .businessDetail.businessDisplayName.isEmpty
                                ? widget.viewModel.product.first.business
                                    .businessDisplayName
                                : businessDetail
                                    .businessDetail.businessDisplayName,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.sp,
                                    color: canvasColor),
                            maxLines: 2,
                          ),
                          SizedBox(
                            width: 3.w,
                          ),
                          ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.r)),
                            child: SizedBox(
                              height: 36.h,
                              width: 36.h,
                              child: CachedNetworkImage(
                                imageUrl:
                                    businessDetail.businessDetail.businessLogoPath
                                            .isEmpty
                                        ? widget.viewModel.product.first
                                            .productImages.first.imagePath
                                        : businessDetail
                                            .businessDetail.businessLogoPath,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: imageProvider, fit: BoxFit.fill),
                                  ),
                                ),
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) => Shimmer(
                                  color: Theme.of(context).disabledColor,
                                  duration: const Duration(seconds: 2),
                                  enabled: true,
                                  child: SizedBox(
                                    height: 0.3.sh,
                                    width: double.infinity,
                                  ),
                                ),
                                errorWidget: (context, url, error) => SizedBox(
                                  child: SvgPicture.asset(
                                    SvgAssetsPaths.imageSvg,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
