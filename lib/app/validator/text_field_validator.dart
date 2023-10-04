import 'package:happiness_club_merchant/utils/extensions/extensions.dart';

import '../models/lookups_model.dart';

class TextFieldValidator {
  // This method check whether first name is valid or not
  static String? validateFullName(String? value) {
    var errorMsg = 'Field Empty'.ntr();
    var minLenErrorMsg = 'Name too short '.ntr();
    var maxLenErrorMsg = 'Name too long'.ntr();

    if (value == null) {
      return errorMsg;
    }

    if (value.length < 2) {
      return minLenErrorMsg;
    }

    if (value.length > 40) {
      return maxLenErrorMsg;
    }

    return null;
  }

  // This method check whether location is given or not
  static String? validateInitialLocation(String? value) {
    var errorMsg = 'Field Empty'.ntr();

    if (value == null) {
      return errorMsg;
    }

    return null;
  }

  // This method check whether phone number is valid or not
  static String? validatePhoneNumber(String? value) {
    var errorMsg = 'In valid number'.ntr();
    if (value == null || value.isEmpty) {
      return errorMsg;
    }
    return (value.length > 6 && value.length < 14) ? null : errorMsg;
  }

  // This method check whether description is valid or not
  static String? validateDescription(String? value) {
    var errorMsg = 'Field is Empty'.ntr();
    var minLenErrorMsg = 'Description too short'.ntr();
    var maxLenErrorMsg = 'Description too long'.ntr();

    if (value == null) {
      return errorMsg;
    }

    if (value.length < 10) {
      return minLenErrorMsg;
    }

    if (value.length > 255) {
      return maxLenErrorMsg;
    }

    return null;
  }

  // This method check whether expiry date is valid or not
  static String? validateExpiryDate(String? value) {
    var errorMsg = 'Field Empty'.ntr();

    if (value!.isEmpty) {
      return errorMsg;
    }

    return null;
  }

  // This method check whether country is selected or not
  static String? validateNationality(String? value) {
    var errorMsg = 'Field Empty'.ntr();

    if (value!.isEmpty) {
      return errorMsg;
    }

    return null;
  }

  // This method check whether textField has text or not
  static String? validateText(String? value) {
    var errorMsg = 'Field Empty'.ntr();

    if (value!.isEmpty) {
      return errorMsg;
    }

    return null;
  }

  // This method check whether document type is selected or not
  static String? validateDocumentType(Item? value) {
    var errorMsg = 'Field Empty'.ntr();

    if (value == null) {
      return errorMsg;
    }

    return null;
  }

  // This method check whether document type is selected or not
  static String? validateCarInformation(String? value) {
    var errorMsg = 'field_empty'.ntr();

    if (value == null) {
      return errorMsg;
    }

    return null;
  }

  // This method check whether document number is valid or not
  static String? validateDateOfBirth(String? value) {
    var errorMsg = 'Field Empty'.ntr();
    var errorUnderAgeMsg = 'under_age_msg'.ntr();

    if (value!.isEmpty) {
      return errorMsg;
    }
    var parsedDate = value.toDateTime();

    if (parsedDate.isUnderage()) {
      return errorUnderAgeMsg;
    }

    return null;
  }

  static String? validateDateOfBirthNew(String? value) {
    var errorMsg = 'Field Empty'.ntr();
    // var errorUnderAgeMsg = 'under_age_msg'.ntr();

    if (value!.isEmpty) {
      return errorMsg;
    }

    return null;
  }

  // This method checks whether email is valid or not

  static String? validateEmail(String? value) {
    var errorMsg2 = 'Enter valid email'.ntr();
    var errorMsg = 'Field Empty'.ntr();

    if (value!.isEmpty) {
      return errorMsg;
    } /*

    if (value!.isEmpty) {
      return null;
    } */

    else {
      final emailValidate = RegExp(
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
          .hasMatch(value);

      if (!emailValidate) {
        return errorMsg2;
      } else {
        return null;
      }
    }
  }

  static String? validateRequiredEmail(String? value) {
    var errorMsg = 'Field Empty'.ntr();
    var errorMsg2 = 'Enter valid email'.ntr();

    if (value!.isEmpty) {
      return errorMsg;
    } else {
      final emailValidate = RegExp(
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
          .hasMatch(value);

      if (!emailValidate) {
        return errorMsg2;
      } else {
        return null;
      }
    }
  }

  static String? isPasswordCompliant(String? password) {
    //

    var errorMsg = 'Password is Required'.ntr();

    var invalidMsg =
        'Passwords must be at least 6 characters and must contain (at least one non alphanumeric character, at least one lowercase, at least one uppercase)'
            .ntr();

    if (password == null || password.isEmpty) {
      return errorMsg;
    }

    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));

    bool hasDigits = password.contains(RegExp(r'[0-9]'));

    bool hasLowercase = password.contains(RegExp(r'[a-z]'));

    bool hasSpecialCharacters =
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    bool hasMinLength = password.length > 6;

    if (hasDigits &
        hasUppercase &
        hasLowercase &
        hasSpecialCharacters &
        hasMinLength) {
      return null;
    } else {
      return invalidMsg;
    }
  }

  static String? validatePassword(String? value) {
    var errorMsg = 'Password is required'.ntr();
    var invalidMsg =
        'Passwords must be at least 6 characters and must contain (at least one non alphanumeric character, at least one lowercase, at least one uppercase)'
            .ntr();
    final regExp = RegExp(
        r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(.*?[$&+,\:;/=?@#|<>.^*()_%!-]).{6,}$");
// (?=.*?[#?!@$%^&*-])
    if (value == null || value.isEmpty) {
      return errorMsg;
    }
    return !regExp.hasMatch(value) ? invalidMsg : null;
  }

  static String? validateConfirmPassword(String? value, String? confirmValue) {
    var errorMsg = 'Password is required'.ntr();
    var invalidMsg =
        'Passwords must be at least 6 characters and must contain (at least one non alphanumeric character, at least one lowercase, at least one uppercase)'
            .ntr();
    var invalidConfirmMsg = 'Passwords dont match'.ntr();
    final regExp = RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{6,}$');

    if (value == null || value.isEmpty) {
      return errorMsg;
    }

    var res = (regExp.hasMatch(value) && !(value == confirmValue))
        ? invalidConfirmMsg
        : !regExp.hasMatch(value)
            ? invalidMsg
            : null;
    return res;
  }

  // This method check whether quantity is valid or not
  static String? validateQuantity(String? value) {
    var errorMsg = 'field_empty'.ntr();
    var maxLenErrorMsg = 'quantity_too_big'.ntr();

    if (value == null) {
      return errorMsg;
    }

    if (value.isEmpty) {
      return errorMsg;
    }
    if (double.parse(value) > 9999) {
      return maxLenErrorMsg;
    }

    return null;
  }

  // This method check whether textField has text or not
  static String? validateSellingPrice(String? value) {
    var errorMsg = 'Field Empty'.ntr();

    if (value!.isEmpty) {
      return errorMsg;
    }

    if (double.tryParse(value)?.isNaN ?? true) {
      return "Must be valid number".ntr();
    }

    if (double.tryParse(value)! <= 0) {
      return "Must be valid numbe".ntr();
    }

    return null;
  }

  // This method check whether textField has text or not
  static String? validateDiscountPrice(String? discount) {
    var errorMsg = 'Field Empty'.ntr();

    var wrongPrice = 'discount must be less then 100%'.ntr();

    if (discount!.isEmpty) {
      return errorMsg;
    }

    if (double.tryParse(discount)?.isNaN ?? true) {
      return "must_be_valid_number".ntr();
    }

    if ((double.tryParse(discount) ?? 1) > 100) {
      return wrongPrice;
    }

    return null;
  }
}
