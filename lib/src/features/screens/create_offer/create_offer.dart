import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:happiness_club_merchant/app/app_asset_path/images_util.dart';
import 'package:happiness_club_merchant/app/app_theme/app_theme.dart';
import 'package:happiness_club_merchant/app/custom_widgets/custom_snackbar.dart';
import 'package:happiness_club_merchant/src/features/screens/business/business_detail/model/business_detail_view_model.dart';
import 'package:happiness_club_merchant/src/features/screens/create_offer/widgets/create_and_edit_offer_form.dart';
import 'package:happiness_club_merchant/src/features/screens/offer_detail_screen/usecases/get_offer_detail.dart';
import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import '../../../../app/custom_widgets/continue_button.dart';
import '../../../../app/toast_messages/toast_messages.dart';
import '../../../../utils/globals.dart';
import '../business/business_detail/business_detail_screen.dart';
import 'model/create_offer_view_model.dart';

// ignore: must_be_immutable
class CreateOfferScreen extends StatelessWidget {
  OfferDetail? data;
  CreateOfferScreen({Key? key, this.data}) : super(key: key);

  CreateOfferViewModel get viewModel => sl();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: CreateOfferScreenContents(
              data: data,
            ),
          ),
        ),
      ),
    );
  }
}

class CreateOfferScreenContents extends StatefulWidget {
  OfferDetail? data;
  CreateOfferScreenContents({Key? key, this.data}) : super(key: key);

  @override
  State<CreateOfferScreenContents> createState() =>
      _CreateOfferScreenContentsState();
}

class _CreateOfferScreenContentsState extends State<CreateOfferScreenContents> {
  @override
  void initState() {
    if (widget.data != null) {
      scheduleMicrotask(() {
        if (widget.data!.offersProducts.isNotEmpty) {
          context.read<CreateOfferViewModel>().init(
              widget.data!.offersProducts.first.product.first.businessId,
              widget.data);
        } else {
          context.read<CreateOfferViewModel>().init2(
                context.read<CreateOfferViewModel>().businessId,
              );
        }

        Intl.systemLocale = 'en_En';
      });
    } else {
      scheduleMicrotask(() {
        context.read<CreateOfferViewModel>().init2(
              context.read<BusinessDetailViewModel>().businessDetail.id,
            );
      });
    }

    context.read<CreateOfferViewModel>().errorMessages =
        (message) => showErrorToast(context, message);
    context.read<CreateOfferViewModel>().successMessage =
        (message) => showSuccessToast(context, message);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<CreateOfferViewModel>();
    var provider = context.watch<BusinessDetailViewModel>();
    return viewModel.isLoading2
        ? Center(
            child: CircularProgressIndicator(
              backgroundColor: kPrimaryColor,
              color: canvasColor,
            ),
          )
        : Container(
            padding: EdgeInsets.only(left: 16.w, right: 16.w),
            height: double.infinity,
            child: SingleChildScrollView(
              child: Form(
                key: viewModel.createOffersFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await viewModel.clearData();
                              Navigator.of(navigatorKeyGlobal.currentContext!)
                                  .pop();
                            },
                            child: Padding(
                              padding: EdgeInsets.only(top: 3.0.h),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: SvgPicture.asset(
                                  SvgAssetsPaths.backSvg,
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          if (viewModel.isEdit) ...[
                            if (widget.data!.offersProducts.isNotEmpty) ...[
                              GestureDetector(
                                onTap: () {
                                  toNext(BusinessDetailScreen(
                                    isCreated: true,
                                    id: widget.data!.offersProducts.first
                                        .product.first.businessId,
                                  ));
                                },
                                child: Text(
                                  widget.data!.offersProducts.first.product
                                      .first.business.businessDisplayName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13.sp),
                                ),
                              ),
                              SizedBox(
                                width: 3.w,
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
                                      imageUrl: widget
                                          .data!
                                          .offersProducts
                                          .first
                                          .product
                                          .first
                                          .business
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
                                          (context, url, downloadProgress) =>
                                              Shimmer(
                                        color: Theme.of(context).disabledColor,
                                        duration: const Duration(seconds: 2),
                                        enabled: true,
                                        child: SizedBox(
                                          height: 36.h,
                                          width: 36.h,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          SizedBox(
                                        child: SvgPicture.asset(
                                          SvgAssetsPaths.imageSvg,
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ] else ...[
                              GestureDetector(
                                onTap: () {
                                  toNext(BusinessDetailScreen(
                                    isCreated: true,
                                    id: provider.businessDetail.id,
                                  ));
                                },
                                child: Text(
                                  provider.businessDetail.businessDisplayName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13.sp),
                                ),
                              ),
                              SizedBox(
                                width: 3.w,
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
                                      imageUrl: provider
                                          .businessDetail.businessLogoPath,
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
                                          (context, url, downloadProgress) =>
                                              Shimmer(
                                        color: Theme.of(context).disabledColor,
                                        duration: const Duration(seconds: 2),
                                        enabled: true,
                                        child: SizedBox(
                                          height: 36.h,
                                          width: 36.h,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          SizedBox(
                                        child: SvgPicture.asset(
                                          SvgAssetsPaths.imageSvg,
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ] else ...[
                            GestureDetector(
                              onTap: () {
                                toNext(BusinessDetailScreen(
                                  isCreated: true,
                                  id: provider.businessDetail.id,
                                ));
                              },
                              child: Text(
                                provider.businessDetail.businessDisplayName,
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13.sp),
                              ),
                            ),
                            SizedBox(
                              width: 3.w,
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
                                    imageUrl: provider
                                        .businessDetail.businessLogoPath,
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
                                        (context, url, downloadProgress) =>
                                            Shimmer(
                                      color: Theme.of(context).disabledColor,
                                      duration: const Duration(seconds: 2),
                                      enabled: true,
                                      child: SizedBox(
                                        height: 36.h,
                                        width: 36.h,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        SizedBox(
                                      child: SvgPicture.asset(
                                        SvgAssetsPaths.imageSvg,
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      viewModel.isEdit ? "Edit Offer".ntr() : "Add Offer".ntr(),
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge!
                          .copyWith(fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    CreateAndEditOfferForm(data: widget.data),
                    SizedBox(
                      height: 10.h,
                    ),
                    ContinueButton(
                        loadingNotifier: viewModel.isLoadingNotifier,
                        text: viewModel.isEdit ? 'Update' : 'Create',
                        onPressed: () async {
                          if (viewModel.isEdit) {
                            if (viewModel.productsByBusinessList.isNotEmpty ||
                                widget.data!.offersProducts.isNotEmpty) {
                              if (viewModel.createOffersFormKey.currentState!
                                  .validate()) {
                                if (viewModel.offerImage != null ||
                                    widget.data!.offerImagePath.isNotEmpty) {
                                  await viewModel.updateOffer();
                                } else {
                                  showSnackBarMessage(
                                      context: context,
                                      content:
                                          "Please add image to create offer",
                                      backgroundColor: kErrorColor);
                                }
                              } else {
                                showSnackBarMessage(
                                    context: context,
                                    content:
                                        "Please add product to create offer",
                                    backgroundColor: kErrorColor);
                              }
                            }
                          } else {
                            if (viewModel.productsByBusinessList.isNotEmpty) {
                              if (viewModel.createOffersFormKey.currentState!
                                  .validate()) {
                                if (viewModel.offerImage != null) {
                                  print(
                                      "id ${context.read<BusinessDetailViewModel>().businessDetail.id}");
                                  await viewModel.createOffer();
                                } else {
                                  showSnackBarMessage(
                                      context: context,
                                      content:
                                          "Please add image to create offer",
                                      backgroundColor: kErrorColor);
                                }
                              }
                            } else {
                              showSnackBarMessage(
                                  context: context,
                                  content: "Please add product to create offer",
                                  backgroundColor: kErrorColor);
                            }
                          }
                        }),
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
