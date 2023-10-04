import 'package:happiness_club_merchant/app/app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';
import 'package:happiness_club_merchant/app/custom_widgets/continue_button.dart';
import 'package:happiness_club_merchant/utils/extensions/extensions.dart';

import '../../../app/app_asset_path/images_util.dart';
import '../../../services/usecases/usecase.dart';
import '../../../utils/globals.dart';
import '../../../utils/router/app_state.dart';
import 'check_internet_connection.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: const SafeArea(
        child: Scaffold(
          body: NoInternetScreenContent(),
        ),
      ),
    );
  }
}

class NoInternetScreenContent extends StatefulWidget {
  const NoInternetScreenContent({Key? key}) : super(key: key);

  @override
  State<NoInternetScreenContent> createState() =>
      _NoInternetScreenContentState();
}

class _NoInternetScreenContentState extends State<NoInternetScreenContent> {
  CheckInternetConnection get checkConnection =>
      sl.get<CheckInternetConnection>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Spacer(
          flex: 1,
        ),
        Flexible(
          flex: 4,
          // fit: FlexFit.tight,
          child: Center(
            child: SizedBox(
              height: 500.h,
              child: Lottie.asset(
                LottieFiles.noInternetConnectionLottie,
                height: 500.h,
                key: const ValueKey('lottie Image'),
              ),
            ),
          ),
        ),
        Flexible(
            flex: 1,
            child: Center(
              child: Container(
                padding: EdgeInsets.only(top: 15.h),
                child: Text('No Internet Connection'.ntr(),
                    style: Theme.of(context).textTheme.headline1!.copyWith(
                        fontWeight: FontWeight.w500, color: kPrimaryColor)),
              ),
            )),
        Flexible(
          flex: 1,
          child: Container(
            padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 20.h),
            child: Center(
                child: Text('Check your internet and try again'.ntr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(fontWeight: FontWeight.normal))),
          ),
        ),
        SizedBox(
          height: 50.h,
        ),
        const Spacer(),
        Flexible(
            child: Padding(
          padding: EdgeInsets.only(left: 16.0.w, right: 16.0.w),
          child: ContinueButton(
            text: 'TRY AGAIN'.ntr(),
            onPressed: () {
              onPressedTryAgain();
            },
          ),
        )),
      ]),
    );
  }

  void onPressedTryAgain() async {
    //

    var checkConnectionEither = await checkConnection.call(NoParams());

    if (checkConnectionEither.isLeft()) {
      return;
    }

    var connected = checkConnectionEither.getOrElse(() => false);
    if (connected) {
      var appState = GetIt.I.get<AppState>();
      appState.moveToBackScreen();
    }
  }
}
