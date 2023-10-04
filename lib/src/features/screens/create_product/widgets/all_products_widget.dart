// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:happiness_club_merchant/src/features/screens/offer_by_business/models/offer_by_business_view_model.dart';
import 'package:happiness_club_merchant/src/features/screens/offer_detail_screen/offer_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happiness_club_merchant/src/features/screens/products_by_business/models/products_by_business_view_model.dart';
import 'package:provider/provider.dart';
import '../../../../../app/app_asset_path/images_util.dart';
import '../../../../../app/app_theme/app_theme.dart';
import '../../../../../utils/globals.dart';
import '../../business/business_detail/model/business_detail_view_model.dart';
import '../../products_by_business/usecase/get_all_products.dart';
import '../../offer_by_business/usecases/get_offers_by_business.dart';

class AllProducts extends StatelessWidget {
  AllProducts({
    Key? key,
    required this.provider,
    required this.fromHome,
  }) : super(key: key);
  final ProductsByBusinessViewModel provider;
  bool? fromHome;
  @override
  Widget build(BuildContext context) {
    return provider.products.isEmpty
        ? Center(
            child: Text(
              "No Product Added",
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(fontWeight: FontWeight.w600, height: 1.1),
            ),
          )
        : GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 5.w,
              childAspectRatio: 0.78,
              mainAxisSpacing: 5.h,
              crossAxisCount: 2,
            ),
            itemCount: fromHome == true
                ? provider.products.length
                : provider.products.length < 2
                    ? provider.products.length
                    : 2,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  provider.onTapProduct(
                      provider.products[index].id, provider.products);
                },
                child: ProductItemTile(
                  productData: provider.products[index],
                ),
              );
            },
          );
  }
}

class ProductItemTile extends StatelessWidget {
  const ProductItemTile({
    super.key,
    required this.productData,
    //required this.showCart,
  });

  final BusinessProduct productData;
  // final bool showCart;

  @override
  Widget build(BuildContext context) {
    //

    //var viewModel = context.watch<BusinessDetailViewModel>();

    return Container(
      decoration: BoxDecoration(
          borderRadius: fieldBorderRadius,
          border: Border.all(color: kBorderColor.withOpacity(0.2))),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: fieldBorderRadius,
            child: CachedNetworkImage(
              height: 130.h,
              imageUrl: productData.productImages.first.imagePath,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  SizedBox(
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
          Padding(
            padding: EdgeInsets.only(left: 10.h, top: 10.h, right: 10.h),
            child: FittedBox(
              fit: BoxFit.fill,
              child: Text(
                productData.productTitle,
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(fontWeight: FontWeight.w600, height: 1.1),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.h, top: 3.h),
            child: Text(
              "\AED ${productData.productPrice}",
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: kPrimaryColor,
                    fontSize: 14.sp,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
        ],
      ),
    );
  }
}

class AllOffers extends StatelessWidget {
  OffersByBusinessViewModel provider;
  AllOffers({Key? key, required this.provider, required this.fromHome})
      : super(key: key);
  bool? fromHome;
  @override
  Widget build(BuildContext context) {
    //

    return provider.offersByBusiness.isEmpty
        ? Center(
            child: Text(
              "No Offer Added",
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(fontWeight: FontWeight.w600, height: 1.1),
            ),
          )
        : GridView.builder(
            reverse: false,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 5.w,
              childAspectRatio: 0.73,
              mainAxisSpacing: 5.h,
              crossAxisCount: 2,
            ),
            itemCount: fromHome == true
                ? provider.offersByBusiness.length
                : provider.offersByBusiness.length < 2
                    ? provider.offersByBusiness.length
                    : 2,
            itemBuilder: (context, index) {
              provider.offersByBusiness.sort(
                (a, b) {
                  if (a.id > b.id) {
                    return 0;
                  } else {
                    return 1;
                  }
                },
              );

              return GestureDetector(
                onTap: () {
                  print(provider.offersByBusiness[index].id);
                  toNext(OfferDetailScreen(
                      id: provider.offersByBusiness[index].id));
                },
                child: OffersItemTile(
                  offerData: provider.offersByBusiness[index],
                ),
              );
            },
          );
  }
}

class OffersItemTile extends StatelessWidget {
  const OffersItemTile({
    super.key,
    required this.offerData,
  });

  final Offer offerData;

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd MMM').format(offerData.expiryDate);
    return Container(
      decoration: BoxDecoration(
          borderRadius: fieldBorderRadius,
          border: Border.all(color: kBorderColor.withOpacity(0.2))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: fieldBorderRadius,
            child: CachedNetworkImage(
              height: 130.h,
              imageUrl: offerData.offerImagePath,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  SizedBox(
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
          Padding(
            padding: EdgeInsets.only(left: 10.h, top: 10.h, right: 10.h),
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Text(
                offerData.offerTitle,
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(fontWeight: FontWeight.w600, height: 1.1),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.h, top: 3.h),
            child: Text(
              "${offerData.offerDiscount.toString()} %",
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: kPrimaryColor,
                    fontSize: 14.sp,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.h, right: 8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Exp: $formattedDate",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(139, 139, 139, 1),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
