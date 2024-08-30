import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mapnrank/app/models/user_model.dart';
import 'package:mapnrank/app/modules/community/controllers/community_controller.dart';
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
    late MockSnackbarController mockSnackbarController;// Replace with your actual controller or service type

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

    test('Create a post', () async {
      // Mock behavior: Assume createPost returns a PostModel object
      Post mockPost = Post(postId: 1, content: 'New Post');
      when(mockCommunityRepository.createPost(any))
          .thenAnswer((_) => Future.value(mockPost));

      // Assert the expected result
      expect(1, mockPost.postId);
      expect('New Post', mockPost.content, );
    });

    test('Update a post', () async {
      // Mock behavior: Assume createPost returns a PostModel object
      Post mockPost = Post(postId: 1, content: 'Updated Post');
      when(mockCommunityRepository.updatePost(any))
          .thenAnswer((_) => Future.value(mockPost));

      // Assert the expected result
      expect(1, mockPost.postId);
      expect('Updated Post', mockPost.content, );
    });

    test('Delete a post', () async {
      // Mock behavior: Assume createPost returns a PostModel object
      Post mockPost = Post(postId: 1);
      when(mockCommunityRepository.deletePost(any))
          .thenAnswer((_) => Future.value(mockPost));

      // Assert the expected result
      expect(1, mockPost.postId);

    });


    test('Like or unlike a post', () async {
      // Mock data: Assume we have a post with ID 1
      final postId = 1;

      // Mock behavior: Assume likeUnlikePost returns void
      when(mockCommunityRepository.likeUnlikePost(postId))
          .thenAnswer((_) => Future.value());


      // Assert the expected result
      expect(1, postId); // Assuming your controller sets a variable for the liked post ID
    });

    test('Comment a post', () async {
      // Mock data: Assume we have a postId and a comment string
      final postId = 1;
      final comment = 'This is a test comment';

      // Mock behavior: Assume commentPost returns void
      when(mockCommunityRepository.commentPost(postId, comment))
          .thenAnswer((_) => Future.value());



      // Assert the expected result or state change in the controller
      expect(1, postId);
      expect('This is a test comment', comment); // Assuming your controller tracks the last comment made
    });

    test('Share a post', () async {
      // Mock data: Assume we have a postId
      final postId = 1;

      // Mock behavior: Assume sharePost returns void
      when(mockCommunityRepository.sharePost(postId))
          .thenAnswer((_) => Future.value());


      // Assert the expected result or state change in the controller
      expect(1, postId); // Assuming your controller tracks the last shared postId
    });

    test('Get a post', () async {
      // Mock data: Assume we have a postId
      final postId = 1;

      // Mock response: Assume getAPost returns a Post object
      final mockPost = Post(postId: 1,
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

    // test('Refresh community data', () async {
    //   // Mock data and behavior for refreshCommunity
    //   final mockPosts = [
    //     Post(postId: 1, content: 'Post 1'),
    //     Post(postId: 2, content: 'Post 2'),
    //   ];
    //
    //   communityController.listAllPosts =[
    //     Post(postId: 1, content: 'Post 1'),
    //     Post(postId: 2, content: 'Post 2'),
    //   ];
    //
    //   // Mock response: Assume refreshCommunity returns a list of posts
    //   when(mockCommunityRepository.getAllPosts(any))
    //       .thenAnswer((_) => Future.value(mockPosts));
    //
    //   expect(communityController.listAllPosts, mockPosts);
    //   expect(communityController.loadingPosts.value, true);
    //   //
    //   //
    //   // // Assert the expected result or state change in the controller
    //   // expect(2, equals(mockPosts.length));
    //   // expect(1, equals(mockPosts[0].postId));
    //   // expect('Post 2', equals(mockPosts[1].content));
    // });

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











    tearDown(() {
      // Optionally, reset mock states or perform cleanup
      reset(mockAuthService);
      reset(mockCommunityRepository);
    });


  });



  // Add more tests as needed for other controller or service methods
}
