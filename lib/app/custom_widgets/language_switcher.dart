


import 'dart:async';

import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/globals.dart';
import '../app_theme/app_theme.dart';
import '../models/language.dart';
import '../providers/languages.dart';
import 'direction.dart';

class ToggleButton extends StatefulWidget {
  const ToggleButton({super.key});

  @override
  ToggleButtonState createState() => ToggleButtonState();
}

double width = 120.w;
double height = 30.h;
const double englishAlign = -1;
const double arabicAlign = 1;
const Color selectedColor = kWhiteColor;
const Color normalColor = kPrimaryColor;

class ToggleButtonState extends State<ToggleButton> {
  late double xAlign;
  late Color englishColor;
  late Color arabicColor;
  LanguageProvider get languageProvider => sl();

  @override
  void initState() {
    super.initState();

    var languageCode = EasyLocalization.of(navigatorKeyGlobal.currentState!.context)?.currentLocale.toString().replaceFirst('_', '-');
    if(languageCode != null && languageCode == Language.AR.languageCode){
      xAlign = arabicAlign;
      englishColor = normalColor;
      arabicColor = selectedColor;
    }else{
      xAlign = englishAlign;
      englishColor = selectedColor;
      arabicColor = normalColor;
    }


    scheduleMicrotask(() async {
      await languageProvider.loadLanguagesFromJSON(context.locale);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: kPrimaryColor, width: 1),
        borderRadius: BorderRadius.all(
          Radius.circular(5.r),
        ),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            alignment: Alignment(xAlign, 0),
            duration: const Duration(milliseconds: 300),
            child: Container(
              width: width * 0.5,
              height: height,
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.r),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                xAlign = englishAlign;
                englishColor = selectedColor;
                arabicColor = normalColor;
                isRTL = false;
                languageProvider.selectedLanguage = Language.US;
                onLanguageChangePressed(
                  languageProvider: languageProvider,
                  language: languageProvider.selectedLanguage,
                );
              });
            },
            child: Align(
              alignment: const Alignment(-1, 0),
              child: Container(
                width: width * 0.5,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Text('english'.ntr(), style: Theme.of(context).textTheme.bodyText2!.copyWith(color: englishColor)),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                xAlign = arabicAlign;
                arabicColor = selectedColor;
                englishColor = normalColor;
                isRTL = true;
                languageProvider.selectedLanguage = Language.AR;
                onLanguageChangePressed(
                  languageProvider: languageProvider,
                  language: languageProvider.selectedLanguage,
                );
              });
            },
            child: Align(
              alignment: const Alignment(1, 0),
              child: Container(
                width: width * 0.5,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Text('arabic'.ntr(), style: Theme.of(context).textTheme.bodyText2!.copyWith(color: arabicColor)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onLanguageChangePressed({required Language language, required LanguageProvider languageProvider}) async {
      await EasyLocalization.of(context)?.setLocale(language.languageCode.toLocale(separator: '-'));
  }
}