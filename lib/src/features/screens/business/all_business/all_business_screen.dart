import 'package:dotted_border/dotted_border.dart';
import 'package:happiness_club_merchant/app/providers/account_provider.dart';
import 'package:happiness_club_merchant/src/features/screens/business/create_business/create_business.dart';
import 'package:happiness_club_merchant/src/features/screens/business/create_business/model/create_business_view_model.dart';
import 'package:happiness_club_merchant/src/features/screens/business/manage_business.dart';
import 'package:happiness_club_merchant/src/features/screens/offer_by_business/models/offer_by_business_view_model.dart';
import 'package:happiness_club_merchant/src/features/screens/products_by_business/models/products_by_business_view_model.dart';
import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import '../../../../../app/app_asset_path/images_util.dart';
import '../../../../../app/app_theme/app_theme.dart';
import '../../../../../app/custom_widgets/custom_snackbar.dart';
import '../../../../../app/custom_widgets/menu_button.dart';
import '../../../../../app/toast_messages/toast_messages.dart';
import '../../../../../utils/globals.dart';
import '../../../drawer/app_drawer.dart';
import '../../create_offer/create_offer.dart';
import '../business_detail/model/business_detail_view_model.dart';
import '../../create_product/model/create_product_view_model.dart';
import 'model/get_all_businesses_view_model.dart';

class AllBusinessesScreen extends StatefulWidget {
  final bool comingFromHome;

  const AllBusinessesScreen({Key? key, required this.comingFromHome})
      : super(key: key);

  @override
  State<AllBusinessesScreen> createState() => _AllBusinessesScreenState();
}

class _AllBusinessesScreenState extends State<AllBusinessesScreen> {
  void initState() {
    super.initState();
    context.read<AllBusinessesViewModel>().init();
    context.read<AllBusinessesViewModel>().errorMessages =
        (message) => showErrorToast(context, message);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: FloatingActionButton(
              elevation: 2,
              onPressed: () async {
                await context.read<AllBusinessesViewModel>().getAllBusinesses();
              },
              backgroundColor: kPrimaryColor,
              child: Icon(Icons.refresh),
            ),
          ),
          drawer: AppMenuDrawer().appDrawer(context),
          appBar: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width, 85.h),
            child: Builder(builder: (ctx) {
              return AppBar(
                centerTitle: true,
                title: Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: context.read<AllBusinessesViewModel>().hasBusiness == 0
                      ? Text('Manage Business',
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(fontWeight: FontWeight.w700))
                      : Text('My Businesses',
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(fontWeight: FontWeight.w700)),
                ),
                titleSpacing: 0,
                // leadingWidth: 150.w,
                leading: widget.comingFromHome == false
                    ? GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: 16.h, top: 8.h),
                          child: Align(
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                              width: 32.h,
                              height: 32.h,
                              SvgAssetsPaths.cancelSvg,
                            ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          Scaffold.of(ctx).openDrawer();
                        },
                        child: MenuButton().show(ctx),
                      ),
                actions: [
                  InkWell(
                    onTap: () {
                      context
                          .read<AllBusinessesViewModel>()
                          .moveToCreateBusiness();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 18, top: 12),
                      child: SizedBox(
                        width: 32.h,
                        height: 32.h,
                        child: SvgPicture.asset(
                          SvgAssetsPaths.addIconSvg,
                        ),
                      ),
                    ),
                  ),
                ],
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 0,
              );
            }),
          ),
          body: AllBusinessesScreenContents(
            comingFromHome: widget.comingFromHome,
          ),
        ),
      ),
    );
  }
}

class AllBusinessesScreenContents extends StatelessWidget {
  final bool comingFromHome;

  const AllBusinessesScreenContents({Key? key, required this.comingFromHome})
      : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<AllBusinessesViewModel>();
    var provider = context.read<CreateBusinessViewModel>();

    return viewModel.hasBusiness == 0
        ? ManageBusinessScreenContents()
        : FocusDetector(
            onFocusGained: () {
              viewModel.init();
            },
            child: Container(
              padding: EdgeInsets.only(left: 16.w, right: 16.w),
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (viewModel.isFetchingNewData) ...[
                    const Center(
                      child: CircularProgressIndicator(
                        color: kPrimaryColor,
                      ),
                    ),
                  ],
                  Expanded(
                    child: viewModel.isLoading
                        ? const AllBusinessesShimmer()
                        : viewModel.allBusinesses.isEmpty
                            ? Text(
                                'No business Added'.ntr(),
                                style: Theme.of(context).textTheme.bodyLarge,
                              )
                            : ListView.builder(
                                itemCount: viewModel.allBusinesses.length,
                                itemBuilder: (BuildContext context, int index) {
                                  print(
                                      "object ${viewModel.allBusinesses[index].businessCoverPath}");
                                  return GestureDetector(
                                    onTap: () async {
                                      await context
                                          .read<ProductsByBusinessViewModel>()
                                          .getProducts(viewModel
                                              .allBusinesses[index].id);
                                      await context
                                          .read<OffersByBusinessViewModel>()
                                          .getOfferByBusiness(
                                              businessId: viewModel
                                                  .allBusinesses[index].id);
                                      viewModel.onTapBusiness(
                                          viewModel.allBusinesses[index]);
                                    },
                                    child: Column(
                                      children: [
                                        Stack(children: [
                                          SizedBox(
                                            height: 150.h,
                                            width: double.infinity,
                                            child: ClipRRect(
                                                borderRadius: fieldBorderRadius,
                                                child: CachedNetworkImage(
                                                  imageUrl: viewModel
                                                          .allBusinesses[index]
                                                          .businessCoverPath ??
                                                      '',
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  progressIndicatorBuilder:
                                                      (context, url,
                                                              downloadProgress) =>
                                                          Shimmer(
                                                    color: Theme.of(context)
                                                        .disabledColor,
                                                    duration: const Duration(
                                                        seconds: 2),
                                                    enabled: true,
                                                    child: SizedBox(
                                                      height: 150.h,
                                                      width: double.infinity,
                                                    ),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          SizedBox(
                                                    child: SvgPicture.asset(
                                                        SvgAssetsPaths.imageSvg,
                                                        fit: BoxFit.fitWidth),
                                                  ),
                                                )),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(5.h),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 1,
                                                    color: kDisabledColor),
                                                borderRadius:
                                                    fieldBorderRadius),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 150.h - 60.h,
                                                        left: 10.w),
                                                    child: Column(children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  kWhiteColor),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      45.r),
                                                        ),
                                                        child: CircleAvatar(
                                                          radius: 40.r,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          child: ClipOval(
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl: viewModel
                                                                  .allBusinesses[
                                                                      index]
                                                                  .businessLogoPath,
                                                              imageBuilder:
                                                                  (context,
                                                                          imageProvider) =>
                                                                      Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  image:
                                                                      DecorationImage(
                                                                    image:
                                                                        imageProvider,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ),
                                                              progressIndicatorBuilder: (context,
                                                                      url,
                                                                      downloadProgress) =>
                                                                  SizedBox(
                                                                      height:
                                                                          30.h,
                                                                      width:
                                                                          30.h,
                                                                      child:
                                                                          Center(
                                                                        child: CircularProgressIndicator
                                                                            .adaptive(
                                                                          value:
                                                                              downloadProgress.progress,
                                                                          valueColor:
                                                                              AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                                                                        ),
                                                                      )),
                                                              errorWidget:
                                                                  (context, url,
                                                                          error) =>
                                                                      SizedBox(
                                                                height: 100.h,
                                                                width: 100.h,
                                                                child:
                                                                    SvgPicture
                                                                        .asset(
                                                                  SvgAssetsPaths
                                                                      .imageSvg,
                                                                  fit: BoxFit
                                                                      .fill,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10.h,
                                                      ),
                                                      Text(
                                                        viewModel
                                                            .allBusinesses[
                                                                index]
                                                            .businessDisplayName,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .displayMedium,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      SizedBox(
                                                        height: 10.h,
                                                      ),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          if (viewModel
                                                                  .allBusinesses[
                                                                      index]
                                                                  .businessStatus ==
                                                              "pending") ...[
                                                            Expanded(
                                                              child: InkWell(
                                                                onTap: () {
                                                                  // Show the custom top Snackbar
                                                                  showSnackBarMessage(
                                                                    context:
                                                                        context,
                                                                    content:
                                                                        "Your business is pending approval please wait",
                                                                  );
                                                                },
                                                                child:
                                                                    Container(
                                                                        padding:
                                                                            EdgeInsets.all(8
                                                                                .h),
                                                                        alignment:
                                                                            Alignment
                                                                                .center,
                                                                        height: 38
                                                                            .h,
                                                                        decoration: BoxDecoration(
                                                                            border:
                                                                                Border.all(color: kPrimaryColor, width: 1.w),
                                                                            borderRadius: BorderRadius.all(Radius.circular(6.r))),
                                                                        child: Image.asset(
                                                                          PngAssetsPath
                                                                              .pendingImg,
                                                                          fit: BoxFit
                                                                              .fill,
                                                                        )),
                                                              ),
                                                            ),
                                                          ] else ...[
                                                            Expanded(
                                                              child: InkWell(
                                                                onTap:
                                                                    () async {
                                                                  await context
                                                                      .read<
                                                                          BusinessDetailViewModel>()
                                                                      .init(viewModel
                                                                          .allBusinesses[
                                                                              index]
                                                                          .id);

                                                                  viewModel.moveToCreateProduct(
                                                                      viewModel
                                                                              .allBusinesses[
                                                                          index]);
                                                                },
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  height: 38.h,
                                                                  decoration: BoxDecoration(
                                                                      border: Border.all(
                                                                          color:
                                                                              kPrimaryColor,
                                                                          width: 1
                                                                              .w),
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(6.r))),
                                                                  child: Text(
                                                                    'Add Product',
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .displaySmall!
                                                                        .copyWith(
                                                                            fontWeight:
                                                                                FontWeight.w400),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 5.w,
                                                            ),
                                                            Expanded(
                                                              child: InkWell(
                                                                onTap:
                                                                    () async {
                                                                  await context
                                                                      .read<
                                                                          BusinessDetailViewModel>()
                                                                      .init(viewModel
                                                                          .allBusinesses[
                                                                              index]
                                                                          .id);
                                                                  viewModel.moveToCreateOffer(
                                                                      viewModel
                                                                              .allBusinesses[
                                                                          index]);
                                                                },
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  height: 38.h,
                                                                  decoration: BoxDecoration(
                                                                      border: Border.all(
                                                                          color:
                                                                              kPrimaryColor,
                                                                          width: 1
                                                                              .w),
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(6.r))),
                                                                  child: Text(
                                                                    'Add Offer',
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .displaySmall!
                                                                        .copyWith(
                                                                            fontWeight:
                                                                                FontWeight.w400),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                          SizedBox(
                                                            width: 10.w,
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10.h,
                                                      ),
                                                    ]),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: InkWell(
                                              onTap: () {
                                                provider
                                                    .getBusinessCoverPicture(
                                                        viewModel
                                                            .allBusinesses[
                                                                index]
                                                            .id);
                                              },
                                              child: Container(
                                                width: 37,
                                                height: 37,
                                                margin:
                                                    const EdgeInsets.all(12),
                                                padding:
                                                    const EdgeInsets.all(8),
                                                decoration: const BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle),
                                                child: const Icon(
                                                  Icons.camera_alt,
                                                  color: kPrimaryColor,
                                                  size: 22,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ]),
                                        SizedBox(height: 20.h),
                                      ],
                                    ),
                                  );
                                }),
                  ),
                ],
              ),
            ),
          );
  }
}

class AllBusinessesShimmer extends StatelessWidget {
  const AllBusinessesShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 2,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Stack(children: [
                ClipRRect(
                  borderRadius: fieldBorderRadius,
                  child: Shimmer(
                    color: Theme.of(context).disabledColor,
                    duration: const Duration(seconds: 2),
                    child: SizedBox(
                      height: 150.h,
                      width: double.infinity,
                      child: const FittedBox(fit: BoxFit.fill),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5.h),
                  // decoration: BoxDecoration(border: Border.all(width: 1, color: kDisabledColor), borderRadius: fieldBorderRadius),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 150.h, left: 10.w),
                          child: Column(children: [
                            SizedBox(
                              height: 10.h,
                            ),
                            ClipRRect(
                              borderRadius: fieldBorderRadius,
                              child: Shimmer(
                                color: Theme.of(context).disabledColor,
                                duration: const Duration(seconds: 2),
                                child: SizedBox(
                                  width: 0.8.sw,
                                  height: 20.h,
                                ),
                              ),
                            )
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
              SizedBox(height: 20.h),
            ],
          );
        });
  }

  DottedBorder buildDottedBorderImages(
      {required BuildContext context,
      required String title,
      required String description,
      required bool isCover,
      required hasWarning}) {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: fieldRadius,
      color: hasWarning ? Theme.of(context).colorScheme.error : kBorderColor,
      dashPattern: const [8, 4],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 0.15.sh,
            ),
            Padding(
              padding: EdgeInsets.only(top: 5.h),
              child: Column(
                children: [
                  SvgPicture.asset(
                    height: 24.h,
                    width: 24.h,
                    SvgAssetsPaths.archiveSvg,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 15.0.h, right: 15.h, bottom: 10.h),
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          description,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  fontWeight: FontWeight.w400, color: kcomment),
                          textAlign: TextAlign.center,
                        )),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
