import 'package:easy_localization/easy_localization.dart';

import 'cache_manager.dart';

class CacheManagerImp implements CacheManager {
  Map<String, dynamic> cache = {};

  @override
  String getString({required String key}) {
    if (cache.containsKey(key)) {
      return cache[key];
    }

    return '';
  }

  @override
  void setString({required String key, required String value}) {
    cache[key] = value;
  }

  @override
  dynamic getDynamicType({required String key}) {
    if (cache.containsKey(key)) {
      return cache[key];
    }

    throw 'cache_failure'.tr();
  }

  @override
  bool setDynamicType({required String key, required dynamic value}) {
    cache[key] = value;
    return true;
  }

  @override
  String deleteString({required String key}) {
    if (cache.containsKey(key)) {
      return cache.remove(key);
    }

    return '';
  }
}
