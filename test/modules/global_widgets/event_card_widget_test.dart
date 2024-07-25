import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mapnrank/app/models/user_model.dart';
import 'package:mapnrank/app/modules/global_widgets/event_card_widget.dart';
import 'package:mapnrank/app/modules/global_widgets/post_card_widget.dart';
import 'package:mapnrank/app/services/auth_service.dart';

void main() {
  setUp(() {
    Get.lazyPut(()=>AuthService());
  });
  tearDown(() {
    Get.reset();  // Reset the GetX state after each test
  });

  testWidgets('EventCardWidget renders correctly and interacts', (WidgetTester tester) async {

    // Arrange
    final UserModel mockUser = UserModel(
      userId: 1,
      firstName: 'John',
      lastName: 'Doe',
      email: 'john.doe@example.com',
      phoneNumber: '1234567890',
      gender: 'Male',
      avatarUrl: 'https://example.com/avatar.png',
      authToken: 'mockAuthToken',
      zoneId: 'zone1',
      birthdate: '1990-01-01',
      profession: 'Company Inc',
      sectors: ['sector1', 'sector2'],
    );

    //AuthService().user.value.authToken = mockUser.authToken;

    final RxInt likeCount = RxInt(5);
    final RxInt shareCount = RxInt(2);

    final eventCardWidget = EventCardWidget(
      eventOrganizer: 'John Doe',
      title: 'Event title',
      sectors: ['sector1', 'sector2'],
      zone: 'Zone 1',
      content: 'This is an event content.',
      eventCreatorId: 1,
      eventId: 1,
      publishedDate: '2024-06-14',
     image: 'https://example.com/image1.png',
      popUpWidget: PopupMenuButton(itemBuilder: (context) {
        return  {'Edit', 'Delete'}.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice, style: const TextStyle(color: Colors.black),),
          );
        }).toList();
      },),

    );

    // Act
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: eventCardWidget,
        ),
      ),
    );

    // Assert
    expect(find.textContaining('John Doe',findRichText: true ), findsOneWidget, );
    expect(find.text('This is an event content.'), findsOneWidget);
    expect(find.byType(FadeInImage), findsAtLeastNWidgets(1));
    expect(find.text('Event title'), findsOneWidget);

    await tester.pump();

    await tester.pump();

  });
}
