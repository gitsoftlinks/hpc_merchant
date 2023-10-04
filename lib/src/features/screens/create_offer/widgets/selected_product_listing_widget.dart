// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happiness_club_merchant/src/features/screens/create_offer/model/create_offer_view_model.dart';
import 'package:happiness_club_merchant/src/features/screens/offer_detail_screen/usecases/get_offer_detail.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../../../app/app_asset_path/images_util.dart';
import '../../../../../app/app_theme/app_theme.dart';

class SelectedProductListingWidget extends StatefulWidget {
  CreateOfferViewModel viewModel;
  OfferDetail? data;
  SelectedProductListingWidget(
      {super.key, required this.viewModel, required this.data});

  @override
  State<SelectedProductListingWidget> createState() =>
      _SelectedProductListingWidgetState();
}

class _SelectedProductListingWidgetState
    extends State<SelectedProductListingWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.viewModel.isEdit) ...[
          ListView.builder(
            itemCount: widget.data!.offersProducts.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              var data = widget.data!.offersProducts[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Container(
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(225, 225, 225, 1),
                      borderRadius: BorderRadius.all(Radius.circular(12.r))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          // setState(() {
                          widget.viewModel.deleteAttachments(
                              attachmentId: data.id, data: widget.data);

                          //  viewModel.productId.removeAt(index);
                          //  });
                        },
                        icon: Icon(
                          Icons.cancel,
                          color: kBlackColor,
                          size: 18.h,
                        ),
                      ),
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.r),
                          ),
                          child: SizedBox(
                            height: 70.h,
                            width: 70.h,
                            child: CachedNetworkImage(
                              imageUrl: data
                                  .product.first.productImages.first.imagePath,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => Shimmer(
                                color: Theme.of(context).disabledColor,
                                duration: const Duration(seconds: 2),
                                enabled: true,
                                child: SizedBox(
                                  height: 70.h,
                                  width: 70.h,
                                ),
                              ),
                              errorWidget: (context, url, error) => SizedBox(
                                child: SvgPicture.asset(
                                  SvgAssetsPaths.imageSvg,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 16.h, right: 16.h, top: 16.h),
                        child: Row(children: [
                          Text(data.product.first.productTitle,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18.sp)),
                          Spacer(),
                          Text("AED ${data.product.first.productPrice}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.sp,
                                      color: Color.fromRGBO(186, 186, 186, 1))),
                        ]),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 16.h, right: 16.h, top: 10.h),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(data.product.first.productDetails,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontWeight: FontWeight.w400)),
                              ])),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(
            height: 10.h,
          ),
        ],
        ListView.builder(
          itemCount: widget.viewModel.productsByBusinessList.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            var data = widget.viewModel.productsByBusinessList[index];
            return Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromRGBO(225, 225, 225, 1),
                    borderRadius: BorderRadius.all(Radius.circular(12.r))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          widget.viewModel.productsByBusinessList
                              .removeAt(index);
                          //  viewModel.productId.removeAt(index);
                        });
                      },
                      icon: Icon(
                        Icons.cancel,
                        color: kBlackColor,
                        size: 18.h,
                      ),
                    ),
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12.r),
                        ),
                        child: SizedBox(
                          height: 70.h,
                          width: 70.h,
                          child: CachedNetworkImage(
                            imageUrl: data.productImages.first.imagePath,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Shimmer(
                              color: Theme.of(context).disabledColor,
                              duration: const Duration(seconds: 2),
                              enabled: true,
                              child: SizedBox(
                                height: 70.h,
                                width: 70.h,
                              ),
                            ),
                            errorWidget: (context, url, error) => SizedBox(
                              child: SvgPicture.asset(
                                SvgAssetsPaths.imageSvg,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 16.h, right: 16.h, top: 16.h),
                      child: Row(children: [
                        Text(data.productTitle,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18.sp)),
                        Spacer(),
                        Text("AED ${data.productPrice}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.sp,
                                    color: Color.fromRGBO(186, 186, 186, 1))),
                      ]),
                    ),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 16.h, right: 16.h, top: 10.h),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(data.productDetails,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontWeight: FontWeight.w400)),
                            ])),
                    SizedBox(
                      height: 10.h,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
