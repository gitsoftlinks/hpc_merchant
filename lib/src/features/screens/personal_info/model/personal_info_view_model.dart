// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import 'package:happiness_club_merchant/utils/imagecroper/image_croper.dart';
import 'package:happiness_club_merchant/utils/router/app_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../../../app/app_usecase/get_current_user_details.dart';
import '../../../../../app/app_usecase/pick_image_from_gallery.dart';
import '../../../../../app/providers/account_provider.dart';
import '../../../../../services/error/failure.dart';
import '../../../../../services/usecases/usecase.dart';
import '../../signin_screen/usecases/send_login.dart';
import '../usecases/update_personal_info.dart';

class PersonalInfoViewModel extends ChangeNotifier {
  final AppState _appState;

  final UpdatePersonalInfo _updatePersonalInfo;
  final PickImageFromGallery _pickImageFromGallery;
  final GetCurrentUserDetails _getCurrentUserDetails;

  // PersonalInfoViewModel(
  //     {required UpdatePersonalInfo updatePersonalInfo,
  //     required GetAllProfessions getAllProfessions,
  //     required AppState appState,
  //     required PickImageFromGallery pickImageFromGallery,
  //     required GetCurrentUserDetails getCurrentUserDetails})
  PersonalInfoViewModel(
      {required UpdatePersonalInfo updatePersonalInfo,
      required AppState appState,
      required PickImageFromGallery pickImageFromGallery,
      required GetCurrentUserDetails getCurrentUserDetails})
      : _appState = appState,
        _updatePersonalInfo = updatePersonalInfo,
        _pickImageFromGallery = pickImageFromGallery,
        _getCurrentUserDetails = getCurrentUserDetails;

  ValueChanged<String>? errorMessages;
  ValueChanged<String>? successMessage;

  UserData get userDetail => GetIt.I.get<AccountProvider>().user;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController currentJobController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  ValueNotifier<bool> isPersonalLoadingNotifier = ValueNotifier(false);
  ValueNotifier<bool> isProfessionalLoadingNotifier = ValueNotifier(false);
  bool isProfessionalButtonEnabled = false;
  bool isPersonalButtonEnabled = false;
  File? profileImage;

  void handleError(Either<Failure, dynamic> either) {
    isPersonalLoadingNotifier.value = false;
    isProfessionalLoadingNotifier.value = false;
    notifyListeners();
    either.fold((l) {
      l.checkAndTakeAction(onError: errorMessages);
    }, (r) => null);
  }

  Future<void> init() async {
    clearData();
    await fillUserData();
  }

  void clearData() {
    isProfessionalButtonEnabled = false;
    isPersonalButtonEnabled = false;
    isPersonalLoadingNotifier.value = false;
    isProfessionalLoadingNotifier.value = false;
    fullNameController.clear();
    contactNumberController.clear();
    emailController.clear();
    dobController.clear();
    currentJobController.clear();
    experienceController.clear();
    profileImage = null;
    notifyListeners();
  }

  Future<void> fillUserData() async {
    fullNameController.text = userDetail.fullName;
    contactNumberController.text = userDetail.phoneNumber;
    emailController.text = userDetail.email;
    dobController.text = userDetail.dateOfBirth ?? '';

    notifyListeners();
  }

  /// This method check requirements for the api call
  void validatePersonalTextFieldsNotEmpty() {
    if (fullNameController.text.isNotEmpty &&
        contactNumberController.text.isNotEmpty &&
        emailController.text.isNotEmpty) {
      isPersonalButtonEnabled = true;
      notifyListeners();
      return;
    }
    isPersonalButtonEnabled = false;
    notifyListeners();
  }

  /// This method check require elements for the api call
  void validateProfessionalTextFieldsNotEmpty() {
    if (currentJobController.text.isNotEmpty &&
        experienceController.text.isNotEmpty) {
      isProfessionalButtonEnabled = true;
      notifyListeners();
      return;
    }
    isProfessionalButtonEnabled = false;
    notifyListeners();
  }

  Future<bool> updateUserInfo() async {
    final accountProvider = GetIt.I.get<AccountProvider>();

    var params = UpdatePersonalInfoParams(
        contactNumber: contactNumberController.text,
        email: emailController.text,
        accessToken: '',
        fullName: fullNameController.text,
        profileImage: profileImage);

    var updateInfoEither = await _updatePersonalInfo.call(params);
    if (updateInfoEither.isLeft()) {
      handleError(updateInfoEither);
      return false;
    }
    successMessage?.call('info updated successfully'.ntr());
    //  await CachedNetworkImage.evictFromCache(accountProvider.profileImage.value);

    await getUserDetails();

    isPersonalButtonEnabled = false;
    isProfessionalButtonEnabled = false;
    isProfessionalButtonEnabled = false;
    isPersonalLoadingNotifier.value = false;
    isProfessionalLoadingNotifier.value = false;

    notifyListeners();
    return true;
  }

  void getProfilePicture(BuildContext context) async {
    var imagePathEither = await _pickImageFromGallery(NoParams());
    if (imagePathEither.isLeft()) {
      handleError(imagePathEither);
      return;
    }
    final getImagePath = imagePathEither.getOrElse(() => '');
    if (getImagePath.isEmpty) {
      return;
    }

    profileImage =
        await Navigator.push(context, MaterialPageRoute(builder: (_) {
      return ImageCropper(path: getImagePath);
    }));
    // profileImage = File(getImagePath);
    print("path is ");

    print(profileImage);

    final mb = profileImage!.path.calculateFileSize();

    print(mb);

    notifyListeners();
  }

  // Future<File?> croppedImage(String path) async {
  //   var cropFile = await ImageCropper().cropImage(
  //     sourcePath: path,
  //     cropStyle: CropStyle.rectangle,
  //     compressQuality: 70,
  //     maxWidth: 1080,
  //     maxHeight: 1080,
  //     aspectRatioPresets: [
  //       CropAspectRatioPreset.ratio3x2,
  //       CropAspectRatioPreset.ratio4x3,
  //       CropAspectRatioPreset.ratio5x3,
  //       CropAspectRatioPreset.ratio5x4
  //     ],
  //     uiSettings: [
  //       AndroidUiSettings(
  //           toolbarTitle: 'Ajwaae'.ntr(),
  //           initAspectRatio: CropAspectRatioPreset.ratio3x2,
  //           lockAspectRatio: true),
  //       IOSUiSettings(minimumAspectRatio: 1.0, title: 'Ajwaae'.ntr())
  //     ],
  //   );
  //   if (cropFile != null) {
  //     return File(cropFile.path);
  //   }
  // }

  Future<void> getUserDetails() async {
    var userInfoEither = await _getCurrentUserDetails.call(NoParams());

    if (userInfoEither.isLeft()) {
      handleError(userInfoEither);
      return;
    }

    var user = userInfoEither.toOption().toNullable()!.user;
    GetIt.I.get<AccountProvider>().cacheRegisteredUserData(user);

    notifyListeners();
  }
}
