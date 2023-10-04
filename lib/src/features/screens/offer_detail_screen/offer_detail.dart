// ignore_for_file: must_be_immutable

import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:happiness_club_merchant/src/features/screens/business/business_detail/widgets/business_detail_shimmer_widget.dart';
import 'package:happiness_club_merchant/src/features/screens/create_offer/create_offer.dart';
import 'package:happiness_club_merchant/src/features/screens/offer_detail_screen/widgets/offer_active_products_listing_widget.dart';
import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import '../../../../app/app_asset_path/images_util.dart';
import '../../../../app/app_theme/app_theme.dart';
import '../../../../utils/globals.dart';
import '../business/business_detail/business_detail_screen.dart';
import 'models/offer_detail_view_model.dart';

class OfferDetailScreen extends StatefulWidget {
  int id;
  OfferDetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<OfferDetailScreen> createState() => _OfferDetailScreenState();
}

class _OfferDetailScreenState extends State<OfferDetailScreen> {
  void initState() {
    scheduleMicrotask(() {
      context.read<OfferDetailViewModel>().fromOffer = false;
      context.read<OfferDetailViewModel>().init(widget.id);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          child: Scaffold(
            floatingActionButton: Padding(
              padding:  EdgeInsets.only(bottom:8.h),
              child: FloatingActionButton(
                  elevation: 2,
                  child: Icon(Icons.refresh),
                  backgroundColor: kPrimaryColor,
                  onPressed: () async {
                    context.read<OfferDetailViewModel>().init(widget.id);
                  }),
            ),
            resizeToAvoidBottomInset: true,
            body: OfferDetailScreenContents(),
          ),
        ),
      ),
    );
  }
}

class OfferDetailScreenContents extends StatelessWidget {
  OfferDetailScreenContents({Key? key}) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<OfferDetailViewModel>();

    String formattedStartDate =
        DateFormat('dd MMM').format(viewModel.offerDetail.startDate);
    String formattedEndDate =
        DateFormat('dd MMM').format(viewModel.offerDetail.expiryDate);
    return viewModel.isLoading
        ? Shimming()
        : SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 0.3.sh,
                              child: CachedNetworkImage(
                                imageUrl: viewModel.offerDetail.offerImagePath,
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
                                    height: 0.3.sh,
                                    width: double.infinity,
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
                        ],
                      ),
                      Positioned(
                        left: 20.h,
                        top: 30.h,
                        child: InkResponse(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: SvgPicture.asset(
                            SvgAssetsPaths.backSvg,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 0.221.sh),
                        child: InkWell(
                          onTap: () {
                            toNext(BusinessDetailScreen(
                              isCreated: true,
                              id: viewModel.offerDetail.offersProducts.first
                                  .product.first.businessId,
                            ));
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: kPrimaryColor.withOpacity(0.8),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25.r),
                                    topRight: Radius.circular(0.r),
                                    bottomLeft: Radius.circular(0.r),
                                    bottomRight: Radius.circular(0.r),
                                  ),
                                ),
                                height: 55.h,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 16.h,
                                      right: 16.h,
                                      top: 8.h,
                                      bottom: 8.h),
                                  child: Row(
                                    children: [
                                      Text(
                                        viewModel
                                            .offerDetail
                                            .offersProducts
                                            .first
                                            .product
                                            .first
                                            .business
                                            .businessDisplayName,
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
                                      Container(
                                        height: 36.h,
                                        width: 36.h,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.r)),
                                          child: CachedNetworkImage(
                                            imageUrl: viewModel
                                                .offerDetail
                                                .offersProducts
                                                .first
                                                .product
                                                .first
                                                .business
                                                .businessLogoPath,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover),
                                              ),
                                            ),
                                            progressIndicatorBuilder: (context,
                                                    url, downloadProgress) =>
                                                Shimmer(
                                              color: Theme.of(context)
                                                  .disabledColor,
                                              duration:
                                                  const Duration(seconds: 2),
                                              enabled: true,
                                              child: SizedBox(
                                                height: 0.3.sh,
                                                width: double.infinity,
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    SizedBox(
                                              child: SvgPicture.asset(
                                                SvgAssetsPaths.imageSvg,
                                                fit: BoxFit.fitWidth,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
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
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.h, right: 16.h),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: InkResponse(
                            onTap: () {
                              toNext(CreateOfferScreen(
                                  data: viewModel.offerDetail));
                            },
                            child: SvgPicture.asset(
                              SvgAssetsPaths.editProductSvg,
                              height: 30.h,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Start Date: $formattedStartDate - End Date: $formattedEndDate',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          Text(
                            viewModel.offerDetail.offerTitle,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20.sp),
                          ),
                          Text(
                            '${'${viewModel.offerDetail.offerDiscount} \%'.ntr()}',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: kPrimaryColor),
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          Text(
                            'Details'.ntr(),
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(fontWeight: FontWeight.w600),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          Text(
                            viewModel.offerDetail.offerDescription,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                            children: [
                              Text(
                                "Products".ntr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20.sp),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          OfferActiveProductsListingWidget(
                              viewModel: viewModel),
                          SizedBox(
                            height: 20.h,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
