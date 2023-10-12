import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:happiness_club_merchant/app/app_theme/app_theme.dart';
// import 'package:hashtagable/widgets/hashtag_text_field.dart';

import 'direction.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final String? labelText;
  final FocusNode? focusNode;
  final bool? autofocus;
  final bool? enabled;
  final bool? isHidden;
  Widget? suffixIcon;
  final Widget? prefixIcon;
  final FormFieldValidator<String>? validator;
  final int? textFieldMaxLength;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTapSuffix;
  final VoidCallback? onTap;
  final TextCapitalization? textCapitalization;
  String? errorText;
  final TextAlign _textAlign;
  final TextInputType? inputType;
  final TextInputAction? inputAction;
  final List<TextInputFormatter>? appInputFormatters;
  final int? textFieldMaxLines;
  final EdgeInsetsGeometry? textFieldPadding;
  final EdgeInsets? scrollPadding;
  final void Function(String)? onFieldSubmitted;

  CustomTextField(
      {Key? key,
      required this.textEditingController,
      required this.hintText,
      required this.validator,
      this.isHidden,
      this.onFieldSubmitted,
        this.scrollPadding,
      this.enabled,
      this.onChanged,
      this.onTapSuffix,
      this.onTap,
      this.focusNode,
      this.textCapitalization,
      this.textFieldMaxLength,
      this.labelText,
      this.suffixIcon,
      this.prefixIcon,
      this.autofocus,
      this.errorText,
      this.inputType,
      this.inputAction,
      this.appInputFormatters,
      this.textFieldMaxLines,
      this.textFieldPadding,
      TextAlign? textAlign})
      : _textAlign = textAlign ?? TextAlign.start,
        super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  //

  bool isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Focus(
          onFocusChange: (value) {
            isFocused = value;
            setState(() {});
          },
          child: TextFormField(
            textAlign: widget._textAlign,
            enabled: widget.enabled,
              scrollPadding:  widget.scrollPadding ??
                  EdgeInsets.symmetric(horizontal: 10.w, vertical: 0),
            enableSuggestions: false,
            focusNode: widget.focusNode == null ? null : widget.focusNode!,
            style: Theme.of(context).textTheme.displayLarge!.merge(TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                height: isRTL ? 1 : null)),
            controller: widget.textEditingController,
            maxLength: widget.textFieldMaxLength,
            maxLines: widget.textFieldMaxLines ?? 1,
            cursorColor: Theme.of(context).primaryColor,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            textCapitalization:
                widget.textCapitalization ?? TextCapitalization.none,
            textInputAction: widget.inputAction ?? TextInputAction.done,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: widget.inputType
            ,onFieldSubmitted: widget.onFieldSubmitted ,
            inputFormatters: widget.appInputFormatters ??
                [
                  // FilteringTextInputFormatter.deny(RegExp(r'\s')),
                ],
            autofocus: widget.autofocus == null ? false : widget.autofocus!,
            onChanged: (text) {
              widget.onChanged?.call(text);

              setState(() {});
            },
            onTap: widget.onTap,
            validator: widget.validator,
            obscureText: widget.isHidden != null ? widget.isHidden! : false,
            decoration: InputDecoration(
              isDense: true,
              hintText: shouldShowLabel() ? '' : widget.hintText,
              labelText: widget.labelText,
              hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).disabledColor,
                  height: isRTL ? 1 : null),
              labelStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: isFocused
                      ? inputFieldBorderColor
                      : Theme.of(context).disabledColor,
                  height: isRTL ? 1 : null),
              contentPadding: widget.textFieldPadding ??
                  EdgeInsets.symmetric(horizontal: 10.w, vertical: 0),
              counterText: '',
              alignLabelWithHint: true,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(fieldRadius),
                  borderSide: const BorderSide(color: kBorderColor)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: shouldShowBlueColor()
                          ? inputFieldBorderColor
                          : Theme.of(context).disabledColor),
                  borderRadius: BorderRadius.all(fieldRadius)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(fieldRadius),
                borderSide:
                    const BorderSide(color: focusedInputFieldBorderColor),
              ),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(fieldRadius),
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.error)),
              suffixIconConstraints: BoxConstraints(maxHeight: 25.h),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(fieldRadius),
                borderSide:
                    BorderSide(width: 1.0, color: Theme.of(context).colorScheme.error),
              ),
              errorText: widget.errorText,
              errorStyle: TextStyle(
                fontSize: 10.sp,
                height: 0.9,
              ),
              errorMaxLines: 3,
              prefixIcon: widget.prefixIcon != null
                  ? Padding(
                      padding:
                          EdgeInsets.only(right: isRTL ? 8.w : 0, left: 8.w),
                      child: widget.prefixIcon,
                    )
                  : null,
              suffixIcon: widget.suffixIcon != null
                  ? Padding(
                      padding:
                          EdgeInsets.only(right: 8.w, left: isRTL ? 8.w : 0),
                      child: InkResponse(
                          radius: 20.r,
                          onTap: widget.onTapSuffix,
                          child: widget.suffixIcon),
                    )
                  : null,
              suffixStyle: const TextStyle(height: 0.3),
            ),
          ),
        ),
      ],
    );
  }

  bool shouldShowBlueColor() =>
      isFocused || widget.textEditingController.text.isNotEmpty;

  bool shouldShowLabel() => widget.textEditingController.text.isNotEmpty;
}

class CustomTextFieldNew extends StatefulWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final String? labelText;
  final FocusNode? focusNode;
  final bool? autofocus;
  final bool? enabled;
  final bool? isHidden;
  Widget? suffixIcon;
  final Widget? prefixIcon;
  final FormFieldValidator<String>? validator;
  final int? textFieldMaxLength;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTapSuffix;
  final VoidCallback? onTap;
  final TextCapitalization? textCapitalization;
  String? errorText;
  final TextAlign _textAlign;
  final TextInputType? inputType;
  final TextInputAction? inputAction;
  final List<TextInputFormatter>? appInputFormatters;
  final int? textFieldMaxLines;
  final EdgeInsetsGeometry? textFieldPadding;

  CustomTextFieldNew(
      {Key? key,
      required this.textEditingController,
      required this.hintText,
      required this.validator,
      this.isHidden,
      this.enabled,
      this.onChanged,
      this.onTapSuffix,
      this.onTap,
      this.focusNode,
      this.textCapitalization,
      this.textFieldMaxLength,
      this.labelText,
      this.suffixIcon,
      this.prefixIcon,
      this.autofocus,
      this.errorText,
      this.inputType,
      this.inputAction,
      this.appInputFormatters,
      this.textFieldMaxLines,
      this.textFieldPadding,
      TextAlign? textAlign})
      : _textAlign = textAlign ?? TextAlign.start,
        super(key: key);

  @override
  State<CustomTextFieldNew> createState() => _CustomTextFieldStateN();
}

class _CustomTextFieldStateN extends State<CustomTextFieldNew> {
  //

  bool isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Focus(
          onFocusChange: (value) {
            isFocused = value;
            setState(() {});
          },
          child: TextFormField(
            textAlign: widget._textAlign,
            enabled: widget.enabled,
            enableSuggestions: false,
            focusNode: widget.focusNode == null ? null : widget.focusNode!,
            style: Theme.of(context).textTheme.displayLarge!.merge(TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                height: isRTL ? 1 : null)),
            controller: widget.textEditingController,
            maxLength: widget.textFieldMaxLength,
            maxLines: widget.textFieldMaxLines,
            cursorColor: Theme.of(context).primaryColor,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            textCapitalization:
                widget.textCapitalization ?? TextCapitalization.none,
            textInputAction: widget.inputAction ?? TextInputAction.done,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: widget.inputType,
            inputFormatters: widget.appInputFormatters ??
                [
                  // FilteringTextInputFormatter.deny(RegExp(r'\s')),
                ],
            autofocus: widget.autofocus == null ? false : widget.autofocus!,
            onChanged: (text) {
              widget.onChanged?.call(text);

              setState(() {});
            },
            onTap: widget.onTap,
            validator: widget.validator,
            obscureText: widget.isHidden != null ? widget.isHidden! : false,
            decoration: InputDecoration(
              isDense: true,
              hintText: shouldShowLabel() ? '' : widget.hintText,
              labelText: widget.labelText,
              hintStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: Theme.of(context).disabledColor,
                  height: isRTL ? 1 : null),
              labelStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: isFocused
                      ? inputFieldBorderColor
                      : Theme.of(context).disabledColor,
                  height: isRTL ? 1 : null),
              contentPadding: widget.textFieldPadding ??
                  EdgeInsets.symmetric(horizontal: 10.w, vertical: 0),
              counterText: '',
              alignLabelWithHint: true,
              border: InputBorder.none,
              // border: OutlineInputBorder(
              //     borderRadius: BorderRadius.all(fieldRadius),
              //     borderSide: const BorderSide(color: kBorderColor)),
              // enabledBorder: OutlineInputBorder(
              //     borderSide: BorderSide(
              //         color: shouldShowBlueColor()
              //             ? inputFieldBorderColor
              //             : Theme.of(context).disabledColor),
              //     borderRadius: BorderRadius.all(fieldRadius)),
              // focusedBorder: OutlineInputBorder(
              //   borderRadius: BorderRadius.all(fieldRadius),
              //   borderSide:
              //       const BorderSide(color: focusedInputFieldBorderColor),
              // ),
              // focusedErrorBorder: OutlineInputBorder(
              //     borderRadius: BorderRadius.all(fieldRadius),
              //     borderSide: BorderSide(color: Theme.of(context).errorColor)),
              suffixIconConstraints: BoxConstraints(maxHeight: 25.h),
              // errorBorder: OutlineInputBorder(
              //   borderRadius: BorderRadius.all(fieldRadius),
              //   borderSide:
              //       BorderSide(width: 1.0, color: Theme.of(context).errorColor),
              // ),
              errorText: widget.errorText,
              errorStyle: TextStyle(
                fontSize: 10.sp,
                height: 0.9,
              ),
              errorMaxLines: 3,
              prefixIcon: widget.prefixIcon != null
                  ? Padding(
                      padding:
                          EdgeInsets.only(right: isRTL ? 8.w : 0, left: 8.w),
                      child: widget.prefixIcon,
                    )
                  : null,
              suffixIcon: widget.suffixIcon != null
                  ? Padding(
                      padding:
                          EdgeInsets.only(right: 8.w, left: isRTL ? 8.w : 0),
                      child: InkResponse(
                          radius: 20.r,
                          onTap: widget.onTapSuffix,
                          child: widget.suffixIcon),
                    )
                  : null,
              suffixStyle: const TextStyle(height: 0.3),
            ),
          ),
        ),
      ],
    );
  }

  bool shouldShowBlueColor() =>
      isFocused || widget.textEditingController.text.isNotEmpty;

  bool shouldShowLabel() => widget.textEditingController.text.isNotEmpty;
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class CustomHashTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final String? labelText;
  final FocusNode? focusNode;
  final bool? autofocus;
  final bool? enabled;
  final bool? isHidden;
  Widget? suffixIcon;
  final Widget? prefixIcon;
  final FormFieldValidator<String>? validator;
  final int? textFieldMaxLength;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTapSuffix;
  final VoidCallback? onTap;
  final TextCapitalization? textCapitalization;
  String? errorText;
  final TextAlign _textAlign;
  final TextInputType? inputType;
  final TextInputAction? inputAction;
  final List<TextInputFormatter>? appInputFormatters;
  final int? textFieldMaxLines;
  final EdgeInsetsGeometry? textFieldPadding;

  CustomHashTextField(
      {Key? key,
      required this.textEditingController,
      required this.hintText,
      required this.validator,
      this.isHidden,
      this.enabled,
      this.onChanged,
      this.onTapSuffix,
      this.onTap,
      this.focusNode,
      this.textCapitalization,
      this.textFieldMaxLength,
      this.labelText,
      this.suffixIcon,
      this.prefixIcon,
      this.autofocus,
      this.errorText,
      this.inputType,
      this.inputAction,
      this.appInputFormatters,
      this.textFieldMaxLines,
      this.textFieldPadding,
      TextAlign? textAlign})
      : _textAlign = textAlign ?? TextAlign.start,
        super(key: key);

  @override
  State<CustomHashTextField> createState() => _CustomHashTextFieldState();
}

class _CustomHashTextFieldState extends State<CustomHashTextField> {
  //

  bool isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Focus(
        //   onFocusChange: (value) {
        //     isFocused = value;
        //     setState(() {});
        //   },
        //   child: HashTagTextField(
        //     textAlign: widget._textAlign,
        //     enabled: widget.enabled,
        //     enableSuggestions: false,
        //     focusNode: widget.focusNode == null ? null : widget.focusNode!,
        //     basicStyle: Theme.of(context).textTheme.headline1!.merge(TextStyle(
        //         fontSize: 16.sp,
        //         fontWeight: FontWeight.w400,
        //         height: isRTL ? 1 : null)),
        //     controller: widget.textEditingController,
        //     maxLength: widget.textFieldMaxLength,
        //     maxLines: widget.textFieldMaxLines ?? 1,
        //     cursorColor: Theme.of(context).primaryColor,
        //     maxLengthEnforcement: MaxLengthEnforcement.enforced,
        //     textCapitalization:
        //         widget.textCapitalization ?? TextCapitalization.none,
        //     textInputAction: widget.inputAction ?? TextInputAction.done,
        //     // autovalidateMode: AutovalidateMode.onUserInteraction,
        //     keyboardType: widget.inputType,
        //     inputFormatters: widget.appInputFormatters ??
        //         [
        //           // FilteringTextInputFormatter.deny(RegExp(r'\s')),
        //         ],
        //     autofocus: widget.autofocus == null ? false : widget.autofocus!,
        //     onChanged: (text) {
        //       widget.onChanged?.call(text);

        //       setState(() {});
        //     },
        //     decoratedStyle: Theme.of(context).textTheme.headline1!.merge(
        //         TextStyle(
        //             fontSize: 16.sp,
        //             fontWeight: FontWeight.w400,
        //             color: Colors.blue,
        //             height: isRTL ? 1 : null)),
        //     onTap: widget.onTap,
        //     // validator: widget.validator,

        //     obscureText: widget.isHidden != null ? widget.isHidden! : false,
        //     decoration: InputDecoration(
        //       isDense: true,
        //       hintText: shouldShowLabel() ? '' : widget.hintText,
        //       labelText: widget.labelText,
        //       hintStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
        //           color: Theme.of(context).disabledColor,
        //           height: isRTL ? 1 : null),
        //       labelStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
        //           color: isFocused
        //               ? inputFieldBorderColor
        //               : Theme.of(context).disabledColor,
        //           height: isRTL ? 1 : null),
        //       contentPadding: widget.textFieldPadding ??
        //           EdgeInsets.symmetric(horizontal: 10.w, vertical: 0),
        //       counterText: '',
        //       alignLabelWithHint: true,
        //       border: OutlineInputBorder(
        //           borderRadius: BorderRadius.all(fieldRadius),
        //           borderSide: const BorderSide(color: kBorderColor)),
        //       enabledBorder: OutlineInputBorder(
        //           borderSide: BorderSide(
        //               color: shouldShowBlueColor()
        //                   ? inputFieldBorderColor
        //                   : Theme.of(context).disabledColor),
        //           borderRadius: BorderRadius.all(fieldRadius)),
        //       focusedBorder: OutlineInputBorder(
        //         borderRadius: BorderRadius.all(fieldRadius),
        //         borderSide:
        //             const BorderSide(color: focusedInputFieldBorderColor),
        //       ),
        //       focusedErrorBorder: OutlineInputBorder(
        //           borderRadius: BorderRadius.all(fieldRadius),
        //           borderSide: BorderSide(color: Theme.of(context).errorColor)),
        //       suffixIconConstraints: BoxConstraints(maxHeight: 25.h),
        //       errorBorder: OutlineInputBorder(
        //         borderRadius: BorderRadius.all(fieldRadius),
        //         borderSide:
        //             BorderSide(width: 1.0, color: Theme.of(context).errorColor),
        //       ),
        //       errorText: widget.errorText,
        //       errorStyle: TextStyle(
        //         fontSize: 10.sp,
        //         height: 0.9,
        //       ),
        //       errorMaxLines: 3,
        //       prefixIcon: widget.prefixIcon != null
        //           ? Padding(
        //               padding:
        //                   EdgeInsets.only(right: isRTL ? 8.w : 0, left: 8.w),
        //               child: widget.prefixIcon,
        //             )
        //           : null,
        //       suffixIcon: widget.suffixIcon != null
        //           ? Padding(
        //               padding:
        //                   EdgeInsets.only(right: 8.w, left: isRTL ? 8.w : 0),
        //               child: InkResponse(
        //                   radius: 20.r,
        //                   onTap: widget.onTapSuffix,
        //                   child: widget.suffixIcon),
        //             )
        //           : null,
        //       suffixStyle: const TextStyle(height: 0.3),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  bool shouldShowBlueColor() =>
      isFocused || widget.textEditingController.text.isNotEmpty;

  bool shouldShowLabel() => widget.textEditingController.text.isNotEmpty;
}

class CustomHashTextFieldNew extends StatefulWidget {
  final TextEditingController textEditingController;
  // final String hintText;
  final String? labelText;
  final FocusNode? focusNode;
  final bool? autofocus;
  final bool? enabled;
  final bool? isHidden;
  Widget? suffixIcon;
  final Widget? prefixIcon;
  final FormFieldValidator<String>? validator;
  final int? textFieldMaxLength;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTapSuffix;
  final VoidCallback? onTap;
  final TextCapitalization? textCapitalization;
  String? errorText;
  final TextAlign _textAlign;
  final TextInputType? inputType;
  final TextInputAction? inputAction;
  final List<TextInputFormatter>? appInputFormatters;
  final int? textFieldMaxLines;
  final EdgeInsetsGeometry? textFieldPadding;

  CustomHashTextFieldNew(
      {Key? key,
      required this.textEditingController,
      required this.validator,
      this.isHidden,
      this.enabled,
      this.onChanged,
      this.onTapSuffix,
      this.onTap,
      this.focusNode,
      this.textCapitalization,
      this.textFieldMaxLength,
      this.labelText,
      this.suffixIcon,
      this.prefixIcon,
      this.autofocus,
      this.errorText,
      this.inputType,
      this.inputAction,
      this.appInputFormatters,
      this.textFieldMaxLines,
      this.textFieldPadding,
      TextAlign? textAlign})
      : _textAlign = textAlign ?? TextAlign.start,
        super(key: key);

  @override
  State<CustomHashTextFieldNew> createState() => _CustomHashTextFieldStateNew();
}

class _CustomHashTextFieldStateNew extends State<CustomHashTextFieldNew> {
  //

  bool isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Focus(
        //   onFocusChange: (value) {
        //     isFocused = value;
        //     setState(() {});
        //   },
        //   child: HashTagTextField(
        //     textAlign: widget._textAlign,
        //     enabled: widget.enabled,
        //     enableSuggestions: false,
        //     focusNode: widget.focusNode == null ? null : widget.focusNode!,
        //     basicStyle: Theme.of(context).textTheme.headline1!.merge(TextStyle(
        //         fontSize: 16.sp,
        //         fontWeight: FontWeight.w400,
        //         height: isRTL ? 1 : null)),
        //     controller: widget.textEditingController,
        //     maxLength: widget.textFieldMaxLength,
        //     maxLines: widget.textFieldMaxLines ?? 1,
        //     cursorColor: Theme.of(context).primaryColor,
        //     maxLengthEnforcement: MaxLengthEnforcement.enforced,
        //     textCapitalization:
        //         widget.textCapitalization ?? TextCapitalization.none,
        //     textInputAction: widget.inputAction ?? TextInputAction.done,
        //     // autovalidateMode: AutovalidateMode.onUserInteraction,
        //     keyboardType: widget.inputType,
        //     inputFormatters: widget.appInputFormatters ??
        //         [
        //           // FilteringTextInputFormatter.deny(RegExp(r'\s')),
        //         ],
        //     autofocus: widget.autofocus == null ? false : widget.autofocus!,
        //     onChanged: (text) {
        //       widget.onChanged?.call(text);

        //       setState(() {});
        //     },
        //     decoratedStyle: Theme.of(context).textTheme.headline1!.merge(
        //           TextStyle(
        //               fontSize: 16.sp,
        //               fontWeight: FontWeight.w400,
        //               color: Colors.blue,
        //               height: isRTL ? 1 : null),
        //         ),
        //     onTap: widget.onTap,
        //     // validator: widget.validator,

        //     obscureText: widget.isHidden != null ? widget.isHidden! : false,
        //     decoration: InputDecoration(
        //       isDense: true,

        //       labelText: widget.labelText,
        //       hintStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
        //           color: Theme.of(context).disabledColor,
        //           height: isRTL ? 1 : null),
        //       labelStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
        //           color: isFocused
        //               ? inputFieldBorderColor
        //               : Theme.of(context).disabledColor,
        //           height: isRTL ? 1 : null),
        //       contentPadding: widget.textFieldPadding ??
        //           EdgeInsets.symmetric(horizontal: 10.w, vertical: 0),
        //       counterText: '',
        //       alignLabelWithHint: true,
        //       border: InputBorder.none,
        //       // enabledBorder: OutlineInputBorder(
        //       //     borderSide: BorderSide(
        //       //         color: shouldShowBlueColor()
        //       //             ? inputFieldBorderColor
        //       //             : Theme.of(context).disabledColor),
        //       //     borderRadius: BorderRadius.all(fieldRadius)),
        //       // focusedBorder: OutlineInputBorder(
        //       //   borderRadius: BorderRadius.all(fieldRadius),
        //       //   borderSide:
        //       //       const BorderSide(color: focusedInputFieldBorderColor),
        //       // ),
        //       // focusedErrorBorder: OutlineInputBorder(
        //       //     borderRadius: BorderRadius.all(fieldRadius),
        //       //     borderSide: BorderSide(color: Theme.of(context).errorColor)),
        //       suffixIconConstraints: BoxConstraints(maxHeight: 25.h),
        //       // errorBorder: OutlineInputBorder(
        //       //   borderRadius: BorderRadius.all(fieldRadius),
        //       //   borderSide:
        //       //       BorderSide(width: 1.0, color: Theme.of(context).errorColor),
        //       // ),
        //       errorText: widget.errorText,
        //       errorStyle: TextStyle(
        //         fontSize: 10.sp,
        //         height: 0.9,
        //       ),
        //       errorMaxLines: 3,
        //       prefixIcon: widget.prefixIcon != null
        //           ? Padding(
        //               padding:
        //                   EdgeInsets.only(right: isRTL ? 8.w : 0, left: 8.w),
        //               child: widget.prefixIcon,
        //             )
        //           : null,
        //       suffixIcon: widget.suffixIcon != null
        //           ? Padding(
        //               padding:
        //                   EdgeInsets.only(right: 8.w, left: isRTL ? 8.w : 0),
        //               child: InkResponse(
        //                   radius: 20.r,
        //                   onTap: widget.onTapSuffix,
        //                   child: widget.suffixIcon),
        //             )
        //           : null,
        //       suffixStyle: const TextStyle(height: 0.3),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  bool shouldShowBlueColor() =>
      isFocused || widget.textEditingController.text.isNotEmpty;

  bool shouldShowLabel() => widget.textEditingController.text.isNotEmpty;
}
