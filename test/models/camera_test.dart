import 'package:flutter_test/flutter_test.dart';
import 'package:fire_safety_console/data/models/camera.dart';
import 'package:fire_safety_console/core/constants.dart';

void main() {
  group('Camera Model', () {
    final cameraData = {
      'id': 1,
      'name': 'Main Gate',
      'location': 'Zone A Entry',
      'ip_address': '192.168.1.100',
      'port': 8080,
      'stream_url': 'rtsp://192.168.1.100:8080/stream',
      'status': Constants.cameraStatusOnline,
      'latitude': 25.3548,
      'longitude': 55.3643,
      'recording_enabled': true,
      'resolution_width': 1920,
      'resolution_height': 1080,
      'frame_rate': 30.0,
    };

    test('Camera.fromJson creates camera correctly', () {
      final camera = Camera.fromJson(cameraData);

      expect(camera.id, 1);
      expect(camera.name, 'Main Gate');
      expect(camera.status, Constants.cameraStatusOnline);
      expect(camera.ipAddress, '192.168.1.100');
      expect(camera.recordingEnabled, true);
    });

    test('Camera.toJson serializes correctly', () {
      final camera = Camera.fromJson(cameraData);
      final json = camera.toJson();

      expect(json['id'], 1);
      expect(json['name'], 'Main Gate');
      expect(json['status'], Constants.cameraStatusOnline);
      expect(json['ip_address'], '192.168.1.100');
    });

    test('Camera.copyWith updates fields correctly', () {
      final camera = Camera.fromJson(cameraData);
      final updated = camera.copyWith(
        status: Constants.cameraStatusOffline,
        name: 'Back Gate',
      );

      expect(updated.id, camera.id);
      expect(updated.status, Constants.cameraStatusOffline);
      expect(updated.name, 'Back Gate');
      expect(updated.ipAddress, camera.ipAddress);
    });

    test('Camera with minimal data', () {
      final minimalData = {
        'id': 2,
        'name': 'Test Camera',
        'location': 'Test',
        'ip_address': '192.168.1.101',
        'port': 8080,
        'stream_url': 'rtsp://test',
        'status': Constants.cameraStatusMaintenance,
        'latitude': 0.0,
        'longitude': 0.0,
      };

      final camera = Camera.fromJson(minimalData);

      expect(camera.id, 2);
      expect(camera.resolutionWidth, null);
      expect(camera.frameRate, null);
      expect(camera.lastSeen, null);
    });

    test('Camera equality works correctly', () {
      final camera1 = Camera.fromJson(cameraData);
      final camera2 = Camera.fromJson(cameraData);

      expect(camera1, camera2);
    });
  });
}
