import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mapnrank/app/modules/community/widgets/comment_loading_widget.dart';
import 'package:mapnrank/color_constants.dart';
 //Adjust the import path based on your project structure

void main() {
  testWidgets('CommentLoadingWidget displays correctly', (WidgetTester tester) async {
    // Build the widget and trigger a frame
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: CommentLoadingWidget(),
        ),
      ),
    );

    // Verify the presence of LinearProgressIndicator
    expect(find.byType(LinearProgressIndicator), findsOneWidget);

    // Verify the color of the LinearProgressIndicator
    final linearProgressIndicator = tester.widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator));
    expect(linearProgressIndicator.valueColor, isInstanceOf<AlwaysStoppedAnimation<Color>>());
    expect((linearProgressIndicator.valueColor as AlwaysStoppedAnimation<Color>).value, equals(interfaceColor));
  });

  testWidgets('CommentLoadingWidget dimensions are correct', (WidgetTester tester) async {
    // Build the widget and trigger a frame
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: CommentLoadingWidget(),
        ),
      ),
    );

    // Verify the dimensions of the Container
    final container = tester.widget<Container>(find.byKey(Key('commentContainer')));

    // Ensure the BoxDecoration is correctly applied
    expect(container.decoration, isInstanceOf<Decoration>());
    expect((container.decoration as BoxDecoration).color, equals(Colors.white.withOpacity(0.4)));

    // Verify the presence of LinearProgressIndicator inside the Column
    expect(find.descendant(of: find.byType(Column), matching: find.byType(LinearProgressIndicator)), findsOneWidget);
  });
}
