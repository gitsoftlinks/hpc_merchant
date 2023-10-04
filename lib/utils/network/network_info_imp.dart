import 'dart:io';

import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../constants/app_strings.dart';
import 'network_info.dart';

class NetworkInfoImp implements NetworkInfo {
  final InternetConnectionChecker _connectionChecker;

  NetworkInfoImp({required InternetConnectionChecker connectionChecker}) : _connectionChecker = connectionChecker;

  @override
  Future<bool> get isConnected => _connectionChecker.hasConnection;

  @override
  String getIP() {
    if (_connectionChecker.addresses.isEmpty) {
      throw NO_IP_ADDRESS_FOUND;
    }

    var ip4List = _connectionChecker.addresses.where((element) => element.address!.type ==  InternetAddressType.IPv4).toList();

    if (ip4List.isEmpty) {
      throw NO_IP_ADDRESS_FOUND;
    }

    return ip4List.last.address!.address;
  }
}
