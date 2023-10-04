import 'dart:io';

import 'package:flutter/material.dart';
import 'package:happiness_club_merchant/utils/globals.dart';

final TextDirection currentDirection = Directionality.of(navigatorKeyGlobal.currentContext!);
bool isRTL = currentDirection == TextDirection.rtl;

final String currentLocale = Platform.localeName;