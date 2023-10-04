// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happiness_club_merchant/src/features/screens/create_product/widgets/select_location_widget.dart';
import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import 'package:happiness_club_merchant/utils/globals.dart';
import 'package:provider/provider.dart';

import '../../../../../app/app_asset_path/images_util.dart';
import '../../../../../app/app_theme/app_theme.dart';
import '../../../../../app/app_usecase/pick_multi_images_from_gallery.dart';
import '../../../../../app/custom_widgets/custom_text_field.dart';
import '../../../../../app/validator/text_field_validator.dart';
import '../../product_detail/usecases/get_product_detail.dart';
import '../model/create_product_view_model.dart';

class CreateAndEditProductForm extends StatefulWidget {
  ProductDetail? data;
  CreateAndEditProductForm({super.key, required this.data});

  @override
  State<CreateAndEditProductForm> createState() =>
      _CreateAndEditProductFormState();
}

class _CreateAndEditProductFormState extends State<CreateAndEditProductForm> {
  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<CreateProductViewModel>();
    return Column(
      children: [
        CustomTextField(
          inputType: TextInputType.text,
          inputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.sentences,
          textEditingController: viewModel.titleController,
          textFieldPadding:
              EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
          hintText: 'Product Title'.ntr(),
          labelText: 'Product Title'.ntr(),
          onChanged: (val) {
            //  viewModel.validateTextFieldsNotEmpty();
          },
          validator: TextFieldValidator.validateText,
        ),
        SizedBox(
          height: 20.h,
        ),
        if (viewModel.isEdit) ...[
          Container(
            margin: EdgeInsets.only(right: 10.w, bottom: 10.h),
            child: ClipRRect(
                borderRadius: fieldBorderRadius,
                child: Stack(
                  children: [
                    Wrap(
                      direction: Axis.horizontal,
                      children: List.generate(
                          List<String>.from(widget.data!.productImages
                              .map((e) => e.imagePath)).length, (index) {
                        return Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 4.0.h, right: 4.h),
                              child: InkWell(
                                onTap: () {},
                                child: ClipRRect(
                                  borderRadius: fieldBorderRadius,
                                  child: SizedBox(
                                    width: 100.h,
                                    height: 80.h,
                                    child: Image.network(
                                      List<String>.from(widget
                                          .data!.productImages
                                          .map((e) => e.imagePath))[index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 3,
                              right: 10,
                              child: GestureDetector(
                                onTap: () {
                                  viewModel.deleteAttachments(
                                      attachmentId:
                                          widget.data!.productImages[index].id,
                                      data: widget.data);
                                },
                                child: SizedBox(
                                  width: 20.h,
                                  height: 20.h,
                                  child: SvgPicture.asset(
                                    SvgAssetsPaths.cancelSvg,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                )),
          ),
        ],
        ValueListenableBuilder<List<MediaResponse>>(
            valueListenable: viewModel.mediaFiles,
            builder: (context, value, _) {
              if (viewModel.uploadableFiles.isNotEmpty) {
                return SizedBox(
                  height: 150.h,
                  width: context.getSize().width,
                  child: OverflowBox(
                    maxWidth: context.getSize().width,
                    maxHeight: 150.h,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: viewModel.uploadableFiles.length,
                        itemBuilder: (context, index) {
                          return Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              borderRadius: fieldBorderRadius,
                            ),
                            margin: EdgeInsets.only(
                                right: 10.w, left: 0, bottom: 10.h),
                            child: Stack(
                              children: [
                                Image(
                                  image: FileImage(
                                    File(viewModel.uploadableFiles[index].path),
                                  ),
                                ),
                                Positioned(
                                  top: 6,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () {
                                      viewModel.removePhotoVideoFile(
                                          viewModel.uploadableFiles[index]);
                                    },
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: const BoxDecoration(
                                          color: Colors.black,
                                          shape: BoxShape.circle),
                                      padding: const EdgeInsets.only(),
                                      child: const Center(
                                        child: Icon(
                                          Icons.close,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
        SizedBox(
          height: 20.h,
        ),
        GestureDetector(
          onTap: () => viewModel.getGalleryImages(),
          child: DottedBorder(
            borderType: BorderType.RRect,
            radius: fieldRadius,
            color: kBorderColor,
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
                        if (viewModel.uploadableFiles.isNotEmpty) ...[
                          CircleAvatar(
                            radius: 50.r,
                            backgroundColor: kWhiteColor,
                            child: ClipRRect(
                                borderRadius: fieldBorderRadius,
                                child: Container(
                                  height: 100.h,
                                  width: 100.h,
                                  color: Colors.red,
                                  child: Image(
                                    fit: BoxFit.fill,
                                    image: FileImage(
                                      File(
                                        viewModel.uploadableFiles.first.path,
                                      ),
                                    ),
                                  ),
                                )),
                          )
                        ] else if (viewModel.isEdit &&
                            widget.data!.productImages.isNotEmpty) ...[
                          CircleAvatar(
                            radius: 50.r,
                            backgroundColor: kWhiteColor,
                            child: ClipRRect(
                                borderRadius: fieldBorderRadius,
                                child: Container(
                                    height: 100.h,
                                    width: 100.h,
                                    color: Colors.red,
                                    child: Image.network(
                                      widget.data!.productImages.first
                                              .imagePath ??
                                          '',
                                      fit: BoxFit.fill,
                                    ))),
                          )
                        ] else ...[
                          SvgPicture.asset(
                            SvgAssetsPaths.cameraSvg,
                            color: kPrimaryColor,
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            'Upload Product Images'.ntr(),
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(fontWeight: FontWeight.w400),
                          ),
                        ],
                        SizedBox(
                          height: 5.h,
                        ),
                        Padding(
                          padding: EdgeInsets.all(15.0.h),
                          child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Good quality product images showing detail'
                                    .ntr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: kcomment),
                                textAlign: TextAlign.center,
                              )),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        CustomTextField(
          inputType: TextInputType.multiline,
          inputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.sentences,
          textEditingController: viewModel.detailController,
          textFieldPadding:
              EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
          textFieldMaxLength: 255,
          textFieldMaxLines: 3,
          hintText: 'Product Detail'.ntr(),
          labelText: 'Product Detail'.ntr(),
          onChanged: (val) {
            //
            //  viewModel.validateTextFieldsNotEmpty();
          },
          validator: TextFieldValidator.validateText,
        ),
        SizedBox(
          height: 20.h,
        ),
        CustomTextField(
          inputType: TextInputType.number,
          inputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.sentences,
          textEditingController: viewModel.priceController,
          textFieldPadding:
              EdgeInsets.symmetric(horizontal: 6.w, vertical: 15.h),
          suffixIcon: Text(
            'AED'.ntr(),
            style: Theme.of(context)
                .textTheme
                .displayMedium!
                .copyWith(fontWeight: FontWeight.w400, color: kPrimaryColor),
          ),
          hintText: 'Set Price'.ntr(),
          labelText: 'Set Price'.ntr(),
          onChanged: (val) {},
          validator: (val) => TextFieldValidator.validateSellingPrice(val),
        ),
        SizedBox(
          height: 10.h,
        ),
        SelectLocationWidget(viewModel: viewModel, data: widget.data),
        SizedBox(
          height: 10.h,
        ),
      ],
    );
  }
}
