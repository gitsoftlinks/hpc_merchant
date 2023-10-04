import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

GlobalKey<NavigatorState> navigatorKeyGlobal = GlobalKey();

GlobalKey<ScaffoldMessengerState> scaffoldMessengerGlobal = GlobalKey();

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

final sl = GetIt.instance;

bool isAndroid = false;

dp(msg, arg) {
  Platform.isAndroid
      ? debugPrint("\n\u001b[1;32m $msg     $arg ")
      : debugPrint(" $msg     $arg ");
}

Future<T?> toNext<T>(Widget widget) => Navigator.push<T?>(
      navigatorKeyGlobal.currentState!.context,
      MaterialPageRoute(builder: (_) => widget),
    );

showSnakBar(String message) {
  ScaffoldMessenger.of(navigatorKeyGlobal.currentState!.context)
      .showSnackBar(SnackBar(content: Text(message)));
}

extension onBtx on BuildContext {
  Size getSize() {
    return MediaQuery.of(this).size;
  }
}
