import 'package:dio/dio.dart';
import 'package:fire_safety_console/core/constants.dart';
import 'package:fire_safety_console/core/env.dart';
import 'package:fire_safety_console/core/logger.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();

  late Dio _dio;

  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: Env.apiBaseUrl,
        connectTimeout: Constants.apiTimeout,
        receiveTimeout: Constants.apiTimeout,
        contentType: 'application/json',
      ),
    );

    // Add logging interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          Logger.debug('→ ${options.method} ${options.path}', tag: 'API');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          Logger.debug('← ${response.statusCode} ${response.requestOptions.path}',
              tag: 'API');
          return handler.next(response);
        },
        onError: (error, handler) {
          Logger.error('✗ ${error.requestOptions.path}: ${error.message}',
              tag: 'API');
          return handler.next(error);
        },
      ),
    );
  }

  factory ApiClient() {
    return _instance;
  }

  // KPI endpoints
  Future<Map<String, dynamic>> getKpi() async {
    try {
      final response = await _dio.get('/api/kpi');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      Logger.error('Failed to fetch KPI', tag: 'ApiClient', exception: e);
      rethrow;
    }
  }

  // Incident endpoints
  Future<List<Map<String, dynamic>>> getIncidents({
    int? limit,
    int? offset,
    String? status,
    String? severity,
  }) async {
    try {
      final params = <String, dynamic>{
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
        if (status != null) 'status': status,
        if (severity != null) 'severity': severity,
      };
      final response = await _dio.get('/api/incidents', queryParameters: params);
      return List<Map<String, dynamic>>.from(response.data as List);
    } on DioException catch (e) {
      Logger.error('Failed to fetch incidents', tag: 'ApiClient', exception: e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getIncident(String id) async {
    try {
      final response = await _dio.get('/api/incidents/$id');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      Logger.error('Failed to fetch incident $id', tag: 'ApiClient', exception: e);
      rethrow;
    }
  }

  Future<void> acknowledgeIncident(String id) async {
    try {
      await _dio.post('/api/incidents/$id/ack');
      Logger.info('Incident $id acknowledged', tag: 'ApiClient');
    } on DioException catch (e) {
      Logger.error('Failed to acknowledge incident', tag: 'ApiClient',
          exception: e);
      rethrow;
    }
  }

  Future<void> escalateIncident(String id) async {
    try {
      await _dio.post('/api/incidents/$id/escalate');
      Logger.info('Incident $id escalated', tag: 'ApiClient');
    } on DioException catch (e) {
      Logger.error('Failed to escalate incident', tag: 'ApiClient', exception: e);
      rethrow;
    }
  }

  Future<void> closeIncident(String id) async {
    try {
      await _dio.post('/api/incidents/$id/close');
      Logger.info('Incident $id closed', tag: 'ApiClient');
    } on DioException catch (e) {
      Logger.error('Failed to close incident', tag: 'ApiClient', exception: e);
      rethrow;
    }
  }

  // Camera endpoints
  Future<List<Map<String, dynamic>>> getCameras() async {
    try {
      final response = await _dio.get('/api/cameras');
      return List<Map<String, dynamic>>.from(response.data as List);
    } on DioException catch (e) {
      Logger.error('Failed to fetch cameras', tag: 'ApiClient', exception: e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> addCamera(Map<String, dynamic> camera) async {
    try {
      final response = await _dio.post('/api/cameras', data: camera);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      Logger.error('Failed to add camera', tag: 'ApiClient', exception: e);
      rethrow;
    }
  }

  Future<void> updateCamera(int id, Map<String, dynamic> camera) async {
    try {
      await _dio.put('/api/cameras/$id', data: camera);
      Logger.info('Camera $id updated', tag: 'ApiClient');
    } on DioException catch (e) {
      Logger.error('Failed to update camera', tag: 'ApiClient', exception: e);
      rethrow;
    }
  }

  Future<void> deleteCamera(int id) async {
    try {
      await _dio.delete('/api/cameras/$id');
      Logger.info('Camera $id deleted', tag: 'ApiClient');
    } on DioException catch (e) {
      Logger.error('Failed to delete camera', tag: 'ApiClient', exception: e);
      rethrow;
    }
  }

  // Sensor endpoints
  Future<List<Map<String, dynamic>>> getSensors() async {
    try {
      final response = await _dio.get('/api/sensors');
      return List<Map<String, dynamic>>.from(response.data as List);
    } on DioException catch (e) {
      Logger.error('Failed to fetch sensors', tag: 'ApiClient', exception: e);
      rethrow;
    }
  }

  // Service health endpoint
  Future<Map<String, dynamic>> getServiceHealth() async {
    try {
      final response = await _dio.get('/api/service/health');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      Logger.error('Failed to fetch service health', tag: 'ApiClient', exception: e);
      rethrow;
    }
  }

  // Training endpoints
  Future<Map<String, dynamic>> startTraining(
      Map<String, dynamic> trainingConfig) async {
    try {
      final response = await _dio.post('/api/training/start', data: trainingConfig);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      Logger.error('Failed to start training', tag: 'ApiClient', exception: e);
      rethrow;
    }
  }

  Future<void> promoteTrainingModel(String trainingId) async {
    try {
      await _dio.post('/api/training/$trainingId/promote');
      Logger.info('Training model $trainingId promoted', tag: 'ApiClient');
    } on DioException catch (e) {
      Logger.error('Failed to promote model', tag: 'ApiClient', exception: e);
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getTrainingRuns() async {
    try {
      final response = await _dio.get('/api/training');
      return List<Map<String, dynamic>>.from(response.data as List);
    } on DioException catch (e) {
      Logger.error('Failed to fetch training runs', tag: 'ApiClient', exception: e);
      rethrow;
    }
  }

  // Analytics endpoints
  Future<Map<String, dynamic>> getAnalytics({DateTime? from, DateTime? to}) async {
    try {
      final params = <String, dynamic>{
        if (from != null) 'from': from.toIso8601String(),
        if (to != null) 'to': to.toIso8601String(),
      };
      final response = await _dio.get('/api/analytics', queryParameters: params);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      Logger.error('Failed to fetch analytics', tag: 'ApiClient', exception: e);
      rethrow;
    }
  }
}
