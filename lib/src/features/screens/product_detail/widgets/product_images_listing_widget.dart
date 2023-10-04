// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happiness_club_merchant/src/features/screens/product_detail/widgets/zoomed_image.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../../../app/app_asset_path/images_util.dart';
import '../../../../../utils/globals.dart';
import '../model/product_detail_view_model.dart';

class ProductImagesListing extends StatelessWidget {
  ProductDetailViewModel viewModel;
  ProductImagesListing({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 5.w,
        childAspectRatio: 1.3,
        mainAxisSpacing: 5.h,
        crossAxisCount: 2,
      ),
      itemCount: viewModel.postDetail.productImages.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.all(2.h),
          child: GestureDetector(
              onTap: () {
                toNext(ZoomedImage(
                    path: viewModel.postDetail.productImages[index].imagePath));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(12.r)),
                child: CachedNetworkImage(
                  imageUrl: viewModel.postDetail.productImages[index].imagePath,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Shimmer(
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
              )),
        );
      },
    );
  }
}
