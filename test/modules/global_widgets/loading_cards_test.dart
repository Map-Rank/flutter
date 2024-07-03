import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapnrank/app/modules/global_widgets/loading_cards.dart';

void main() {
  testWidgets('LoadingCardWidget displays at least 3 loading images', (WidgetTester tester) async {
    // Load the widget
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LoadingCardWidget(),
        ),
      ),
    );

    // Verify that the GridView.builder contains 4 items
    expect(find.byType(GridView), findsOneWidget);
    expect(find.byType(Container), findsAtLeastNWidgets(3));

    // Verify that each item contains the loading image
    expect(find.byType(Image), findsAtLeastNWidgets(3));
    expect(find.image(AssetImage('assets/images/loading.gif')), findsAtLeastNWidgets(3));
  });
}