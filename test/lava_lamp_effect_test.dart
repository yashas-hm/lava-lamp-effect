import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lava_lamp_effect/lava_lamp_effect.dart';

void main() {
  group('LavaLampEffect Widget Tests', () {
    testWidgets('LavaLampEffect can be created with required parameters',
        (WidgetTester tester) async {
      // Build the widget with only required parameters
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: LavaLampEffect(
                size: const Size(200, 300),
              ),
            ),
          ),
        ),
      );

      // Verify the widget is created
      expect(find.byType(LavaLampEffect), findsOneWidget);
      
      // Pump a few frames to ensure animation works
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('LavaLampEffect can be customized with optional parameters',
        (WidgetTester tester) async {
      // Define custom parameters
      const customColor = Colors.purple;
      const customLavaCount = 6;
      const customSpeed = 2;
      const customRepeatDuration = Duration(seconds: 5);

      // Build the widget with custom parameters
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: LavaLampEffect(
                size: const Size(200, 300),
                color: customColor,
                lavaCount: customLavaCount,
                speed: customSpeed,
                repeatDuration: customRepeatDuration,
              ),
            ),
          ),
        ),
      );

      // Verify the widget is created
      expect(find.byType(LavaLampEffect), findsOneWidget);
      
      // Pump a few frames to ensure animation works with custom parameters
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('LavaLampEffect renders CustomPaint with LavaPainter',
        (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: LavaLampEffect(
                size: const Size(200, 300),
              ),
            ),
          ),
        ),
      );

      // Verify CustomPaint is used for rendering
      expect(find.byType(CustomPainter), findsOneWidget);
    });

    testWidgets('LavaLampEffect disposes animation controller properly',
        (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: LavaLampEffect(
                size: const Size(200, 300),
              ),
            ),
          ),
        ),
      );

      // Verify the widget is created
      expect(find.byType(LavaLampEffect), findsOneWidget);
      
      // Rebuild with a different widget to trigger dispose
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text('No LavaLampEffect'),
            ),
          ),
        ),
      );
      
      // If dispose doesn't work properly, this would likely cause an error
      // during the test run, so reaching this point means dispose worked
      expect(find.byType(LavaLampEffect), findsNothing);
      expect(find.text('No LavaLampEffect'), findsOneWidget);
    });

    testWidgets('LavaLampEffect handles size changes',
        (WidgetTester tester) async {
      // Build the widget with initial size
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 200,
                height: 300,
                child: LavaLampEffect(
                  size: const Size(200, 300),
                ),
              ),
            ),
          ),
        ),
      );

      // Verify the widget is created with initial size
      expect(find.byType(LavaLampEffect), findsOneWidget);
      
      // Change the size
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                height: 400,
                child: LavaLampEffect(
                  size: const Size(300, 400),
                ),
              ),
            ),
          ),
        ),
      );
      
      // Pump a few frames to ensure animation works with new size
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      
      // If size change handling doesn't work properly, this would likely cause an error
      // during the test run, so reaching this point means size change handling worked
      expect(find.byType(LavaLampEffect), findsOneWidget);
    });
  });
}
