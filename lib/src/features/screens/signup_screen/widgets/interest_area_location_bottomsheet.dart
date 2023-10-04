import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../../app/custom_widgets/continue_button.dart';
import '../../../../../../app/custom_widgets/direction.dart';
import '../../../../../../app/validator/text_field_validator.dart';
import '../../../../../../utils/globals.dart';
import '../../../../../app/app_asset_path/images_util.dart';
import '../../../../../app/app_theme/app_theme.dart';
import '../../../../../app/app_usecase/google_map/google_map_place_get.dart';
import '../model/signup_view_model.dart';

class InterestAreaLocationBottomSheet {
  SignUpViewModel get viewModel => sl();

  Future show({required BuildContext context, int? locationIndex}) async {
    var headingStyle = Theme.of(context).textTheme.headline1!.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w500);
    return showModalBottomSheet(
      context: context,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      isDismissible: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: kBottomSheetRadius),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, myState) {
          viewModel.closeBottomSheet = () => Navigator.of(context).pop();
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Stack(
                children: [
                  locationPicker(context, headingStyle, myState, locationIndex),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Form locationPicker(
    BuildContext context,
    TextStyle headingStyle,
    StateSetter myState,
    int? locationIndex,
  ) {
    bool isFocused = false;

    bool shouldShowBlueColor() => viewModel.selectedLocationController.text.isNotEmpty;
    return Form(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: kBottomSheetRadius2,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(viewModel.lat, viewModel.long),
                      zoom: 16,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      if (!viewModel.googleMapCompleter.isCompleted) {
                        viewModel.googleMapCompleter.complete(controller);
                      }

                      myState(() {});
                    },
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    onTap: (LatLng latLng) async {
                      await viewModel.onTapMap(latLng);
                      myState(() {});
                    },
                    zoomControlsEnabled: false,
                    markers: viewModel.marker,
                  ),
                ),
                Positioned(
                  bottom: 0.9.sh / 3,
                  right: 5.w,
                  child: Card(
                    color: Colors.transparent,
                    elevation: 0,
                    child: Container(
                      decoration: BoxDecoration(borderRadius: fieldBorderRadius, border: Border.all(color: kPrimaryColor, width: 1), color: kWhiteColor),
                      width: 40.h,
                      height: 90.h,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Flexible(
                            child: IconButton(
                                icon: Icon(
                                  Icons.add,
                                  color: kPrimaryColor,
                                  size: 20.h,
                                ),
                                onPressed: () async {
                                  final GoogleMapController controller = await viewModel.googleMapCompleter.future;
                                  var currentZoomLevel = await controller.getZoomLevel();

                                  currentZoomLevel = currentZoomLevel + 1;
                                  controller.animateCamera(
                                    CameraUpdate.newCameraPosition(
                                      CameraPosition(
                                        target: LatLng(viewModel.lat, viewModel.long),
                                        zoom: currentZoomLevel,
                                      ),
                                    ),
                                  );
                                }),
                          ),
                          SizedBox(height: 2.h),
                          Flexible(
                            child: IconButton(
                                icon: Icon(
                                  Icons.remove,
                                  color: kPrimaryColor,
                                  size: 20.h,
                                ),
                                onPressed: () async {
                                  final GoogleMapController controller = await viewModel.googleMapCompleter.future;
                                  var currentZoomLevel = await controller.getZoomLevel();
                                  currentZoomLevel = currentZoomLevel - 1;
                                  if (currentZoomLevel < 0) currentZoomLevel = 0;
                                  controller.animateCamera(
                                    CameraUpdate.newCameraPosition(
                                      CameraPosition(
                                        target: LatLng(viewModel.lat, viewModel.long),
                                        zoom: currentZoomLevel,
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 5.h,
            left: 20.w,
            child: SizedBox(
              width: 33.w,
              height: 33.w,
              child: OutlinedButton(
                onPressed: (){
                  viewModel.initializeCloseMap();
                },
                style: OutlinedButton.styleFrom(
                    backgroundColor: kWhiteColor,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: fieldBorderRadius,
                    )),
                child: Icon(
                  Icons.close,
                  size: 20.w,
                  color: kPrimaryColor,
                ),
              ),
            ),
          ),
          Positioned(
            top: 50.h,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
              ),
              child: TypeAheadFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                hideSuggestionsOnKeyboardHide: false,
                suggestionsBoxController: viewModel.suggestionsBoxController,
                getImmediateSuggestions: false,
                minCharsForSuggestions: 3,
                hideOnEmpty: true,
                loadingBuilder: (context) {
                  return const Center(
                    heightFactor: 2,
                    child: CircularProgressIndicator(
                      color: kPrimaryColor,
                    ),
                  );
                },
                suggestionsCallback: (value) async {
                  return await viewModel.getPlaces(value);
                },
                itemBuilder: (context, Prediction prediction) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: ListTile(title: Text(prediction.description, style: Theme.of(context).textTheme.bodyText1)),
                  );
                },
                validator: TextFieldValidator.validateText,
                onSuggestionSelected: (Prediction prediction) async {
                  viewModel.selectedLocationController.text = prediction.description;
                  await viewModel.updateGoogleMapWithPlaceId(prediction.placeId);
                  viewModel.validateLocationTextFieldsNotEmpty();
                  myState(() {});
                },
                textFieldConfiguration: TextFieldConfiguration(
                  controller: viewModel.selectedLocationController,
                  onChanged: (val) {
                    viewModel.validateLocationTextFieldsNotEmpty();
                    myState(() {});
                  },
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: kWhiteColor,
                      isDense: true,
                      hintText: 'interest_area'.ntr(),
                      labelText: 'interest_area'.ntr(),
                      hintStyle: Theme.of(context).textTheme.bodyText2!.copyWith(color: Theme.of(context).disabledColor, fontSize: 14.sp, height: isRTL ? 1 : null),
                      labelStyle:
                          Theme.of(context).textTheme.bodyText2!.copyWith(color: isFocused ? inputFieldBorderColor : Theme.of(context).disabledColor, fontSize: 14.sp, height: isRTL ? 1 : null),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
                      counterText: '',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(fieldRadius), borderSide: const BorderSide(color: kBorderColor)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(fieldRadius),
                        borderSide: BorderSide(color: shouldShowBlueColor() ? inputFieldBorderColor : Theme.of(context).disabledColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(fieldRadius),
                        borderSide: const BorderSide(color: focusedInputFieldBorderColor),
                      ),
                      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.all(fieldRadius), borderSide: BorderSide(color: Theme.of(context).errorColor)),
                      suffixIconConstraints: BoxConstraints(maxHeight: 25.h),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(fieldRadius),
                        borderSide: BorderSide(width: 1.0, color: Theme.of(context).errorColor),
                      ),
                      errorStyle: TextStyle(
                        fontSize: 10.sp,
                        height: 0.9,
                      ),
                      errorMaxLines: 3,
                      suffixStyle: const TextStyle(height: 0.3),
                      prefixIcon: Container(
                        height: kButtonHeight,
                        width: 55.w,
                        decoration: BoxDecoration(
                            border: Border(
                                right: isRTL ? BorderSide.none : const BorderSide(width: 1, color: kBorderColor), left: isRTL ? const BorderSide(width: 1, color: kBorderColor) : BorderSide.none)),
                        margin: EdgeInsets.only(right: isRTL ? 0 : 10.w, left: isRTL ? 5.w : 0),
                        padding: EdgeInsets.only(right: 13.w, left: 13.w),
                        child: SvgPicture.asset(
                          SvgAssetsPaths.fieldLocationSvg,
                        ),
                      ),
                      suffixIcon: viewModel.selectedLocationController.text.isEmpty
                          ? null
                          : GestureDetector(
                              onTap: () {
                                viewModel.clearLocationText();
                                viewModel.validateLocationTextFieldsNotEmpty();
                                myState(() {});
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                                child: Icon(
                                  Icons.close,
                                  size: 15.w,
                                  color: kBorderColor,
                                ),
                              ),
                            )),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 80.h,
            left: 30.w,
            right: 30.w,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: fieldBorderRadius,
                // border: Border.all(color: kPrimaryColor.withOpacity(0.5)),
                color: kToolTipBGColor,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                      width: 25.h,
                      child: const Icon(
                        Icons.info_outline,
                        color: kBlackColor,
                      )),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                    child: Text(
                      'move_the_marker_text'.ntr(),
                      style: Theme.of(context).textTheme.caption!.copyWith(
                            fontWeight: FontWeight.w300,
                          ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.w),
              child: ContinueButton(
                text: 'save_interest_area'.ntr(),
                style: Theme.of(context).textTheme.button!.copyWith(color: Theme.of(context).canvasColor),
                onPressed: viewModel.isSaveLocationButtonEnabled
                    ? () {
                        FocusScope.of(context).unfocus();
                        viewModel.addLocation();
                        Navigator.of(context).pop();
                      }
                    : null,
              ),
            ),
          )
        ],
      ),
    );
  }
}
