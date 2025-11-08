import 'package:fire_safety_console/core/logger.dart';
import 'package:fire_safety_console/data/models/training_run.dart';
import 'package:fire_safety_console/data/services/api_client.dart';

class TrainingRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<TrainingRun>> getTrainingRuns() async {
    try {
      final data = await _apiClient.getTrainingRuns();
      return data.map((json) => TrainingRun.fromJson(json)).toList();
    } catch (e) {
      Logger.error('Failed to get training runs', tag: 'TrainingRepository',
          exception: e);
      rethrow;
    }
  }

  Future<TrainingRun> startTraining(Map<String, dynamic> config) async {
    try {
      final data = await _apiClient.startTraining(config);
      return TrainingRun.fromJson(data);
    } catch (e) {
      Logger.error('Failed to start training', tag: 'TrainingRepository',
          exception: e);
      rethrow;
    }
  }

  Future<void> promoteModel(String trainingId) async {
    try {
      await _apiClient.promoteTrainingModel(trainingId);
    } catch (e) {
      Logger.error('Failed to promote model', tag: 'TrainingRepository',
          exception: e);
      rethrow;
    }
  }
}
