
import 'package:flutter_test/flutter_test.dart';

void main() {

  testWidgets('Widget renders correctly and interacts', (WidgetTester tester) async {


  });
}



// import 'package:flutter/services.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:get/get.dart';
// import 'package:mapnrank/common/helper.dart';
// import 'package:mapnrank/common/ui.dart';
// import 'package:mockito/mockito.dart';
//
//
// class MockMethodChannel extends Mock implements MethodChannel {}
//
// void main() {
//   TestWidgetsFlutterBinding.ensureInitialized();
//
//   group('Helper', () {
//     late Helper helper;
//     late MockMethodChannel mockMethodChannel;
//
//     setUp(() {
//       mockMethodChannel = MockMethodChannel();
//       helper = Helper(methodChannel: mockMethodChannel);
//     });
//
//     test('onWillPop shows snackbar and returns false if tapped once', () async {
//       // Simulate a tap
//       final result = await helper.onWillPop();
//
//       // Verify the snackbar is shown
//       verify(Get.showSnackbar(Ui.defaultSnackBar(message: "Tap again to leave!".tr)));
//
//       // Expect the result to be false
//       expect(result, isFalse);
//     });
//
//     test('onWillPop invokes SystemNavigator.pop if tapped twice quickly', () async {
//       // Set currentBackPressTime to a recent time to simulate the second tap within 2 seconds
//       helper.currentBackPressTime = DateTime.now();
//
//       // Mock the method channel for SystemNavigator.pop
//       when(mockMethodChannel.invokeMethod('SystemNavigator.pop')).thenAnswer((_) async {});
//
//       // Simulate a second tap
//       final result = await helper.onWillPop();
//
//       // Verify the SystemNavigator.pop is invoked
//       expect(result, isTrue);
//     });
//   });
// }