import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fire_safety_console/presentation/widgets/kpi_card.dart';

void main() {
  group('KPI Card Widget', () {
    testWidgets('KpiCard displays title and value', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KpiCard(
              title: 'Total Incidents',
              value: '47',
              icon: Icons.warning,
            ),
          ),
        ),
      );

      expect(find.text('Total Incidents'), findsOneWidget);
      expect(find.text('47'), findsOneWidget);
      expect(find.byIcon(Icons.warning), findsOneWidget);
    });

    testWidgets('KpiCard displays unit when provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KpiCard(
              title: 'Uptime',
              value: '99.8',
              unit: '%',
              icon: Icons.trending_up,
            ),
          ),
        ),
      );

      expect(find.text('Uptime'), findsOneWidget);
      expect(find.text('99.8'), findsOneWidget);
      expect(find.text('%'), findsOneWidget);
    });

    testWidgets('KpiCard is tappable', (WidgetTester tester) async {
      int tapCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KpiCard(
              title: 'Test',
              value: '10',
              icon: Icons.info,
              onTap: () => tapCount++,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(KpiCard));
      expect(tapCount, 1);
    });

    testWidgets('KpiCard with custom background color',
        (WidgetTester tester) async {
      const customColor = Color(0xFFFF0000);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KpiCard(
              title: 'Test',
              value: '50',
              icon: Icons.check,
              backgroundColor: customColor,
            ),
          ),
        ),
      );

      final card = find.byType(Card);
      expect(card, findsOneWidget);

      final cardWidget = tester.widget<Card>(card);
      expect(cardWidget.color, customColor);
    });

    testWidgets('KpiCard has proper layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KpiCard(
              title: 'Layout Test',
              value: '100',
              icon: Icons.star,
            ),
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(Icon), findsOneWidget);
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('KpiCard renders without error on null callback',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KpiCard(
              title: 'No Tap',
              value: '0',
              icon: Icons.close,
              onTap: null,
            ),
          ),
        ),
      );

      expect(find.byType(KpiCard), findsOneWidget);
      expect(find.text('No Tap'), findsOneWidget);
    });
  });
}
