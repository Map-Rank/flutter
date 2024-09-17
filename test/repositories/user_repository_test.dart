import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mapnrank/app/models/user_model.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:mapnrank/app/models/feedback_model.dart';
import 'package:mapnrank/app/providers/laravel_provider.dart';
import 'package:mapnrank/app/repositories/user_repository.dart';
import 'user_repository_test.mocks.dart';

@GenerateMocks([LaravelApiClient])
void main() {
  late UserRepository userRepository;
  late MockLaravelApiClient mockLaravelApiClient;

  setUp(() {
    // Create a mock instance of LaravelApiClient
    //mockLaravelApiClient = MockLaravelApiClient();

    // Inject the mock instance into GetX
   // Get.put<LaravelApiClient>(mockLaravelApiClient);

    // Initialize UserRepository which depends on the mocked LaravelApiClient
    //userRepository = UserRepository();

    // Stub the sendFeedback method in LaravelApiClient
    //when(mockLaravelApiClient.sendFeedback(any)).thenAnswer((_) async {});
  });
  test('', () async{});

  // test('sendFeedback should call sendFeedback on LaravelApiClient', () async {
  //   // Arrange
  //   final feedbackModel = FeedbackModel(
  //     feedbackText: 'Great app!',
  //     imageFile: null,
  //     rating: '5',
  //   );
  //
  //   // Act: Call the sendFeedback method in UserRepository
  //   await userRepository.sendFeedback(feedbackModel);
  //
  //   // Assert: Verify that the sendFeedback method was called on the mock LaravelApiClient
  //   verify(mockLaravelApiClient.sendFeedback(feedbackModel)).called(1);
  // });
  //
  // test('login should call login on LaravelApiClient', () async {
  //   // Arrange
  //   final userModel = UserModel(email: 'test@example.com', password: 'password');
  //
  //   // Stub the login method in LaravelApiClient
  //   when(mockLaravelApiClient.login(any)).thenAnswer((_) async {});
  //
  //   // Act: Call the login method in UserRepository
  //   await userRepository.login(userModel);
  //
  //   // Assert: Verify that the login method was called on the mock LaravelApiClient
  //   verify(mockLaravelApiClient.login(userModel)).called(1);
  // });
  //
  // test('updateUser should call updateUser on LaravelApiClient', () async {
  //   // Arrange
  //   final userModel = UserModel(userId: 1, email: 'test@example.com');
  //
  //   // Stub the updateUser method in LaravelApiClient
  //   when(mockLaravelApiClient.updateUser(any)).thenAnswer((_) async {});
  //
  //   // Act: Call the updateUser method in UserRepository
  //   await userRepository.updateUser(userModel);
  //
  //   // Assert: Verify that the updateUser method was called on the mock LaravelApiClient
  //   verify(mockLaravelApiClient.updateUser(userModel)).called(1);
  // });
}
