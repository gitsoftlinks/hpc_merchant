// ignore_for_file: must_be_immutable

import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happiness_club_merchant/app/custom_widgets/custom_snackbar.dart';
import 'package:happiness_club_merchant/src/features/screens/create_offer/model/create_offer_view_model.dart';
import 'package:happiness_club_merchant/src/features/screens/create_offer/widgets/select_product_widget.dart';
import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import 'package:provider/provider.dart';
import '../../../../../app/app_asset_path/images_util.dart';
import '../../../../../app/app_theme/app_theme.dart';
import '../../../../../app/custom_widgets/custom_text_field.dart';
import '../../../../../app/validator/text_field_validator.dart';
import '../../offer_detail_screen/usecases/get_offer_detail.dart';
import 'package:intl/intl.dart';

class CreateAndEditOfferForm extends StatefulWidget {
  OfferDetail? data;
  CreateAndEditOfferForm({super.key, required this.data});

  @override
  State<CreateAndEditOfferForm> createState() => _CreateAndEditOfferFormState();
}

class _CreateAndEditOfferFormState extends State<CreateAndEditOfferForm> {
  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<CreateOfferViewModel>();
    return Column(
      children: [
        CustomTextField(
          inputType: TextInputType.text,
          inputAction: TextInputAction.next,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          textEditingController: viewModel.nameController,
          textFieldPadding:
              EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
          hintText: 'Title'.ntr(),
          labelText: 'Title'.ntr(),
          onChanged: (val) {},
          validator: TextFieldValidator.validateText,
        ),
        SizedBox(
          height: 20.h,
        ),
        CustomTextField(
          inputType: TextInputType.number,
          inputAction: TextInputAction.next,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          textEditingController: viewModel.discountController,
          textFieldPadding:
              EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
          hintText: 'Discount %'.ntr(),
          labelText: 'Discount %'.ntr(),
          onChanged: (val) {
            //  viewModel.validateTextFieldsNotEmpty();
          },
          validator: TextFieldValidator.validateDiscountPrice,
        ),
        SizedBox(
          height: 20.h,
        ),
        CustomTextField(
          inputType: TextInputType.multiline,
          inputAction: TextInputAction.done,
          textCapitalization: TextCapitalization.sentences,
          autofocus: true,
          textEditingController: viewModel.descriptionController,
          textFieldPadding:
              EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
          textFieldMaxLength: 255,
          textFieldMaxLines: 3,
          hintText: 'Description'.ntr(),
          onChanged: (val) {
            // viewModel.validateTextFieldsNotEmpty();
          },
          validator: TextFieldValidator.validateDescription,
        ),
        SizedBox(
          height: 20.h,
        ),
        GestureDetector(
          onTap: () => viewModel.getOfferPicture(),
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
                        if (viewModel.offerImage != null) ...[
                          CircleAvatar(
                            radius: 50.r,
                            backgroundColor: kWhiteColor,
                            child: ClipRRect(
                                borderRadius: fieldBorderRadius,
                                child: Container(
                                    height: 100.h,
                                    width: 100.h,
                                    color: Colors.red,
                                    child: Image.file(
                                      viewModel.offerImage!,
                                      fit: BoxFit.fill,
                                    ))),
                          )
                        ] else if (viewModel.isEdit &&
                            (widget.data!.offerImagePath.isNotEmpty)) ...[
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
                                      viewModel.coverOfferImgUrl ?? '',
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
                            'Upload Image'.ntr(),
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
                                'Add promotional banner to highlight offer'
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
          inputType: TextInputType.none,
          inputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.sentences,
          textEditingController: viewModel.startDateController,
          textFieldPadding:
              EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
          hintText: 'Start Date'.ntr(),
          labelText: 'Start Date'.ntr(),
          onTap: () async {
            String formattedDateTime =
                DateFormat('yyyy-MM-dd').format(DateTime.now());
            viewModel.startDateController.text = formattedDateTime;
            final date = await showDatePickerDialog(
             splashColor: canvasColor,
              highlightColor: canvasColor,
              context: context,
              slidersColor: kPrimaryColor,
              leadingDateTextStyle: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(fontWeight: FontWeight.w600, color: kPrimaryColor),
              initialDate: DateTime.now(),
              minDate: DateTime(1900),
              maxDate: DateTime(2023, 12, 31),
              enabledCellDecoration: BoxDecoration(color: canvasColor),
              selectedCellDecoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(150.r))),
              selectedCellTextStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.w400, color: canvasColor),
              currentDateDecoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(150.r))),
              currentDateTextStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.w400, color: canvasColor),
              enabledCellTextStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.w400, color: kBlackColor),
              daysNameTextStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.w500, color: kPrimaryColor),
            );
            if (date != null) {
              var currentDate = DateTime(DateTime.now().year,
                  DateTime.now().month, DateTime.now().day);
              setState(
                () {
                  if (date.isBefore(currentDate)) {
                    showSnackBarMessage(
                        context: context,
                        content: "Can't select before current date",
                        backgroundColor: kErrorColor);
                  } else {
                    viewModel.startDateController.text =
                        DateFormat('yyyy-MM-dd').format(date);
                  }
                },
              );
            } else {
              return;
            }
          },
          onChanged: (val) {},
          validator: TextFieldValidator.validateText,
        ),
        SizedBox(
          height: 20.h,
        ),
        CustomTextField(
          inputType: TextInputType.none,
          inputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.sentences,
          textEditingController: viewModel.endDateController,
          textFieldPadding:
              EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
          hintText: 'Expiry Date'.ntr(),
          labelText: 'Expiry Date'.ntr(),
          onTap: () async {
            if (viewModel.startDateController.text.isNotEmpty) {
              String formattedDateTime = DateFormat('yyyy-MM-dd')
                  .format(DateTime.parse(viewModel.startDateController.text));
              viewModel.endDateController.text = formattedDateTime;
              DateFormat format = DateFormat("yyyy-MM-dd");
              var startDate = format.parse(viewModel.startDateController.text);
              final date = await showDatePickerDialog(
                context: context,
                slidersColor: kPrimaryColor,
                leadingDateTextStyle: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(
                        fontWeight: FontWeight.w600, color: kPrimaryColor),
                initialDate: startDate,
                minDate: DateTime(1900),
                maxDate: DateTime(3000),
                enabledCellDecoration: BoxDecoration(color: canvasColor),
                selectedCellDecoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(150.r))),
                selectedCellTextStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w400, color: canvasColor),
                currentDateDecoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(150.r))),
                currentDateTextStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w400, color: canvasColor),
                enabledCellTextStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w400, color: kBlackColor),
                daysNameTextStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(
                        fontWeight: FontWeight.w500, color: kPrimaryColor),
              );
              if (date != null) {
                setState(
                  () {
                    if (date.isBefore(
                        DateTime.parse(viewModel.startDateController.text))) {
                      showSnackBarMessage(
                          context: context,
                          content: "Can't select before start date",
                          backgroundColor: kErrorColor);
                    } else {
                      viewModel.endDateController.text =
                          DateFormat('yyyy-MM-dd').format(date);
                    }
                  },
                );
              } else {
                return;
              }
            } else {
              showSnackBarMessage(
                  context: context,
                  content: "Please select start date to continue!",
                  backgroundColor: kErrorColor);
            }
          },
          onChanged: (val) {
            //  viewModel.validateTextFieldsNotEmpty();
          },
          validator: TextFieldValidator.validateText,
        ),
        SizedBox(
          height: 20.h,
        ),
        SelectProductWidget(data: widget.data, viewModel: viewModel),
        SizedBox(
          height: 10.h,
        ),
      ],
    );
  }
}
