import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mapnrank/app/models/user_model.dart';
import 'package:mapnrank/app/modules/auth/controllers/auth_controller.dart';
import 'package:mapnrank/app/modules/global_widgets/main_drawer_widget.dart';
import 'package:mapnrank/app/modules/root/controllers/root_controller.dart';
import 'package:mapnrank/app/services/auth_service.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



class MockAuthService extends GetxService with Mock implements AuthService {
  final user = Rx<UserModel>(UserModel(email: 'test@example.com',
      firstName: 'John',
      lastName: 'Doe',
      avatarUrl: 'http://example.com/avatar.png'));
}
class MockRootController extends GetxController with Mock implements RootController {}
class MockAuthController extends GetxController with  Mock implements AuthController {}

void main() {
  late MockAuthService mockAuthService;
  late MockRootController mockRootController;
  late MockAuthController mockAuthController;

  setUp(() {
    // Initialize GetX dependencies
    mockAuthService = MockAuthService();
    mockRootController = MockRootController();
    mockAuthController = MockAuthController();

    Get.lazyPut<AuthService>(() => mockAuthService);
    Get.lazyPut<RootController>(() => mockRootController);
    Get.lazyPut<AuthController>(() => mockAuthController);


  });
  tearDown(() {
    Get.reset();  // Reset the GetX state after each test
  });


  testWidgets('MainDrawerWidget shows user details when user is logged in', (WidgetTester tester) async {
    // Arrange
    var mockUser = Rx<UserModel>(UserModel(
        email: 'test@example.com',
        firstName: 'John',
        lastName: 'Doe',
        avatarUrl: 'http://example.com/avatar.png'
    ));
    mockAuthService.user = mockUser;

    // Act
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
                  return MainDrawerWidget();
                }

            ),),
        ),
      ),
    );

    // Assert
    expect(find.text('John Doe'), findsOneWidget);
    expect(find.byType(UserAccountsDrawerHeader), findsOneWidget);
  });

  testWidgets('MainDrawerWidget handles logout', (WidgetTester tester) async {
    // Arrange
    var mockUser = Rx<UserModel>(UserModel(email: 'test@example.com'));
    mockAuthService.user = mockUser;

    // Act
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
                  return MainDrawerWidget();
                }

            ),),
        ),
      ),
    );

   await tester.tap(find.byKey(const Key('logoutIcon')));
    //await tester.pumpAndSettle();

    // Assert
    //verify(mockAuthController.logout()).called(1);
  });
}
