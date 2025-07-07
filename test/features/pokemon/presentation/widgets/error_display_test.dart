import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_pokemon_clean_arc/features/pokemon/presentation/widgets/error_display.dart';

void main() {
  group('ErrorDisplay Widget Tests', () {
    const tMessage = 'Something went wrong';

    testWidgets('should display error message', (WidgetTester tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorDisplay(
              message: tMessage,
            ),
          ),
        ),
      );

      // assert
      expect(find.text('Oops! Something went wrong'), findsOneWidget);
      expect(find.text(tMessage), findsOneWidget);
    });

    testWidgets('should display retry button', (WidgetTester tester) async {
      // arrange & act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorDisplay(
              message: tMessage,
              onRetry: () {},
            ),
          ),
        ),
      );

      // assert
      expect(find.text('Try Again'), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('should call onRetry when retry button is tapped',
        (WidgetTester tester) async {
      // arrange
      bool wasRetryPressed = false;
      void onRetry() {
        wasRetryPressed = true;
      }

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorDisplay(
              message: tMessage,
              onRetry: onRetry,
            ),
          ),
        ),
      );

      // act
      await tester.tap(find.text('Try Again'));
      await tester.pumpAndSettle();

      // assert
      expect(wasRetryPressed, isTrue);
    });

    testWidgets('should not display retry button when onRetry is null',
        (WidgetTester tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorDisplay(
              message: tMessage,
            ),
          ),
        ),
      );

      // assert
      expect(find.text('Try Again'), findsNothing);
      expect(find.byIcon(Icons.refresh), findsNothing);
    });

    testWidgets('should display error icon', (WidgetTester tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorDisplay(
              message: tMessage,
            ),
          ),
        ),
      );

      // assert
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('should display custom icon when provided',
        (WidgetTester tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorDisplay(
              message: tMessage,
              icon: Icons.wifi_off,
            ),
          ),
        ),
      );

      // assert
      expect(find.byIcon(Icons.wifi_off), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsNothing);
    });
  });
}
