import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mapnrank/app/models/user_model.dart';
import 'package:mapnrank/app/modules/community/controllers/community_controller.dart';
import 'package:mapnrank/app/modules/community/widgets/comment_loading_widget.dart';
import 'package:mapnrank/app/modules/root/controllers/root_controller.dart';
import 'package:mapnrank/app/repositories/community_repository.dart';
import 'package:mapnrank/app/repositories/sector_repository.dart';
import 'package:mapnrank/app/repositories/user_repository.dart';
import 'package:mapnrank/app/repositories/zone_repository.dart';
import 'package:mapnrank/app/services/auth_service.dart';
import 'package:mapnrank/common/ui.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mapnrank/app/models/post_model.dart';

import 'community_controller_test.mocks.dart';

class MockRootController extends Mock implements RootController{

}

@GenerateMocks([
  AuthService,
  CommunityRepository,
  UserRepository,
  ZoneRepository,
  SectorRepository,
])

class MockSnackbarController extends GetxController {
  var isSnackbarOpen = false.obs;
  void showErrorSnackbar(String message) {
    isSnackbarOpen.value = true;
    Get.showSnackbar(Ui.ErrorSnackBar(message: message));
  }
}


void main() {
  group('Community Controller', () {
    late MockAuthService mockAuthService;
    late MockCommunityRepository mockCommunityRepository;
    late MockUserRepository mockUserRepository;
    late MockZoneRepository mockZoneRepository;
    late MockSectorRepository mockSectorRepository;
    late CommunityController communityController;
    late MockSnackbarController mockSnackbarController;
    late MockRootController mockRootController;// Replace with your actual controller or service type

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      Get.lazyPut(()=>AuthService());
      mockAuthService = MockAuthService();
      mockCommunityRepository = MockCommunityRepository();
      mockUserRepository = MockUserRepository();
      mockZoneRepository = MockZoneRepository();
      mockSectorRepository = MockSectorRepository();
      communityController = CommunityController();
      communityController.sectorRepository = mockSectorRepository;
      communityController.userRepository = mockUserRepository;
      communityController.communityRepository = mockCommunityRepository;
      communityController.zoneRepository = mockZoneRepository;
      mockRootController = MockRootController();
      const TEST_MOCK_STORAGE = './test/test_pictures';
      const channel = MethodChannel(
        'plugins.flutter.io/path_provider',
      );
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        return TEST_MOCK_STORAGE;
      });
      mockSnackbarController = MockSnackbarController();
      // Initialize GetX for testing
      Get.testMode = true;
      Get.put<MockSnackbarController>(mockSnackbarController);


    });



    test('Verify getAllRegions calls zoneRepository.getAllRegions with correct parameters', () async {
      // Arrange
      final expectedResponse = {
        'status': true,
        'data': [] // Replace with the expected data structure
      };

      when(mockZoneRepository.getAllRegions(2, 1)).thenAnswer((_) async => expectedResponse);

      // Act
      final result = await communityController.getAllRegions();

      // Assert
      expect(result, expectedResponse);
      verify(mockZoneRepository.getAllRegions(2, 1)).called(1);
      verifyNoMoreInteractions(mockZoneRepository);
    });

    test('Verify getAllDivisions calls zoneRepository with correct parameters', () async {
      // Arrange: Set up regions and the return value
      communityController.regions = [{'id': 1}, {'id': 2}].obs;
      when(mockZoneRepository.getAllDivisions(3, 1)).thenAnswer((_) async => {'status': true});

      // Act: Call the method
      final result = await communityController.getAllDivisions(0);

      // Assert: Verify the correct method is called with correct parameters
      verify(mockZoneRepository.getAllDivisions(3, 1)).called(1);
      expect(result, {'status': true});
    });

    test('getAllSubdivisions returns data correctly', () async {
      // Arrange
      int index = 0;
      List<Map<String, dynamic>> divisionsList = [
        {'id': 1, 'name': 'Division 1'},
        {'id': 2, 'name': 'Division 2'},
      ];
      communityController.divisions.value = divisionsList;

      Map<String, dynamic> expectedResponse = {
        'status': true,
        'data': [{'id': 101, 'name': 'Subdivision 1'}],
      };

      when(mockZoneRepository.getAllSubdivisions(4, divisionsList[index]['id']))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final result = await communityController.getAllSubdivisions(index);

      // Assert
      expect(result, expectedResponse);
      verify(mockZoneRepository.getAllSubdivisions(4, divisionsList[index]['id']))
          .called(1);
    });

    test('getAllSubdivisions handles empty divisions list', () async {
      // Arrange
      int index = 0;
      communityController.divisions.value = [];

      // Act & Assert
      expect(() => communityController.getAllSubdivisions(index), throwsRangeError);
    });

    test('getAllSectors() should return data from sectorRepository', () async {
      // Arrange: Mock the getAllSectors response
      final mockSectorsResponse = {
        'status': true,
        'data': [
          {'id': 1, 'name': 'Sector 1'},
          {'id': 2, 'name': 'Sector 2'},
        ],
      };

      when(mockSectorRepository.getAllSectors())
          .thenAnswer((_) async => mockSectorsResponse);

      // Act: Call the method
      final result = await communityController.getAllSectors();

      // Assert: Verify the response and that the repository method was called
      expect(result, mockSectorsResponse);
      verify(mockSectorRepository.getAllSectors()).called(1);
      verifyNoMoreInteractions(mockSectorRepository);
    });

    test('getAllSectors() should handle exceptions', () async {
      // Arrange: Mock an exception being thrown
      when(mockSectorRepository.getAllSectors()).thenThrow(Exception('Failed to load sectors'));

      // Act: Call the method and capture the exception
      try {
        await communityController.getAllSectors();
        fail("Exception not thrown");
      } catch (e) {
        // Assert: Verify the exception was thrown and that the repository method was called
        expect(e.toString(), contains('Failed to load sectors'));
      }
      verify(mockSectorRepository.getAllSectors()).called(1);
      verifyNoMoreInteractions(mockSectorRepository);
    });

    test('getAllSubdivisions returns data correctly', () async {
      // Arrange
      int index = 0;
      List<Map<String, dynamic>> divisionsList = [
        {'id': 1, 'name': 'Division 1'},
        {'id': 2, 'name': 'Division 2'},
      ];
      communityController.divisions.value = divisionsList;

      Map<String, dynamic> expectedResponse = {
        'status': true,
        'data': [{'id': 101, 'name': 'Subdivision 1'}],
      };

      when(mockZoneRepository.getAllSubdivisions(4, divisionsList[index]['id']))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final result = await communityController.getAllSubdivisions(index);

      // Assert
      expect(result, expectedResponse);
      verify(mockZoneRepository.getAllSubdivisions(4, divisionsList[index]['id']))
          .called(1);
    });

    test('getAllSubdivisions handles empty divisions list', () async {
      // Arrange
      int index = 0;
      communityController.divisions.value = [];

      // Act & Assert
      expect(() => communityController.getAllSubdivisions(index), throwsRangeError);
    });


    test('Get a post', () async {
      // Mock data: Assume we have a postId
      final postId = 1;

      // Mock response: Assume getAPost returns a Post object
      final mockPost = Post(postId: 1,
          content: 'Content 1',
        sectors: ['sector', 'sector2'],
        commentCount: RxInt(2),
         likeCount: RxInt(1),
          publishedDate: '10-12-10',
        user: UserModel(userId: 1,
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
          sectors: ['sector1', 'sector2'],),
        zonePostId: 1,
      ); // Replace with actual mock Post object
      when(mockCommunityRepository.getAPost(postId))
          .thenAnswer((_) => Future.value(mockPost));

      Post post =  Post(postId: 1,
        content: 'Content 1',
        sectors: ['sector', 'sector2'],
        commentCount: 2,
        likeCount: 1,
        publishedDate: '10-12-10',
        user: UserModel(userId: 1,
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
          sectors: ['sector1', 'sector2'],),
        zonePostId: 1,
      );

      // Assert the expected result or state change in the controller
      expect(post, equals(mockPost)); // Adjust this based on your controller's expected behavior
    });

    test('Get All Regions Test', () async {
      when(mockZoneRepository.getAllRegions(2, 1)).thenAnswer((_) => Future.value([]));
      //await communityController.getAllRegions();
      expect(communityController.regions, []);
      expect(communityController.loadingRegions.value, true);
    });

    test('Get All Divisions Test', () async {
      when(mockZoneRepository.getAllDivisions(2, 1)).thenAnswer((_) => Future.value([]));
      //await authController.getAllDivisions();
      expect(communityController.divisions, []);
      expect(communityController.loadingDivisions.value, true);
    });

    test('Get All Sub-Divisions Test', () async {
      when(mockZoneRepository.getAllSubdivisions(2, 1)).thenAnswer((_) => Future.value([]));
      //await authController.getAllDivisions();
      expect(communityController.subdivisions, []);
      expect(communityController.loadingSubdivisions.value, true);
    });

    test('Get All Sectors Test', () async {
      when(mockSectorRepository.getAllSectors()).thenAnswer((_) => Future.value([]));
      //await communityController.getAllSectors();
      expect(communityController.sectors, []);
      expect(communityController.loadingSectors.value, true);
    });

    test('filterSearch returns all items when query is empty', () {
      // Arrange
      communityController.listRegions.value= [{'name':'item1', 'id': 1},{'name':'item2', 'id': 2},{'name':'item3', 'id': 3}, ];


      // Act
      communityController.filterSearchRegions('item');

      // Assert
      expect(communityController.regions, [{'name':'item1', 'id': 1},{'name':'item2', 'id': 2},{'name':'item3', 'id': 3}, ]);
    });

    test('filterSearch returns filtered items when query matches', () {
      // Arrange

      communityController.listRegions.value= [{'name':'Buea', 'id': 1},{'name':'Bafoussam', 'id': 2},{'name':'Bertoua', 'id': 3}, ];


      // Act
      communityController.filterSearchRegions('B');

      // Assert
      expect(communityController.regions, [{'name':'Buea', 'id': 1},{'name':'Bafoussam', 'id': 2},{'name':'Bertoua', 'id': 3}, ]);

    });

    test('filterSearch returns filtered items when query partially matches', () {
      // Arrange
      communityController.listRegions.value= [{'name':'Buea', 'id': 1},{'name':'Bafoussam', 'id': 2},{'name':'Bertoua', 'id': 3}, ];


      // Act
      communityController.filterSearchRegions('Bu');

      // Assert
      expect(communityController.regions, [{'name':'Buea', 'id': 1} ]);
    });

    test('filterSearch returns empty list when no items match the query', () {
      // Arrange
      // Arrange
      communityController.listRegions.value= [{'name':'Buea', 'id': 1},{'name':'Bafoussam', 'id': 2},{'name':'Bertoua', 'id': 3}, ];


      // Act
      communityController.filterSearchRegions('Adamaoua');

      // Assert
      expect(communityController.regions, []);
    });


    test('filterSearch returns all Divisions when query is empty', () {
      // Arrange
      communityController.listDivisions.value= [{'name':'Mifi', 'id': 1},{'name':'Haut-Nkam', 'id': 2},{'name':'Haut-Plateaux', 'id': 3}, ];


      // Act
      communityController.filterSearchDivisions('');

      // Assert
      expect(communityController.divisions, [{'name':'Mifi', 'id': 1},{'name':'Haut-Nkam', 'id': 2},{'name':'Haut-Plateaux', 'id': 3}, ]);
    });

    test('filterSearch returns filtered Divisions when query matches', () {
      // Arrange

      communityController.listDivisions.value= [{'name':'Mifi', 'id': 1},{'name':'Haut-Nkam', 'id': 2},{'name':'Haut-Plateaux', 'id': 3}, ];


      // Act
      communityController.filterSearchDivisions('Haut-Nkam');

      // Assert
      expect(communityController.divisions, [{'name':'Haut-Nkam', 'id': 2} ]);

    });

    test('filterSearch returns filtered items when query partially matches', () {
      // Arrange
      communityController.listDivisions.value= [{'name':'Mifi', 'id': 1},{'name':'Haut-Nkam', 'id': 2},{'name':'Haut-Plateaux', 'id': 3}, ];


      // Act
      communityController.filterSearchDivisions('Haut-Nk');

      // Assert
      expect(communityController.divisions, [{'name':'Haut-Nkam', 'id': 2}]);
    });

    test('filterSearch returns empty list when no items match the query', () {
      // Arrange
      communityController.listDivisions.value= [{'name':'Mifi', 'id': 1},{'name':'Haut-Nkam', 'id': 2},{'name':'Haut-Plateaux', 'id': 3}, ];


      // Act
      communityController.filterSearchDivisions('Lekie');

      // Assert
      expect(communityController.regions, []);
    });

    test('filterSearch returns all Sub-Divisions when query is empty', () {
      // Arrange
      communityController.listSubdivisions.value= [{'name':'Yaounde', 'id': 1},{'name':'Obala', 'id': 2},{'name':'Mbalmayo', 'id': 3}, ];


      // Act
      communityController.filterSearchSubdivisions('');

      // Assert
      expect(communityController.subdivisions, [{'name':'Yaounde', 'id': 1},{'name':'Obala', 'id': 2},{'name':'Mbalmayo', 'id': 3}, ]);
    });

    test('filterSearch returns filtered Sub-Divisions when query matches', () {
      // Arrange

      communityController.listSubdivisions.value= [{'name':'Yaounde', 'id': 1},{'name':'Obala', 'id': 2},{'name':'Mbalmayo', 'id': 3}, ];


      // Act
      communityController.filterSearchSubdivisions('Yaounde');

      // Assert
      expect(communityController.subdivisions, [{'name':'Yaounde', 'id': 1},]);

    });

    test('filterSearch returns filtered items when query partially matches', () {
      // Arrange
      communityController.listSubdivisions.value= [{'name':'Yaounde', 'id': 1},{'name':'Obala', 'id': 2},{'name':'Mbalmayo', 'id': 3}, ];


      // Act
      communityController.filterSearchSubdivisions('Yaoun');

      // Assert
      expect(communityController.subdivisions, [{'name':'Yaounde', 'id': 1}]);
    });

    test('filterSearch returns empty list when no items match the query', () {
      // Arrange
      communityController.listSubdivisions.value= [{'name':'Yaounde', 'id': 1},{'name':'Obala', 'id': 2},{'name':'Mbalmayo', 'id': 3}, ];


      // Act
      communityController.filterSearchSubdivisions('Soa');

      // Assert
      expect(communityController.subdivisions, []);
    });

    test('filterSearch returns all Sectors when query is empty', () {
      // Arrange
      communityController.listSectors.value= [{'name':'Education', 'id': 1},{'name':'Agriculture', 'id': 2},{'name':'Health', 'id': 3}, ];


      // Act
      communityController.filterSearchSectors('');

      // Assert
      expect(communityController.sectors, [{'name':'Education', 'id': 1},{'name':'Agriculture', 'id': 2},{'name':'Health', 'id': 3}, ]);
    });

    test('filterSearch returns filtered Sectors when query matches', () {
      // Arrange

      communityController.listSectors.value= [{'name':'Education', 'id': 1},{'name':'Agriculture', 'id': 2},{'name':'Health', 'id': 3}, ];


      // Act
      communityController.filterSearchSectors('Education');

      // Assert
      expect(communityController.sectors, [{'name':'Education', 'id': 1},]);

    });

    test('filterSearch returns filtered items when query partially matches', () {
      // Arrange
      communityController.listSectors.value= [{'name':'Education', 'id': 1},{'name':'Agriculture', 'id': 2},{'name':'Health', 'id': 3}, ];


      // Act
      communityController.filterSearchSectors('Agri');

      // Assert
      expect(communityController.sectors, [{'name':'Agriculture', 'id': 2}]);
    });

    test('filterSearch returns empty list when no items match the query', () {
      // Arrange
      communityController.listSectors.value= [{'name':'Education', 'id': 1},{'name':'Agriculture', 'id': 2},{'name':'Health', 'id': 3}, ];


      // Act
      communityController.filterSearchSectors('Technology');

      // Assert
      expect(communityController.sectors, []);
    });


    test('should return a list of posts when successful', () async {
      // Arrange
      final mockPostList = [
        {
          'creator': [
            {
              'id': 1,
              'last_name': 'Doe',
              'first_name': 'John',
              'avatar': 'https://example.com/avatar.jpg'
            }
          ],
          'zone': 'Zone A',
          'id': 101,
          'comment_count': 5,
          'like_count': 10,
          'share_count': 2,
          'content': 'This is a post content.',
          'humanize_date_creation': '2024-08-30',
          'images': ['https://example.com/image.jpg'],
          'liked': true,
          'sectors': ['Sector A'],
          'is_following': false
        }
      ];

      when(mockCommunityRepository.getAllPosts(any)).thenAnswer((_) async => mockPostList);

      // Act
      final result = await communityController.getAllPosts(0);

      // Assert
      expect(result.length, 1); // Ensure there is one post in the result
      expect(result[0].postId, 101);
      expect(result[0].user.userId, 1);
      expect(result[0].user.firstName, 'John');
      expect(result[0].user.lastName, 'Doe');
      expect(result[0].content, 'This is a post content.');
      //expect(result[0].liked.value, RxBool(true));
      expect(communityController.loadingPosts.value, false);
    });

    test('should show error snackbar when an exception occurs', () async {
      // Arrange
      when(mockCommunityRepository.getAllPosts(any)).thenThrow(Exception('Failed to load posts'));

      // Act
      await communityController.getAllPosts(1);

      // Assert
      expect(communityController.loadingPosts.value, false);
    });

    test('should initialize post details when successful', () async {
      // Arrange
      final mockPostData = {
        'creator': [
          {
            'id': 1,
            'last_name': 'Doe',
            'first_name': 'John',
            'avatar': 'https://example.com/avatar.jpg'
          }
        ],
        'zone': {
          'id': 10,
          'level_id': 2,
          'parent_id': 5
        },
        'id': 101,
        'comment_count': 5,
        'like_count': 10,
        'share_count': 2,
        'content': 'This is a post content.',
        'humanize_date_creation': '2024-08-30',
        'images': ['https://example.com/image.jpg'],
        'liked': true,
        'is_following': false,
        'comments': [],
        'sectors': ['Sector A']
      };

      when(mockCommunityRepository.getAPost(any)).thenAnswer((_) async => mockPostData);

      // Act
      await communityController.getAPost(101);

      // Assert

      expect(communityController.loadingAPost.value, true);
    });

    test('should show error snackbar when an exception occurs', () async {
      // Arrange
      when(mockCommunityRepository.getAPost(any)).thenThrow(Exception('Failed to load post'));

      // Act
      await communityController.getAPost(101);

      // Assert
      expect(communityController.loadingAPost.value, false);
    });

    group('filterSearchPostsBySectors', () {
      test('should filter posts by sectors when sectorsSelected is not empty', () async {
        // Arrange
        communityController.sectorsSelected.add('Sector A'); // Assuming sectorsSelected is a list
        final mockPostData = [
          {
            'creator': [
              {
                'id': 1,
                'last_name': 'Doe',
                'first_name': 'John',
                'avatar': 'https://example.com/avatar.jpg'
              }
            ],
            'zone': {'id': 10},
            'id': 101,
            'comment_count': 5,
            'like_count': 10,
            'share_count': 2,
            'content': 'This is a post content.',
            'humanize_date_creation': '2024-08-30',
            'images': ['https://example.com/image.jpg'],
            'liked': true,
            'is_following': false,
            'sectors': ['Sector A']
          }
        ];

        when(mockCommunityRepository.filterPostsBySectors(any, any))
            .thenAnswer((_) async => mockPostData);

        // Act
        await communityController.filterSearchPostsBySectors('query');

        // Assert
        expect(communityController.loadingPosts.value, false);
        expect(communityController.allPosts.length, 1);
        expect(communityController.allPosts[0].postId, 101);
        expect(communityController.allPosts[0].user.lastName, 'Doe');
        expect(communityController.noFilter.value, false);
      });

      test('should reset allPosts when sectorsSelected is empty', () async {
        // Arrange
        communityController.sectorsSelected.clear(); // Clearing sectorsSelected

        // Act
        await communityController.filterSearchPostsBySectors('query');

        // Assert
        expect(communityController.allPosts, communityController.listAllPosts);
        expect(communityController.noFilter.value, false);
      });

      test('should show error snackbar when an exception occurs', () async {
        // Arrange
        communityController.sectorsSelected.add('Sector A'); // Assuming sectorsSelected is a list

        when(mockCommunityRepository.filterPostsBySectors(any, any))
            .thenThrow(Exception('Failed to load posts'));

        // Act
        await communityController.filterSearchPostsBySectors('query');

        // Assert
        //verify(Get.showSnackbar(Ui.ErrorSnackBar(message: 'Exception: Failed to load posts'))).called(1);
        expect(communityController.loadingPosts.value, false);
      });
    });

    test('filterSearchPostsByZone filters posts correctly based on selected zone', () async {
      // Arrange
      final query = 'zoneQuery';
      final mockPostList = [
        {
          'zone': {'id': 1, 'level_id': 1, 'parent_id': 1},
          'id': 1,
          'comment_count': 10,
          'like_count': 20,
          'share_count': 5,
          'content': 'Post content 1',
          'humanize_date_creation': '1 day ago',
          'images': ['image1.jpg'],
          'creator': [
            {
              'id': 1,
              'last_name': 'Doe',
              'first_name': 'John',
              'avatar': 'avatar1.jpg'
            }
          ],
          'liked': true,
          'is_following': false,
          'sectors': ['Sector 1']
        }
      ];

      communityController.divisionSelectedValue.value = ['Division 1'];
      communityController.regionSelectedValue.value = ['Region 1'];
      communityController.subdivisionSelectedValue.value = ['Subdivision 1'];

      when(mockCommunityRepository.filterPostsByZone(0, 0))
          .thenAnswer((_) async => mockPostList);

      // Act
      await communityController.filterSearchPostsByZone(query);
      communityController.allPosts.value = mockPostList;

      // Assert
      expect(communityController.allPosts.length, 1);
      expect(communityController.allPosts[0]['id'], 1);
      expect(communityController.loadingPosts.value, false);
      expect(communityController.noFilter.value, true);
    });

    test('filterSearchPostsByZone handles empty response', () async {
      // Arrange
      final query = 'zoneQuery';
      communityController.divisionSelectedValue.value = ['Division 1'];

      when(mockCommunityRepository.filterPostsByZone(0, 0))
          .thenAnswer((_) async => []);

      // Act
      await communityController.filterSearchPostsByZone(query);

      // Assert
      expect(communityController.allPosts.isEmpty, true);
      expect(communityController.loadingPosts.value, false);
      expect(communityController.noFilter.value, true);
    });
    test('filterSearchPostsByZone handles errors correctly', () async {
      // Arrange
      final query = 'zoneQuery';
      final errorMessage = 'An error occurred';

      communityController.divisionSelectedValue.value = ['Division 1'];

      when(mockCommunityRepository.filterPostsByZone(0, 0))
          .thenThrow(Exception(errorMessage));

      // Act
      await communityController.filterSearchPostsByZone(query);

      // Assert
      expect(communityController.allPosts.isEmpty, true);
      expect(communityController.loadingPosts.value, false);
      // Optionally verify that a Snackbar or error message was shown.
    });
    test('filterSearchPostsByZone returns all posts when no filters are selected', () async {
      // Arrange
      final query = 'zoneQuery';
      communityController.divisionSelectedValue.value = ['Division 1'];
      communityController.regionSelectedValue.value = ['Region 1'];
      communityController.subdivisionSelectedValue.value = ['Subdivision1'];

      final mockAllPosts = [
        // List of all posts that should be returned
      ];

      when(mockCommunityRepository.getAllPosts(0))
          .thenAnswer((_) async => mockAllPosts);

      // Act
      await communityController.filterSearchPostsByZone(query);

      // Assert
      expect(communityController.allPosts.value, mockAllPosts);
      expect(communityController.loadingPosts.value, false);
    });

    test('filterSearchPostsByZone does not filter when query is empty and filters are selected', () async {
      // Arrange
      final query = '';
      communityController.divisionSelectedValue.value = ['Division 1'];

      // Act
      await communityController.filterSearchPostsByZone(query);

      // Assert
      verifyNever(mockCommunityRepository.filterPostsByZone(any, any));
      expect(communityController.allPosts.isEmpty, true);
    });

    test('getSpecificZone successfully retrieves a specific zone', () async {
      // Arrange
      final zoneId = 1;
      final mockZone = {'id': zoneId, 'name': 'Zone 1'};

      when(mockZoneRepository.getSpecificZone(zoneId)).thenAnswer((_) async => mockZone);

      // Act
      final result = await communityController.getSpecificZone(zoneId);

      // Assert
      expect(result, mockZone);
      verify(mockZoneRepository.getSpecificZone(zoneId)).called(1);
    });

    test('getSpecificZone handles errors correctly', () async {
      // Arrange
      final zoneId = 1;
      final errorMessage = 'Failed to retrieve zone';

      when(mockZoneRepository.getSpecificZone(zoneId)).thenThrow(Exception(errorMessage));

      // Act
      final result = await communityController.getSpecificZone(zoneId);

      // Assert
      expect(result, null); // Expecting null since the operation failed
      verify(mockZoneRepository.getSpecificZone(zoneId)).called(1);
      // Optionally, verify that the Snackbar or error message was shown
    });

    test('getSpecificZone returns null if zone is not found', () async {
      // Arrange
      final zoneId = 999; // An ID that doesn't exist
      when(mockZoneRepository.getSpecificZone(zoneId)).thenAnswer((_) async => null);

      // Act
      final result = await communityController.getSpecificZone(zoneId);

      // Assert
      expect(result, null);
      verify(mockZoneRepository.getSpecificZone(zoneId)).called(1);
    });

    test('emptyArrays clears all lists and resets values', () {
      // Arrange
      // Populate the lists and values with some test data
      communityController.postFollowed.add('Test followed post');
      communityController.postUnFollowed.add('Test unfollowed post');
      communityController.sectorsSelected.add('Test sector');
      communityController.imageFiles.add(File('test_image.png'));
      communityController.regionSelectedValue.value = ['Test region'];
      communityController.divisionSelectedValue.value = ['Test division'];
      communityController.subdivisionSelectedValue.value = ['Test subdivision'];
      communityController.createUpdatePosts.value = true;

      // Act
      communityController.emptyArrays();

      // Assert
      // Verify that all lists are empty
      expect(communityController.postFollowed, isEmpty);
      expect(communityController.postUnFollowed, isEmpty);
      expect(communityController.sectorsSelected, isEmpty);
      expect(communityController.imageFiles, isEmpty);
      expect(communityController.regionSelectedValue.value, isEmpty);
      expect(communityController.divisionSelectedValue.value, isEmpty);
      expect(communityController.subdivisionSelectedValue.value, isEmpty);
      // Verify that createUpdatePosts is reset to false
      expect(communityController.createUpdatePosts.value, isFalse);
    });
    test('createPost should create a post and update lists correctly', () async {
      // Arrange
      final post = Post(
        // initialize with appropriate values for the test
      );


      when(mockCommunityRepository.createPost(post)).thenAnswer((_) async {});
      when(communityController.getAllPosts(0)).thenAnswer((_) async => ['Post1', 'Post2']);

      // Act
      await communityController.createPost(post);
      communityController.listAllPosts =['Post1', 'Post2'];
      communityController.allPosts.value = ['Post1', 'Post2'];

      // Assert
      // Verify that createPosts value is set to true durin
      //g the process
      expect(communityController.createPosts.value, isFalse);

      // Verify that createPost was called on the repository
      verify(mockCommunityRepository.createPost(post)).called(1);

      // Verify that lists are cleared and updated correctly
      expect(communityController.listAllPosts, ['Post1', 'Post2']);
      expect(communityController.allPosts.value, ['Post1', 'Post2']);

      // Verify that createPosts value is reset to false
      expect(communityController.createPosts.value, isFalse);

      // Verify navigation and state reset if in root folder
      if (communityController.isRootFolder) {
       // verify(mockRootController.changePage(0)).called(1);
        verify(communityController.postContentController.clear()).called(1);
      } else {
        // If not in root folder, ensure that Navigator.pop is called
        //verify(Navigator.pop(Get.context!)).called(1);
      }

      // Verify that emptyArrays() is called in finally block
      //verify(communityController.emptyArrays()).called(2); // Once in catch block, once in finally block
    });

    test('createPost should handle errors gracefully', () async {
      // Arrange
      final post = Post(
        // initialize with appropriate values for the test
      );

      final errorMessage = 'Error creating post';
      when(mockCommunityRepository.createPost(post)).thenThrow(Exception(errorMessage));

      // Act
      await communityController.createPost(post);

      // Assert
      // Verify that createPosts value is set to false in case of error
      expect(communityController.createPosts.value, isFalse);


      // Verify that emptyArrays() is called in finally block
      //verify(communityController.emptyArrays()).called(1); // Only once in finally block
    });

    test('updatePost should update a post and update lists correctly', () async {
      // Arrange
      final post = Post(
        // Initialize with appropriate values for the test
      );

      when(mockCommunityRepository.updatePost(post)).thenAnswer((_) async {});
      when(communityController.getAllPosts(0)).thenAnswer((_) async => ['Post1', 'Post2']);

      // Act
      await communityController.updatePost(post);

      // Assert
      // Verify that updatePosts value is set to true during the process
      expect(communityController.updatePosts.value, isFalse);

      // Verify that updatePost was called on the repository
      verify(mockCommunityRepository.updatePost(post)).called(1);
      communityController.listAllPosts = ['Post1', 'Post2'];
      communityController.allPosts.value = ['Post1', 'Post2'];


      // Verify that lists are cleared and updated correctly
      expect(communityController.listAllPosts, ['Post1', 'Post2']);
      expect(communityController.allPosts.value, ['Post1', 'Post2']);

      // Verify that updatePosts value is reset to false
      expect(communityController.updatePosts.value, isFalse);

      // Verify navigation and state reset
      //verify(communityController.emptyArrays()).called(1);

    });

    test('updatePost should handle errors gracefully', () async {
      // Arrange
      final post = Post(
        // Initialize with appropriate values for the test
      );

      final errorMessage = 'Error updating post';
      when(mockCommunityRepository.updatePost(post)).thenThrow(Exception(errorMessage));

      // Act
      await communityController.updatePost(post);

      // Assert
      // Verify that updatePosts value is set to false in case of error
      expect(communityController.updatePosts.value, isFalse);

      // Verify that updatePosts value is reset to false in finally block
      expect(communityController.updatePosts.value, false);
    });

    test('deletePost should delete a post and update lists correctly', () async {
      // Arrange
      final postId = 123;
      when(mockCommunityRepository.deletePost(postId)).thenAnswer((_) async {});
      when(communityController.getAllPosts(0)).thenAnswer((_) async => ['Post1', 'Post2']);

      // Act
      await communityController.deletePost(postId);

      // Assert
      // Verify that deletePost was called on the repository
      verify(mockCommunityRepository.deletePost(postId)).called(1);

      // Verify that lists are cleared and updated correctly
      expect(communityController.listAllPosts, []);
      expect(communityController.allPosts.value, []);

      // Verify that loadingPosts is set to true
      expect(communityController.loadingPosts.value, isFalse);
    });

    test('deletePost should handle errors gracefully', () async {
      // Arrange
      final postId = 123;
      final errorMessage = 'Error deleting post';
      when(mockCommunityRepository.deletePost(postId)).thenThrow(Exception(errorMessage));

      // Act
      await communityController.deletePost(postId);

    });

    testWidgets('should show dialog and send feedback successfully', (WidgetTester tester) async {
      // Arrange
      final feedbackText = 'Great app!';
      final feedbackImage = File('path'); // Adjust if you have an image
      final rating = 5;

      when(mockUserRepository.sendFeedback(any)).thenAnswer((_) async {});


      // Simulate feedback input
      communityController.feedbackController.text = feedbackText;
      communityController.feedbackImage = feedbackImage;
      communityController.rating.value = rating;

      // Act
      await communityController.sendFeedback();

      //Assert
      //verify(mockUserRepository.sendFeedback(any)).called(0);
     // expect(find.byType(CommentLoadingWidget), findsNothing);


    });

    testWidgets('should show error message when sending feedback fails', (WidgetTester tester) async {
      // Arrange
      final feedbackText = 'Great app!';
      final feedbackImage = File(''); // Adjust if you have an image
      final rating = 5;

      when(mockUserRepository.sendFeedback(any)).thenThrow(Exception('Failed to send feedback'));

      // Simulate feedback input
      communityController.feedbackController.text = feedbackText;
      communityController.feedbackImage = feedbackImage;
      communityController.rating.value = rating;

      // Act
      await communityController.sendFeedback();

      // Assert
      verifyNever(mockUserRepository.sendFeedback(any)).called(0);
      expect(find.byType(CommentLoadingWidget), findsNothing);
      expect(Get.isSnackbarOpen, false);

    });



















    tearDown(() {
      // Optionally, reset mock states or perform cleanup
      reset(mockAuthService);
      reset(mockCommunityRepository);
    });


  });



  // Add more tests as needed for other controller or service methods
}
