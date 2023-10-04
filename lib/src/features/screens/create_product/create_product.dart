// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:io';
import 'package:happiness_club_merchant/app/custom_widgets/custom_snackbar.dart';
import 'package:happiness_club_merchant/src/features/screens/business/all_business/model/get_all_businesses_view_model.dart';
import 'package:happiness_club_merchant/src/features/screens/business/business_detail/business_detail_screen.dart';
import 'package:happiness_club_merchant/src/features/screens/create_product/model/create_product_view_model.dart';
import 'package:happiness_club_merchant/src/features/screens/create_product/usecases/get_business_locations.dart';
import 'package:happiness_club_merchant/src/features/screens/create_product/widgets/create_and_edit_product_form.dart';
import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import '../../../../app/app_usecase/pick_multi_images_from_gallery.dart';
import '../../../../app/custom_widgets/direction.dart';
import '../../../../app/app_asset_path/images_util.dart';
import '../../../../app/app_theme/app_theme.dart';
import '../../../../app/custom_widgets/continue_button.dart';
import '../../../../app/custom_widgets/custom_text_field.dart';
import '../../../../app/toast_messages/toast_messages.dart';
import '../../../../app/validator/text_field_validator.dart';
import '../../../../utils/globals.dart';
import '../business/business_detail/model/business_detail_view_model.dart';
import '../product_detail/usecases/get_product_detail.dart';

class CreateProductScreen extends StatelessWidget {
  ProductDetail? data;
  CreateProductScreen({Key? key, this.data}) : super(key: key);

  CreateProductViewModel get viewModel => sl();
  AllBusinessesViewModel get provider => sl();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: ChangeNotifierProvider.value(
        value: provider,
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: SafeArea(
            child: Scaffold(
              body: CreateProductScreenContents(data: data),
            ),
          ),
        ),
      ),
    );
  }
}

class CreateProductScreenContents extends StatefulWidget {
  ProductDetail? data;
  CreateProductScreenContents({Key? key, this.data}) : super(key: key);

  @override
  State<CreateProductScreenContents> createState() =>
      _CreateProductScreenContentsState();
}

class _CreateProductScreenContentsState
    extends State<CreateProductScreenContents> {
  @override
  @override
  void initState() {
    super.initState();
    scheduleMicrotask(() {
      if (context.read<BusinessDetailViewModel>().businessDetail.id == 0) {
        context.read<CreateProductViewModel>().init(
            context.read<AllBusinessesViewModel>().allBusinesses.first.id,
            widget.data);
      } else {
        context.read<CreateProductViewModel>().init(
            context.read<BusinessDetailViewModel>().businessDetail.id,
            widget.data);
      }
    });

    context.read<BusinessDetailViewModel>().errorMessages =
        (message) => showErrorToast(context, message);
    context.read<BusinessDetailViewModel>().successMessage =
        (message) => showSuccessToast(context, message);
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.read<BusinessDetailViewModel>();
    var provider2 = context.read<AllBusinessesViewModel>();
    var viewModel = context.watch<CreateProductViewModel>();
    return viewModel.isLoading
        ? Center(
            child: CircularProgressIndicator(
              color: kPrimaryColor,
              backgroundColor: canvasColor,
            ),
          )
        : Container(
            padding: EdgeInsets.only(left: 16.w, right: 16.w),
            height: double.infinity,
            child: SingleChildScrollView(
              child: Form(
                key: viewModel.createProductsFormKey,
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
                              viewModel.createProductsFormKey.currentState!
                                  .reset();
                              viewModel.isEdit = false;

                              Navigator.of(navigatorKeyGlobal.currentContext!)
                                  .pop();
                            },
                            child: Padding(
                              padding: EdgeInsets.only(top: 3.0.h),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: SvgPicture.asset(
                                  SvgAssetsPaths.backIconSvg,
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          if (provider.businessDetail.id == 0) ...[
                            GestureDetector(
                              onTap: () {
                                toNext(BusinessDetailScreen(
                                  isCreated: true,
                                  id: provider2.allBusinesses.first.id,
                                ));
                              },
                              child: Text(
                                provider2
                                    .allBusinesses.first.businessDisplayName,
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
                                    imageUrl: provider2
                                        .allBusinesses.first.businessLogoPath,
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
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      viewModel.isEdit
                          ? "Edit Product".ntr()
                          : "Add Product".ntr(),
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge!
                          .copyWith(fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    CreateAndEditProductForm(
                      data: widget.data,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    if (viewModel.isEdit == false) ...[
                      ContinueButton(
                        loadingNotifier: viewModel.isLoadingNotifier,
                        text: 'Save And Add Another Product',
                        backgroundColor: Color.fromRGBO(77, 63, 50, 1),
                        onPressed: () async {
                          if (viewModel.uploadableFiles.isEmpty) {
                            showSnackBarMessage(
                                context: context,
                                content:
                                    "Please select at least one image to create product ",
                                backgroundColor: kErrorColor);
                          } else {
                            if (viewModel.objectList.isEmpty) {
                              showSnackBarMessage(
                                  context: context,
                                  content:
                                      "Please select at least one location to create product ",
                                  backgroundColor: kErrorColor);
                            } else {
                              if (viewModel.createProductsFormKey.currentState!
                                  .validate()) {
                                viewModel.isExit = true;

                                await viewModel
                                    .addNewProduct(provider.businessDetail.id);
                                Future.delayed(Duration(seconds: 1), () {
                                  viewModel.createProductsFormKey.currentState!
                                      .reset();
                                });
                              }
                            }
                          }
                        },
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                    ContinueButton(
                        loadingNotifier: viewModel.isLoadingNotifier2,
                        text: viewModel.isEdit ? 'Update' : 'Save',
                        onPressed: () async {
                          if (viewModel.isEdit) {
                            await viewModel.editProductPost(
                                provider.businessDetail.id, widget.data!.id);
                          } else {
                            if (viewModel.uploadableFiles.isEmpty) {
                              showSnackBarMessage(
                                  context: context,
                                  content:
                                      "Please select at least one image to create product ",
                                  backgroundColor: kErrorColor);
                            } else {
                              if (viewModel.createProductsFormKey.currentState!
                                  .validate()) {
                                if (viewModel.objectList.isEmpty) {
                                  showSnackBarMessage(
                                      context: context,
                                      content:
                                          "Please select at least one location to create product ",
                                      backgroundColor: kErrorColor);
                                } else {
                                  await viewModel.addNewProduct(
                                      provider.businessDetail.id);
                                }
                              }
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
