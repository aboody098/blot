import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';
import 'package:fire_safety_console/data/local/local_cache.dart';

void main() {
  group('LocalCache Service', () {
    late LocalCache cache;

    setUp(() async {
      // Initialize GetStorage for testing
      GetStorage.init();
      cache = LocalCache();
      await cache.initialize();
    });

    tearDown(() async {
      await cache.clear();
    });

    test('LocalCache stores and retrieves data', () async {
      const testData = 'test_value';

      await cache.set('test_key', testData);
      final retrieved = cache.get<String>('test_key');

      expect(retrieved, testData);
    });

    test('LocalCache respects TTL', () async {
      const testData = 'test_value';

      await cache.set(
        'test_key',
        testData,
        ttl: const Duration(seconds: 1),
      );

      // Should be available immediately
      var retrieved = cache.get<String>('test_key');
      expect(retrieved, testData);

      // Wait for TTL to expire
      await Future.delayed(const Duration(seconds: 2));

      // Should be expired now
      retrieved = cache.get<String>('test_key');
      expect(retrieved, null);
    });

    test('LocalCache removes expired entries', () async {
      await cache.set(
        'expired_key',
        'value',
        ttl: const Duration(milliseconds: 100),
      );

      await Future.delayed(const Duration(milliseconds: 200));
      await cache.clearExpiredCache();

      expect(cache.hasValidCache('expired_key'), false);
    });

    test('LocalCache stores different types', () async {
      await cache.set('string', 'value');
      await cache.set('number', 42);
      await cache.set('bool', true);
      await cache.set('list', [1, 2, 3]);

      expect(cache.get<String>('string'), 'value');
      expect(cache.get<int>('number'), 42);
      expect(cache.get<bool>('bool'), true);
    });

    test('LocalCache removes items', () async {
      await cache.set('remove_test', 'value');
      expect(cache.get<String>('remove_test'), 'value');

      await cache.remove('remove_test');
      expect(cache.get<String>('remove_test'), null);
    });

    test('LocalCache specific KPI caching', () async {
      final kpiData = {'total': 47, 'critical': 2};

      await cache.cacheKpi(kpiData);
      final retrieved = cache.getCachedKpi();

      expect(retrieved, kpiData);
    });

    test('LocalCache returns null for non-existent keys', () async {
      expect(cache.get<String>('non_existent'), null);
    });

    test('LocalCache validates cache existence', () async {
      await cache.set('valid_cache', 'value');
      await cache.set('expired_cache', 'value',
          ttl: const Duration(milliseconds: 100));

      expect(cache.hasValidCache('valid_cache'), true);

      await Future.delayed(const Duration(milliseconds: 150));
      expect(cache.hasValidCache('expired_cache'), false);
    });

    test('LocalCache getCacheSize returns correct count', () async {
      await cache.clear();
      expect(cache.getCacheSize(), 0);

      await cache.set('cache1', 'value1');
      await cache.set('cache2', 'value2');

      expect(cache.getCacheSize(), 2);
    });

    test('LocalCache clears all cache', () async {
      await cache.set('cache1', 'value1');
      await cache.set('cache2', 'value2');

      expect(cache.getCacheSize(), 2);

      await cache.clear();

      expect(cache.getCacheSize(), 0);
      expect(cache.get<String>('cache1'), null);
    });
  });
}
