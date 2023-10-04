import 'package:happiness_club_merchant/app/app_asset_path/images_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happiness_club_merchant/src/features/home/model/home_view_model.dart';
import 'package:provider/provider.dart';
import '../app_theme/app_theme.dart';
import 'direction.dart';

class ToggleViewButton extends StatefulWidget {
  final HomeViewModel viewModel;
  const ToggleViewButton({super.key, required this.viewModel});

  @override
  ToggleViewButtonState createState() => ToggleViewButtonState();
}

double width = 64.w;
double height = 32.h;

class ToggleViewButtonState extends State<ToggleViewButton> {
  //

  @override
  void initState() {
    super.initState();
    widget.viewModel.initSwitchValues();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(builder: (context, s, p) {
      return Container(
        width: width,
        height: height,
        margin: EdgeInsets.only(
            right: isRTL ? 0 : 16.w, top: 16.w, left: isRTL ? 16.w : 0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: kLightGreenColor, width: 1),
          borderRadius: BorderRadius.all(fieldRadius),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              alignment: Alignment(widget.viewModel.xAlign, 0),
              duration: const Duration(milliseconds: 300),
              child: Container(
                width: width * 0.5,
                height: height,
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft:
                        widget.viewModel.xAlign == widget.viewModel.englishAlign
                            ? Radius.circular(11.r)
                            : Radius.zero,
                    bottomLeft:
                        widget.viewModel.xAlign == widget.viewModel.englishAlign
                            ? Radius.circular(11.r)
                            : Radius.zero,
                    topRight:
                        widget.viewModel.xAlign == widget.viewModel.arabicAlign
                            ? Radius.circular(11.r)
                            : Radius.zero,
                    bottomRight:
                        widget.viewModel.xAlign == widget.viewModel.arabicAlign
                            ? Radius.circular(11.r)
                            : Radius.zero,
                  ),
                  border: Border.all(color: kLightGreenColor, width: 1),
                ),
              ),
            ),
            // GestureDetector(
            //   onTap: () {
            //     widget.viewModel.toggleProjectMapView(false);
            //     //
            //   },
            //   child: Align(
            //     alignment: const Alignment(-1, 0),
            //     child: Container(
            //       width: width * 0.5,
            //       color: Colors.transparent,
            //       alignment: Alignment.center,
            //       child: SvgPicture.asset(widget.viewModel.listSvg),
            //     ),
            //   ),
            // ),
            // GestureDetector(
            //   onTap: () {
            //     //

            //     widget.viewModel.toggleProjectMapView(true);
            //   },
            //   child: Align(
            //     alignment: const Alignment(1, 0),
            //     child: Container(
            //       width: width * 0.5,
            //       color: Colors.transparent,
            //       alignment: Alignment.center,
            //       child: SvgPicture.asset(widget.viewModel.mapSvg),
            //     ),
            //   ),
            // ),
          ],
        ),
      );
    });
  }
}
