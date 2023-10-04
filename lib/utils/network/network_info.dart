abstract class NetworkInfo {
  /// This method tells whether the system is connected with the internet or not
  /// Output : returns the string as output
  Future<bool> get isConnected;

  /// This method returns the IP with which the user is connected
  /// Output : returns the string as output
  String getIP();
}
