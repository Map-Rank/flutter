import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapnrank/app/models/user_model.dart';
import 'package:mapnrank/app/services/auth_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:get/get.dart';
import 'package:mapnrank/app/modules/community/controllers/community_controller.dart';
import 'package:mapnrank/app/modules/community/views/community_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Generate the mock for CommunityController
@GenerateNiceMocks([MockSpec<CommunityController>()])
import 'community_view_test.mocks.dart';

void main() {
  late MockCommunityController mockCommunityController;

  setUp(() {
    // Initialize the mock controller
    mockCommunityController = MockCommunityController();

    // Inject the mock controller into GetX
    Get.put<MockCommunityController>;
    Get.put(AuthService());
    Get.put(CommunityController());
    CommunityController().currentUser.value = UserModel(userId: 1,
      firstName: 'John',
      phoneNumber: '777777777',
      gender: 'Male',
      lastName: 'Doe',
      email: 'john.doe@example.com',
      avatarUrl: '',
      myPosts: ['Post1', 'Post2'], // Example post identifiers
      myEvents: ['Event1', 'Event2'], );

    const TEST_MOCK_STORAGE = './test/test_pictures';
    const channel = MethodChannel(
      'plugins.flutter.io/path_provider',
    );
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return TEST_MOCK_STORAGE;
    });

  });

  testWidgets('CommunityView renders correctly and interacts with controller', (WidgetTester tester) async {
    // Arrange
    when(mockCommunityController.currentUser).thenReturn(Rx(UserModel(avatarUrl: ''))); // Mock a default user state
    when(mockCommunityController.feedbackController).thenReturn(TextEditingController());
    when(mockCommunityController.rating).thenReturn(RxInt(0)); // Mock the rating observable
    when(mockCommunityController.loadFeedbackImage).thenReturn(RxBool(false)); // Mock the image loading state

    await tester.pumpWidget(
      GetMaterialApp(
        home: const CommunityView(),
        localizationsDelegates: [
          AppLocalizations.delegate,
          // ... other localization delegates
        ],
        locale: const Locale('en'),
      ),
    );

    // Act
    await tester.pumpAndSettle(); // Wait for everything to settle

    // Assert
    expect(find.byType(FloatingActionButton), findsOneWidget); // Check that FAB is present

    // Interact with the FAB
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Verify that the feedback form is displayed
    //expect(find.text('Send via WhatsApp'), findsOneWidget);
    //expect(find.byType(TextFormField), findsOneWidget);

    // Interact with the rating stars
    //await tester.tap(find.byIcon(Icons.star_border).first);
    await tester.pumpAndSettle();

    // Verify that the rating is updated
    //verify(mockCommunityController.rating.value = 1).called(1);
  });
}
