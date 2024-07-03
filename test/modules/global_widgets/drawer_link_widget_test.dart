import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mapnrank/app/modules/global_widgets/drawer_link_widget.dart';
import 'package:mapnrank/color_constants.dart';


void main() {
  // A helper function to create the DrawerLinkWidget with provided parameters
  Widget createDrawerLinkWidget({IconData? icon, String? text, bool? special, bool? drawer, ValueChanged<void>? onTap}) {
    return GetMaterialApp(
      home: Scaffold(
        body: DrawerLinkWidget(
          icon: icon,
          text: text,
          special: special,
          drawer: drawer,
          onTap: onTap,
        ),
      ),
    );
  }

  testWidgets('DrawerLinkWidget displays correct icon and text', (WidgetTester tester) async {
    // Arrange
    const testIcon = Icons.home;
    const testText = 'Home';
    const testSpecial = false;
    const testDrawer = true;

    // Act
    await tester.pumpWidget(createDrawerLinkWidget(
      icon: testIcon,
      text: testText,
      special: testSpecial,
      drawer: testDrawer,
      onTap: (value) {},
    ));

    // Assert
    expect(find.byIcon(testIcon), findsOneWidget);
    expect(find.text(testText), findsOneWidget);
  });

  testWidgets('DrawerLinkWidget displays special icon color when special is true', (WidgetTester tester) async {
    // Arrange
    const testIcon = Icons.home;
    const testText = 'Home';
    const testSpecial = true;
    const testDrawer = true;

    // Act
    await tester.pumpWidget(createDrawerLinkWidget(
      icon: testIcon,
      text: testText,
      special: testSpecial,
      drawer: testDrawer,
      onTap: (value) {},
    ));

    // Assert
    final iconFinder = find.byIcon(testIcon);
    final iconWidget = tester.widget<Icon>(iconFinder);
    expect(iconWidget.color, specialColor);
  });

  testWidgets('DrawerLinkWidget displays regular icon color when special is false', (WidgetTester tester) async {
    // Arrange
    const testIcon = Icons.home;
    const testText = 'Home';
    const testSpecial = false;
    const testDrawer = true;

    // Act
    await tester.pumpWidget(createDrawerLinkWidget(
      icon: testIcon,
      text: testText,
      special: testSpecial,
      drawer: testDrawer,
      onTap: (value) {},
    ));

    // Assert
    final iconFinder = find.byIcon(testIcon);
    final iconWidget = tester.widget<Icon>(iconFinder);
    expect(iconWidget.color, buttonColor);
  });

  testWidgets('DrawerLinkWidget triggers onTap callback when tapped', (WidgetTester tester) async {
    // Arrange
    const testIcon = Icons.home;
    const testText = 'Home';
    bool callbackTriggered = false;

    // Act
    await tester.pumpWidget(createDrawerLinkWidget(
      icon: testIcon,
      text: testText,
      special: false,
      drawer: true,
      onTap: (value) {
        callbackTriggered = true;
      },
    ));

    // Act
    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();

    // Assert
    expect(callbackTriggered, isTrue);
  });
}
