import 'package:get_storage/get_storage.dart';
import 'package:fire_safety_console/core/logger.dart';

class LocalCache {
  static final LocalCache _instance = LocalCache._internal();

  late GetStorage _storage;
  static const String _cachePrefix = 'cache_';
  static const String _timestampPrefix = 'timestamp_';
  static const Duration defaultTTL = Duration(hours: 1);

  LocalCache._internal();

  factory LocalCache() {
    return _instance;
  }

  Future<void> initialize() async {
    _storage = GetStorage();
    Logger.info('Local cache initialized', tag: 'LocalCache');
  }

  // Generic cache methods
  Future<void> set<T>(
    String key,
    T value, {
    Duration ttl = defaultTTL,
  }) async {
    try {
      final cacheKey = '$_cachePrefix$key';
      final timestampKey = '$_timestampPrefix$key';

      await _storage.write(cacheKey, value);
      await _storage.write(
        timestampKey,
        DateTime.now().add(ttl).millisecondsSinceEpoch,
      );

      Logger.debug('Cached: $key', tag: 'LocalCache');
    } catch (e) {
      Logger.error('Failed to cache $key', tag: 'LocalCache', exception: e);
    }
  }

  T? get<T>(String key) {
    try {
      final cacheKey = '$_cachePrefix$key';
      final timestampKey = '$_timestampPrefix$key';

      final expireTime = _storage.read<int>(timestampKey);
      if (expireTime != null) {
        final now = DateTime.now().millisecondsSinceEpoch;
        if (now > expireTime) {
          await remove(key);
          Logger.debug('Cache expired: $key', tag: 'LocalCache');
          return null;
        }
      }

      final value = _storage.read<T>(cacheKey);
      if (value != null) {
        Logger.debug('Cache hit: $key', tag: 'LocalCache');
      }
      return value;
    } catch (e) {
      Logger.error('Failed to read cache $key', tag: 'LocalCache', exception: e);
      return null;
    }
  }

  Future<void> remove(String key) async {
    try {
      final cacheKey = '$_cachePrefix$key';
      final timestampKey = '$_timestampPrefix$key';

      await _storage.remove(cacheKey);
      await _storage.remove(timestampKey);

      Logger.debug('Cache removed: $key', tag: 'LocalCache');
    } catch (e) {
      Logger.error('Failed to remove cache $key', tag: 'LocalCache',
          exception: e);
    }
  }

  Future<void> clear() async {
    try {
      final keys = _storage.getKeys();
      for (final key in keys) {
        if (key.toString().startsWith(_cachePrefix) ||
            key.toString().startsWith(_timestampPrefix)) {
          await _storage.remove(key);
        }
      }
      Logger.info('Cache cleared', tag: 'LocalCache');
    } catch (e) {
      Logger.error('Failed to clear cache', tag: 'LocalCache', exception: e);
    }
  }

  bool hasValidCache(String key) {
    try {
      final timestampKey = '$_timestampPrefix$key';
      final expireTime = _storage.read<int>(timestampKey);

      if (expireTime == null) {
        return false;
      }

      final now = DateTime.now().millisecondsSinceEpoch;
      return now <= expireTime;
    } catch (e) {
      return false;
    }
  }

  // Specific cache methods for common data
  Future<void> cacheKpi(Map<String, dynamic> data) async {
    await set('kpi', data, ttl: const Duration(minutes: 5));
  }

  Map<String, dynamic>? getCachedKpi() {
    return get<Map<String, dynamic>>('kpi');
  }

  Future<void> cacheIncidents(List<dynamic> data) async {
    await set('incidents', data, ttl: const Duration(minutes: 10));
  }

  List<dynamic>? getCachedIncidents() {
    return get<List<dynamic>>('incidents');
  }

  Future<void> cacheCameras(List<dynamic> data) async {
    await set('cameras', data, ttl: const Duration(hours: 1));
  }

  List<dynamic>? getCachedCameras() {
    return get<List<dynamic>>('cameras');
  }

  Future<void> cacheSensors(List<dynamic> data) async {
    await set('sensors', data, ttl: const Duration(minutes: 5));
  }

  List<dynamic>? getCachedSensors() {
    return get<List<dynamic>>('sensors');
  }

  Future<void> cacheAnalytics(Map<String, dynamic> data) async {
    await set('analytics', data, ttl: const Duration(hours: 2));
  }

  Map<String, dynamic>? getCachedAnalytics() {
    return get<Map<String, dynamic>>('analytics');
  }

  Future<void> cacheTrainingRuns(List<dynamic> data) async {
    await set('training_runs', data, ttl: const Duration(minutes: 15));
  }

  List<dynamic>? getCachedTrainingRuns() {
    return get<List<dynamic>>('training_runs');
  }

  // Cache statistics
  int getCacheSize() {
    try {
      final keys = _storage.getKeys();
      return keys.where((key) => key.toString().startsWith(_cachePrefix)).length;
    } catch (e) {
      return 0;
    }
  }

  Future<void> clearExpiredCache() async {
    try {
      final keys = _storage.getKeys();
      int cleared = 0;

      for (final key in keys) {
        if (key.toString().startsWith(_timestampPrefix)) {
          final expireTime = _storage.read<int>(key);
          if (expireTime != null) {
            final now = DateTime.now().millisecondsSinceEpoch;
            if (now > expireTime) {
              final originalKey = key.toString().replaceFirst(_timestampPrefix, '');
              await remove(originalKey);
              cleared++;
            }
          }
        }
      }

      Logger.info('Cleared $cleared expired cache entries', tag: 'LocalCache');
    } catch (e) {
      Logger.error('Failed to clear expired cache', tag: 'LocalCache',
          exception: e);
    }
  }
}
