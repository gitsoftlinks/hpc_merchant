// // ignore_for_file: use_build_context_synchronously

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../../../../../../app/app_theme/app_theme.dart';
// import '../../../../../../app/custom_widgets/continue_button.dart';
// import '../../../../../../utils/globals.dart';
// import '../model/create_business_view_model.dart';
// import 'package:cupertino_icons/cupertino_icons.dart';

// showBusinessContractAlert(context, CreateBusinessViewModel provider) {
//   generalDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(
//               Radius.circular(
//                 20.r,
//               ),
//             ),
//           ),
//           contentPadding: EdgeInsets.only(
//             top: 10.h,
//           ),
//           scrollable: true,
//           content: Container(
//             child: Column(children: [
//               Padding(
//                 padding: EdgeInsets.only(left: 36.h, right: 36.h, top: 16.h),
//                 child: Icon(
//                   Icons.edit_document,
//                   color: kPrimaryColor,
//                   size: 80.w,
//                 ),
//               ),
//               SizedBox(
//                 height: 20.h,
//               ),
//               Padding(
//                   padding: EdgeInsets.only(left: 16.w, right: 16.w),
//                   child: provider.data),
//               SizedBox(
//                 height: 20.h,
//               ),
             
//               SizedBox(
//                 height: 10.h,
//               )
//             ]),
//           ),
//         );
//       });
// }
 