import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happiness_club_merchant/utils/extensions/extensions.dart';


enum SelectedCurrencyEnum { USD, JOD, SAR }

extension GetAsset on SelectedCurrencyEnum {
  SvgPicture buildSvgIcon() {
    switch (this) {
      case SelectedCurrencyEnum.USD:
        return SvgPicture.asset('SvgAssetsPaths.flagUSDSvg', width: 25.0.w);
      case SelectedCurrencyEnum.JOD:
        return SvgPicture.asset('SvgAssetsPaths.flagEURSvg', width: 25.0.w);
      case SelectedCurrencyEnum.SAR:
        return SvgPicture.asset('SvgAssetsPaths.flagGBPSvg', width: 25.0.w);
    }
  }

  String getCurrencySymbol() {
    switch (this) {
      case SelectedCurrencyEnum.USD:
        return '\$';
      case SelectedCurrencyEnum.JOD:
        return 'د.ا';
      case SelectedCurrencyEnum.SAR:
        return 'ر.س';
    }
  }

  String getCurrencyName() {
    switch (this) {
      case SelectedCurrencyEnum.USD:
        return 'usd'.ntr();
      case SelectedCurrencyEnum.JOD:
        return 'jod'.ntr();
      case SelectedCurrencyEnum.SAR:
        return 'sar'.ntr();
    }
  }

  double formatValueToDouble(String value) {
    if (value.contains('\$')) {
      return double.parse(value.replaceAll(' ', '').replaceAll(',', '').replaceAll('\$', ''));
    }

    if (value.contains('£')) {
      return double.parse(value.replaceAll(' ', '').replaceAll(',', '').replaceAll('£', ''));
    }

    if (value.startsWith('€')) {
      return double.parse(value.replaceAll(' ', '').replaceAll('€', '').replaceAll(',', '').replaceAll(' ', ''));
    }
    return double.parse(value.replaceAll(' ', '').replaceAll('.', '').replaceAll(',', '.').replaceAll(' ', '').replaceAll('€', ''));
  }

  // String formatValueToString(String value) {
  //   switch (this) {
  //     case SelectedCurrencyEnum.USD:
  //       return value.replaceAll(' ', '').replaceAll(',', '').replaceAll('\$', '');
  //     case SelectedCurrencyEnum.JOD:
  //       return _formatEuroCurrencyBasedOnCountry(value);
  //     case SelectedCurrencyEnum.SAR:
  //       return value.replaceAll(' ', '').replaceAll(',', '').replaceAll('£', '');
  //   }
  // }

  // String formatValuesToCurrency({required int decimalDigits, required double amount}) {
  //   switch (this) {
  //     case SelectedCurrencyEnum.USD:
  //       return easy.NumberFormat.simpleCurrency(locale: 'en', decimalDigits: decimalDigits).format(amount);
  //     case SelectedCurrencyEnum.JOD:
  //
  //       /// Get balance of euro based on currency
  //       return _getEuroBalanceBasedOnCountry(decimalDigits, amount);
  //
  //     case SelectedCurrencyEnum.SAR:
  //       return easy.NumberFormat.simpleCurrency(locale: 'en_GB', decimalDigits: decimalDigits).format(amount);
  //   }
  // }

  // String getDefaultValue() {
  //   switch (this) {
  //     case SelectedCurrencyEnum.USD:
  //       return '\$0.00';
  //     case SelectedCurrencyEnum.JOD:
  //       return _getEuroBalanceBasedOnCountry(2, 0);
  //     case SelectedCurrencyEnum.SAR:
  //       return '£0.00';
  //   }
  // }

  // String _getEuroBalanceBasedOnCountry(int decimalDigits, double amount) {
  //   var isoOfCurrentCountry = sl.get<UserRuntimeConfig>().countryISO;
  //   if (isoOfCurrentCountry._isDecimalCountry()) {
  //     return easy.NumberFormat.simpleCurrency(locale: 'en_IE', decimalDigits: decimalDigits).format(amount.truncateToDecimalPlacesDouble(4));
  //   }
  //   var formattedCommaAmount = easy.NumberFormat.simpleCurrency(locale: 'de_DE', decimalDigits: decimalDigits).format(amount.truncateToDecimalPlacesDouble(2));
  //   formattedCommaAmount = formattedCommaAmount.replaceAll(' €', '');
  //   return '€${formattedCommaAmount}';
  // }

  // String _formatEuroCurrencyBasedOnCountry(String value) {
  //   var isoOfCurrentCountry = sl.get<UserRuntimeConfig>().countryISO;
  //   if (isoOfCurrentCountry._isDecimalCountry()) {
  //     return value.replaceAll(' ', '').replaceAll(',', '').replaceAll('£', '').replaceAll('€', '');
  //   }
  //
  //   return value.replaceAll(' ', '').replaceAll('.', '').replaceAll(',', '.').replaceAll(' ', '').replaceAll('€', '');
  // }
}

extension GetPNGAsset on SelectedCurrencyEnum {
  Image buildPNGIcon() {
    switch (this) {
      case SelectedCurrencyEnum.USD:
        return Image.asset('SvgAssetsPaths.flagUSDPng');
      case SelectedCurrencyEnum.JOD:
        return Image.asset('SvgAssetsPaths.flagEURPng');
      case SelectedCurrencyEnum.SAR:
        return Image.asset('SvgAssetsPaths.flagGBPPng');
    }
  }
}

extension SelectedCurrencyEnumPar on String {
  SelectedCurrencyEnum toSelectedCurrencyEnum() {
    return SelectedCurrencyEnum.values.firstWhere((e) => e.toString().toLowerCase() == 'SelectedCurrencyEnum.$this'.toLowerCase(), orElse: () => SelectedCurrencyEnum.USD); //return null if not found
  }
}

extension SelectedCurrencyEnumDePar on SelectedCurrencyEnum {
  String getString() {
    return toString().split('.').last; //return null if not found
  }
}

extension SelectedCurrencySymbolRemoval on SelectedCurrencyEnum {
  String replaceCurrencySymbol({required String amount}) {
    switch (this) {
      case SelectedCurrencyEnum.USD:
        return amount.replaceAll('\$', '');
      case SelectedCurrencyEnum.JOD:
        return amount.replaceAll('€', '');
      case SelectedCurrencyEnum.SAR:
        return amount.replaceAll('£', '');
    }
  }
}

extension CurrencyEnumFromSymbol on String {
  SelectedCurrencyEnum getCurrencyEnumFromSymbol() {
    switch (this) {
      case '\$':
        return SelectedCurrencyEnum.USD;
      case '€':
        return SelectedCurrencyEnum.JOD;
      case '£':
        return SelectedCurrencyEnum.SAR;
      default:
        return SelectedCurrencyEnum.USD;
    }
  }

  bool _isDecimalCountry() {
    var countryThatAreCommaWise = ['AR', 'BR', 'CO', 'FR', 'DE', 'ID', 'IT', 'PT', 'ZA', 'ES', 'CL', 'AT', 'DK', 'FI', 'HK', 'NL', 'SE', 'TR'];

    if (countryThatAreCommaWise.contains(this)) {
      return false;
    }

    return true;
  }
}
