import 'package:flutter_test/flutter_test.dart';
import 'package:fire_safety_console/data/models/incident.dart';
import 'package:fire_safety_console/core/constants.dart';

void main() {
  group('Incident Model', () {
    final now = DateTime.now();
    final incidentData = {
      'id': 'INC-001',
      'title': 'Fire Detected',
      'description': 'Fire in Zone A',
      'severity': Constants.severityCritical,
      'status': Constants.statusOpen,
      'detection_class': 'Fire',
      'camera_id': 1,
      'confidence': 0.95,
      'created_at': now.toIso8601String(),
      'location': 'Zone A',
      'affected_persons': 5,
    };

    test('Incident.fromJson creates incident correctly', () {
      final incident = Incident.fromJson(incidentData);

      expect(incident.id, 'INC-001');
      expect(incident.title, 'Fire Detected');
      expect(incident.severity, Constants.severityCritical);
      expect(incident.confidence, 0.95);
      expect(incident.location, 'Zone A');
      expect(incident.affectedPersons, 5);
    });

    test('Incident.toJson serializes correctly', () {
      final incident = Incident.fromJson(incidentData);
      final json = incident.toJson();

      expect(json['id'], 'INC-001');
      expect(json['title'], 'Fire Detected');
      expect(json['severity'], Constants.severityCritical);
      expect(json['confidence'], 0.95);
    });

    test('Incident.copyWith creates new instance with updated fields', () {
      final incident = Incident.fromJson(incidentData);
      final updated = incident.copyWith(
        status: Constants.statusAcknowledged,
        title: 'Updated Title',
      );

      expect(updated.id, incident.id);
      expect(updated.status, Constants.statusAcknowledged);
      expect(updated.title, 'Updated Title');
      expect(updated.severity, incident.severity);
    });

    test('Incident equality works correctly', () {
      final incident1 = Incident.fromJson(incidentData);
      final incident2 = Incident.fromJson(incidentData);

      expect(incident1, incident2);
    });

    test('Incident handles missing optional fields', () {
      final minimalData = {
        'id': 'INC-002',
        'title': 'Test',
        'description': 'Test description',
        'severity': Constants.severityMinor,
        'status': Constants.statusOpen,
        'detection_class': 'Test',
        'camera_id': 1,
        'confidence': 0.8,
        'created_at': now.toIso8601String(),
      };

      final incident = Incident.fromJson(minimalData);

      expect(incident.id, 'INC-002');
      expect(incident.location, null);
      expect(incident.affectedPersons, null);
      expect(incident.acknowledgedAt, null);
    });

    test('Incident with evidence URLs', () {
      final dataWithEvidence = {
        ...incidentData,
        'evidence_urls': ['https://example.com/image1.jpg', 'https://example.com/image2.jpg'],
      };

      final incident = Incident.fromJson(dataWithEvidence);

      expect(incident.evidenceUrls.length, 2);
      expect(incident.evidenceUrls[0], 'https://example.com/image1.jpg');
    });
  });
}
