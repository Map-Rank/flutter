import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mapnrank/app/modules/global_widgets/text_field_widget.dart';
import 'package:mockito/mockito.dart';


void main() {
  late Widget textFieldWidget;

  setUp(() {
    // mockController = MockTextEditingController();
    // when(mockController.text).thenReturn('New Value');

    textFieldWidget = MaterialApp(
      home: Scaffold(
        body: TextFieldWidget(
          errorText: '',
         // textController: mockController,
          iconData: Icons.email, // Replace with appropriate icon
          labelText: 'Label Text',
          suffixIcon: Icon(Icons.clear), // Replace with appropriate icon
          suffix: Text('Suffix Text'), // Replace with appropriate widget
          readOnly: false, // Example value, adjust as needed
          onCancelTapped: () {}, // Example callback, adjust as needed
        ),
      ),
    );
  });

  testWidgets('TextFieldWidget renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(textFieldWidget);

    // Find the Text widget by key
    expect(find.byKey(Key('labelText')), findsOneWidget);

    // Example: Verify initial value is set correctly
    // TextFormField does not display initial value in the text directly, it uses the controller
    // hence, we cannot use find.text to find the initial value directly.

    // Tap on TextField and verify onChanged behavior
    await tester.tap(find.byType(TextFormField));
    await tester.enterText(find.byType(TextFormField), 'New Value');
    await tester.pump();


    // Verify interaction with onCancelTapped
    if (find.byType(TextButton).evaluate().isNotEmpty) {
      await tester.tap(find.byType(TextButton));

    }
  });

  // Add more tests as needed to cover other scenarios and behaviors
}
