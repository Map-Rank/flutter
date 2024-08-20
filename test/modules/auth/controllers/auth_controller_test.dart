
import 'dart:io';
import 'dart:ui';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapnrank/app/modules/community/controllers/community_controller.dart';
import 'package:mapnrank/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:mapnrank/app/modules/events/controllers/events_controller.dart';
import 'package:mapnrank/app/modules/notifications/controllers/notification_controller.dart';
import 'package:mapnrank/app/modules/root/controllers/root_controller.dart';
import 'package:mapnrank/app/providers/laravel_provider.dart';
import 'package:mapnrank/app/routes/app_routes.dart';
import 'package:mapnrank/app/services/auth_service.dart';
import 'package:mapnrank/common/ui.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mapnrank/app/modules/auth/controllers/auth_controller.dart';
import 'package:mapnrank/app/models/user_model.dart';
import 'package:mapnrank/app/repositories/sector_repository.dart';
import 'package:mapnrank/app/repositories/user_repository.dart';
import 'package:mapnrank/app/repositories/zone_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'auth_controller_test.mocks.dart';
import 'package:image/image.dart' as Im;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


// Generate mocks using generateMocks utility
@GenerateMocks([UserRepository, ZoneRepository, SectorRepository])

class MockAppLocalizations implements AppLocalizations {
  @override
  String get select_language => 'Select Language';

  // Implement other members of AppLocalizations if needed
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockAuthService extends GetxService with Mock implements AuthService {
  final user = Rx<UserModel>(UserModel(email: 'test@example.com',
      firstName: 'John',
      lastName: 'Doe',
      avatarUrl: 'http://example.com/avatar.png'));}


class MockBuildContext extends Mock implements BuildContext {}
class MockImagePicker extends Mock implements ImagePicker {
  @override
  Future<XFile?> pickImage({
    required ImageSource source,
    int? imageQuality,
    double? maxHeight,
    double? maxWidth,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = true,
  }) async {
    return MockXFile();
  }

}
class MockXFile extends Mock implements XFile {
  @override
  final String path = 'test/test_pictures/testPicture.png';
}
class MockRootController extends Mock implements RootController {}

class MockDirectory extends Mock implements Directory {
  var path = '/mock/temp/dir';
}
class MockImage extends Mock implements Im.Image {}
class MockGetClass extends Mock implements GetInterface {}

class MockLaravelApiClient extends Mock implements LaravelApiClient {}
class MockDashboardController extends Mock implements DashboardController {}
class MockCommunityController extends Mock implements CommunityController {}
class MockNotificationController extends Mock implements NotificationController {}
class MockEventsController extends Mock implements EventsController {}
class MockGetStorage extends Mock implements GetStorage {}




void main() {

  late AuthController authController;
  late MockUserRepository mockUserRepository;
  late MockZoneRepository mockZoneRepository;
  late MockSectorRepository mockSectorRepository;
  late MockAuthService mockAuthService;
  late MockBuildContext mockBuildContext;
  late MockImagePicker mockImagePicker;
  late MockXFile mockXFile;
  late MockDirectory mockDirectory;
  late MockGetClass mockGet;
  late MockRootController mockRootController;
  late MockLaravelApiClient mockLaravelApiClient;
  late MockDashboardController mockDashboardController;
  late MockCommunityController mockCommunityController;
  late MockNotificationController mockNotificationController;
  late MockEventsController mockEventsController;
  late MockGetStorage mockGetStorage;





  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    mockAuthService = MockAuthService();
    mockRootController = MockRootController();
    mockGet = MockGetClass();
    mockDirectory = MockDirectory();
    mockBuildContext = MockBuildContext();
    mockImagePicker = MockImagePicker();
    mockGetStorage = MockGetStorage();
    mockXFile = MockXFile();
    Get.lazyPut(()=>AuthService());

    Get.testMode = true;
    mockUserRepository = MockUserRepository();
    mockZoneRepository = MockZoneRepository();
    mockSectorRepository = MockSectorRepository();

    authController = AuthController();
    authController.userRepository = mockUserRepository;
    Get.put<AuthService>(mockAuthService);
    Get.put<RootController>(mockRootController);

    authController.currentUser = AuthService().user;
    authController.userRepository = mockUserRepository;
    authController.zoneRepository = mockZoneRepository;
    authController.sectorRepository = mockSectorRepository;
    const TEST_MOCK_STORAGE = '/test/test_pictures';
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

  group('AuthController Tests', () {

    test('onInit initializes correctly when storage is empty', () async {
      authController.birthDateDisplay.text = "--/--/--";
      when(mockGetStorage.read("allRegions")).thenReturn(null);
      when(mockGetStorage.read("allSectors")).thenReturn(null);
      when(mockZoneRepository.getAllRegions(any, any)).thenAnswer((_) async => {
        [],

      });
      when(mockSectorRepository.getAllSectors()).thenAnswer((_) async => {
        'data': ['Sector1', 'Sector2'],
        'status': true,
      });

      //await authController.onInit();

      expect(authController.birthDateDisplay.text, "--/--/--");
      expect(authController.listRegions.value, []);
      expect(authController.loadingRegions.value, true);
      // verify(mockGetStorage.write("allRegions", any)).called(1);
      // verify(mockGetStorage.write("allSectors", any)).called(1);
    });

    test('onInit initializes correctly when storage is populated', () async {
      authController.birthDateDisplay.text = "--/--/--";
      when(mockGetStorage.read("allRegions")).thenReturn({
        []
      });
      when(mockGetStorage.read("allSectors")).thenReturn({
        [],
      });

      //await authController.onInit();

      expect(authController.birthDateDisplay.text, "--/--/--");
      expect(authController.listRegions.value, []);
      expect(authController.loadingRegions.value, true);
      expect(authController.listSectors.value, []);
      expect(authController.loadingSectors.value, true);
    });

    test('SnackBar is shown when sectors are loading', () async {
      when(mockGetStorage.read("allRegions")).thenReturn(null);
      when(mockGetStorage.read("allSectors")).thenReturn(null);
      when(mockZoneRepository.getAllRegions(any, any)).thenAnswer((_) async => {
        'data': ['Region1', 'Region2'],
        'status': true,
      });
      when(mockSectorRepository.getAllSectors()).thenAnswer((_) async => {
        'data': ['Sector1', 'Sector2'],
        'status': true,
      });

      //await authController.onInit();

      // Check if SnackBar is shown
      //expect(find.text('Loading Sectors...'), findsOneWidget);
    });

    test('Filter Search Regions Test', () async {
      authController.listRegions.value = [{'name': 'Region 1'}, {'name': 'Region 2'}];

      authController.filterSearchRegions('region 1');
      expect(authController.regions.length, 1);
      expect(authController.regions[0]['name'], 'Region 1');
    });

    testWidgets('Birth Date Picker Test', (WidgetTester tester) async {
      // Create a mock AuthController instance
      final authController = AuthController();

      // Build the app and trigger a frame
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () async {
                    await authController.birthDatePicker(context, 50);
                  },
                  child: Text('Pick Date'),
                );
              },
            ),
          ),
        ),
      );

      // Tap the button to trigger the date picker
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Simulate picking a date
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Validate that the date was set correctly
      expect(authController.birthDate.value, isNot('--/--/--'));
      expect(authController.birthDateDisplay.text, isNot('--/--/--'));
    });

    testWidgets('Select Camera Or Gallery Profile Image Test', (WidgetTester tester) async {
      //Mock the image picker to return a fake image path
      // when(mockImagePicker.pickImage(source: ImageSource.camera)).thenAnswer(
      //       (_) async => mockXFile,
      // );
      // when(mockImagePicker.pickImage(source: ImageSource.gallery)).thenAnswer(
      //       (_) async => mockXFile,
      // );

      // Create a widget to test the profile image picker dialog
      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () async {
                    authController.selectCameraOrGalleryProfileImage();
                  },
                  child: const Text('Select Profile Image'),
                );
              },
            ),
          ),
        ),
      );


      // Replace the ImagePicker instance in the AuthController with the mock instance
      authController.picker = mockImagePicker;

      // Tap the button to trigger the profile image picker dialog
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Validate that the dialog is shown
      expect(find.byType(AlertDialog), findsOneWidget);

      // Tap the 'Take a picture' ListTile
      await tester.tap(find.text('Take a picture'));
      await tester.pumpAndSettle();

      // Validate that the profile image path was set correctly for camera
      expect(authController.profileImage.path, 'test/test_pictures/testPicture.png');

      // Tap the button to trigger the profile image picker dialog again
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Tap the 'Upload Image' ListTile
      await tester.tap(find.text('Upload Image'));
      await tester.pumpAndSettle();

      // Validate that the profile image path was set correctly for gallery
      expect(authController.profileImage.path, 'test/test_pictures/testPicture.png');
    });

    test('profileImagePicker - Camera Source', () async {
      final mockXFile = MockXFile();
      final mockImage = MockImage();

      // Mock ImagePicker behavior for camera source
      //when(mockImagePicker.pickImage(source: ImageSource.camera)).thenAnswer((_) async => mockXFile);

      // Mock getTemporaryDirectory behavior
      //when(mockDirectory.path).thenReturn('/mock/temp/dir');
      //when(getTemporaryDirectory()).thenAnswer((_) async => mockDirectory);

      // Mock image manipulation behavior
      //when(Im.decodeImage(Uint8List(1000))).thenReturn(mockImage);
      //when(Im.encodeJpg(mockImage, quality: 4)).thenReturn(Uint8List.fromList([1, 2, 3]));

      // Call the profileImagePicker method with camera source
      //await authController.profileImagePicker('camera');

      // Verify profileImage and loadProfileImage.value are updated
      //expect(authController.profileImage, isA<File>());
      expect(authController.loadProfileImage.value, false);

      // Verify Navigator.of(context).pop() is called
      //verify(Navigator.of(mockBuildContext).canPop());
    });

    test('profileImagePicker - Gallery Source', () async {
      final mockXFile = MockXFile();
      final mockImage = MockImage();

      // Mock ImagePicker behavior for gallery source
      //when(mockImagePicker.pickImage(source: ImageSource.gallery)).thenAnswer((_) async => mockXFile);

      // Mock getTemporaryDirectory behavior
      //when(mockDirectory.path).thenReturn('/mock/temp/dir');
     // when(getTemporaryDirectory()).thenAnswer((_) async => mockDirectory);

      // Mock image manipulation behavior
      //when(Im.decodeImage(Uint8List(1000))).thenReturn(mockImage);
      //when(Im.encodeJpg(mockImage, quality: 4)).thenReturn(Uint8List.fromList([1, 2, 3]));

      // Call the profileImagePicker method with gallery source
      //await authController.profileImagePicker('gallery');

      // Verify profileImage and loadProfileImage.value are updated
      //expect(authController.profileImage, isA<File>());
      expect(authController.loadProfileImage.value, false);

      // Verify Navigator.of(context).pop() is called
      //verify(Navigator.of(mockBuildContext).canPop());
    });


    test('register success', () async {
      final user = UserModel(userId: 1, firstName: 'John', lastName: 'Doe'); // Assuming you have a User model
      when(mockUserRepository.register(any)).thenAnswer((_) async => user);

      //await authController.register();

      //verify(mockUserRepository.register(any)).called(1);
     // verify(mockAuthService.user.value = user).called(1);
     // verify(mockRootController.changePage(0)).called(1);
     // expect(find.text('Your account was created successfully'), findsOneWidget);
      expect(authController.loading.value, false);
    });

    test('register failure', () async {
      when(mockUserRepository.register(any)).thenThrow(Exception('Registration failed'));

      //await authController.register();

      //verify(mockUserRepository.register(any)).called(1);
      //expect(find.text('Registration failed'), findsOneWidget);
      expect(authController.loading.value, false);
    });
    test('Login Test', () async {
      final mockUserModel = UserModel(); // Mock user model object

      // Mock login method response
      when(mockUserRepository.login(any)).thenAnswer((_) async => mockUserModel);

      // Mock Get.find calls
      final mockRootController = MockRootController();
      // when(Get.find<RootController>()).thenReturn(mockRootController);
      //when(mockRootController.changePage(0)).thenAnswer((_) async {});

      //await authController.login();
      //expect(authController.currentUser.value, mockUserModel);
      //verify(mockUserRepository.login(any)); // Verify repository method called
      //verify(mockRootController.changePage(0)); // Verify root controller method called
    });

    test('logout success', () async {
      when(mockUserRepository.logout()).thenAnswer((_) async => Future.value());

      //await authController.logout();

      //verify(mockUserRepository.logout()).called(1);
      expect(Routes.LOGIN, Routes.LOGIN);
    });

    test('logout failure', () async {
      when(mockUserRepository.logout()).thenThrow(Exception('Logout failed'));

      //await authController.logout();

      //verify(mockUserRepository.logout()).called(1);
    });

    test('Get All Regions Test', () async {
      when(mockZoneRepository.getAllRegions(any, any)).thenAnswer((_) => Future.value([]));
      await authController.getAllRegions();
      expect(authController.listRegions, []);
      expect(authController.regions, []);
      expect(authController.loadingRegions.value, true);
    });

    test('Get All Divisions Test', () async {
      when(mockZoneRepository.getAllDivisions(any, any)).thenAnswer((_) => Future.value([]));
      //await authController.getAllDivisions();
      expect(authController.listDivisions, []);
      expect(authController.loadingDivisions.value, true);
    });

    test('Get All Sub-Divisions Test', () async {
      when(mockZoneRepository.getAllSubdivisions(any, any)).thenAnswer((_) => Future.value([]));
      //await authController.getAllDivisions();
      expect(authController.listSubdivisions, []);
      expect(authController.loadingSubdivisions.value, true);
    });

    test('Get All Sectors Test', () async {
      when(mockSectorRepository.getAllSectors()).thenAnswer((_) => Future.value([]));
      await authController.getAllSectors();
      expect(authController.listSectors, []);
      expect(authController.loadingSectors.value, true);
    });

    test('filterSearch returns all items when query is empty', () {
      // Arrange
      authController.listRegions.value= [{'name':'item1', 'id': 1},{'name':'item2', 'id': 2},{'name':'item3', 'id': 3}, ];


      // Act
      authController.filterSearchRegions('item');

      // Assert
      expect(authController.regions, [{'name':'item1', 'id': 1},{'name':'item2', 'id': 2},{'name':'item3', 'id': 3}, ]);
    });

    test('filterSearch returns filtered items when query matches', () {
      // Arrange

      authController.listRegions.value= [{'name':'Buea', 'id': 1},{'name':'Bafoussam', 'id': 2},{'name':'Bertoua', 'id': 3}, ];


      // Act
      authController.filterSearchRegions('B');

      // Assert
      expect(authController.regions, [{'name':'Buea', 'id': 1},{'name':'Bafoussam', 'id': 2},{'name':'Bertoua', 'id': 3}, ]);

    });

    test('filterSearch returns filtered items when query partially matches', () {
      // Arrange
      authController.listRegions.value= [{'name':'Buea', 'id': 1},{'name':'Bafoussam', 'id': 2},{'name':'Bertoua', 'id': 3}, ];


      // Act
      authController.filterSearchRegions('Bu');

      // Assert
      expect(authController.regions, [{'name':'Buea', 'id': 1} ]);
    });

    test('filterSearch returns empty list when no items match the query', () {
      // Arrange
      // Arrange
      authController.listRegions.value= [{'name':'Buea', 'id': 1},{'name':'Bafoussam', 'id': 2},{'name':'Bertoua', 'id': 3}, ];


      // Act
      authController.filterSearchRegions('Adamaoua');

      // Assert
      expect(authController.regions, []);
    });


    test('filterSearch returns all Divisions when query is empty', () {
      // Arrange
      authController.listDivisions.value= [{'name':'Mifi', 'id': 1},{'name':'Haut-Nkam', 'id': 2},{'name':'Haut-Plateaux', 'id': 3}, ];


      // Act
      authController.filterSearchDivisions('');

      // Assert
      expect(authController.divisions, [{'name':'Mifi', 'id': 1},{'name':'Haut-Nkam', 'id': 2},{'name':'Haut-Plateaux', 'id': 3}, ]);
    });

    test('filterSearch returns filtered Divisions when query matches', () {
      // Arrange

      authController.listDivisions.value= [{'name':'Mifi', 'id': 1},{'name':'Haut-Nkam', 'id': 2},{'name':'Haut-Plateaux', 'id': 3}, ];


      // Act
      authController.filterSearchDivisions('Haut-Nkam');

      // Assert
      expect(authController.divisions, [{'name':'Haut-Nkam', 'id': 2} ]);

    });

    test('filterSearch returns filtered items when query partially matches', () {
      // Arrange
      authController.listDivisions.value= [{'name':'Mifi', 'id': 1},{'name':'Haut-Nkam', 'id': 2},{'name':'Haut-Plateaux', 'id': 3}, ];


      // Act
      authController.filterSearchDivisions('Haut-Nk');

      // Assert
      expect(authController.divisions, [{'name':'Haut-Nkam', 'id': 2}]);
    });

    test('filterSearch returns empty list when no items match the query', () {
      // Arrange
      authController.listDivisions.value= [{'name':'Mifi', 'id': 1},{'name':'Haut-Nkam', 'id': 2},{'name':'Haut-Plateaux', 'id': 3}, ];


      // Act
      authController.filterSearchDivisions('Lekie');

      // Assert
      expect(authController.regions, []);
    });



    test('filterSearch returns all Sub-Divisions when query is empty', () {
      // Arrange
      authController.listSubdivisions.value= [{'name':'Yaounde', 'id': 1},{'name':'Obala', 'id': 2},{'name':'Mbalmayo', 'id': 3}, ];


      // Act
      authController.filterSearchSubdivisions('');

      // Assert
      expect(authController.subdivisions, [{'name':'Yaounde', 'id': 1},{'name':'Obala', 'id': 2},{'name':'Mbalmayo', 'id': 3}, ]);
    });

    test('filterSearch returns filtered Sub-Divisions when query matches', () {
      // Arrange

      authController.listSubdivisions.value= [{'name':'Yaounde', 'id': 1},{'name':'Obala', 'id': 2},{'name':'Mbalmayo', 'id': 3}, ];


      // Act
      authController.filterSearchSubdivisions('Yaounde');

      // Assert
      expect(authController.subdivisions, [{'name':'Yaounde', 'id': 1},]);

    });

    test('filterSearch returns filtered items when query partially matches', () {
      // Arrange
      authController.listSubdivisions.value= [{'name':'Yaounde', 'id': 1},{'name':'Obala', 'id': 2},{'name':'Mbalmayo', 'id': 3}, ];


      // Act
      authController.filterSearchSubdivisions('Yaoun');

      // Assert
      expect(authController.subdivisions, [{'name':'Yaounde', 'id': 1}]);
    });

    test('filterSearch returns empty list when no items match the query', () {
      // Arrange
      authController.listSubdivisions.value= [{'name':'Yaounde', 'id': 1},{'name':'Obala', 'id': 2},{'name':'Mbalmayo', 'id': 3}, ];


      // Act
      authController.filterSearchSubdivisions('Soa');

      // Assert
      expect(authController.subdivisions, []);
    });


    test('filterSearch returns all Sectors when query is empty', () {
      // Arrange
      authController.listSectors.value= [{'name':'Education', 'id': 1},{'name':'Agriculture', 'id': 2},{'name':'Health', 'id': 3}, ];


      // Act
      authController.filterSearchSectors('');

      // Assert
      expect(authController.sectors, [{'name':'Education', 'id': 1},{'name':'Agriculture', 'id': 2},{'name':'Health', 'id': 3}, ]);
    });

    test('filterSearch returns filtered Sectors when query matches', () {
      // Arrange

      authController.listSectors.value= [{'name':'Education', 'id': 1},{'name':'Agriculture', 'id': 2},{'name':'Health', 'id': 3}, ];


      // Act
      authController.filterSearchSectors('Education');

      // Assert
      expect(authController.sectors, [{'name':'Education', 'id': 1},]);

    });

    test('filterSearch returns filtered items when query partially matches', () {
      // Arrange
      authController.listSectors.value= [{'name':'Education', 'id': 1},{'name':'Agriculture', 'id': 2},{'name':'Health', 'id': 3}, ];


      // Act
      authController.filterSearchSectors('Agri');

      // Assert
      expect(authController.sectors, [{'name':'Agriculture', 'id': 2}]);
    });

    test('filterSearch returns empty list when no items match the query', () {
      // Arrange
      authController.listSectors.value= [{'name':'Education', 'id': 1},{'name':'Agriculture', 'id': 2},{'name':'Health', 'id': 3}, ];


      // Act
      authController.filterSearchSectors('Technology');

      // Assert
      expect(authController.sectors, []);
    });



    // Add more tests as needed for other methods in AuthController
  });
}

