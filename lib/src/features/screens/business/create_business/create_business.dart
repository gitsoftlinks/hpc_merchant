//import 'dart:io';

// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:io';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:happiness_club_merchant/app/custom_widgets/custom_snackbar.dart';
import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../../../app/models/select_location_view_model.dart';
import '../../../../../app/app_asset_path/images_util.dart';
import '../../../../../app/app_theme/app_theme.dart';
import '../../../../../app/custom_widgets/continue_button.dart';
import '../../../../../app/custom_widgets/custom_text_field.dart';
import '../../../../../app/custom_widgets/select_location_bottomsheet.dart';
import '../../../../../app/toast_messages/toast_messages.dart';
import '../../../../../app/validator/text_field_validator.dart';
import '../../../../../utils/globals.dart';
import '../business_detail/usecases/get_business_detail.dart';
import 'model/create_business_view_model.dart';

class CreateBusinessScreen extends StatelessWidget {
  const CreateBusinessScreen({Key? key, this.businessData}) : super(key: key);

  final BusinessDetail? businessData;

  SelectLocationViewModel get locationModel => sl();
  CreateBusinessViewModel get viewModel => sl();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: viewModel,
        ),
        ChangeNotifierProvider.value(
          value: locationModel,
        ),
      ],
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              body: CreateBusinessScreenContents(
                businessData: businessData,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CreateBusinessScreenContents extends StatefulWidget {
  final BusinessDetail? businessData;
  const CreateBusinessScreenContents({Key? key, this.businessData})
      : super(key: key);

  @override
  State<CreateBusinessScreenContents> createState() =>
      _CreateBusinessScreenContentsState();
}

class _CreateBusinessScreenContentsState
    extends State<CreateBusinessScreenContents> {
  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() {
      context.read<CreateBusinessViewModel>().init(widget.businessData);
    });
    if (context.read<SelectLocationViewModel>().branchSelected == false) {
      context.read<SelectLocationViewModel>().afterSaveButtonClick = () =>
          context
              .read<CreateBusinessViewModel>()
              .callSave(TextEditingController(), TextEditingController());
    }

    context.read<CreateBusinessViewModel>().errorMessages =
        (message) => showErrorToast(context, message);
  }

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<CreateBusinessViewModel>();
    return viewModel.isLoading2
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
                key: viewModel.createBusinessFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();

                              viewModel.createBusinessFormKey.currentState
                                  ?.reset();
                              viewModel.clearData();
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
                          if (viewModel.isEdit) ...[
                            SizedBox(
                              width: 60.w,
                            ),
                          ] else ...[
                            SizedBox(
                              width: 40.w,
                            ),
                          ],
                          viewModel.isEdit
                              ? Text(
                                  "Edit Business".ntr(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge!
                                      .copyWith(fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center,
                                )
                              : Text(
                                  "Create Business".ntr(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge!
                                      .copyWith(fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center,
                                ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Business Details'.ntr(),
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: kPrimaryColor),
                        )),
                    SizedBox(
                      height: 20.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        viewModel.getProfilePicture();
                      },
                      child: buildDottedBorderImages(
                          context: context,
                          viewModel: viewModel,
                          coverUrl: viewModel.logoImageUrl,
                          image: viewModel.logoImage,
                          title: 'Upload Logo'.ntr(),
                          description:
                              'Your business official trade mark'.ntr(),
                          isCover: false,
                          hasWarning: false),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        viewModel.getCoverPicture(context);
                      },
                      child: buildDottedBorderImages(
                          context: context,
                          viewModel: viewModel,
                          image: viewModel.coverImage,
                          coverUrl: viewModel.coverImageUrl,
                          title: 'Upload Trade license'.ntr(),
                          description:
                              'Please provide business trade license'.ntr(),
                          isCover: true,
                          hasWarning: false),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomTextField(
                      inputType: TextInputType.number,
                      inputAction: TextInputAction.done,
                      textCapitalization: TextCapitalization.sentences,
                      textEditingController: viewModel.trnController,
                      textFieldPadding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 15.h),
                      hintText: 'TRN',
                      onChanged: (val) {
                        viewModel.validateTextFieldsNotEmpty();
                      },
                      validator: TextFieldValidator.validateText,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomTextField(
                      inputType: TextInputType.text,
                      inputAction: TextInputAction.done,
                      textCapitalization: TextCapitalization.sentences,
                      textEditingController: viewModel.tradeNumberController,
                      textFieldPadding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 15.h),
                      hintText: 'Trade License Number',
                      onChanged: (val) {
                        viewModel.validateTextFieldsNotEmpty();
                      },
                      validator: TextFieldValidator.validateText,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomTextField(
                      inputType: TextInputType.none,
                      inputAction: TextInputAction.done,
                      textCapitalization: TextCapitalization.sentences,
                      textEditingController:
                          viewModel.tradeExpiryDateController,
                      textFieldPadding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 15.h),
                      hintText: 'Trade License Expiry Date',
                      onTap: () async {
                        String formattedDateTime =
                            DateFormat('yyyy-MM-dd').format(DateTime.now());
                        viewModel.tradeExpiryDateController.text =
                            formattedDateTime;
                        final date = await showDatePickerDialog(
                          context: context,
                          slidersColor: kPrimaryColor,
                          leadingDateTextStyle: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: kPrimaryColor),
                          initialDate: DateTime.now(),
                          minDate: DateTime(1900),
                          maxDate: DateTime(2023, 12, 31),
                          enabledCellDecoration:
                              BoxDecoration(color: canvasColor),
                          selectedCellDecoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(150.r))),
                          selectedCellTextStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: canvasColor),
                          currentDateDecoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(150.r))),
                          currentDateTextStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: canvasColor),
                          enabledCellTextStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: kBlackColor),
                          daysNameTextStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: kPrimaryColor),
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
                                viewModel.tradeExpiryDateController.text =
                                    DateFormat('yyyy-MM-dd').format(date);
                              }
                            },
                          );
                        } else {
                          return;
                        }
                      },
                      onChanged: (val) {
                        viewModel.validateTextFieldsNotEmpty();
                      },
                      validator: TextFieldValidator.validateText,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),

                    CustomTextField(
                      inputType: TextInputType.multiline,
                      inputAction: TextInputAction.done,
                      textCapitalization: TextCapitalization.sentences,
                      textEditingController: viewModel.businessNameController
                      ,
                      textFieldPadding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 15.h),
                      hintText: 'Business Display Name',
                      onChanged: (val) {
                        viewModel.validateTextFieldsNotEmpty();
                      },
                      validator: TextFieldValidator.validateText,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomTextField(
                      inputType: TextInputType.multiline,
                      inputAction: TextInputAction.done,
                      textCapitalization: TextCapitalization.sentences,
                      textEditingController:
                          viewModel.businessLegalNameController,
                      textFieldPadding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 15.h),
                      hintText: 'Business Legal Name',
                      onChanged: (val) {
                        viewModel.validateTextFieldsNotEmpty();
                      },
                      validator: TextFieldValidator.validateText,
                    ),

                    SizedBox(
                      height: 20.h,
                    ),
                    CustomTextField(
                      inputType: TextInputType.multiline,
                      inputAction: TextInputAction.done,
                      textCapitalization: TextCapitalization.sentences,
                      textEditingController: viewModel.descriptionController,
                      textFieldPadding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 15.h),
                      textFieldMaxLength: 255,
                      textFieldMaxLines: 3,
                      hintText: 'Description'.ntr(),
                      onChanged: (val) {
                        viewModel.validateTextFieldsNotEmpty();
                      },
                      validator: TextFieldValidator.validateDescription,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    ValueListenableBuilder(
                        valueListenable: viewModel.selectedCategory,
                        builder: (context, value, _) {
                          return DropdownButtonFormField<String>(
                            alignment: Alignment.centerLeft,
                            validator: TextFieldValidator.validateText,
                            decoration: InputDecoration(
                              // constraints: BoxConstraints(
                              //     maxHeight: fieldHeight, minHeight: fieldHeight),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(fieldRadius),
                                  borderSide:
                                      const BorderSide(color: kBorderColor)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: inputFieldBorderColor),
                                  borderRadius: BorderRadius.all(fieldRadius)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(fieldRadius),
                                borderSide: const BorderSide(
                                    color: focusedInputFieldBorderColor),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(fieldRadius),
                                  borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.error)),
                              suffixIconConstraints:
                                  BoxConstraints(maxHeight: 25.h),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(fieldRadius),
                                borderSide: BorderSide(
                                    width: 1.0,
                                    color: Theme.of(context).colorScheme.error),
                              ),
                              errorStyle: TextStyle(
                                fontSize: 10.sp,
                                height: 0.9,
                              ),
                            ),
                            focusColor: kDisabledColor,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: kBlackColor,
                              size: 15.w,
                            ),
                            dropdownColor: canvasColor,
                            hint: Text('Category',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(color: inputFieldBorderColor)),
                            borderRadius: fieldBorderRadius,
                            value: value != null ? value.categoryName : null,
                            onChanged: (val) {
                              viewModel.changeSelectedCategory(val!);
                              viewModel.validateTextFieldsNotEmpty();
                            },
                            items:
                                viewModel.businessCategories.map((valueItem) {
                              return DropdownMenuItem<String>(
                                alignment: Alignment.centerLeft,
                                value: valueItem.categoryName,
                                onTap: () =>
                                    viewModel.categoryId = valueItem.id,
                                child: Text(
                                  valueItem.categoryName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        color: kToastTextColor,
                                      ),
                                ),
                              );
                            }).toList(),

                            selectedItemBuilder: (BuildContext _) {
                              return viewModel.businessCategories
                                  .map<Widget>((item) {
                                return Container(
                                  alignment: Alignment.centerLeft,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.w),
                                  child: Text(
                                    value != null ? value.categoryName : '',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge!,
                                  ),
                                );
                              }).toList();
                            },
                            // itemHeight: null,
                            // menuMaxHeight: 220.w,
                          );
                        }),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            inputType: TextInputType.text,
                            textCapitalization: TextCapitalization.sentences,
                            textEditingController:
                                viewModel.branchNameController,
                            textFieldPadding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 15.h),
                            textFieldMaxLength: 100,
                            hintText: 'Branch Name'.ntr(),
                            suffixIcon: Icon(
                              Icons.location_on,
                              color: kPrimaryColor,
                              size: 24.w,
                            ),
                            onChanged: (val) {
                              viewModel.validateTextFieldsNotEmpty();
                            },
                            onTap: () async {},
                            validator: TextFieldValidator.validateText,
                          ),
                        ),
                        SizedBox(
                          width: 15.w,
                        ),
                        Expanded(
                          child: CustomTextField(
                            inputType: TextInputType.none,
                            textCapitalization: TextCapitalization.sentences,
                            textEditingController: viewModel.locationController,
                            textFieldPadding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 15.h),
                            textFieldMaxLength: 100,
                            hintText: 'Location'.ntr(),
                            suffixIcon: Icon(
                              Icons.location_on,
                              color: kPrimaryColor,
                              size: 24.w,
                            ),
                            onChanged: (val) {
                              viewModel.validateTextFieldsNotEmpty();
                            },
                            onTap: () async {
                              setState(() {
                                viewModel.editCity = '';
                                viewModel.editLat = '';
                                viewModel.editLng = '';
                              });

                              context
                                  .read<SelectLocationViewModel>()
                                  .clearLocation();

                              bool alreadyHaveLocation = await viewModel
                                  .checkIfAlreadySelectedLocation();

                              if (!mounted) return;

                              context
                                  .read<SelectLocationViewModel>()
                                  .googleMapCompleter = Completer();

                              context
                                  .read<SelectLocationViewModel>()
                                  .initPermissionAndLocation(
                                      isTappedOnLocation: alreadyHaveLocation);

                              var locationBottomSheet =
                                  SelectLocationBottomSheet();

                              locationBottomSheet.show();
                              return;
                            },
                            validator: TextFieldValidator.validateText,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    if (viewModel.isEdit) ...[
                      ValueListenableBuilder<List<Widget>>(
                          valueListenable: viewModel.branchFields,
                          builder: (context, fields, _) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:
                                  widget.businessData!.businessBranches.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    top: 10.h,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Color.fromRGBO(239, 239, 239, 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12.r))),
                                    padding: const EdgeInsets.only(
                                        left: 12,
                                        right: 12,
                                        top: 10,
                                        bottom: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            keyboardType: TextInputType.text,
                                            focusNode:
                                                AlwaysDisabledFocusNode(),
                                            textCapitalization:
                                                TextCapitalization.sentences,
                                            controller: viewModel
                                                    .editBranchNameControllers[
                                                index],
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayLarge!
                                                .merge(TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w400,
                                                )),
                                            decoration: InputDecoration(
                                              fillColor: canvasColor,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          fieldRadius),
                                                  borderSide: const BorderSide(
                                                      color: kBorderColor)),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color:
                                                          inputFieldBorderColor),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          fieldRadius)),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    fieldRadius),
                                                borderSide: const BorderSide(
                                                    color:
                                                        focusedInputFieldBorderColor),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              fieldRadius),
                                                      borderSide: BorderSide(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .error)),
                                              suffixIconConstraints:
                                                  BoxConstraints(
                                                      maxHeight: 25.h),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    fieldRadius),
                                                borderSide: BorderSide(
                                                    width: 1.0,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .error),
                                              ),
                                              errorStyle: TextStyle(
                                                fontSize: 10.sp,
                                                height: 0.9,
                                              ),
                                              hintText: 'Branch Name'.ntr(),
                                              hintStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                    color: Theme.of(context)
                                                        .disabledColor,
                                                  ),
                                              suffixIcon: Padding(
                                                padding: EdgeInsets.all(3.h),
                                                child: Icon(
                                                  Icons.location_on,
                                                  color: kPrimaryColor,
                                                  size: 24.w,
                                                ),
                                              ),
                                            ),
                                            onChanged: (val) {
                                              context.read<
                                                  CreateBusinessViewModel>()
                                                ..validateTextFieldsNotEmpty();
                                            },
                                            onTap: () async {},
                                            validator:
                                                TextFieldValidator.validateText,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15.w,
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            focusNode:
                                                AlwaysDisabledFocusNode(),
                                            keyboardType: TextInputType.none,
                                            textCapitalization:
                                                TextCapitalization.sentences,
                                            controller: viewModel
                                                .editBranchControllers[index],
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayLarge!
                                                .merge(TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w400,
                                                )),
                                            decoration: InputDecoration(
                                              fillColor: canvasColor,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          fieldRadius),
                                                  borderSide: const BorderSide(
                                                      color: kBorderColor)),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color:
                                                          inputFieldBorderColor),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          fieldRadius)),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    fieldRadius),
                                                borderSide: const BorderSide(
                                                    color:
                                                        focusedInputFieldBorderColor),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              fieldRadius),
                                                      borderSide: BorderSide(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .error)),
                                              suffixIconConstraints:
                                                  BoxConstraints(
                                                      maxHeight: 25.h),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    fieldRadius),
                                                borderSide: BorderSide(
                                                    width: 1.0,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .error),
                                              ),
                                              errorStyle: TextStyle(
                                                fontSize: 10.sp,
                                                height: 0.9,
                                              ),
                                              hintText: 'Location'.ntr(),
                                              hintStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                    color: Theme.of(context)
                                                        .disabledColor,
                                                  ),
                                              suffixIcon: Padding(
                                                padding: EdgeInsets.all(3.h),
                                                child: Icon(
                                                  Icons.location_on,
                                                  color: kPrimaryColor,
                                                  size: 24.w,
                                                ),
                                              ),
                                            ),
                                            onChanged: (val) {
                                              context.read<
                                                  CreateBusinessViewModel>()
                                                ..validateTextFieldsNotEmpty();
                                            },
                                            onTap: () async {
                                              context
                                                  .read<
                                                      CreateBusinessViewModel>()
                                                  .isBranch = true;
                                              context
                                                  .read<
                                                      SelectLocationViewModel>()
                                                  .clearLocation();

                                              bool alreadyHaveLocation = await context
                                                  .read<
                                                      CreateBusinessViewModel>()
                                                  .checkIfAlreadySelectedLocation();

                                              if (!mounted) return;
                                              context
                                                  .read<
                                                      SelectLocationViewModel>()
                                                  .googleMapCompleter = Completer();
                                              context
                                                  .read<
                                                      SelectLocationViewModel>()
                                                  .initPermissionAndLocation(
                                                      isTappedOnLocation:
                                                          alreadyHaveLocation);

                                              var locationBottomSheet =
                                                  SelectLocationBottomSheet();

                                              locationBottomSheet.show();
                                            },
                                            validator:
                                                TextFieldValidator.validateText,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15.w,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            viewModel.deleteAttachments(
                                                attachmentId: widget
                                                    .businessData!
                                                    .businessBranches[index]
                                                    .id,
                                                data: widget.businessData);
                                          },
                                          child: Icon(
                                            Icons.cancel_sharp,
                                            color: kBlackColor,
                                            size: 15.h,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
                    ],
                    ValueListenableBuilder<List<Widget>>(
                        valueListenable: viewModel.branchFields,
                        builder: (context, fields, _) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: fields.length,
                            itemBuilder: (context, index) {
                              return Container(
                                  margin: EdgeInsets.only(top: 10.h),
                                  child: fields[index]);
                            },
                          );
                        }),
                    SizedBox(
                      height: 5.h,
                    ),
                    InkWell(
                      onTap: () {
                        if (viewModel.branchControllers.isEmpty ||
                            viewModel.branchControllers.last.text.isNotEmpty) {
                          _addLocationBranch();
                        } else {
                          showSnackBarMessage(
                              context: context,
                              content:
                                  "Please fill previous field to add another",
                              backgroundColor: kErrorColor);
                        }
                        //  }
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.add_circle_outline_sharp,
                            color: kPrimaryColor,
                            size: 24.h,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            "Add Another",
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: kPrimaryColor),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    viewModel.isEdit
                        ? ContinueButton(
                            loadingNotifier: viewModel.isLoadingNotifier,
                            text: 'Update'.ntr(),
                            onPressed: () async {
                              if (viewModel.createBusinessFormKey.currentState!
                                  .validate()) {
                                if (viewModel.branchControllers.isEmpty ||
                                    viewModel.branchControllers.last.text
                                        .isNotEmpty) {
                                  FocusScope.of(context).unfocus();

                                  await viewModel.updateBusiness();
                                } else {
                                  showSnackBarMessage(
                                      context: context,
                                      content:
                                          "Please fill previous field to add another",
                                      backgroundColor: kErrorColor);
                                }
                              }
                            })
                        : ContinueButton(
                            loadingNotifier: viewModel.isLoadingNotifier,
                            text: 'Create'.ntr(),
                            onPressed: () async {
                              if (viewModel.createBusinessFormKey.currentState!
                                  .validate()) {
                                if (viewModel.branchControllers.isEmpty ||
                                    viewModel.branchControllers.last.text
                                        .isNotEmpty) {
                                  FocusScope.of(context).unfocus();
                                  await viewModel.createNewBusiness();
                                } else {
                                  showSnackBarMessage(
                                      context: context,
                                      content:
                                          "Please fill previous field to add another",
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

  DottedBorder buildDottedBorderImages(
      {required BuildContext context,
      required CreateBusinessViewModel viewModel,
      required File? image,
      String? coverUrl,
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
              padding: EdgeInsets.only(top: 10.h),
              child: Column(
                children: [
                  if (image != null) ...[
                    CircleAvatar(
                      radius: 50.r,
                      backgroundColor: kWhiteColor,
                      child: ClipRRect(
                          borderRadius: isCover
                              ? fieldBorderRadius
                              : BorderRadius.circular(50.r),
                          child: Container(
                              height: 100.h,
                              width: 100.h,
                              color: Colors.red,
                              child: Image.file(
                                image,
                                fit: BoxFit.cover,
                              ))),
                    )
                  ] else if (coverUrl != null && coverUrl.isNotEmpty) ...[
                    CircleAvatar(
                      radius: 50.r,
                      backgroundColor: kWhiteColor,
                      child: ClipRRect(
                        borderRadius: isCover
                            ? fieldBorderRadius
                            : BorderRadius.circular(50.r),
                        child: Container(
                          height: 100.h,
                          width: 100.h,
                          color: Colors.red,
                          child: CachedNetworkImage(
                            imageUrl: coverUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                SvgPicture.asset(
                              SvgAssetsPaths.cameraSvg,
                              width: 20,
                              height: 20,
                            ),
                          ),
                        ),
                      ),
                    )
                  ] else ...[
                    SvgPicture.asset(SvgAssetsPaths.cameraSvg,
                        color: kPrimaryColor),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      title,
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

  void _addLocationBranch() {
    var branchController = TextEditingController();
    var nameController = TextEditingController();
    var field;
    field = Container(
      decoration: BoxDecoration(
          color: Color.fromRGBO(239, 239, 239, 1),
          borderRadius: BorderRadius.all(Radius.circular(12.r))),
      padding: const EdgeInsets.only(left: 12, right: 12, top: 10, bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              controller: nameController,
              style: Theme.of(context).textTheme.displayLarge!.merge(TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  )),
              decoration: InputDecoration(
                fillColor: canvasColor,
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(fieldRadius),
                    borderSide: const BorderSide(color: kBorderColor)),
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: inputFieldBorderColor),
                    borderRadius: BorderRadius.all(fieldRadius)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(fieldRadius),
                  borderSide:
                      const BorderSide(color: focusedInputFieldBorderColor),
                ),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(fieldRadius),
                    borderSide:
                        BorderSide(color: Theme.of(context).colorScheme.error)),
                suffixIconConstraints: BoxConstraints(maxHeight: 25.h),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(fieldRadius),
                  borderSide: BorderSide(
                      width: 1.0, color: Theme.of(context).colorScheme.error),
                ),
                errorStyle: TextStyle(
                  fontSize: 10.sp,
                  height: 0.9,
                ),
                hintText: 'Branch Name'.ntr(),
                hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).disabledColor,
                    ),
                suffixIcon: Padding(
                  padding: EdgeInsets.all(3.h),
                  child: Icon(
                    Icons.location_on,
                    color: kPrimaryColor,
                    size: 24.w,
                  ),
                ),
              ),
              onChanged: (val) {
                context.read<CreateBusinessViewModel>()
                  ..validateTextFieldsNotEmpty();
              },
              onTap: () async {},
              validator: TextFieldValidator.validateText,
            ),
          ),
          SizedBox(
            width: 15.w,
          ),
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.none,
              textCapitalization: TextCapitalization.sentences,
              controller: branchController,
              style: Theme.of(context).textTheme.displayLarge!.merge(TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  )),
              decoration: InputDecoration(
                fillColor: canvasColor,
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(fieldRadius),
                    borderSide: const BorderSide(color: kBorderColor)),
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: inputFieldBorderColor),
                    borderRadius: BorderRadius.all(fieldRadius)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(fieldRadius),
                  borderSide:
                      const BorderSide(color: focusedInputFieldBorderColor),
                ),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(fieldRadius),
                    borderSide:
                        BorderSide(color: Theme.of(context).colorScheme.error)),
                suffixIconConstraints: BoxConstraints(maxHeight: 25.h),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(fieldRadius),
                  borderSide: BorderSide(
                      width: 1.0, color: Theme.of(context).colorScheme.error),
                ),
                errorStyle: TextStyle(
                  fontSize: 10.sp,
                  height: 0.9,
                ),
                hintText: 'Location'.ntr(),
                hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).disabledColor,
                    ),
                suffixIcon: Padding(
                  padding: EdgeInsets.all(3.h),
                  child: Icon(
                    Icons.location_on,
                    color: kPrimaryColor,
                    size: 24.w,
                  ),
                ),
              ),
              onChanged: (val) {
                context.read<CreateBusinessViewModel>()
                  ..validateTextFieldsNotEmpty();
              },
              onTap: () async {
                context.read<CreateBusinessViewModel>().isBranch = true;

                context.read<SelectLocationViewModel>().clearLocation();

                bool alreadyHaveLocation = await context
                    .read<CreateBusinessViewModel>()
                    .checkIfAlreadySelectedLocation();

                if (!mounted) return;

                context.read<SelectLocationViewModel>().googleMapCompleter =
                    Completer();

                context
                    .read<SelectLocationViewModel>()
                    .initPermissionAndLocation(
                        isTappedOnLocation: alreadyHaveLocation);

                var locationBottomSheet = SelectLocationBottomSheet();

                locationBottomSheet.show();
              },
              validator: TextFieldValidator.validateText,
            ),
          ),
          SizedBox(
            width: 15.w,
          ),
          InkWell(
            onTap: () {
              context.read<CreateBusinessViewModel>().removeBranchField(
                  field: field,
                  branch: branchController,
                  branchName: nameController);
            },
            child: Icon(
              Icons.cancel_sharp,
              color: kBlackColor,
              size: 15.h,
            ),
          )
        ],
      ),
    );
    context.read<CreateBusinessViewModel>().addBranchField(
        field: field, branch: branchController, branchName: nameController);
    context.read<SelectLocationViewModel>().afterSaveButtonClick = () => context
        .read<CreateBusinessViewModel>()
        .callSave(branchController, nameController);
  }
}
