// ignore_for_file: constant_identifier_names

import 'package:clean/data/network/error_handler.dart';
import 'package:clean/data/response/responses.dart';

const CACHE_HOME_KEY = "CACHE_HOME_KEY";
const CACHE_HOME_INTERVAL = 60 * 1000; //1 MINUTE CACHE IN MILLE

abstract class LocalDataSource {
  Future<HomeResponse> getHomeData();

  Future<void> saveHomeToCache(HomeResponse homeResponse);

  void clearCache();

  void removeFromCache(String key);
}

class LocalDataSourceImpl implements LocalDataSource {
  //run time cashe
  Map<String, CachedItem> cacheMap = Map();
  @override
  Future<HomeResponse> getHomeData() async {
    CachedItem? cashedItem = cacheMap[CACHE_HOME_KEY];
    if (cashedItem != null && cashedItem.isValid(CACHE_HOME_INTERVAL)) {
      // return the response from cache
      return cashedItem.data;
    } else {
      //return an error that cache is not there or its not valid
      throw ErrorHandler.handle(DataSource.CASHE_ERROR);
    }
  }

  @override
  Future<void> saveHomeToCache(HomeResponse homeResponse) async {
    cacheMap[CACHE_HOME_KEY] = CachedItem(homeResponse);
  }

  @override
  void clearCache() {
    cacheMap.clear();
  }

  @override
  void removeFromCache(String key) {
    cacheMap.remove(key);
  }
}

class CachedItem {
  dynamic data;
  int casheTime = DateTime.now().millisecondsSinceEpoch;

  CachedItem(this.data);
}

extension CachedItemExtension on CachedItem {
  bool isValid(int expirationTimeInMillis) {
    int currentTimeInMillis = DateTime.now().millisecondsSinceEpoch;
    bool isValid = currentTimeInMillis - casheTime < expirationTimeInMillis;
    return isValid;
  }
}
