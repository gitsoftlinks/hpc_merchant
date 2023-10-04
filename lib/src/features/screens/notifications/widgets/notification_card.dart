import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/app_theme/app_theme.dart';

class NotificationCard extends StatefulWidget {
  const NotificationCard({Key? key}) : super(key: key);

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 6,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  child: SizedBox(
                    width: 40.h,
                    height: 40.h,
                    child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(fieldHeight),
                            child: Image.network(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRKTBIcYCniUn7AsZBpP51BpEcM84japtDB17SOHK5WkQ&s',
                              height: 40.h,
                              width: 40.h,
                              fit: BoxFit.cover,
                            ))),
                  ),
                ),
              ],
            ),
            title: Padding(
              padding: EdgeInsets.only(top: 10.0.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Janan Khan',
                    style: Theme.of(context)
                        .textTheme
                        .headline2!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Flexible(
                    child: Text('like a picture you shared',
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                            fontWeight: FontWeight.w400,
                            color: kDisabledTextColor)),
                  ),
                ],
              ),
            ),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 3.h,
                ),
                Text(
                  '54 min ago',
                  style: Theme.of(context)
                      .textTheme
                      .headline3!
                      .copyWith(fontWeight: FontWeight.w400, color: kcomment),
                ),
                const Divider(
                  color: kDisabledColor,
                  thickness: 2,
                ),
                SizedBox(
                  height: 3.h,
                ),
              ],
            ),
          );
        });
  }
}
