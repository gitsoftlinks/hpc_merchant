import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:happiness_club_merchant/src/features/screens/create_product/model/create_product_view_model.dart';
import 'package:happiness_club_merchant/utils/extensions/extensions.dart';

import '../../../../../app/app_theme/app_theme.dart';
import '../../../../../app/custom_widgets/custom_snackbar.dart';
import '../../product_detail/usecases/get_product_detail.dart';

// ignore: must_be_immutable
class SelectLocationWidget extends StatefulWidget {
  CreateProductViewModel viewModel;
  ProductDetail? data;
  SelectLocationWidget(
      {super.key, required this.viewModel, required this.data});

  @override
  State<SelectLocationWidget> createState() => _SelectLocationWidgetState();
}

class _SelectLocationWidgetState extends State<SelectLocationWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Color.fromRGBO(225, 225, 225, 1),
              borderRadius: BorderRadius.all(Radius.circular(12.r))),
          child: Padding(
            padding: EdgeInsets.only(left: 16.h, right: 16.h, top: 16.h),
            child: Column(
              children: [
                ValueListenableBuilder(
                    valueListenable: widget.viewModel.selectedLocation,
                    builder: (context, value, _) {
                      return DropdownButtonFormField<String>(
                        alignment: Alignment.centerLeft,

                        validator: (value) {},
                        decoration: InputDecoration(
                          fillColor: canvasColor,
                          filled: true,
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
                                  color: Theme.of(context).colorScheme.error)),
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
                        hint: Text('Select location',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: inputFieldBorderColor)),
                        borderRadius: fieldBorderRadius,
                        value: value != null ? value.cityName : null,
                        onChanged: (val) {
                          widget.viewModel.changeSelectedLocation(val!);
                        },
                        items:
                            widget.viewModel.businessLocations.map((valueItem) {
                          return DropdownMenuItem<String>(
                            alignment: Alignment.centerLeft,
                            value: valueItem.cityName,
                            onTap: () =>
                                widget.viewModel.categoryId = valueItem.id,
                            child: Text(
                              '${valueItem.branchName},${valueItem.cityName}',
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
                          return widget.viewModel.businessLocations
                              .map<Widget>((item) {
                            return Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Text(
                                value != null
                                    ? '${value.branchName},${value.cityName}'
                                    : 'Select location',
                                style: Theme.of(context).textTheme.bodySmall!,
                              ),
                            );
                          }).toList();
                        },
                        // itemHeight: null,
                        // menuMaxHeight: 220.w,
                      );
                    }),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  children: [
                    Container(
                      height: 32.h,
                      width: 32.h,
                      decoration: BoxDecoration(
                          color: canvasColor,
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.r))),
                      child: Checkbox(
                        value: widget.viewModel.isQuantity,

                        side: BorderSide.none,
                        fillColor: MaterialStatePropertyAll(canvasColor),
                        checkColor: kPrimaryColor,
                        onChanged: (s) {
                          setState(() {
                            widget.viewModel.isQuantity = s!;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text('Quantity Applicable',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontWeight: FontWeight.w400)),
                    if (widget.viewModel.isQuantity) ...[
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 30.h),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            textCapitalization: TextCapitalization.sentences,
                            controller: widget.viewModel.quantityController,
                            decoration: InputDecoration(
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(color: inputFieldBorderColor),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 6.w, vertical: 15.h),
                              hintText: 'Quantity'.ntr(),
                              fillColor: canvasColor,
                              filled: true,
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
                            onChanged: (val) {
                              //  viewModel.validateTextFieldsNotEmpty();
                            },
                            validator: (value) {},
                          ),
                        ),
                      ),
                    ] else ...[
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 7.h),
                          child: Container(
                            height: 48.h,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.r)),
                                border:
                                    Border.all(color: kBorderColor, width: 1.w),
                                color: canvasColor),
                            child: Padding(
                              padding: EdgeInsets.only(left: 8.h, right: 8.h),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    color: kPrimaryColor,
                                    size: 20.h,
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      'Available',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium!
                                          .copyWith(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                InkResponse(
                  onTap: () {
                    setState(() {
                      if (widget.viewModel.isEdit) {
                        if (widget.data!.productLocations
                            .where((element) =>
                                element['city_name'].toString() ==
                                widget
                                    .viewModel.selectedLocation.value!.cityName)
                            .isNotEmpty) {
                          showSnackBarMessage(
                              context: context,
                              content: "Location Already Selected",
                              backgroundColor: kErrorColor);
                        } else {
                          if (widget.viewModel.isQuantity &&
                              widget
                                  .viewModel.quantityController.text.isEmpty) {
                            showSnackBarMessage(
                                context: context,
                                content: "Please Enter quantity",
                                backgroundColor: kErrorColor);
                          } else {
                            if (widget.viewModel.objectList.isEmpty) {
                              widget.viewModel.object = ProductLocation(
                                id: widget.viewModel.selectedLocation.value!.id,
                                lat: widget
                                    .viewModel.selectedLocation.value!.lat,
                                lng: widget
                                    .viewModel.selectedLocation.value!.lng,
                                isAvailable:
                                    widget.viewModel.isQuantity ? 0 : 1,
                                quantity: widget.viewModel.isQuantity
                                    ? widget.viewModel.quantityController.text
                                    : '',
                                city: widget
                                    .viewModel.selectedLocation.value!.cityName,
                                branchName: widget.viewModel.selectedLocation
                                    .value!.branchName,
                                quantityApplicable:
                                    widget.viewModel.isQuantity ? 1 : 0,
                              );
                              print(
                                  'Location Object : ${widget.viewModel.object}');
                              widget.viewModel.objectList
                                  .add(widget.viewModel.object);
                              print('list 2 : ${widget.viewModel.objectList}');
                            } else {
                              if (widget.viewModel.objectList
                                  .where((element) =>
                                      element.id ==
                                      widget
                                          .viewModel.selectedLocation.value!.id)
                                  .isNotEmpty) {
                                showSnackBarMessage(
                                    context: context,
                                    content: "Location Already Selected",
                                    backgroundColor: kErrorColor);
                                widget.viewModel.selectedLocation =
                                    ValueNotifier(null);
                              } else {
                                widget.viewModel.object = ProductLocation(
                                  id: widget
                                      .viewModel.selectedLocation.value!.id,
                                  lat: widget
                                      .viewModel.selectedLocation.value!.lat,
                                  lng: widget
                                      .viewModel.selectedLocation.value!.lng,
                                  isAvailable:
                                      widget.viewModel.isQuantity ? 0 : 1,
                                  quantity: widget.viewModel.isQuantity
                                      ? widget.viewModel.quantityController.text
                                      : '',
                                  city: widget.viewModel.selectedLocation.value!
                                      .cityName,
                                  branchName: widget.viewModel.selectedLocation
                                      .value!.branchName,
                                  quantityApplicable:
                                      widget.viewModel.isQuantity ? 1 : 0,
                                );
                                print(
                                    'Location Object : ${widget.viewModel.object}');
                                widget.viewModel.objectList
                                    .add(widget.viewModel.object);
                                print(
                                    'list 2 : ${widget.viewModel.objectList}');
                              }
                            }

                            widget.viewModel.quantityController.clear();
                            widget.viewModel.isQuantity = false;
                            widget.viewModel.selectedLocation =
                                ValueNotifier(null);
                          }
                        }
                      } else {
                        if (widget.viewModel.objectList.isNotEmpty) {
                          if (widget.viewModel.objectList
                              .where((element) =>
                                  element.id ==
                                  widget.viewModel.selectedLocation.value!.id)
                              .isNotEmpty) {
                            showSnackBarMessage(
                                context: context,
                                content: "Location Already Selected",
                                backgroundColor: kErrorColor);
                            widget.viewModel.selectedLocation =
                                ValueNotifier(null);
                          } else {
                            if (widget.viewModel.isQuantity &&
                                widget.viewModel.quantityController.text
                                    .isEmpty) {
                              showSnackBarMessage(
                                  context: context,
                                  content: "Please Enter quantity",
                                  backgroundColor: kErrorColor);
                            } else {
                              widget.viewModel.object = ProductLocation(
                                id: widget.viewModel.selectedLocation.value!.id,
                                lat: widget
                                    .viewModel.selectedLocation.value!.lat,
                                lng: widget
                                    .viewModel.selectedLocation.value!.lng,
                                isAvailable:
                                    widget.viewModel.isQuantity ? 0 : 1,
                                quantity: widget.viewModel.isQuantity
                                    ? widget.viewModel.quantityController.text
                                    : '',
                                city: widget
                                    .viewModel.selectedLocation.value!.cityName,
                                branchName: widget.viewModel.selectedLocation
                                    .value!.branchName,
                                quantityApplicable:
                                    widget.viewModel.isQuantity ? 1 : 0,
                              );
                              print(
                                  'Location Object : ${widget.viewModel.object}');
                              widget.viewModel.objectList
                                  .add(widget.viewModel.object);
                              widget.viewModel.quantityController.clear();
                              widget.viewModel.isQuantity = false;
                              widget.viewModel.selectedLocation =
                                  ValueNotifier(null);
                            }
                          }
                        } else {
                          if (widget.viewModel.isQuantity &&
                              widget
                                  .viewModel.quantityController.text.isEmpty) {
                            showSnackBarMessage(
                                context: context,
                                content: "Please Enter quantity",
                                backgroundColor: kErrorColor);
                          } else {
                            widget.viewModel.object = ProductLocation(
                              id: widget.viewModel.selectedLocation.value!.id,
                              lat: widget.viewModel.selectedLocation.value!.lat,
                              lng: widget.viewModel.selectedLocation.value!.lng,
                              isAvailable: widget.viewModel.isQuantity ? 0 : 1,
                              quantity: widget.viewModel.isQuantity
                                  ? widget.viewModel.quantityController.text
                                  : '',
                              city: widget
                                  .viewModel.selectedLocation.value!.cityName,
                              branchName: widget
                                  .viewModel.selectedLocation.value!.branchName,
                              quantityApplicable:
                                  widget.viewModel.isQuantity ? 1 : 0,
                            );
                            print(
                                'Location Object : ${widget.viewModel.object}');
                            widget.viewModel.objectList
                                .add(widget.viewModel.object);
                            widget.viewModel.quantityController.clear();
                            widget.viewModel.isQuantity = false;
                            widget.viewModel.selectedLocation =
                                ValueNotifier(null);
                          }
                        }
                      }
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 44.h,
                    width: 134.h,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromRGBO(77, 63, 50, 1), width: 1.w),
                        borderRadius: BorderRadius.all(Radius.circular(12.r))),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        widget.viewModel.objectList.isNotEmpty
                            ? Icon(
                                Icons.add,
                                color: kPrimaryColor,
                                size: 25.h,
                              )
                            : Container(),
                        Text(
                          widget.viewModel.objectList.isEmpty
                              ? 'Confirm'
                              : 'Add More',
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                  fontWeight: FontWeight.w400, fontSize: 14.sp),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        if (widget.viewModel.isEdit) ...[
          ListView.builder(
            itemCount: widget.data!.productLocations.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Container(
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(225, 225, 225, 1),
                      borderRadius: BorderRadius.all(Radius.circular(12.r))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            widget.viewModel.deleteLocationAttachments(
                                attachmentId:
                                    widget.data!.productLocations[index]['id'],
                                data: widget.data);
                          });
                        },
                        icon: Icon(
                          Icons.cancel,
                          color: kBlackColor,
                          size: 18.h,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 16.h, right: 16.h, top: 16.h),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(right: 16.w),
                                child: Text(
                                    "${widget.data!.productLocations[index]['branch_name'].toString()},${widget.data!.productLocations[index]['city_name'].toString()}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18.sp)),
                              ),
                            ),
                            if (widget.data!.productLocations[index]
                                    ['is_quantity_applicable'] ==
                                0) ...[
                              Text('Available',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.sp,
                                          color: Color.fromRGBO(
                                              186, 186, 186, 1))),
                            ]
                          ],
                        ),
                      ),
                      if (widget.data!.productLocations[index]
                              ['is_quantity_applicable'] ==
                          1) ...[
                        Padding(
                          padding: EdgeInsets.only(left: 16.h, right: 16.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Quantity',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontWeight: FontWeight.w400)),
                              Spacer(),
                              Container(
                                height: 48.h,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12.r)),
                                    border: Border.all(
                                        color: kBorderColor, width: 1.w),
                                    color: canvasColor),
                                child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.h, right: 8.h),
                                    child: Text(
                                      widget
                                          .data!
                                          .productLocations[index]
                                              ['quantity_count']
                                          .toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16.sp),
                                    )),
                              ),
                            ],
                          ),
                        )
                      ],
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(
            height: 10.h,
          ),
        ],
        ListView.builder(
          itemCount: widget.viewModel.objectList.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            print("11 : ${widget.viewModel.objectList.length}");
            var data = widget.viewModel.objectList[index];
            return Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromRGBO(225, 225, 225, 1),
                    borderRadius: BorderRadius.all(Radius.circular(12.r))),
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 0.8.sw, bottom: 30.h),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            widget.viewModel.objectList.removeAt(index);
                          });
                        },
                        icon: Icon(
                          Icons.cancel,
                          color: kBlackColor,
                          size: 18.h,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: 16.h, right: 16.h, top: 0.06.sh),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 16.h),
                                  child: Text('${data.branchName},${data.city}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18.sp)),
                                ),
                              ),
                              if (data.quantity.isEmpty) ...[
                                Text('Available',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14.sp,
                                            color: Color.fromRGBO(
                                                186, 186, 186, 1))),
                              ]
                            ],
                          ),
                        ),
                        if (data.quantity.isNotEmpty) ...[
                          Padding(
                            padding: EdgeInsets.only(left: 16.h, right: 16.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Quantity',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontWeight: FontWeight.w400)),
                                Spacer(),
                                Expanded(
                                  child: Container(
                                    height: 48.h,
                                    width: 50.w,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12.r)),
                                        border: Border.all(
                                            color: kBorderColor, width: 1.w),
                                        color: canvasColor),
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 8.h, right: 8.h),
                                        child: Text(
                                          data.quantity,
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16.sp),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                        SizedBox(
                          height: 10.h,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
