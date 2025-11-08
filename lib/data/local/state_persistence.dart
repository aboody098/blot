import 'package:get_storage/get_storage.dart';
import 'package:fire_safety_console/core/constants.dart';
import 'package:fire_safety_console/core/logger.dart';

class StatePersistence {
  static final StatePersistence _instance = StatePersistence._internal();

  late GetStorage _storage;

  StatePersistence._internal();

  factory StatePersistence() {
    return _instance;
  }

  Future<void> initialize() async {
    _storage = GetStorage();
    Logger.info('State persistence initialized', tag: 'StatePersistence');
  }

  // Theme persistence
  String getThemeMode() {
    return _storage.read<String>(Constants.storageKeyTheme) ?? 'system';
  }

  Future<void> saveThemeMode(String mode) async {
    await _storage.write(Constants.storageKeyTheme, mode);
    Logger.debug('Theme saved: $mode', tag: 'StatePersistence');
  }

  // Language persistence
  String getLanguage() {
    return _storage.read<String>(Constants.storageKeyLanguage) ?? 'en';
  }

  Future<void> saveLanguage(String language) async {
    await _storage.write(Constants.storageKeyLanguage, language);
    Logger.debug('Language saved: $language', tag: 'StatePersistence');
  }

  // API Token persistence
  String? getApiToken() {
    return _storage.read<String>(Constants.storageKeyApiToken);
  }

  Future<void> saveApiToken(String token) async {
    await _storage.write(Constants.storageKeyApiToken, token);
    Logger.debug('API token saved', tag: 'StatePersistence');
  }

  Future<void> clearApiToken() async {
    await _storage.remove(Constants.storageKeyApiToken);
    Logger.info('API token cleared', tag: 'StatePersistence');
  }

  // User preferences
  Future<void> saveUserPreference(String key, dynamic value) async {
    await _storage.write('pref_$key', value);
    Logger.debug('User preference saved: $key', tag: 'StatePersistence');
  }

  dynamic getUserPreference(String key, {dynamic defaultValue}) {
    return _storage.read('pref_$key') ?? defaultValue;
  }

  Future<void> removeUserPreference(String key) async {
    await _storage.remove('pref_$key');
  }

  // Settings
  Future<void> saveSettings(String key, dynamic value) async {
    await _storage.write('setting_$key', value);
    Logger.debug('Setting saved: $key', tag: 'StatePersistence');
  }

  dynamic getSetting(String key, {dynamic defaultValue}) {
    return _storage.read('setting_$key') ?? defaultValue;
  }

  // YOLO Configuration
  double getYoloThreshold() {
    return _storage.read<double>('yolo_threshold') ?? 0.5;
  }

  Future<void> saveYoloThreshold(double threshold) async {
    await _storage.write('yolo_threshold', threshold);
    Logger.debug('YOLO threshold saved: $threshold',
        tag: 'StatePersistence');
  }

  Map<String, bool> getEnabledClasses() {
    final data = _storage.read<Map>('enabled_classes');
    if (data == null) return {};
    return Map<String, bool>.from(data);
  }

  Future<void> saveEnabledClasses(Map<String, bool> classes) async {
    await _storage.write('enabled_classes', classes);
    Logger.debug('Enabled classes saved', tag: 'StatePersistence');
  }

  // App state
  Future<void> saveLastRoute(String route) async {
    await _storage.write('last_route', route);
  }

  String? getLastRoute() {
    return _storage.read<String>('last_route');
  }

  Future<void> saveLastUpdateTime(String key, DateTime time) async {
    await _storage.write('last_update_$key', time.toIso8601String());
  }

  DateTime? getLastUpdateTime(String key) {
    final str = _storage.read<String>('last_update_$key');
    if (str == null) return null;
    try {
      return DateTime.parse(str);
    } catch (e) {
      return null;
    }
  }

  // Favorite incidents/cameras
  List<String> getFavoriteIncidents() {
    final data = _storage.read<List>('favorite_incidents');
    return data != null ? List<String>.from(data) : [];
  }

  Future<void> addFavoriteIncident(String id) async {
    final favorites = getFavoriteIncidents();
    if (!favorites.contains(id)) {
      favorites.add(id);
      await _storage.write('favorite_incidents', favorites);
      Logger.debug('Favorite incident added: $id', tag: 'StatePersistence');
    }
  }

  Future<void> removeFavoriteIncident(String id) async {
    final favorites = getFavoriteIncidents();
    favorites.remove(id);
    await _storage.write('favorite_incidents', favorites);
    Logger.debug('Favorite incident removed: $id', tag: 'StatePersistence');
  }

  List<int> getUnreadIncidents() {
    final data = _storage.read<List>('unread_incidents');
    return data != null ? List<int>.from(data) : [];
  }

  Future<void> markIncidentAsRead(int id) async {
    final unread = getUnreadIncidents();
    unread.remove(id);
    await _storage.write('unread_incidents', unread);
  }

  // App statistics
  int getAppOpenCount() {
    return _storage.read<int>('app_open_count') ?? 0;
  }

  Future<void> incrementAppOpenCount() async {
    final count = getAppOpenCount() + 1;
    await _storage.write('app_open_count', count);
  }

  DateTime? getFirstLaunchDate() {
    final str = _storage.read<String>('first_launch_date');
    if (str == null) return null;
    try {
      return DateTime.parse(str);
    } catch (e) {
      return null;
    }
  }

  Future<void> setFirstLaunchDate() async {
    if (getFirstLaunchDate() == null) {
      await _storage.write(
          'first_launch_date', DateTime.now().toIso8601String());
    }
  }

  // Clear all persistent data
  Future<void> clearAll() async {
    await _storage.erase();
    Logger.info('All persistent data cleared', tag: 'StatePersistence');
  }

  // Export/Import settings
  Map<String, dynamic> exportSettings() {
    final settings = <String, dynamic>{};
    final keys = _storage.getKeys();

    for (final key in keys) {
      if (key.toString().startsWith('setting_') ||
          key.toString().startsWith('pref_')) {
        settings[key.toString()] = _storage.read(key);
      }
    }

    Logger.info('Settings exported', tag: 'StatePersistence');
    return settings;
  }

  Future<void> importSettings(Map<String, dynamic> settings) async {
    try {
      for (final entry in settings.entries) {
        await _storage.write(entry.key, entry.value);
      }
      Logger.info('Settings imported', tag: 'StatePersistence');
    } catch (e) {
      Logger.error('Failed to import settings', tag: 'StatePersistence',
          exception: e);
      rethrow;
    }
  }
}
