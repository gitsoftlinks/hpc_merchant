abstract class FCMService {

  /// This method gets the FCM token form firebase sdk.
  /// OUTPUT: [String] FCM token.
  /// may throw exception
  Future<String> getFCMToken();

  /// This method deletes the FCM token form firebase sdk.
  Future<void> deleteFCMToken();
}