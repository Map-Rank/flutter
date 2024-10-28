import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapnrank/app/modules/global_widgets/custom_bottom_nav_bar.dart';
// Adjust the import based on your file structure

void main() {
  testWidgets('CustomBottomNavigationBar test', (WidgetTester tester) async {
    int selectedIndex = 0;
final items = [
 CustomBottomNavigationItem(icon: Icon(Icons.home), label: 'Home'),
 CustomBottomNavigationItem(icon: Icon(Icons.search), label: 'Search'),
 CustomBottomNavigationItem(icon: Icon(Icons.person), label: 'Profile'),
];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return CustomBottomNavigationBar(
                currentIndex: selectedIndex,
                children: items,
                onChange: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              );
            },
          ),
        ),
      ),
    );

    // Initial state check
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Search'), findsNothing);
    expect(find.text('Profile'), findsNothing);

    // Tap on the second item (Search)
    await tester.tap(find.byIcon(Icons.search));
    await tester.pump();

    // Check if the second item is now selected
    expect(selectedIndex, 1);
    expect(find.text('Home'), findsNothing);
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Profile'), findsNothing);

    // Tap on the third item (Profile)
    await tester.tap(find.byIcon(Icons.person));
    await tester.pump();

    // Check if the third item is now selected
    expect(selectedIndex, 2);
    expect(find.text('Home'), findsNothing);
    expect(find.text('Search'), findsNothing);
    expect(find.text('Profile'), findsOneWidget);
  });
}
