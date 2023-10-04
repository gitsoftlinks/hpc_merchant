import 'dart:async';
import 'package:happiness_club_merchant/app/app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import '../../../app/app_asset_path/images_util.dart';
import '../../../utils/constants/app_strings.dart';
import '../../../utils/globals.dart';
import 'model/splash_screen_view_model.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  bool bioAutEnabled = false;

  SplashScreenViewModel get viewModel => sl();

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  double animatedOpacity = 1;

  @override
  void initState() {
    super.initState();

    viewModel.errorMessages = (value) => scaffoldKey.currentContext.show(message: value);
    SchedulerBinding.instance.addPostFrameCallback((_) async{
      viewModel.startConfiguration = () => viewModel.getAllConfigurations();
    });

    viewModel.showInternetSnackBar = () {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(NO_INTERNET),
        duration: const Duration(hours: 1),
        action: SnackBarAction(
          onPressed: () {
            ScaffoldMessenger.of(navigatorKeyGlobal.currentState!.overlay!.context).hideCurrentSnackBar();

            viewModel.getAllConfigurations();
          },
          label: 'retry'.ntr(),
        ),
      ));
    };

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ChangeNotifierProvider.value(
          value: viewModel,
          builder: (context, snapshot) {
            return SplashScreenContent(animatedOpacity: animatedOpacity);
          }),
    );
  }

}

class SplashScreenContent extends StatefulWidget {
  const SplashScreenContent({
    Key? key,
    required this.animatedOpacity,
  }) : super(key: key);

  final double animatedOpacity;

  @override
  State<SplashScreenContent> createState() => _SplashScreenContentState();
}

class _SplashScreenContentState extends State<SplashScreenContent> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(left: 0, right: 0, top: 0, bottom: 0, child: Container()),
        const Positioned(left: 0, right: 0, top: 0, child: AppAnimatedLogo()),
        Positioned(
            left: 0,
            right: 0,
            bottom: 90.h,
            child: Center(
                child: Text(
              'loading'.ntr(),
              style: Theme.of(context).textTheme.bodyText1!.copyWith(color: kPrimaryColor),
            ))),
        Positioned(left: 0, right: 0, bottom: 50.h, child: const PercentIndicate()),
        Positioned(
            left: 0,
            right: 0,
            bottom: 20.h,
            child: Center(
                child: Text(
              'version'.ntr(args: {'value': context.read<SplashScreenViewModel>().appVersion}),
              style: Theme.of(context).textTheme.bodyText1!.copyWith(color: kDisabledTextColor),
            ))),
      ],
    );
  }
}

class AppAnimatedLogo extends StatefulWidget {
  const AppAnimatedLogo({Key? key}) : super(key: key);

  @override
  AppAnimatedLogoState createState() => AppAnimatedLogoState();
}

class AppAnimatedLogoState extends State<AppAnimatedLogo> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 420.h,
      child: Stack(
        children: [
          Positioned(left: 0, bottom: 0, right: 0, child: Center(child: SizedBox(height: 200.h, width: 0.7.sw, child: Image.asset(PngAssetsPath.logoImage)))),
        ],
      ),
    );
  }
}

class PercentIndicate extends StatefulWidget {
  const PercentIndicate({Key? key}) : super(key: key);

  @override
  PercentIndicateState createState() => PercentIndicateState();
}

class PercentIndicateState extends State<PercentIndicate> {
  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() async {
      await Future.delayed(const Duration(milliseconds: 2000)).whenComplete(() => context.read<SplashScreenViewModel>().getEssentialPermissions());
    });
  }

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<SplashScreenViewModel>();
    return SizedBox(
      height: 50.h,
      child: Stack(
        children: [
          Positioned(
              left: 0,
              bottom: 30.h,
              right: 0,
              child: Center(
                  child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.3.sw),
                child: LinearProgressIndicator(
                  value: viewModel.progressMade/100,
                  minHeight: 5.0,
                  // semanticsValue: viewModel.progressMade.toString(),
                  // color: kPrimaryColor.withOpacity(0.4),
                  backgroundColor:  kPrimaryColor.withOpacity(0.4),
                  valueColor: const AlwaysStoppedAnimation<Color>(kPrimaryColor),
                ),
              ))),
        ],
      ),
    );
  }
}
