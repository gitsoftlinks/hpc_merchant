import 'package:happiness_club_merchant/app/app_theme/app_theme.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../../app/app_asset_path/images_util.dart';
import '../../../../utils/globals.dart';
import 'all_business/model/get_all_businesses_view_model.dart';

class MangeBusinessScreen extends StatelessWidget {
  const MangeBusinessScreen({super.key});
  AllBusinessesViewModel get viewModel => sl();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: viewModel,
        ),
      ],
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              body: ManageBusinessScreenContents(),
            ),
          ),
        ),
      ),
    );
  }
}

class ManageBusinessScreenContents extends StatefulWidget {
  const ManageBusinessScreenContents({super.key});

  @override
  State<ManageBusinessScreenContents> createState() =>
      _ManageBusinessScreenContentsState();
}

class _ManageBusinessScreenContentsState
    extends State<ManageBusinessScreenContents> {
  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<AllBusinessesViewModel>();
    return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.only(left: 16.h, right: 16.h),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 140.h,
                    child: GestureDetector(
                      onTap: () {
                        viewModel.moveToCreateBusiness();
                      },
                      child: buildDottedBorderImages(
                          context: context,
                          title: 'Add Your Business',
                          description:
                              'To manage your products and offers with branches',
                          isCover: false,
                          hasWarning: false),
                    ),
                  ),
                ]),
          ),
        ));
  }

  DottedBorder buildDottedBorderImages(
      {required BuildContext context,
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
              padding: EdgeInsets.only(top: 5.h),
              child: Column(
                children: [
                  SvgPicture.asset(
                    height: 24.h,
                    width: 24.h,
                    SvgAssetsPaths.archiveSvg,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 15.0.h, right: 15.h, bottom: 10.h),
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
}
