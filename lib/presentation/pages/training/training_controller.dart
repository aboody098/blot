import 'package:get/get.dart';
import 'package:fire_safety_console/core/mock_data.dart';
import 'package:fire_safety_console/data/models/training_run.dart';
import 'package:fire_safety_console/data/repositories/training_repository.dart';
import 'package:fire_safety_console/data/services/websocket_service.dart';

class TrainingController extends GetxController {
  final TrainingRepository _trainingRepo = Get.find();
  final WebSocketService _wsService = Get.find();

  // Observable state
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // Data observables
  final trainingRuns = <TrainingRun>[].obs;

  // New training form observables
  final isStartingTraining = false.obs;
  final newTrainingName = ''.obs;
  final selectedModel = 'YOLOv8'.obs;
  final totalEpochs = 100.obs;

  final availableModels = ['YOLOv8', 'YOLOv7', 'YOLOv5'];

  @override
  void onInit() {
    super.onInit();
    _loadTrainingRuns();
    _setupWebSocketListeners();
  }

  @override
  void onClose() {
    // Clean up listeners if needed
    super.onClose();
  }

  Future<void> _loadTrainingRuns() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      // Load training runs from repository or mock data
      trainingRuns.value = MockData.getTrainingRuns();

      // In production, would call:
      // trainingRuns.value = await _trainingRepo.getAllTrainingRuns();

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = 'Failed to load training runs: $e';
    }
  }

  void _setupWebSocketListeners() {
    // Listen for real-time training updates
    _wsService.messages.listen((message) {
      _handleWebSocketMessage(message);
    });
  }

  void _handleWebSocketMessage(Map<String, dynamic> message) {
    final type = message['type'] as String?;

    if (type == 'TrainingProgress') {
      try {
        final trainingData = message['data'] as Map<String, dynamic>;
        final trainingId = trainingData['id'] as String;

        // Update training run in list
        final index = trainingRuns.indexWhere((t) => t.id == trainingId);
        if (index != -1) {
          trainingRuns[index] = TrainingRun.fromJson(trainingData);
        }
      } catch (e) {
        print('Error handling training progress: $e');
      }
    }
  }

  Future<void> startNewTraining() async {
    if (newTrainingName.value.isEmpty || isStartingTraining.value) return;

    try {
      isStartingTraining.value = true;

      // In production, would call:
      // await _trainingRepo.startTraining(
      //   name: newTrainingName.value,
      //   model: selectedModel.value,
      //   epochs: totalEpochs.value,
      // );

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Create new training run
      final newRun = TrainingRun(
        id: 'TRAIN-${DateTime.now().millisecondsSinceEpoch}',
        name: newTrainingName.value,
        status: 'QUEUED',
        epoch: 0,
        totalEpochs: totalEpochs.value,
        trainingLoss: 0.0,
        validationLoss: 0.0,
        accuracy: 0.0,
        mAP: 0.0,
        startedAt: DateTime.now(),
        model: selectedModel.value,
      );

      trainingRuns.insert(0, newRun);

      Get.snackbar(
        'Success',
        'Training run started successfully',
        snackPosition: SnackPosition.BOTTOM,
      );

      // Reset form
      newTrainingName.value = '';
      totalEpochs.value = 100;

      isStartingTraining.value = false;
    } catch (e) {
      isStartingTraining.value = false;
      Get.snackbar(
        'Error',
        'Failed to start training: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> stopTraining(String trainingId) async {
    try {
      // In production, would call:
      // await _trainingRepo.stopTraining(trainingId);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Update training run status
      final index = trainingRuns.indexWhere((t) => t.id == trainingId);
      if (index != -1) {
        trainingRuns[index] = trainingRuns[index].copyWith(
          status: 'STOPPED',
        );
      }

      Get.snackbar(
        'Success',
        'Training run stopped',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to stop training: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> deleteTraining(String trainingId) async {
    try {
      // In production, would call:
      // await _trainingRepo.deleteTraining(trainingId);

      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));

      // Remove from list
      trainingRuns.removeWhere((t) => t.id == trainingId);

      Get.snackbar(
        'Success',
        'Training run deleted',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete training: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> refreshTrainingRuns() async {
    await _loadTrainingRuns();
  }

  int get runningCount =>
      trainingRuns.where((t) => t.status == 'RUNNING').length;

  int get completedCount =>
      trainingRuns.where((t) => t.status == 'COMPLETED').length;

  int get queuedCount =>
      trainingRuns.where((t) => t.status == 'QUEUED').length;
}
