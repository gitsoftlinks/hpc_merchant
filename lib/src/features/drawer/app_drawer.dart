import 'package:happiness_club_merchant/app/app_theme/app_theme.dart';
import 'package:happiness_club_merchant/app/providers/account_provider.dart';
import 'package:happiness_club_merchant/src/features/screens/business/all_business/all_business_screen.dart';
import 'package:happiness_club_merchant/src/features/screens/products_by_business/products_by_business.dart';
import 'package:happiness_club_merchant/src/features/screens/create_offer/create_offer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:happiness_club_merchant/app/app_asset_path/images_util.dart';
import 'package:happiness_club_merchant/src/features/screens/offer_by_business/offers_by_business.dart';
import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import '../../../app/custom_widgets/direction.dart';
import '../../../app/custom_widgets/logout_bottomsheet.dart';
import '../../../utils/constants/string_constants.dart';
import '../../../utils/globals.dart';

import 'menu_drawer_view_model.dart';

class AppMenuDrawer {
  MenuDrawerViewModel get viewModel => sl();
  AccountProvider get accountProvider => sl();

  Drawer appDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            color: kPrimaryColor,
            height: 140.h,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(right: 16.w, left: 26.w),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    viewModel.onPressPersonalInfoButton();
                    print('img : ${accountProvider.profileImage.value}');
                    print("object ${accountProvider.user.fullName}");
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: isRTL
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: SizedBox(
                          width: 72.h,
                          height: 72.h,
                          child: ValueListenableBuilder<String>(
                              valueListenable: accountProvider.profileImage,
                              builder: (context, value, _) {
                                return CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(60.h),
                                    clipBehavior: Clip.antiAlias,
                                    child: CachedNetworkImage(
                                      imageUrl: value,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        width: 72.h,
                                        height: 72.h,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(60.h),
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      progressIndicatorBuilder: (context, url,
                                              downloadProgress) =>
                                          SizedBox(
                                              height: 50.h,
                                              width: 50.h,
                                              child: Center(
                                                child: CircularProgressIndicator
                                                    .adaptive(
                                                  value:
                                                      downloadProgress.progress,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          Theme.of(context)
                                                              .primaryColor),
                                                ),
                                              )),
                                      errorWidget: (context, url, error) =>
                                          SizedBox(
                                        height: 72.h,
                                        width: 72.h,
                                        child: SvgPicture.asset(
                                            SvgAssetsPaths.userSvg),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ValueListenableBuilder<String>(
                                valueListenable: accountProvider.userName,
                                builder: (context, value, _) {
                                  return Flexible(
                                    flex: 2,
                                    child: Text(
                                      value,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium!
                                          .copyWith(
                                              color: kWhiteColor,
                                              fontWeight: FontWeight.w600),
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }),
                            SizedBox(
                              height: 10.h,
                            ),
                            Flexible(
                              flex: 2,
                              child: Text(
                                viewModel.userDetail.email,
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(
                                        color: kWhiteColor,
                                        fontWeight: FontWeight.w400),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          ListTile(
            // dense: true,
            // visualDensity:
            //     VisualDensity(horizontal: 0, vertical: -0.0045.sh),
            // horizontalTitleGap: 0,
            leading: SizedBox(
                height: 24.h,
                width: 24.h,
                child: SvgPicture.asset(SvgAssetsPaths.drawerProfileSvg)),
            title: Text('Profile',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.normal)),
            onTap: () {
              Navigator.pop(context);
              viewModel.onPressPersonalInfoButton();
            },
          ),
          ListTile(
            //   dense: true,
            // visualDensity:
            //     VisualDensity(horizontal: 0, vertical: -0.0045.sh),
            // horizontalTitleGap: 0,
            leading: SizedBox(
                height: 24.h,
                width: 24.h,
                child: SvgPicture.asset(SvgAssetsPaths.drawerBriefcaseSvg)),
            title: Text('Manage Business',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.normal)),
            onTap: () {
              Navigator.pop(context);

              viewModel.onPressBusinesses();
            },
          ),
          ListTile(
            //   dense: true,
            // visualDensity:
            //     VisualDensity(horizontal: 0, vertical: -0.0045.sh),
            //  horizontalTitleGap: 0,
            leading: SizedBox(
                height: 24.h,
                width: 24.h,
                child: SvgPicture.asset(SvgAssetsPaths.drawerShoppingCartSvg)),
            title: Text('Offers',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.normal)),
            onTap: () {
              Navigator.of(navigatorKeyGlobal.currentContext!)
                  .push(MaterialPageRoute(
                builder: (context) {
                  return OffersByBusinessScreen(
                    toHome: false,
                    comingFromHome: false,
                  );
                },
              ));
            },
          ),
          ListTile(
            // dense: true,
            // visualDensity:
            //     VisualDensity(horizontal: 0, vertical: -0.0045.sh),
            // horizontalTitleGap: 0,
            leading: SizedBox(
                height: 24.h,
                width: 24.h,
                child: SvgPicture.asset(SvgAssetsPaths.drawerSettingSvg)),
            title: Text('Settings',
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(fontWeight: FontWeight.normal)),
            onTap: () {
              //  viewModel.onPressSettings();
              Navigator.pop(context);
            },
          ),
          const Spacer(),
          Align(
            alignment: isRTL ? Alignment.centerRight : Alignment.centerLeft,
            child: ListTile(
              horizontalTitleGap: 0,
              leading: SizedBox(
                  height: 24.h,
                  width: 24.h,
                  child: SvgPicture.asset(SvgAssetsPaths.drawerLogoutSvg)),
              title: Text(
                'log out'.ntr(),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: kErrorColor),
              ),
              onTap: () {
                // viewModel.logout();
                Navigator.pop(context);
                var logoutBottomSheet = LogoutBottomSheet();
                logoutBottomSheet.show();
              },
            ),
          ),
          SizedBox(
            height: isAndroid ? 20.h : 40.h,
          ),
        ],
      ),
    );
  }
}
