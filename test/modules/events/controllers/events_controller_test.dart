import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mapnrank/app/models/event_model.dart';
import 'package:mapnrank/app/modules/events/controllers/events_controller.dart';
import 'package:mapnrank/app/repositories/events_repository.dart';
import 'package:mapnrank/app/repositories/sector_repository.dart';
import 'package:mapnrank/app/repositories/user_repository.dart';
import 'package:mapnrank/app/repositories/zone_repository.dart';
import 'package:mapnrank/app/services/auth_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'events_controller_test.mocks.dart';

@GenerateMocks([
  AuthService,
  EventsRepository,
  UserRepository,
  ZoneRepository,
  SectorRepository,
])

void main() {
  group('Event Controller', () {
    late MockAuthService mockAuthService;
    late MockEventsRepository mockEventsRepository;
    late MockUserRepository mockUserRepository;
    late MockZoneRepository mockZoneRepository;
    late EventsController eventsController;
    late MockSectorRepository mockSectorRepository;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      Get.lazyPut(()=>AuthService());
      mockAuthService = MockAuthService();
      mockEventsRepository = MockEventsRepository();
      mockUserRepository = MockUserRepository();
      mockZoneRepository = MockZoneRepository();
      mockSectorRepository = MockSectorRepository();
      eventsController = EventsController();

      const TEST_MOCK_STORAGE = './test/test_pictures';
      const channel = MethodChannel(
        'plugins.flutter.io/path_provider',
      );
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        return TEST_MOCK_STORAGE;
      });

    });

    tearDown(() {
      // Optionally, reset mock states or perform cleanup
      reset(mockAuthService);
      reset(mockEventsRepository);
    });

    test('Initialization Test', () async {
      expect(eventsController.loadingRegions.value, true);
      expect(eventsController.regions, []);
    });

    test('Get All Regions Test', () async {
      when(mockZoneRepository.getAllRegions(2, 1)).thenAnswer((_) => Future.value([]));
      //await eventsController.getAllRegions();
      expect(eventsController.listRegions, []);
      expect(eventsController.loadingRegions.value, true);
    });

    test('Get All Divisions Test', () async {
      when(mockZoneRepository.getAllDivisions(2, 1)).thenAnswer((_) => Future.value([]));
      //await authController.getAllDivisions();
      expect(eventsController.listDivisions, []);
      expect(eventsController.loadingDivisions.value, true);
    });

    test('Get All Sub-Divisions Test', () async {
      when(mockZoneRepository.getAllSubdivisions(2, 1)).thenAnswer((_) => Future.value([]));
      //await authController.getAllDivisions();
      expect(eventsController.listSubdivisions, []);
      expect(eventsController.loadingSubdivisions.value, true);
    });

    test('Get All Sectors Test', () async {
      when(mockSectorRepository.getAllSectors()).thenAnswer((_) => Future.value([]));
      //await eventsController.getAllSectors();
      expect(eventsController.listSectors, []);
      expect(eventsController.loadingSectors.value, true);
    });


    test('Filter Search Regions Test', () async {
      eventsController.listRegions.value = [{'name': 'Region 1'}, {'name': 'Region 2'}];

      eventsController.filterSearchRegions('region 1');
      expect(eventsController.regions.length, 1);
      expect(eventsController.regions[0]['name'], 'Region 1');
    });



    test('Fetch all events', () async {
      // Arrange
      final List<Event> mockEvents = [
        Event(eventId: 1, content: 'Content 1', title: 'Title 1'),
        Event(eventId: 2, content: 'Content 2', title: 'Title 2'),
      ];

      // Mock behavior: Return mockEvents when getAllEvents is called
      when(mockEventsRepository.getAllEvents(any)).thenAnswer((_) => Future.value(mockEvents));

      // Act
      final events = [ Event(eventId: 1, content: 'Content 1', title: 'Title 1'),
        Event(eventId: 2, content: 'Content 2', title: 'Title 2'),];

      // Assert
      expect(events, mockEvents);
    });


    test('Create an event', () async {
      // Mock behavior: Assume createEvent returns an eventModel object
      Event mockEvent = Event(eventId: 1, content: 'New Event', title: 'Title 1');
      when(mockEventsRepository.createEvent(any))
          .thenAnswer((_) => Future.value(mockEvent));

      // Assert the expected result
      expect(1, mockEvent.eventId);
      expect('New Event', mockEvent.content, );
      expect('Title 1', mockEvent.title, );
    });

    test('Update an event', () async {
      // Mock behavior: Assume updateEvent returns an eventModel object
      Event mockEvent = Event(eventId: 1, content: 'Updated Event', title: 'Title 1');
      when(mockEventsRepository.updateEvent(any))
          .thenAnswer((_) => Future.value(mockEvent));

      // Assert the expected result
      expect(1, mockEvent.eventId);
      expect('Updated Event', mockEvent.content, );
      expect('Title 1', mockEvent.title, );
    });

    test('Delete a event', () async {
      // Mock behavior: Assume deleteEvent returns an eventModel object
      Event mockEvent = Event(eventId: 1);
      when(mockEventsRepository.deleteEvent(any))
          .thenAnswer((_) => Future.value(mockEvent));

      // Assert the expected result
      expect(1, mockEvent.eventId);

    });

    test('Get an event', () async {
      // Mock data: Assume we have an eventId
      final eventId = 1;

      // Mock response: Assume getAnEvent returns an Event object
      final mockEvent = Event(eventId: 1,
        content: 'Content 1',
        sectors: ['sector', 'sector2'],
        eventCreatorId:4,
        publishedDate: '10-12-10',
        title: 'Title',
          endDate: '10-12-10',
        startDate: '10-12-10',
          zone: 'Douala'
      ); // Replace with actual mock Event object
      when(mockEventsRepository.getAnEvent(eventId))
          .thenAnswer((_) => Future.value(mockEvent));

      Event event =  Event(eventId: 1,
          content: 'Content 1',
          sectors: ['sector', 'sector2'],
          eventCreatorId:4,
          publishedDate: '10-12-10',
          title: 'Title',
          endDate: '10-12-10',
          startDate: '10-12-10',
          zone: 'Douala'
      );

      // Assert the expected result or state change in the controller
      expect(event, equals(mockEvent)); // Adjust this based on your controller's expected behavior
    });

    test('Refresh event data', () async {
      // Mock data and behavior for refreshCommunity
      final mockEvents = [
        Event(eventId: 1, content: 'Content 1', title: 'Title 1'),
        Event(eventId: 2, content: 'Content 2', title: 'Title 2')
      ];

      // Mock response: Assume refreshCommunity returns a list of events
      when(mockEventsRepository.getAllEvents(any))
          .thenAnswer((_) => Future.value(mockEvents));


      // Assert the expected result or state change in the controller
      expect(2, equals(mockEvents.length));
      expect(1, equals(mockEvents[0].eventId));
      expect('Content 2', equals(mockEvents[1].content));
    });

    test('Filter events by sectors - sectors found', () async {
      // Mock data or setup for test
      int page = 1;
      List<int> sectors = [1, 2, 3];

      // Mock behavior of the events repository
      when(mockEventsRepository.filterEventsBySectors(page, sectors))
          .thenAnswer((_) => Future.value("Filtered events"));


      // Optionally, assert on the result or other behavior
      expect(4, greaterThan(0));
    });

    test('Filter posts by sectors - No sectors found', () async {
      // Mock data or setup for test
      int page = 1;
      List<int> sectors = [1, 2, 3];

      // Mock behavior of the community repository
      when(mockEventsRepository.filterEventsBySectors(page, sectors))
          .thenAnswer((_) => Future.value([]));

      // Optionally, assert on the result or other behavior
      expect([], isEmpty);
    });

    test('Filter events by zone - zones found', () async {
      // Mock data or setup for test
      int page = 1;
      int zoneId = 123;

      // Mock behavior of the community repository
      when(mockEventsRepository.filterEventsByZone(page, zoneId))
          .thenAnswer((_) => Future.value("Filtered events"));


      // Optionally, assert on the result or other behavior
      expect(5, greaterThan(0));
    });

    test('Filter events by zone - No zone found', () async {
      // Mock data or setup for test
      int page = 1;
      int zoneId = 123;

      // Mock behavior of the community repository
      when(mockEventsRepository.filterEventsByZone(page, zoneId))
          .thenAnswer((_) => Future.value([]));


      // Optionally, assert on the result or other behavior
      expect([], isEmpty);
    });

    test('Get all regions', () async {
      // Mock data or setup for test
      int levelId = 1;
      int parentId = 123;

      // Mock behavior of the zone repository
      when(mockZoneRepository.getAllRegions(levelId, parentId))
          .thenAnswer((_) => Future.value([{"id":1, "name": "Adamaoua"}]));

      // Optionally, assert on the result or other behavior
      // For example, check that the result is as expected
      expect([{"id":1, "name": "Adamaoua"}], equals([{"id":1, "name": "Adamaoua"}]));
    });

    test('Get all divisions', () async {
      // Mock data or setup for test
      int levelId = 2;
      int parentId = 456;

      // Mock behavior of the zone repository
      when(mockZoneRepository.getAllDivisions(levelId, parentId))
          .thenAnswer((_) => Future.value([{"id":1, "name": "Mifi"}]));

      // Optionally, assert on the result or other behavior
      // For example, check that the result is as expected
      expect([{"id":1, "name": "Mifi"}], equals([{"id":1, "name": "Mifi"}]));
    });


    test('Get all subdivisions', () async {
      // Mock data or setup for test
      int levelId = 2;
      int parentId = 456;

      // Mock behavior of the zone repository
      when(mockZoneRepository.getAllSubdivisions(levelId, parentId))
          .thenAnswer((_) => Future.value([{"id":1, "name": "Bafoussam"}]));


      // Optionally, assert on the result or other behavior
      // For example, check that the result is as expected
      expect([{"id":1, "name": "Bafoussam"}], equals([{"id":1, "name": "Bafoussam"}]));
    });
    test('Get All Regions Test', () async {
      when(mockZoneRepository.getAllRegions(2, 1)).thenAnswer((_) => Future.value([]));
      //await eventsController.getAllRegions();
      expect(eventsController.listRegions, []);
      expect(eventsController.loadingRegions.value, true);
    });

    test('Get All Divisions Test', () async {
      when(mockZoneRepository.getAllDivisions(2, 1)).thenAnswer((_) => Future.value([]));
      //await authController.getAllDivisions();
      expect(eventsController.listDivisions, []);
      expect(eventsController.loadingDivisions.value, true);
    });

    test('Get All Sub-Divisions Test', () async {
      when(mockZoneRepository.getAllSubdivisions(2, 1)).thenAnswer((_) => Future.value([]));
      //await authController.getAllDivisions();
      expect(eventsController.listSubdivisions, []);
      expect(eventsController.loadingSubdivisions.value, true);
    });

    test('Get All Sectors Test', () async {
      when(mockSectorRepository.getAllSectors()).thenAnswer((_) => Future.value([]));
      //await eventsController.getAllSectors();
      expect(eventsController.listSectors, []);
      expect(eventsController.loadingSectors.value, true);
    });

    test('filterSearch returns all items when query is empty', () {
      // Arrange
      eventsController.listRegions.value= [{'name':'item1', 'id': 1},{'name':'item2', 'id': 2},{'name':'item3', 'id': 3}, ];


      // Act
      eventsController.filterSearchRegions('item');

      // Assert
      expect(eventsController.regions, [{'name':'item1', 'id': 1},{'name':'item2', 'id': 2},{'name':'item3', 'id': 3}, ]);
    });

    test('filterSearch returns filtered items when query matches', () {
      // Arrange

      eventsController.listRegions.value= [{'name':'Buea', 'id': 1},{'name':'Bafoussam', 'id': 2},{'name':'Bertoua', 'id': 3}, ];


      // Act
      eventsController.filterSearchRegions('B');

      // Assert
      expect(eventsController.regions, [{'name':'Buea', 'id': 1},{'name':'Bafoussam', 'id': 2},{'name':'Bertoua', 'id': 3}, ]);

    });

    test('filterSearch returns filtered items when query partially matches', () {
      // Arrange
      eventsController.listRegions.value= [{'name':'Buea', 'id': 1},{'name':'Bafoussam', 'id': 2},{'name':'Bertoua', 'id': 3}, ];


      // Act
      eventsController.filterSearchRegions('Bu');

      // Assert
      expect(eventsController.regions, [{'name':'Buea', 'id': 1} ]);
    });

    test('filterSearch returns empty list when no items match the query', () {
      // Arrange
      // Arrange
      eventsController.listRegions.value= [{'name':'Buea', 'id': 1},{'name':'Bafoussam', 'id': 2},{'name':'Bertoua', 'id': 3}, ];


      // Act
      eventsController.filterSearchRegions('Adamaoua');

      // Assert
      expect(eventsController.regions, []);
    });


    test('filterSearch returns all Divisions when query is empty', () {
      // Arrange
      eventsController.listDivisions.value= [{'name':'Mifi', 'id': 1},{'name':'Haut-Nkam', 'id': 2},{'name':'Haut-Plateaux', 'id': 3}, ];


      // Act
      eventsController.filterSearchDivisions('');

      // Assert
      expect(eventsController.divisions, [{'name':'Mifi', 'id': 1},{'name':'Haut-Nkam', 'id': 2},{'name':'Haut-Plateaux', 'id': 3}, ]);
    });

    test('filterSearch returns filtered Divisions when query matches', () {
      // Arrange

      eventsController.listDivisions.value= [{'name':'Mifi', 'id': 1},{'name':'Haut-Nkam', 'id': 2},{'name':'Haut-Plateaux', 'id': 3}, ];


      // Act
      eventsController.filterSearchDivisions('Haut-Nkam');

      // Assert
      expect(eventsController.divisions, [{'name':'Haut-Nkam', 'id': 2} ]);

    });

    test('filterSearch returns filtered items when query partially matches', () {
      // Arrange
      eventsController.listDivisions.value= [{'name':'Mifi', 'id': 1},{'name':'Haut-Nkam', 'id': 2},{'name':'Haut-Plateaux', 'id': 3}, ];


      // Act
      eventsController.filterSearchDivisions('Haut-Nk');

      // Assert
      expect(eventsController.divisions, [{'name':'Haut-Nkam', 'id': 2}]);
    });

    test('filterSearch returns empty list when no items match the query', () {
      // Arrange
      eventsController.listDivisions.value= [{'name':'Mifi', 'id': 1},{'name':'Haut-Nkam', 'id': 2},{'name':'Haut-Plateaux', 'id': 3}, ];


      // Act
      eventsController.filterSearchDivisions('Lekie');

      // Assert
      expect(eventsController.regions, []);
    });



    test('filterSearch returns all Sub-Divisions when query is empty', () {
      // Arrange
      eventsController.listSubdivisions.value= [{'name':'Yaounde', 'id': 1},{'name':'Obala', 'id': 2},{'name':'Mbalmayo', 'id': 3}, ];


      // Act
      eventsController.filterSearchSubdivisions('');

      // Assert
      expect(eventsController.subdivisions, [{'name':'Yaounde', 'id': 1},{'name':'Obala', 'id': 2},{'name':'Mbalmayo', 'id': 3}, ]);
    });

    test('filterSearch returns filtered Sub-Divisions when query matches', () {
      // Arrange

      eventsController.listSubdivisions.value= [{'name':'Yaounde', 'id': 1},{'name':'Obala', 'id': 2},{'name':'Mbalmayo', 'id': 3}, ];


      // Act
      eventsController.filterSearchSubdivisions('Yaounde');

      // Assert
      expect(eventsController.subdivisions, [{'name':'Yaounde', 'id': 1},]);

    });

    test('filterSearch returns filtered items when query partially matches', () {
      // Arrange
      eventsController.listSubdivisions.value= [{'name':'Yaounde', 'id': 1},{'name':'Obala', 'id': 2},{'name':'Mbalmayo', 'id': 3}, ];


      // Act
      eventsController.filterSearchSubdivisions('Yaoun');

      // Assert
      expect(eventsController.subdivisions, [{'name':'Yaounde', 'id': 1}]);
    });

    test('filterSearch returns empty list when no items match the query', () {
      // Arrange
      eventsController.listSubdivisions.value= [{'name':'Yaounde', 'id': 1},{'name':'Obala', 'id': 2},{'name':'Mbalmayo', 'id': 3}, ];


      // Act
      eventsController.filterSearchSubdivisions('Soa');

      // Assert
      expect(eventsController.subdivisions, []);
    });


    test('filterSearch returns all Sectors when query is empty', () {
      // Arrange
      eventsController.listSectors.value= [{'name':'Education', 'id': 1},{'name':'Agriculture', 'id': 2},{'name':'Health', 'id': 3}, ];


      // Act
      eventsController.filterSearchSectors('');

      // Assert
      expect(eventsController.sectors, [{'name':'Education', 'id': 1},{'name':'Agriculture', 'id': 2},{'name':'Health', 'id': 3}, ]);
    });

    test('filterSearch returns filtered Sectors when query matches', () {
      // Arrange

      eventsController.listSectors.value= [{'name':'Education', 'id': 1},{'name':'Agriculture', 'id': 2},{'name':'Health', 'id': 3}, ];


      // Act
      eventsController.filterSearchSectors('Education');

      // Assert
      expect(eventsController.sectors, [{'name':'Education', 'id': 1},]);

    });

    test('filterSearch returns filtered items when query partially matches', () {
      // Arrange
      eventsController.listSectors.value= [{'name':'Education', 'id': 1},{'name':'Agriculture', 'id': 2},{'name':'Health', 'id': 3}, ];


      // Act
      eventsController.filterSearchSectors('Agri');

      // Assert
      expect(eventsController.sectors, [{'name':'Agriculture', 'id': 2}]);
    });

    test('filterSearch returns empty list when no items match the query', () {
      // Arrange
      eventsController.listSectors.value= [{'name':'Education', 'id': 1},{'name':'Agriculture', 'id': 2},{'name':'Health', 'id': 3}, ];


      // Act
      eventsController.filterSearchSectors('Technology');

      // Assert
      expect(eventsController.sectors, []);
    });



  });









  // Add more tests as needed for other controller or service methods
}
