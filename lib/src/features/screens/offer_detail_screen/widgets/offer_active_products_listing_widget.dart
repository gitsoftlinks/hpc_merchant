// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../app/app_asset_path/images_util.dart';
import '../../../../../app/app_theme/app_theme.dart';
import '../models/offer_detail_view_model.dart';

class OfferActiveProductsListingWidget extends StatelessWidget {
  OfferDetailViewModel viewModel;
  OfferActiveProductsListingWidget({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 5.w,
        childAspectRatio: 0.8,
        mainAxisSpacing: 5.h,
        crossAxisCount: 2,
      ),
      itemCount: viewModel.offerDetail.offersProducts.length,
      itemBuilder: (context, index) {
        var product = viewModel.offerDetail.offersProducts[index].product;
        return GestureDetector(
          onTap: () {
            viewModel.onTapProduct(product.first.id, product);
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: fieldBorderRadius,
                border: Border.all(color: kBorderColor.withOpacity(0.2))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: fieldBorderRadius,
                  child: CachedNetworkImage(
                    height: 130.h,
                    imageUrl: product.first.productImages.first.imagePath,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => SizedBox(
                            height: 30.h,
                            width: 50.h,
                            child: Center(
                              child: CircularProgressIndicator.adaptive(
                                value: downloadProgress.progress,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).primaryColor),
                              ),
                            )),
                    errorWidget: (context, url, error) => SizedBox(
                      width: double.infinity,
                      child: SvgPicture.asset(
                        SvgAssetsPaths.imageSvg,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 20.h, top: 10.h),
                        child: Text(
                          product.first.productTitle,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(fontWeight: FontWeight.w600, height: 1.1,overflow: TextOverflow.ellipsis),maxLines: 2,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
