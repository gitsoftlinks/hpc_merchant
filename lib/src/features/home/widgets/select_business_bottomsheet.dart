import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happiness_club_merchant/app/app_theme/app_theme.dart';
import 'package:happiness_club_merchant/src/features/screens/products_by_business/models/products_by_business_view_model.dart';
import 'package:happiness_club_merchant/src/features/screens/products_by_business/products_by_business.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import '../../../../../app/app_asset_path/images_util.dart';
import '../../../../utils/globals.dart';
import '../../screens/business/all_business/model/get_all_businesses_view_model.dart';
import '../../screens/business/business_detail/model/business_detail_view_model.dart';
import '../../screens/offer_by_business/offers_by_business.dart';

class SelectBusinessBottomSheet {
  bool fromProduct = false;
  SelectBusinessBottomSheet(
      {required this.fromProduct,
      required this.provider,
      required this.viewModel});

  AllBusinessesViewModel? viewModel;
  ProductsByBusinessViewModel? provider;

  Future<void> show() {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: kBottomSheetRadius,
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: navigatorKeyGlobal.currentContext!,
      // isScrollControlled: true,
      builder: (builder) {
        return Container(
          padding:
              EdgeInsets.only(left: 16.w, bottom: 10.w, right: 16.w, top: 20.w),
          color: Theme.of(navigatorKeyGlobal.currentContext!)
              .scaffoldBackgroundColor,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 6.0.h,
              ),
              Center(
                child: Container(
                  width: 50.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      color: kDisabledTextColor),
                ),
              ),
              SizedBox(
                height: 6.0.h,
              ),
              Container(
                height: MediaQuery.of(navigatorKeyGlobal.currentContext!)
                        .size
                        .height *
                    0.46,
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: viewModel!.allBusinesses.length,
                    itemBuilder: (context, index) {
                      var data = viewModel!.allBusinesses[index];
                      return ListTile(
                        onTap: () async {
                          if (fromProduct == false) {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        OffersByBusinessScreen(
                                            toHome: true,
                                            comingFromHome: false,
                                            id: data.id)));
                          }
                          if (fromProduct) {
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (context) => ProductsByBusinessScreen(
                                comingFromHome: false,
                                toHome: true,
                                id: data.id,
                              ),
                            ));
                          }
                        },
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -2.h),
                        contentPadding: const EdgeInsets.all(0),
                        leading: Container(
                          height: 36.h,
                          width: 36.h,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.r)),
                              border: Border.all(
                                  color: kDisabledColor, width: 1.w)),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.r)),
                            child: CachedNetworkImage(
                              imageUrl: data.businessLogoPath,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.fill),
                                ),
                              ),
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => Shimmer(
                                color: Theme.of(context).disabledColor,
                                duration: const Duration(seconds: 2),
                                enabled: true,
                                child: SizedBox(
                                  height: 0.3.sh,
                                  width: double.infinity,
                                ),
                              ),
                              errorWidget: (context, url, error) => SizedBox(
                                child: SvgPicture.asset(
                                  SvgAssetsPaths.imageSvg,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          data.businessDisplayName,
                          style: Theme.of(navigatorKeyGlobal.currentContext!)
                              .textTheme
                              .titleMedium,
                        ),
                        trailing: Padding(
                          padding: EdgeInsets.only(right: 14.w),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 20.h,
                          ),
                        ),
                      );
                    }),
              ),
              const Divider(
                thickness: 1,
                color: kDisabledColor,
              ),
              SizedBox(
                height: 10.0.h,
              ),
            ],
          ),
        );
      },
    );
  }
}
