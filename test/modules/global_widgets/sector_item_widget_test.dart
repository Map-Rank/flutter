import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mapnrank/app/modules/global_widgets/sector_item_widget.dart';

void main() {
  testWidgets('SectorItemWidget displays the correct text', (WidgetTester tester) async {
    // Arrange
    const String testSectorName = 'Test Sector';

    // Act
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: SectorItemWidget(
            sectorName: testSectorName,
            selected: false,
          ),
        ),
      ),
    );

    // Assert
    expect(find.text(testSectorName), findsOneWidget);
  });

  testWidgets('SectorItemWidget displays the correct icon when not selected', (WidgetTester tester) async {
    // Act
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: SectorItemWidget(
            sectorName: 'Test Sector',
            selected: false,
          ),
        ),
      ),
    );

    // Assert
    expect(find.byIcon(FontAwesomeIcons.square), findsOneWidget);
    expect(find.byIcon(FontAwesomeIcons.squareCheck), findsNothing);
  });

  testWidgets('SectorItemWidget displays the correct icon when selected', (WidgetTester tester) async {
    // Act
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: SectorItemWidget(
            sectorName: 'Test Sector',
            selected: true,
          ),
        ),
      ),
    );

    // Assert
    expect(find.byIcon(FontAwesomeIcons.squareCheck), findsOneWidget);
    expect(find.byIcon(FontAwesomeIcons.square), findsNothing);
  });

  testWidgets('SectorItemWidget displays the correct border', (WidgetTester tester) async {
    // Act
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: SectorItemWidget(
            sectorName: 'Test Sector',
            selected: false,
          ),
        ),
      ),
    );

    // Assert
    final container = tester.widget<Container>(find.byType(Container).first);
    final BoxDecoration? decoration = container.decoration as BoxDecoration?;
    expect(decoration?.border?.bottom.color, Colors.black38);
    expect(decoration?.border?.bottom.width, 0.5);
  });

  testWidgets('SectorItemWidget has padding applied', (WidgetTester tester) async {
    // Act
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: SectorItemWidget(
            sectorName: 'Test Sector',
            selected: false,
          ),
        ),
      ),
    );

    // Assert
    final padding = tester.widget<Padding>(find.byType(Padding).first);
    expect(padding.padding, const EdgeInsets.only(left: 0,top: 10, right: 10, bottom: 10.5));
  });
}
