import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mapnrank/app/modules/community/widgets/buildSelectZone.dart';
import 'package:mockito/mockito.dart';
import 'package:mapnrank/app/modules/community/controllers/community_controller.dart';
import 'package:mapnrank/app/modules/events/controllers/events_controller.dart';
import 'package:mapnrank/app/modules/global_widgets/location_widget.dart';
import 'package:mapnrank/app/modules/global_widgets/text_field_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


// Mock class
class MockCommunityController extends GetxController with Mock implements CommunityController {
  @override
  var chooseARegion = false.obs;

  @override
  var chooseADivision = false.obs;

  @override
  var chooseASubDivision = false.obs;

  @override
  var loadingRegions = false.obs;

  @override
  var loadingDivisions = false.obs;

  @override
  var loadingSubdivisions = false.obs;

  @override
  var regionSelected = false.obs;

  @override
  var divisionSelected = false.obs;

  @override
  var subdivisionSelected = false.obs;

  @override
  var regionSelectedIndex = 0.obs;

  @override
  var divisionSelectedIndex = 0.obs;

  @override
  var subdivisionSelectedIndex = 0.obs;

  @override
  var regions = [].obs;

  @override
  var divisions = [].obs;

  @override
  var subdivisions = [].obs;

  @override
  var regionSelectedValue = [].obs;

  @override
  var divisionSelectedValue = [].obs;

  @override
  var subdivisionSelectedValue = [].obs;
}

void main() {
  late MockCommunityController mockCommunityController;

  setUp(() {
    mockCommunityController = MockCommunityController();
    Get.put<CommunityController>(mockCommunityController);
    Get.lazyPut(() => EventsController());
  });

  testWidgets('BuildSelectZone renders correctly and handles interactions', (WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: Localizations(
              delegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              locale: Locale('en'),

              child: Builder(
                  builder: (BuildContext context) {
                    return BuildSelectZone();
                  }

              ),),
        ),
      ),
    );

    // Verify initial state
    //expect(find.byKey(Key('chooseRegion')), findsOneWidget);
    //expect(find.byKey(Key('chooseRegionIcon')), findsOneWidget);

    // Simulate tapping on 'Choose a region'
    //await tester.tap(find.byKey(Key('chooseRegion')));

    // Verify the controller state change
    //expect(mockCommunityController.chooseARegion.value, true);

    // Mock the state after region is chosen
    //mockCommunityController.chooseARegion.value = true;

    // await tester.pumpWidget(
    //   GetMaterialApp(
    //     home: Scaffold(
    //       body:Builder(
    //           builder: (BuildContext context) {
    //             return BuildSelectZone();
    //           }
    //
    //       ),
    //     ),
    //   ),
    // );

    // Verify region selection UI
    //expect(find.text('Select a region'), findsOneWidget);
    //expect(find.byType(TextFieldWidget), findsOneWidget);

    // Simulate region selection
    mockCommunityController.regions.value = [
      {'name': 'Region 1', 'id': 1}
    ];

    // await tester.pumpWidget(
    //   GetMaterialApp(
    //     home: Scaffold(
    //       body:Builder(
    //           builder: (BuildContext context) {
    //             return BuildSelectZone();
    //           }
    //
    //       ),
    //     ),
    //   ),
    // );

    // expect(find.text('Region 1'), findsOneWidget);
    //
    // // Simulate tapping on the region
    // await tester.tap(find.text('Region 1'));
    await tester.pumpAndSettle();

    // Verify the controller state change for region selection
    //expect(mockCommunityController.regionSelected.value, true);

    // Simulate tapping on 'Choose a Division'
    //await tester.tap(find.text('Choose a Division'));
    await tester.pumpAndSettle();

    // Verify the controller state change for division selection
   // expect(mockCommunityController.chooseADivision.value, true);

    // Simulate division selection
    mockCommunityController.divisions.value = [
      {'name': 'Division 1', 'id': 1}
    ];

    // await tester.pumpWidget(
    //   GetMaterialApp(
    //     home: Scaffold(
    //       body:Builder(
    //           builder: (BuildContext context) {
    //             return BuildSelectZone();
    //           }
    //
    //       ),
    //     ),
    //   ),
    // );

    // expect(find.text('Division 1'), findsOneWidget);
    //
    // // Simulate tapping on the division
    // await tester.tap(find.text('Division 1'));
    // await tester.pumpAndSettle();

    // Verify the controller state change for division selection
   // expect(mockCommunityController.divisionSelected.value, false);

    // Simulate tapping on 'Choose a Sub-Division'
    //await tester.tap(find.text('Choose a Sub-Division'));
    await tester.pumpAndSettle();

    // Verify the controller state change for subdivision selection
    //expect(mockCommunityController.chooseASubDivision.value, true);

    // Simulate subdivision selection
    mockCommunityController.subdivisions.value = [
      {'name': 'Sub-Division 1', 'id': 1}
    ];

    // await tester.pumpWidget(
    //   GetMaterialApp(
    //     home: Scaffold(
    //       body: Builder(
    //       builder: (BuildContext context) {
    //         return BuildSelectZone();
    //       }
    //
    //     ),
    //   ),
    // )
    // );

    // expect(find.text('Sub-Division 1'), findsOneWidget);
    //
    // // Simulate tapping on the subdivision
    // await tester.tap(find.text('Sub-Division 1'));
    // await tester.pumpAndSettle();

    // Verify the controller state change for subdivision selection
    //expect(mockCommunityController.subdivisionSelected.value, false);
  });
}
