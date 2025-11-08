import 'package:equatable/equatable.dart';

class Incident extends Equatable {
  final String id;
  final String title;
  final String description;
  final String severity; // CRITICAL, MAJOR, MINOR
  final String status; // OPEN, ACKNOWLEDGED, CLOSED, ESCALATED
  final String detectionClass; // Fire, Smoke, Gas Leak, PPE, etc.
  final int cameraId;
  final double confidence;
  final DateTime createdAt;
  final DateTime? acknowledgedAt;
  final DateTime? closedAt;
  final List<String> evidenceUrls;
  final String? location;
  final int? affectedPersons;

  const Incident({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.status,
    required this.detectionClass,
    required this.cameraId,
    required this.confidence,
    required this.createdAt,
    this.acknowledgedAt,
    this.closedAt,
    this.evidenceUrls = const [],
    this.location,
    this.affectedPersons,
  });

  factory Incident.fromJson(Map<String, dynamic> json) {
    return Incident(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      severity: json['severity'] ?? 'MINOR',
      status: json['status'] ?? 'OPEN',
      detectionClass: json['detection_class'] ?? '',
      cameraId: json['camera_id'] ?? 0,
      confidence: (json['confidence'] ?? 0.0).toDouble(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      acknowledgedAt: json['acknowledged_at'] != null
          ? DateTime.parse(json['acknowledged_at'])
          : null,
      closedAt:
          json['closed_at'] != null ? DateTime.parse(json['closed_at']) : null,
      evidenceUrls: List<String>.from(json['evidence_urls'] ?? []),
      location: json['location'],
      affectedPersons: json['affected_persons'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'severity': severity,
        'status': status,
        'detection_class': detectionClass,
        'camera_id': cameraId,
        'confidence': confidence,
        'created_at': createdAt.toIso8601String(),
        'acknowledged_at': acknowledgedAt?.toIso8601String(),
        'closed_at': closedAt?.toIso8601String(),
        'evidence_urls': evidenceUrls,
        'location': location,
        'affected_persons': affectedPersons,
      };

  Incident copyWith({
    String? id,
    String? title,
    String? description,
    String? severity,
    String? status,
    String? detectionClass,
    int? cameraId,
    double? confidence,
    DateTime? createdAt,
    DateTime? acknowledgedAt,
    DateTime? closedAt,
    List<String>? evidenceUrls,
    String? location,
    int? affectedPersons,
  }) {
    return Incident(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      severity: severity ?? this.severity,
      status: status ?? this.status,
      detectionClass: detectionClass ?? this.detectionClass,
      cameraId: cameraId ?? this.cameraId,
      confidence: confidence ?? this.confidence,
      createdAt: createdAt ?? this.createdAt,
      acknowledgedAt: acknowledgedAt ?? this.acknowledgedAt,
      closedAt: closedAt ?? this.closedAt,
      evidenceUrls: evidenceUrls ?? this.evidenceUrls,
      location: location ?? this.location,
      affectedPersons: affectedPersons ?? this.affectedPersons,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        severity,
        status,
        detectionClass,
        cameraId,
        confidence,
        createdAt,
        acknowledgedAt,
        closedAt,
        evidenceUrls,
        location,
        affectedPersons,
      ];
}
