import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapnrank/app/models/event_model.dart';
import 'package:mapnrank/app/models/post_model.dart';
import 'package:mapnrank/app/models/user_model.dart';
import 'package:mapnrank/app/modules/events/controllers/events_controller.dart';
import 'package:mapnrank/app/modules/events/views/events_view.dart';
import 'package:mapnrank/app/modules/global_widgets/loading_cards.dart';
import 'package:mapnrank/app/modules/global_widgets/post_card_widget.dart';
import 'package:mapnrank/app/services/auth_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:get/get.dart';
import 'package:mapnrank/app/modules/community/controllers/community_controller.dart';
import 'package:mapnrank/app/modules/community/views/community_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'events_view_test.mocks.dart';

// Generate the mock for CommunityController
@GenerateNiceMocks([MockSpec<EventsController>()])


void main() {
  late MockEventsController mockEventsController;
  late EventsController eventsController;

  setUp(() {
    // Initialize the mock controller
    Get.put(AuthService());
    Get.put(EventsController());
    mockEventsController = MockEventsController();
    eventsController = EventsController();

    // Inject the mock controller into GetX
    //Get.put<MockCommunityController>;

    final mockEvent = Event(
      eventId: 1,
      title: "Flutter Conference",
      content: "An exciting conference about Flutter development.",
      zone: "Zone 1",
      organizer: "Tech World",
      publishedDate: "2024-09-01",
      imagesUrl: "https://example.com/event_image.jpg",
    );
    eventsController.allEvents.value = [mockEvent];
    eventsController.loadingEvents.value = false;
    eventsController.currentUser.value = UserModel(userId: 1,
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

  tearDown(() {
    Get.reset();
  });

  testWidgets('CommunityView renders correctly and interacts with controller', (WidgetTester tester) async {
    eventsController.allEvents.value = [ Event(
      eventId: 1,
      title: "Flutter Conference",
      content: "An exciting conference about Flutter development.",
      zone: "Zone 1",
      organizer: "Tech World",
      publishedDate: "2024-09-01",
      imagesUrl: "https://example.com/event_image.jpg",
    )];
    eventsController.loadingEvents.value = false;
    // Arrange
    when(mockEventsController.currentUser).thenReturn(Rx(UserModel(avatarUrl: '')));
    when(mockEventsController.allEvents).thenReturn([ Event(
      eventId: 1,
      title: "Flutter Conference",
      content: "An exciting conference about Flutter development.",
      zone: "Zone 1",
      organizer: "Tech World",
      publishedDate: "2024-09-01",
      imagesUrl: "https://example.com/event_image.jpg",
    )].obs);
    when(mockEventsController.loadingEvents).thenReturn(false.obs);// Mock a default user state

    await tester.pumpWidget(
      GetMaterialApp(
        home: const EventsView(),
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
    //await tester.tap(find.byType(FloatingActionButton));
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

