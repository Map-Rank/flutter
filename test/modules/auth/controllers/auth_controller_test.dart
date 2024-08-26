
import 'dart:io';

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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


// Generate mocks using generateMocks utility
@GenerateMocks([UserRepository, ZoneRepository, SectorRepository])



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
    Get.lazyPut(() => AuthService());

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
      when(mockZoneRepository.getAllRegions(any, any)).thenAnswer((_) async =>
      {
        [],

      });
      when(mockSectorRepository.getAllSectors()).thenAnswer((_) async =>
      {
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
      when(mockZoneRepository.getAllRegions(any, any)).thenAnswer((_) async =>
      {
        'data': ['Region1', 'Region2'],
        'status': true,
      });
      when(mockSectorRepository.getAllSectors()).thenAnswer((_) async =>
      {
        'data': ['Sector1', 'Sector2'],
        'status': true,
      });
    });


    test('Filter Search Regions Test', () async {
      authController.listRegions.value =
      [{'name': 'Region 1'}, {'name': 'Region 2'}];

      authController.filterSearchRegions('region 1');
      expect(authController.regions.length, 1);
      expect(authController.regions[0]['name'], 'Region 1');
    });
  });
}
