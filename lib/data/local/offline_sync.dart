import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:fire_safety_console/core/logger.dart';

typedef SyncCallback = Future<bool> Function();

class OfflineSync extends GetxService {
  static final OfflineSync _instance = OfflineSync._internal();

  late GetStorage _storage;
  late Connectivity _connectivity;

  final isOnline = true.obs;
  final pendingChanges = <String, Map<String, dynamic>>{}.obs;
  final Map<String, SyncCallback> _syncCallbacks = {};

  OfflineSync._internal() {
    _connectivity = Connectivity();
    _storage = GetStorage();
  }

  factory OfflineSync() {
    return _instance;
  }

  @override
  Future<OfflineSync> onInit() async {
    super.onInit();
    await _initializeConnectivity();
    return this;
  }

  Future<void> _initializeConnectivity() async {
    // Check initial connectivity
    final result = await _connectivity.checkConnectivity();
    _updateConnectivity(result);

    // Listen to connectivity changes
    _connectivity.onConnectivityChanged.listen((result) {
      _updateConnectivity(result);
    });

    Logger.info('Offline sync initialized', tag: 'OfflineSync');
  }

  void _updateConnectivity(ConnectivityResult result) {
    final wasOnline = isOnline.value;
    isOnline.value = result != ConnectivityResult.none;

    Logger.info('Connectivity: ${isOnline.value ? "ONLINE" : "OFFLINE"}',
        tag: 'OfflineSync');

    // If came back online, try to sync
    if (!wasOnline && isOnline.value) {
      syncPendingChanges();
    }
  }

  // Queue a change for offline sync
  Future<void> queueChange(
    String key,
    Map<String, dynamic> data, {
    required SyncCallback callback,
  }) async {
    try {
      pendingChanges[key] = data;
      _syncCallbacks[key] = callback;

      // Save to persistent storage
      await _storage.write('pending_$key', data);

      Logger.info('Change queued: $key', tag: 'OfflineSync');

      // Try to sync immediately if online
      if (isOnline.value) {
        await _syncChange(key);
      }
    } catch (e) {
      Logger.error('Failed to queue change', tag: 'OfflineSync', exception: e);
    }
  }

  // Sync a single change
  Future<bool> _syncChange(String key) async {
    try {
      final callback = _syncCallbacks[key];
      if (callback == null) {
        Logger.warning('No callback for $key', tag: 'OfflineSync');
        return false;
      }

      final success = await callback();

      if (success) {
        pendingChanges.remove(key);
        _syncCallbacks.remove(key);
        await _storage.remove('pending_$key');
        Logger.info('Change synced: $key', tag: 'OfflineSync');
        return true;
      } else {
        Logger.warning('Failed to sync: $key', tag: 'OfflineSync');
        return false;
      }
    } catch (e) {
      Logger.error('Sync error for $key', tag: 'OfflineSync', exception: e);
      return false;
    }
  }

  // Sync all pending changes
  Future<int> syncPendingChanges() async {
    if (!isOnline.value) {
      Logger.warning('Cannot sync: offline', tag: 'OfflineSync');
      return 0;
    }

    Logger.info('Syncing ${pendingChanges.length} pending changes',
        tag: 'OfflineSync');

    int synced = 0;
    final keys = List<String>.from(pendingChanges.keys);

    for (final key in keys) {
      final success = await _syncChange(key);
      if (success) {
        synced++;
      }
    }

    Logger.info('Synced $synced changes', tag: 'OfflineSync');
    return synced;
  }

  // Load pending changes from storage
  Future<void> loadPendingChanges() async {
    try {
      final keys = _storage.getKeys();

      for (final key in keys) {
        if (key.toString().startsWith('pending_')) {
          final data = _storage.read(key);
          if (data != null) {
            final changeKey = key.toString().replaceFirst('pending_', '');
            pendingChanges[changeKey] = data as Map<String, dynamic>;
          }
        }
      }

      Logger.info('Loaded ${pendingChanges.length} pending changes',
          tag: 'OfflineSync');
    } catch (e) {
      Logger.error('Failed to load pending changes', tag: 'OfflineSync',
          exception: e);
    }
  }

  // Clear all pending changes
  Future<void> clearPendingChanges() async {
    try {
      final keys = _storage.getKeys();

      for (final key in keys) {
        if (key.toString().startsWith('pending_')) {
          await _storage.remove(key);
        }
      }

      pendingChanges.clear();
      _syncCallbacks.clear();

      Logger.info('Pending changes cleared', tag: 'OfflineSync');
    } catch (e) {
      Logger.error('Failed to clear pending changes', tag: 'OfflineSync',
          exception: e);
    }
  }

  // Remove a specific pending change
  Future<void> removePendingChange(String key) async {
    try {
      pendingChanges.remove(key);
      _syncCallbacks.remove(key);
      await _storage.remove('pending_$key');

      Logger.info('Pending change removed: $key', tag: 'OfflineSync');
    } catch (e) {
      Logger.error('Failed to remove pending change', tag: 'OfflineSync',
          exception: e);
    }
  }

  // Get pending changes count
  int getPendingChangesCount() {
    return pendingChanges.length;
  }

  // Check if a specific change is pending
  bool isPending(String key) {
    return pendingChanges.containsKey(key);
  }

  @override
  void onClose() {
    _syncCallbacks.clear();
    super.onClose();
  }
}
