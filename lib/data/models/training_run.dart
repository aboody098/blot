import 'package:equatable/equatable.dart';

class TrainingRun extends Equatable {
  final String id;
  final String name;
  final String status; // QUEUED, RUNNING, COMPLETED, FAILED
  final int epoch;
  final int totalEpochs;
  final double trainingLoss;
  final double validationLoss;
  final double accuracy;
  final double mAP; // Mean Average Precision
  final DateTime startedAt;
  final DateTime? completedAt;
  final String? bestModelCheckpoint;
  final double? confidence;
  final String? model; // Model type (YOLOv8, etc.)

  const TrainingRun({
    required this.id,
    required this.name,
    required this.status,
    required this.epoch,
    required this.totalEpochs,
    required this.trainingLoss,
    required this.validationLoss,
    required this.accuracy,
    required this.mAP,
    required this.startedAt,
    this.completedAt,
    this.bestModelCheckpoint,
    this.confidence,
    this.model,
  });

  factory TrainingRun.fromJson(Map<String, dynamic> json) {
    return TrainingRun(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      status: json['status'] ?? 'QUEUED',
      epoch: json['epoch'] ?? 0,
      totalEpochs: json['total_epochs'] ?? 100,
      trainingLoss: (json['training_loss'] ?? 0.0).toDouble(),
      validationLoss: (json['validation_loss'] ?? 0.0).toDouble(),
      accuracy: (json['accuracy'] ?? 0.0).toDouble(),
      mAP: (json['mAP'] ?? 0.0).toDouble(),
      startedAt: json['started_at'] != null
          ? DateTime.parse(json['started_at'])
          : DateTime.now(),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
      bestModelCheckpoint: json['best_model_checkpoint'],
      confidence: json['confidence']?.toDouble(),
      model: json['model'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'status': status,
        'epoch': epoch,
        'total_epochs': totalEpochs,
        'training_loss': trainingLoss,
        'validation_loss': validationLoss,
        'accuracy': accuracy,
        'mAP': mAP,
        'started_at': startedAt.toIso8601String(),
        'completed_at': completedAt?.toIso8601String(),
        'best_model_checkpoint': bestModelCheckpoint,
        'confidence': confidence,
        'model': model,
      };

  double get progress => epoch / totalEpochs;

  TrainingRun copyWith({
    String? id,
    String? name,
    String? status,
    int? epoch,
    int? totalEpochs,
    double? trainingLoss,
    double? validationLoss,
    double? accuracy,
    double? mAP,
    DateTime? startedAt,
    DateTime? completedAt,
    String? bestModelCheckpoint,
    double? confidence,
    String? model,
  }) {
    return TrainingRun(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      epoch: epoch ?? this.epoch,
      totalEpochs: totalEpochs ?? this.totalEpochs,
      trainingLoss: trainingLoss ?? this.trainingLoss,
      validationLoss: validationLoss ?? this.validationLoss,
      accuracy: accuracy ?? this.accuracy,
      mAP: mAP ?? this.mAP,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      bestModelCheckpoint: bestModelCheckpoint ?? this.bestModelCheckpoint,
      confidence: confidence ?? this.confidence,
      model: model ?? this.model,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        status,
        epoch,
        totalEpochs,
        trainingLoss,
        validationLoss,
        accuracy,
        mAP,
        startedAt,
        completedAt,
        bestModelCheckpoint,
        confidence,
        model,
      ];
}
