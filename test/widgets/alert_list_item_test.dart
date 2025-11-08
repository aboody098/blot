import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fire_safety_console/presentation/widgets/alert_list_item.dart';
import 'package:fire_safety_console/data/models/incident.dart';
import 'package:fire_safety_console/core/constants.dart';

void main() {
  group('Alert List Item Widget', () {
    final testIncident = Incident(
      id: 'INC-001',
      title: 'Fire Detected',
      description: 'Fire detected in Zone A',
      severity: Constants.severityCritical,
      status: Constants.statusOpen,
      detectionClass: 'Fire',
      cameraId: 1,
      confidence: 0.95,
      createdAt: DateTime.now(),
    );

    testWidgets('AlertListItem displays incident information',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AlertListItem(incident: testIncident),
          ),
        ),
      );

      expect(find.text('Fire Detected'), findsOneWidget);
      expect(find.text('Fire detected in Zone A'), findsOneWidget);
      expect(find.text(Constants.severityCritical), findsOneWidget);
    });

    testWidgets('AlertListItem shows confidence percentage',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AlertListItem(incident: testIncident),
          ),
        ),
      );

      expect(find.text('Conf: 95%'), findsOneWidget);
    });

    testWidgets('AlertListItem displays detection class',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AlertListItem(incident: testIncident),
          ),
        ),
      );

      expect(find.text('Fire'), findsOneWidget);
    });

    testWidgets('AlertListItem is tappable', (WidgetTester tester) async {
      int tapCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AlertListItem(
              incident: testIncident,
              onTap: () => tapCount++,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(AlertListItem));
      expect(tapCount, 1);
    });

    testWidgets('AlertListItem shows different severity colors',
        (WidgetTester tester) async {
      final minorIncident = testIncident.copyWith(
        severity: Constants.severityMinor,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AlertListItem(incident: minorIncident),
          ),
        ),
      );

      expect(find.text(Constants.severityMinor), findsOneWidget);
    });

    testWidgets('AlertListItem with major severity',
        (WidgetTester tester) async {
      final majorIncident = testIncident.copyWith(
        severity: Constants.severityMajor,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AlertListItem(incident: majorIncident),
          ),
        ),
      );

      expect(find.text(Constants.severityMajor), findsOneWidget);
    });

    testWidgets('AlertListItem renders with navigation arrow',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AlertListItem(incident: testIncident),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);
    });

    testWidgets('AlertListItem displays multiple items correctly',
        (WidgetTester tester) async {
      final incidents = [
        testIncident,
        testIncident.copyWith(id: 'INC-002', title: 'Smoke Alert'),
        testIncident.copyWith(id: 'INC-003', title: 'Gas Leak'),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: incidents
                  .map((incident) => AlertListItem(incident: incident))
                  .toList(),
            ),
          ),
        ),
      );

      expect(find.byType(AlertListItem), findsNWidgets(3));
      expect(find.text('Fire Detected'), findsOneWidget);
      expect(find.text('Smoke Alert'), findsOneWidget);
      expect(find.text('Gas Leak'), findsOneWidget);
    });
  });
}
