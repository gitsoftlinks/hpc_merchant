
import 'package:flutter_udid/flutter_udid.dart';

abstract class UDIDGenerator {
  /// This method will give UDID to the user
  /// [Output]: [String] udid for this device
  Future<String> getUDID();
}

class UDIDGeneratorImp implements UDIDGenerator {
  @override
  Future<String> getUDID() async {
    var udid = await FlutterUdid.udid;
    return udid;
  }
}
