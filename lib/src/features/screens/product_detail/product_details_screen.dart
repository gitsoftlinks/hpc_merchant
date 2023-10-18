import 'dart:async';
import 'package:happiness_club_merchant/app/app_theme/app_theme.dart';
import 'package:happiness_club_merchant/src/features/screens/business/business_detail/widgets/business_detail_shimmer_widget.dart';
import 'package:happiness_club_merchant/src/features/screens/create_product/create_product.dart';
import 'package:happiness_club_merchant/src/features/screens/product_detail/widgets/current_product_business_widget.dart';
import 'package:happiness_club_merchant/src/features/screens/product_detail/widgets/product_images_listing_widget.dart';
import 'package:happiness_club_merchant/src/features/screens/product_detail/widgets/product_locations_listing_widget.dart';
import 'package:happiness_club_merchant/src/features/screens/offer_detail_screen/models/offer_detail_view_model.dart';
import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import '../../../../app/app_asset_path/images_util.dart';
import '../../../../app/toast_messages/toast_messages.dart';
import '../../../../utils/globals.dart';
import '../../../../utils/router/ui_pages.dart';
import 'model/product_detail_view_model.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({Key? key}) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  void initState() {
    super.initState();

    getArguments();

    context.read<ProductDetailViewModel>().errorMessages =
        (message) => showErrorToast(context, message);

    context.read<ProductDetailViewModel>().successMessage =
        (message) => showSuccessToast(context, message);
  }

  void getArguments() {
    scheduleMicrotask(() {
      if (!mounted) {
        return;
      }

      var pageConfiguration =
          ModalRoute.of(context)?.settings.arguments as PageConfiguration?;

      if (pageConfiguration == null) {
        return;
      }

      var map = pageConfiguration.arguments;

      if (map.isEmpty) {
        return;
      }

      if (context.read<OfferDetailViewModel>().fromOffer) {
        context.read<ProductDetailViewModel>().product = map['productList'];
        context.read<OfferDetailViewModel>().fromOffer = false;
      } else {
        context.read<ProductDetailViewModel>().productList = map['productList'];
      }

      context.read<ProductDetailViewModel>().productId = map['productId'];

      context.read<ProductDetailViewModel>().init();

      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: Padding(
            padding:  EdgeInsets.only(bottom:8.h),
            child: FloatingActionButton(
              elevation: 2,
              backgroundColor: kPrimaryColor,
              onPressed: () async {
                await context.read<ProductDetailViewModel>().init();
              },
              child: Icon(Icons.refresh),
            ),
          ),
          body: ProductDetailsScreenContents(),
        ),
      ),
    );
  }
}

class ProductDetailsScreenContents extends StatelessWidget {
  const ProductDetailsScreenContents({Key? key}) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<ProductDetailViewModel>();

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
                                imageUrl: viewModel
                                    .postDetail.productImages.first.imagePath,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover),
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

                            viewModel.productLocations = [];
                          },
                          child: SvgPicture.asset(
                            SvgAssetsPaths.backSvg,
                          ),
                        ),
                      ),
                      CurrentProductBusinessWidget(viewModel: viewModel),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.h, right: 16.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              viewModel.postDetail.productTitle,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20.sp),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              print('edit');
                              toNext(CreateProductScreen(
                                  data: viewModel.postDetail));
                            },
                            child: SvgPicture.asset(
                              SvgAssetsPaths.editProductSvg,
                              height: 25.h,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      ProductLocationListingWidget(viewModel: viewModel),
                      SizedBox(
                        height: 3.h,
                      ),
                      Text(
                        '${'AED ${viewModel.postDetail.productPrice}'.ntr()}',
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
                        viewModel.postDetail.productDetails,
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        "Product Images".ntr(),
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 20.sp),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      ProductImagesListing(viewModel: viewModel),
                      SizedBox(
                        height: 20.h,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
