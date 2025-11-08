/// Environment configuration
class Env {
  static late String _apiBaseUrl;
  static late String _wsBaseUrl;
  static late bool _isDevelopment;

  static void init() {
    // Configure based on environment
    _isDevelopment = true;
    _apiBaseUrl = 'http://localhost:8000';
    _wsBaseUrl = 'ws://localhost:8000';
  }

  static String get apiBaseUrl => _apiBaseUrl;
  static String get wsBaseUrl => _wsBaseUrl;
  static bool get isDevelopment => _isDevelopment;

  // API endpoints
  static String get kpiEndpoint => '$apiBaseUrl/api/kpi';
  static String get incidentsEndpoint => '$apiBaseUrl/api/incidents';
  static String get camerasEndpoint => '$apiBaseUrl/api/cameras';
  static String get healthEndpoint => '$apiBaseUrl/api/service/health';
  static String get trainingEndpoint => '$apiBaseUrl/api/training';
  static String get sensorsEndpoint => '$apiBaseUrl/api/sensors';

  // WebSocket endpoints
  static String get wsEndpoint => '$wsBaseUrl/ws';

  static String incidentDetailsEndpoint(String id) =>
      '$apiBaseUrl/api/incidents/$id';

  static String ackIncidentEndpoint(String id) =>
      '$apiBaseUrl/api/incidents/$id/ack';

  static String escalateIncidentEndpoint(String id) =>
      '$apiBaseUrl/api/incidents/$id/escalate';

  static String closeIncidentEndpoint(String id) =>
      '$apiBaseUrl/api/incidents/$id/close';

  static String promoteTrainingEndpoint(String id) =>
      '$apiBaseUrl/api/training/$id/promote';
}
