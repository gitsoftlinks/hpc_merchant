import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../app_theme/app_theme.dart';

class ShowImagePreview {
  void show({required BuildContext context, required String imageUrl}) {
    var isPDFfile = imageUrl.split('/').last.split('.').last.contains('pdf');

    var alert = AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.symmetric(horizontal: 10.w),
        content: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: ClipOval(
                  child: Material(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: InkResponse(
                        radius: 20.w,
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: EdgeInsets.all(5.w),
                          child: Icon(
                            Icons.close,
                            size: 20.w,
                            color: kBlackColor,
                          ),
                        )),
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              if(isPDFfile) ...[
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.r),
                  child: SizedBox(
                    width: 1.0.sw,
                    // child: SfPdfViewer.network(
                    //   imageUrl,
                    //   // key: _pdfViewerKey,
                    // ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              ],
              if(!isPDFfile) ...[
              ClipRRect(
                  borderRadius: BorderRadius.circular(5.r),
                  child:  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  )),
    ]
            ],
          ),
        ));
    showDialog(
        barrierDismissible: true,
        barrierColor: kBlackColor.withOpacity(0.4),
        context: context,
        useRootNavigator: false,
        builder: (_) {
          return alert;
        });
  }
}
