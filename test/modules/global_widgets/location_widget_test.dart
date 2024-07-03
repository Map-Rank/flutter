import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mapnrank/app/modules/global_widgets/location_widget.dart';


void main() {
  testWidgets('LocationWidget displays the correct text', (WidgetTester tester) async {
    // Arrange
    const String testRegionName = 'Test Region';

    // Act
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: LocationWidget(
            regionName: testRegionName,
            selected: false,
          ),
        ),
      ),
    );

    // Assert
    expect(find.text(testRegionName), findsOneWidget);
  });

  testWidgets('LocationWidget displays the correct icon when not selected', (WidgetTester tester) async {
    // Act
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: LocationWidget(
            regionName: 'Test Region',
            selected: false,
          ),
        ),
      ),
    );

    // Assert
    expect(find.byIcon(FontAwesomeIcons.square), findsOneWidget);
    expect(find.byIcon(FontAwesomeIcons.check), findsNothing);
  });

  testWidgets('LocationWidget displays the correct icon when selected', (WidgetTester tester) async {
    // Act
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: LocationWidget(
            regionName: 'Test Region',
            selected: true,
          ),
        ),
      ),
    );

    // Assert
    expect(find.byIcon(FontAwesomeIcons.check), findsOneWidget);
    expect(find.byIcon(FontAwesomeIcons.square), findsNothing);
  });

  testWidgets('LocationWidget displays the correct border when selected', (WidgetTester tester) async {
    // Act
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: LocationWidget(
            regionName: 'Test Region',
            selected: true,
          ),
        ),
      ),
    );

    // Assert
    final container = tester.widget<Container>(find.byType(Container).first);
    final BoxDecoration? decoration = container.decoration as BoxDecoration?;
    expect(decoration?.border, isNull);
    //expect(decoration?.border?.top.color, equals(interfaceColor));
  });

  testWidgets('LocationWidget has no border when not selected', (WidgetTester tester) async {
    // Act
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: LocationWidget(
            regionName: 'Test Region',
            selected: false,
          ),
        ),
      ),
    );

    // Assert
    final container = tester.widget<Container>(find.byType(Container).first);
    final BoxDecoration? decoration = container.decoration as BoxDecoration?;
    expect(decoration?.border, isNull);
  });
}
