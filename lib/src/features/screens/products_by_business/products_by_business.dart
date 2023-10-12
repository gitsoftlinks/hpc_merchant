// ignore_for_file: must_be_immutable

import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:happiness_club_merchant/app/app_theme/app_theme.dart';
import 'package:happiness_club_merchant/src/features/home/home_screen.dart';
import 'package:happiness_club_merchant/src/features/home/model/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import '../../../../app/app_asset_path/images_util.dart';
import '../../../../app/custom_widgets/custom_snackbar.dart';
import '../../home/widgets/select_business_bottomsheet.dart';
import '../business/all_business/model/get_all_businesses_view_model.dart';
import '../business/business_detail/model/business_detail_view_model.dart';
import '../create_product/widgets/all_products_widget.dart';
import 'models/products_by_business_view_model.dart';

class ProductsByBusinessScreen extends StatefulWidget {
  bool? comingFromHome;
  bool? toHome;
  int? id;
  ProductsByBusinessScreen(
      {Key? key, required this.comingFromHome, this.id, required this.toHome})
      : super(key: key);

  @override
  State<ProductsByBusinessScreen> createState() =>
      _ProductsByBusinessScreenState();
}

class _ProductsByBusinessScreenState extends State<ProductsByBusinessScreen> {
  void initState() {
    super.initState();
    scheduleMicrotask(() {
      if( context.read<AllBusinessesViewModel>().user.hasBusiness == 1){
        if (widget.id != null) {
          context.read<ProductsByBusinessViewModel>().getProducts(widget.id);
          context.read<BusinessDetailViewModel>().init(widget.id);
        } else {
          context.read<ProductsByBusinessViewModel>().getProducts(
              context.read<AllBusinessesViewModel>().allBusinesses.first.id);
        }
      }

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
                child: Icon(Icons.refresh),
                onPressed: () async {
                  if(context.read<AllBusinessesViewModel>().user.hasBusiness == 1){

                    if (widget.id != null) {
                      await context
                          .read<ProductsByBusinessViewModel>()
                          .getProducts(widget.id);
                    } else {
                      await context.read<ProductsByBusinessViewModel>().getProducts(
                          context
                              .read<AllBusinessesViewModel>()
                              .allBusinesses
                              .first
                              .id);
                    }
                  }

                }),
          ),
          body: ProductsByBusinessScreenContents(
            toHome: widget.toHome,
            comingFromHome: widget.comingFromHome,
            id: widget.id,
          ),
        ),
      ),
    );
  }
}

class ProductsByBusinessScreenContents extends StatelessWidget {
  bool? comingFromHome;
  bool? toHome;
  int? id;
  ProductsByBusinessScreenContents(
      {Key? key, required this.comingFromHome, this.id, required this.toHome})
      : super(key: key);

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<ProductsByBusinessViewModel>();
    var v = context.watch<BusinessDetailViewModel>();
    var k = context.watch<AllBusinessesViewModel>();
    var a = context.watch<HomeViewModel>();
    return viewModel.isLoading
        ? Center(
            child: CircularProgressIndicator(
              backgroundColor: kPrimaryColor,
              color: canvasColor,
            ),
          )
        : Container(
            padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 10.h),
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    children: [
                      if (comingFromHome == false) ...[
                        GestureDetector(
                          onTap: () {
                            if (toHome == true) {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => HomeScreen(
                                  viewModel: a,
                                ),
                              ));
                            } else {
                              Navigator.of(context).pop();
                            }
                          },
                          child: Align(
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                              SvgAssetsPaths.backSvg,
                            ),
                          ),
                        ),
                      ],
                      Spacer(),
                      InkResponse(
                        onTap: () {},
                        child: SvgPicture.asset(
                          SvgAssetsPaths.searchSvg,
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      InkResponse(
                        onTap: () async {
                          if(k.user.hasBusiness == 1){
                            if (id == null) {
                              if (k.allBusinesses.first.businessStatus ==
                                  'pending') {
                                showSnackBarMessage(
                                    context: context,
                                    content:
                                    "Can't add products until business has been approved",
                                    backgroundColor: kErrorColor);
                              } else {
                                await v.init(k.allBusinesses.first.id);
                                v.moveToCartScreen();
                              }
                            } else {
                              if (v.businessDetail.businessStatus == 'pending') {
                                showSnackBarMessage(
                                    context: context,
                                    content:
                                    "Can't add products until business has been approved",
                                    backgroundColor: kErrorColor);
                              } else {
                                await v.init(id);
                                v.moveToCartScreen();
                              }
                            }
                          }else{
                            showSnackBarMessage(context: context, content: 'Please add business to continue');
                          }

                        },
                        child: SvgPicture.asset(
                          SvgAssetsPaths.addIconSvg,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Products',
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      Spacer(),
                      if(k.user.hasBusiness == 1) ...[
                        if (id != null) ...[
                          Expanded(
                            child: Text(
                              v.businessDetail.businessDisplayName,
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.sp),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(50.r)),
                                border: Border.all(
                                    color: kDisabledColor, width: 1.w)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(50.r),
                              ),
                              child: SizedBox(
                                height: 36.h,
                                width: 36.h,
                                child: CachedNetworkImage(
                                  imageUrl: v.businessDetail.businessLogoPath,
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
                                      height: 36.h,
                                      width: 36.h,
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
                          SizedBox(
                            width: 5.w,
                          ),
                          InkResponse(
                            onTap: () {
                              var bottomSheet = SelectBusinessBottomSheet(
                                  fromProduct: true,
                                  viewModel: k,
                                  provider: context
                                      .read<ProductsByBusinessViewModel>());
                              bottomSheet.show();
                            },
                            child: Icon(
                              Icons.arrow_drop_down,
                              color: kPrimaryColor,
                            ),
                          )
                        ] else ...[
                          Expanded(
                            child: Text(
                              k.allBusinesses.first.businessDisplayName,
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.sp),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(50.r)),
                                border: Border.all(
                                    color: kDisabledColor, width: 1.w)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(50.r),
                              ),
                              child: SizedBox(
                                height: 36.h,
                                width: 36.h,
                                child: CachedNetworkImage(
                                  imageUrl:
                                  k.allBusinesses.first.businessLogoPath,
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
                                      height: 36.h,
                                      width: 36.h,
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
                          SizedBox(
                            width: 5.w,
                          ),
                          InkResponse(
                            onTap: () {
                              var bottomSheet = SelectBusinessBottomSheet(
                                  fromProduct: true,
                                  viewModel: k,
                                  provider: context
                                      .read<ProductsByBusinessViewModel>());
                              bottomSheet.show();
                            },
                            child: Icon(
                              Icons.arrow_drop_down,
                              color: kPrimaryColor,
                            ),
                          )
                        ],
                      ] else ...[  Expanded(
                        child: Text(
                          'No business',
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 13.sp),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(50.r)),
                              border: Border.all(
                                  color: kDisabledColor, width: 1.w)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(50.r),
                            ),
                            child: SizedBox(
                              height: 36.h,
                              width: 36.h,
                              child: CachedNetworkImage(
                                imageUrl:  v.businessDetail
                                    .businessLogoPath,
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
                                    height: 36.h,
                                    width: 36.h,
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
                        SizedBox(
                          width: 5.w,
                        ),
                        InkResponse(
                          onTap: () {
                            showSnackBarMessage(context: context, content: "No business Added");
                          },
                          child: Icon(
                            Icons.arrow_drop_down,
                            color: kPrimaryColor,
                          ),
                        )],

                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  viewModel.products.isEmpty
                      ? SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.all(20.h),
                            child: Text(
                              'No Products Found!',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                        )
                      : AllProducts(
                          provider: viewModel,
                          fromHome: true,
                        ),
                  SizedBox(
                    height: 20.h,
                  )
                ],
              ),
            ));
  }
}
