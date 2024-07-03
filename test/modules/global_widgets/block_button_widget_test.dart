import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mapnrank/app/modules/global_widgets/block_button_widget.dart';

void main() {
  // Helper function to wrap the widget with necessary dependencies
  Widget createWidgetForTesting({required Widget child}) {
    return GetMaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }

  testWidgets('BlockButtonWidget displays text', (WidgetTester tester) async {
    // Define a key to find the button later
    final buttonKey = Key('blockButton');

    // Create the widget by wrapping it with MaterialApp and Scaffold
    await tester.pumpWidget(createWidgetForTesting(
      child: BlockButtonWidget(
        key: buttonKey,
        color: Colors.blue,
        text: Text('Test Button'),
        onPressed: () {},
      ),
    ));

    // Verify if the button is displayed with the correct text
    expect(find.text('Test Button'), findsOneWidget);
  });

  testWidgets('BlockButtonWidget onPressed callback is triggered', (WidgetTester tester) async {
    bool pressed = false;

    await tester.pumpWidget(createWidgetForTesting(
      child: BlockButtonWidget(
        color: Colors.blue,
        text: Text('Test Button'),
        onPressed: () {
          pressed = true;
        },
      ),
    ));

    // Tap the button and trigger a frame
    await tester.tap(find.byType(BlockButtonWidget));
    await tester.pump();

    // Verify if the onPressed callback is triggered
    expect(pressed, isTrue);
  });

  testWidgets('BlockButtonWidget has correct color', (WidgetTester tester) async {
    final buttonKey = Key('blockButton');

    await tester.pumpWidget(createWidgetForTesting(
      child: BlockButtonWidget(
        key: buttonKey,
        color: Colors.blue,
        text: Text('Test Button'),
        onPressed: () {},
      ),
    ));

    // Verify if the button has the correct color
    final materialButton = tester.widget<MaterialButton>(find.descendant(
      of: find.byKey(buttonKey),
      matching: find.byType(MaterialButton),
    ));
    expect(materialButton.color, Colors.blue);
  });

  testWidgets('BlockButtonWidget is disabled', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(
      child: BlockButtonWidget(
        color: Colors.blue,
        text: Text('Test Button'),
        onPressed: null, // Button is disabled if onPressed is null
      ),
    ));

    // Verify if the button is disabled
    final materialButton = tester.widget<MaterialButton>(find.descendant(
      of: find.byType(BlockButtonWidget),
      matching: find.byType(MaterialButton),
    ));
    expect(materialButton.onPressed, isNull);
  });
}
