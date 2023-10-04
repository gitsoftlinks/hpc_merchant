abstract class CacheManager {

  /// This method will return the saved String if exists
  /// Input: [key] the key of the value
  /// Output: [String] the value of the key
  String getString({required String key});



  /// This method will delete the value from the cache
  /// Input: [key] the key of the value
  /// Output: [value] will return the value that is just removed
  String deleteString({required String key});


  /// This method will set the input in the cache
  /// Input: [key] the key against which the value is to be set, [value] the value that is to be set.
  void setString({required String key, required String value});

  bool setDynamicType({required String key, required dynamic value});


  dynamic getDynamicType({required String key});

}