import 'dart:async';
import 'package:happiness_club_merchant/app/custom_widgets/custom_snackbar.dart';
import 'package:happiness_club_merchant/src/features/screens/business/business_detail/pdf_view_screen.dart';
import 'package:happiness_club_merchant/src/features/screens/business/business_detail/widgets/all_branches_location_pop_up.dart';
import 'package:happiness_club_merchant/src/features/screens/business/business_detail/widgets/all_business_location_listing_widget.dart';
import 'package:happiness_club_merchant/src/features/screens/business/business_detail/widgets/view_trade_license_widget.dart';
import 'package:happiness_club_merchant/src/features/screens/create_product/widgets/all_products_widget.dart';
import 'package:happiness_club_merchant/src/features/screens/business/business_detail/widgets/business_detail_shimmer_widget.dart';
import 'package:happiness_club_merchant/src/features/screens/offer_by_business/models/offer_by_business_view_model.dart';
import 'package:happiness_club_merchant/src/features/screens/offer_by_business/offers_by_business.dart';
import 'package:happiness_club_merchant/src/features/screens/products_by_business/models/products_by_business_view_model.dart';
import 'package:happiness_club_merchant/src/features/screens/products_by_business/products_by_business.dart';
import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import '../../../../../app/app_asset_path/images_util.dart';
import '../../../../../app/app_theme/app_theme.dart';
import '../../../../../app/toast_messages/toast_messages.dart';
import '../../create_product/model/create_product_view_model.dart';
import '../create_business/create_business.dart';
import '../../../../../utils/globals.dart';
import '../../../../../utils/router/ui_pages.dart';
import 'model/business_detail_view_model.dart';

class BusinessDetailScreen extends StatefulWidget {
  int? id;
  bool isCreated;
  BusinessDetailScreen({Key? key, this.id, required this.isCreated})
      : super(key: key);

  @override
  State<BusinessDetailScreen> createState() => _BusinessDetailScreenState();
}

class _BusinessDetailScreenState extends State<BusinessDetailScreen> {
  late int businessId;
  BusinessDetailViewModel? bv;

  @override
  void initState() {
    super.initState();
    deleFun();
  }

  deleFun() async {
    Future.delayed(const Duration(milliseconds: 200)).then((value) {
      if (widget.isCreated == true) {
        context.read<ProductsByBusinessViewModel>().getProducts(widget.id);
        context.read<BusinessDetailViewModel>().init(widget.id);
        context
            .read<OffersByBusinessViewModel>()
            .getOfferByBusiness(businessId: widget.id!);
      } else {
        getArguments();
        context.read<ProductsByBusinessViewModel>().getProducts(businessId);
        context
            .read<OffersByBusinessViewModel>()
            .getOfferByBusiness(businessId: businessId);
      }

      context.read<BusinessDetailViewModel>().errorMessages =
          (message) => showErrorToast(context, message);
      context.read<BusinessDetailViewModel>().successMessage =
          (message) => showSuccessToast(context, message);
    });
  }

  void getArguments() {
    var pageConfiguration =
        ModalRoute.of(context)?.settings.arguments as PageConfiguration?;

    if (pageConfiguration == null) {
      return;
    }

    var map = pageConfiguration.arguments;

    if (map.isEmpty) {
      return;
    }
    businessId = map['businessId'];

    bv?.init(map['businessId']);
    context.read<BusinessDetailViewModel>().init(businessId);
    context.read<ProductsByBusinessViewModel>().getProducts(businessId);
    context
        .read<OffersByBusinessViewModel>()
        .getOfferByBusiness(businessId: businessId);
    print(businessId);
  }

  @override
  void dispose() {
    bv?.products.clear();

    super.dispose();
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
              padding: EdgeInsets.only(bottom: 8.h),
              child: FloatingActionButton(
                  elevation: 2,
                  backgroundColor: kPrimaryColor,
                  child: Icon(Icons.refresh),
                  onPressed: () async {
                    await deleFun();
                  }),
            ),
            resizeToAvoidBottomInset: false,
            body: BusinessDetailScreenContents(
              id: widget.id,
              isCreated: widget.isCreated,
            ),
          ),
        ),
      ),
    );
  }
}

class BusinessDetailScreenContents extends StatelessWidget {
  int? id;
  bool isCreated;
  BusinessDetailScreenContents({Key? key, this.id, required this.isCreated})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<BusinessDetailViewModel>();

    var productsByBusiness = context.read<ProductsByBusinessViewModel>();
    var offersByBusiness = context.read<OffersByBusinessViewModel>();
    return viewModel.isLoading
        ? Shimming()
        : SingleChildScrollView(
            child: Column(children: [
              SizedBox(
                child: Stack(
                  children: [
                    Positioned(
                      left: 20.h,
                      top: 20.h,
                      child: InkResponse(
                        onTap: () {
                          viewModel.moveBack();
                        },
                        child: SvgPicture.asset(
                          SvgAssetsPaths.backSvg,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 0.16.sh - 50.h),
                      child: SizedBox(
                        height: 185.h,
                        width: MediaQuery.of(context).size.width.w,
                        child: Card(
                          margin: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 16.h),
                          shape: RoundedRectangleBorder(
                              borderRadius: fieldBorderRadius),
                          elevation: 10,
                          shadowColor: canvasColor,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 16.h, right: 16.h, top: 0.05.sh),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 0.54.sw, bottom: 16.h),
                                    child: Row(
                                      children: [
                                        InkResponse(
                                          onTap: () {
                                            toNext(TradeLicense(
                                                path: viewModel.businessDetail
                                                    .tradeLicensePath));
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                SvgAssetsPaths.tradeSvg,
                                                height: 25.h,
                                              ),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              Text(
                                                'Trade license',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineMedium!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: kPrimaryColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        InkResponse(
                                          onTap: () async {
                                            toNext(PdfViewFromNetwork(
                                              path: viewModel.downloadLinkUrl,

                                            ));
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                height: 25.h,
                                                width: 25.h,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey.shade300,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                50.r))),
                                                child: Icon(
                                                  Icons.edit_document,
                                                  size: 12.h,
                                                  color: kBlackColor,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              Text(
                                                'Contract',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineMedium!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: kPrimaryColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 70.h),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              viewModel.businessDetail
                                                  .businessDisplayName,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayMedium!
                                                  .copyWith(
                                                      fontSize: 18.sp,
                                                      fontWeight:
                                                          FontWeight.w600),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 1.w,
                                          ),
                                          if (viewModel.businessDetail
                                                  .businessStatus ==
                                              'pending') ...[
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: kErrorColor,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              20.r))),
                                              child: Icon(
                                                Icons.clear_rounded,
                                                color: canvasColor,
                                                size: 12.h,
                                              ),
                                            ),
                                          ] else ...[
                                            Icon(
                                              Icons.check_circle_rounded,
                                              color: kPrimaryColor,
                                              size: 12.h,
                                            )
                                          ],
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 3.h,
                                    ),
                                    Text(
                                      viewModel.businessDetail.categories
                                          .categoryName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall!
                                          .copyWith(
                                              fontWeight: FontWeight.w400,
                                              color: kPrimaryColor),
                                    ),
                                    SizedBox(
                                      height: 3.h,
                                    ),
                                    Text(
                                      viewModel
                                          .businessDetail.businessLegalName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall!
                                          .copyWith(
                                            fontWeight: FontWeight.w400,
                                          ),
                                    ),
                                    SizedBox(
                                      height: 3.h,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on_outlined,
                                          color: kBorderColor,
                                          size: 20.h,
                                        ),
                                        SizedBox(
                                          width: 3.w,
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(right: 68.h),
                                            child: Text(
                                              viewModel.address,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displaySmall!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: kBorderColor),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0.04.sh,
                      left: 0.0.sh,
                      right: 0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 135.w),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.r)),
                              border: Border.all(
                                  color: kDisabledColor, width: 1.w)),
                          height: 82.h,
                          width: 82.h,
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.r)),
                            child: CachedNetworkImage(
                              imageUrl:
                                  viewModel.businessDetail.businessLogoPath,
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
                                  height: 82.h,
                                  width: 82.h,
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
                      ),
                    ),
                    Positioned(
                      top: 0.13.sh,
                      left: 0.57.sw,
                      child: InkResponse(
                        onTap: () {
                          toNext(CreateBusinessScreen(
                            businessData: viewModel.businessDetail,
                          ));
                        },
                        child: Container(
                            height: 30.h,
                            width: 30.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50.r),
                                ),
                                color: kPrimaryColor),
                            child: Icon(
                              Icons.edit,
                              color: canvasColor,
                              size: 12.h,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.h, right: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Branches'.ntr(),
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(fontWeight: FontWeight.w600),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        if (viewModel.businessDetail.businessBranches.length >
                            2) ...[
                          InkResponse(
                            onTap: () {
                              showBranchesAlert(context);
                            },
                            child: Text(
                              'See All'.ntr(),
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromRGBO(81, 145, 242, 1)),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ],
                    ),
                    BusinessLocationWidget(viewModel: viewModel),
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
                      viewModel.businessDetail.businessDescription,
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
                          'Products'.ntr(),
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(fontWeight: FontWeight.w600),
                          textAlign: TextAlign.start,
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ProductsByBusinessScreen(
                                comingFromHome: false,
                                toHome: false,
                                id: viewModel.businessDetail.id,
                              ),
                            ));
                          },
                          child: Text(
                            'View All'.ntr(),
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromRGBO(81, 145, 242, 1)),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        InkResponse(
                          onTap: () {
                            if (viewModel.businessDetail.businessStatus ==
                                'pending') {
                              showSnackBarMessage(
                                  context: context,
                                  content:
                                      "Can't add products until business has been approved",
                                  backgroundColor: kErrorColor);
                            } else {
                              viewModel.moveToCartScreen();
                            }
                          },
                          child: SvgPicture.asset(
                            SvgAssetsPaths.addIconSvg,
                            height: 32.h,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    AllProducts(
                      fromHome: false,
                      provider: productsByBusiness,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      children: [
                        Text(
                          'Offers'.ntr(),
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(fontWeight: FontWeight.w600),
                          textAlign: TextAlign.start,
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => OffersByBusinessScreen(
                                      comingFromHome: false,
                                      id: viewModel.businessDetail.id,
                                      toHome: false,
                                    )));
                          },
                          child: Text(
                            'View All'.ntr(),
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromRGBO(81, 145, 242, 1)),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        InkResponse(
                          onTap: () {
                            if (viewModel.businessDetail.businessStatus ==
                                'pending') {
                              showSnackBarMessage(
                                  context: context,
                                  content:
                                      "Can't add offers until a product is added",
                                  backgroundColor: kErrorColor);
                            } else {
                              viewModel.moveToCreateOffer();
                            }
                          },
                          child: SvgPicture.asset(
                            SvgAssetsPaths.addIconSvg,
                            height: 32.h,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    AllOffers(fromHome: false, provider: offersByBusiness),
                    SizedBox(
                      height: 10.h,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
            ]),
          );
  }
}
