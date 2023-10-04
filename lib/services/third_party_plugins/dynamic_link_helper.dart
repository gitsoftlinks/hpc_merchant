// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:flutter/foundation.dart';

// import '../../utils/constants/app_strings.dart';

// abstract class DynamicLinkHelper {
//   /// This method will listen to the dynamic link
//   /// Output: [Uri] contains the received Link
//   Stream<Uri> listenToDynamicLinks();

//   /// This method will get the initial link with which the app is installed or opened.
//   /// Output: [String] contains the link
//   Future<Uri> getInitialLink();

//   /// This method will get the initial link with which the app is installed or opened.
//   /// Input: [String] contains the arguments
//   /// Output: [String] contains the generated link
//   Future<String> generateDynamicLink(String params);
// }

// class DynamicLinkHelperImpl implements DynamicLinkHelper {
//   FirebaseDynamicLinks firebaseDynamicLinks;
//   String url;
//   String uriPrefix;
//   String androidPackage;
//   String iosPackage;

//   DynamicLinkHelperImpl({required this.firebaseDynamicLinks, required this.url, required this.uriPrefix, required this.androidPackage, required this.iosPackage});

//   @override
//   Stream<Uri> listenToDynamicLinks() {
//     return firebaseDynamicLinks.onLink.map((event) => event.link);
//   }

//   @override
//   Future<Uri> getInitialLink() async {
//     var pendingDynamicLinkData = await firebaseDynamicLinks.getInitialLink();
//     var uri = pendingDynamicLinkData?.link;

//     if (uri != null) {
//       return uri;
//     }

//     throw DYNAMIC_LINK_ERROR;
//   }

//   @override
//   Future<String> generateDynamicLink(String args) async {
//     final dynamicLinkParams = DynamicLinkParameters(
//       link: Uri.parse(url + args),
//       uriPrefix: uriPrefix,
//       androidParameters: AndroidParameters(packageName: androidPackage),
//       iosParameters: IOSParameters(bundleId: iosPackage),
//     );
//     var ss = firebaseDynamicLinks.app.options.deepLinkURLScheme;
//     debugPrint(ss);
//     final link = await firebaseDynamicLinks.buildLink(dynamicLinkParams);
//     return link.toString();
//   }
// }
