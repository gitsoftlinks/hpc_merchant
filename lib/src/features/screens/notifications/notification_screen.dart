import 'dart:convert';

import 'package:happiness_club_merchant/app/custom_widgets/custom_button.dart';
import 'package:happiness_club_merchant/src/features/screens/notifications/widgets/notification_shimmer_widget.dart';
import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:provider/provider.dart';
import '../../../../app/app_theme/app_theme.dart';
import '../../../../app/custom_widgets/direction.dart';
import '../../../../utils/globals.dart';
import 'model/notificatiiion_view_model.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  NotificationViewModel get viewModel => sl();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: GestureDetector(
        onTap: () => '',
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: const SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              body: NotificationScreenContents(),
            ),
          ),
        ),
      ),
    );
  }
}

class NotificationScreenContents extends StatefulWidget {
  const NotificationScreenContents({Key? key}) : super(key: key);

  @override
  State<NotificationScreenContents> createState() =>
      _NotificationScreenContentsState();
}

class _NotificationScreenContentsState
    extends State<NotificationScreenContents> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<NotificationViewModel>();
    return RefreshIndicator(
      color: kPrimaryColor,
      onRefresh: () async {
        await viewModel.getNotifications();
      },
      child: FocusDetector(
        onFocusGained: () {
          viewModel.init();
        },
        child: Container(
          padding: EdgeInsets.only(left: 16.w, right: 16.w),
          height: double.infinity,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30.h,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "notifications".ntr(),
                    style: Theme.of(context)
                        .textTheme
                        .headline1!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                if (viewModel.showShimmer) ...[
                  buildNotificationShimmer(context)
                ] else if (viewModel.notifications.isEmpty) ...[
                  Text('no_new_notification'.ntr(),
                      style: Theme.of(context).textTheme.bodyText1)
                ] else ...[
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: viewModel.notifications.length,
                    itemBuilder: (BuildContext context, int index) {
                      var notification = viewModel.notifications[index];
                      return ListTile(
                        onTap: () {
                          viewModel.onTapNotification(
                              notification: notification);
                        },
                        contentPadding: EdgeInsets.zero,
                        tileColor: notification.notificationReadStatus == 0
                            ? kaLightGrey.withOpacity(0.2)
                            : null,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(fieldRadiusDouble),
                        ),
                        leading: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            // Flexible(
                            //   child: SizedBox(
                            //     width: 40.h,
                            //     height: 40.h,
                            //     child: CircleAvatar(
                            //       backgroundColor: Colors.white,
                            //       child: ClipRRect(
                            //           borderRadius: BorderRadius.circular(60.h),
                            // child: CachedNetworkImage(
                            //   imageUrl: notification
                            //       .fromuserdetails.profileImage,
                            //   imageBuilder:
                            //       (context, imageProvider) =>
                            //           Container(
                            //     decoration: BoxDecoration(
                            //       image: DecorationImage(
                            //         image: imageProvider,
                            //         fit: BoxFit.cover,
                            //       ),
                            //     ),
                            //   ),
                            //   progressIndicatorBuilder: (context, url,
                            //           downloadProgress) =>
                            //       SizedBox(
                            //           height: 50.h,
                            //           width: 50.h,
                            //           child: Center(
                            //             child:
                            //                 CircularProgressIndicator
                            //                     .adaptive(
                            //               value: downloadProgress
                            //                   .progress,
                            //               valueColor:
                            //                   AlwaysStoppedAnimation<
                            //                           Color>(
                            //                       Theme.of(context)
                            //                           .primaryColor),
                            //             ),
                            //           )),
                            //   errorWidget: (context, url, error) =>
                            //       SizedBox(
                            //     height: 70.h,
                            //     width: 70.h,
                            //     child: SvgPicture.asset(
                            //         SvgAssetsPaths.userSvg),
                            //   ),
                            // )),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        title: Padding(
                          padding: EdgeInsets.only(top: 10.0.h),
                          child: RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: notification.fromuserdetails.fullName,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2!
                                    .copyWith(fontWeight: FontWeight.w500)),
                            const TextSpan(text: ' '),
                            TextSpan(
                                text: notification.detail,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5!
                                    .copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: kDisabledTextColor))
                          ])),
                        ),
                        subtitle: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 3.h,
                                ),
                                Text(
                                  notification.createdAt
                                      .toString()
                                      .formatWithCurrentDay(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3!
                                      .copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: kcomment),
                                ),
                                SizedBox(
                                  height: 3.h,
                                ),
                              ],
                            ),
                            const Spacer(),
                            if (notification.notificationType.name ==
                                "friend_request") ...[
                              CustomButton(
                                text: "Reject",
                                height: 35,
                                backgroundColor: kPrimaryColor,
                                onPressed: () {
                                  var d = jsonDecode(notification.actionIds);

                                  dp("Id is", notification.id);

                                  dp("Id is", d["friend_request_id"]);

                                  // viewModel.rejectFriendRequest(
                                  //     d["friend_request_id"],
                                  //     index,
                                  //     notification);
                                },
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              CustomButton(
                                text: "Accept",
                                height: 35,
                                backgroundColor: kPrimaryColor,
                                onPressed: () {
                                  var d = jsonDecode(notification.actionIds);
                                  dp("Id is", d["friend_request_id"]);
                                  dp("Id is", notification.id);
                                  // viewModel.acceptFriendRequest(
                                  //     d["friend_request_id"],
                                  //     index,
                                  //     notification);
                                },
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ]
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: EdgeInsets.only(
                            left: isRTL ? 0 : 50.w, right: isRTL ? 50.w : 0),
                        child: const Divider(
                          color: kDisabledColor,
                          thickness: 2,
                        ),
                      );
                    },
                  ),
                ],
                SizedBox(
                  height: 40.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
