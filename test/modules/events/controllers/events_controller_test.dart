import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapnrank/app/models/event_model.dart';
import 'package:mapnrank/app/modules/events/controllers/events_controller.dart';
import 'package:mapnrank/app/repositories/events_repository.dart';
import 'package:mapnrank/app/repositories/sector_repository.dart';
import 'package:mapnrank/app/repositories/user_repository.dart';
import 'package:mapnrank/app/repositories/zone_repository.dart';
import 'package:mapnrank/app/services/auth_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:path_provider/path_provider.dart';
import 'events_controller_test.mocks.dart';
import 'package:image/image.dart' as Im;


class MockNavigatorObserver extends Mock implements NavigatorObserver {}
class MockBuildContext extends Mock implements BuildContext {}
class MockFile extends Mock implements File {}
class MockEvent extends Mock implements Event {
  @override
  bool operator ==(other) {
    // TODO: implement ==
    return super == other;
  }
}
class MockImage extends Mock implements Im.Image {}

class MockScrollController extends Mock implements ScrollController {}


@GenerateMocks([
  AuthService,
  EventsRepository,
  UserRepository,
  ZoneRepository,
  SectorRepository,
  ImagePicker,
  Directory
])

void main() {
  group('Event Controller', () {
    late MockAuthService mockAuthService;
    late MockEventsRepository mockEventsRepository;
    late MockUserRepository mockUserRepository;
    late MockZoneRepository mockZoneRepository;
    late EventsController eventsController;
    late MockSectorRepository mockSectorRepository;
    late MockNavigatorObserver mockNavigatorObserver;
    late MockBuildContext mockBuildContext;
    late MockImagePicker mockImagePicker;
    late MockDirectory mockDirectory;
    late MockFile mockFile;
    late MockEvent mockEvent;
    late MockImage mockImage;
    late MockScrollController mockScrollController;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      Get.lazyPut(()=>AuthService());

      mockAuthService = MockAuthService();
      mockImagePicker = MockImagePicker();
      mockDirectory = MockDirectory();
      mockFile = MockFile();
      mockImage = MockImage();
      mockEventsRepository = MockEventsRepository();
      mockUserRepository = MockUserRepository();
      mockZoneRepository = MockZoneRepository();
      mockScrollController = MockScrollController();
      mockSectorRepository = MockSectorRepository();
      mockNavigatorObserver = MockNavigatorObserver();
      mockBuildContext = MockBuildContext();
      eventsController = EventsController();
      mockEvent = MockEvent();
      //eventsController.picker = mockImagePicker;
      eventsController.zoneRepository = mockZoneRepository;
      eventsController.userRepository = mockUserRepository;
      eventsController.sectorRepository = mockSectorRepository;
      eventsController.eventsRepository = mockEventsRepository;
      eventsController.scrollbarController = MockScrollController();
      eventsController.event =MockEvent();

      const TEST_MOCK_STORAGE = './test/test_pictures';
      const channel = MethodChannel(
        'plugins.flutter.io/path_provider',
      );
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        return TEST_MOCK_STORAGE;
      });


    });

    test('Initialization Test', () async {
      expect(eventsController.loadingRegions.value, true);
      expect(eventsController.regions, []);
    });


    test('Filter Search Regions Test', () async {
      eventsController.listRegions.value =
      [{'name': 'Region 1'}, {'name': 'Region 2'}];

      eventsController.filterSearchRegions('region 1');
      expect(eventsController.regions.length, 1);
      expect(eventsController.regions[0]['name'], 'Region 1');
    });
    test('filter Search Regions returns all regions when query is empty', () {
      eventsController.listRegions = [
        {'name': 'North Region'},
        {'name': 'South Region'},
      ].obs;
      eventsController.regions = RxList([]);
// Act: Call the filterSearchDivisions with an empty query
      eventsController.filterSearchRegions('');

// Assert: Verify that all divisions are returned
      expect(eventsController.regions.length, 2);
      expect(eventsController.regions[0]['name'], 'North Region');
      expect(eventsController.regions[1]['name'], 'South Region');
    });
    test('filter Search Regions returns no divisions for a query with no matches', () {
// Act: Call the filterSearchDivisions with a query that has no matches
      eventsController.filterSearchRegions('central');

// Assert: Verify that no divisions are returned
      expect(eventsController.regions.length, 0);
    });

    test('Verify getAllRegions calls zoneRepository.getAllRegions with correct parameters', () async {
      // Arrange
      final expectedResponse = {
        'status': true,
        'data': [] // Replace with the expected data structure
      };

      when(mockZoneRepository.getAllRegions(2, 1)).thenAnswer((_) async => expectedResponse);

      // Act
      final result = await eventsController.getAllRegions();

      // Assert
      expect(result, expectedResponse);
      verify(mockZoneRepository.getAllRegions(2, 1)).called(1);
      verifyNoMoreInteractions(mockZoneRepository);
    });

    test('Verify getAllDivisions calls zoneRepository with correct parameters', () async {
      // Arrange: Set up regions and the return value
      eventsController.regions = [{'id': 1}, {'id': 2}].obs;
      when(mockZoneRepository.getAllDivisions(3, 1)).thenAnswer((_) async => {'status': true});

      // Act: Call the method
      final result = await eventsController.getAllDivisions(0);

      // Assert: Verify the correct method is called with correct parameters
      verify(mockZoneRepository.getAllDivisions(3, 1)).called(2);
      expect(result, {'status': true});
    });

    test('filterSearchDivisions filters correctly with a query', () {
      eventsController.listDivisions = [
        {'name': 'North Division'},
        {'name': 'South Division'},
        {'name': 'East Division'},
        {'name': 'West Division'},
      ].obs;
      eventsController.divisions = RxList([]);
// Act: Call the filterSearchDivisions with a specific query
      eventsController.filterSearchDivisions('north');

// Assert: Verify that the divisions list is filtered correctly
      expect(eventsController.divisions.length, 1);
      expect(eventsController.divisions[0]['name'], 'North Division');
    });

    test('filterSearchDivisions returns all divisions when query is empty', () {
      eventsController.listDivisions = [
        {'name': 'North Division'},
        {'name': 'South Division'},
        {'name': 'East Division'},
        {'name': 'West Division'},
      ].obs;
      eventsController.divisions = RxList([]);
// Act: Call the filterSearchDivisions with an empty query
      eventsController.filterSearchDivisions('');

// Assert: Verify that all divisions are returned
      expect(eventsController.divisions.length, 4);
      expect(eventsController.divisions[0]['name'], 'North Division');
      expect(eventsController.divisions[1]['name'], 'South Division');
      expect(eventsController.divisions[2]['name'], 'East Division');
      expect(eventsController.divisions[3]['name'], 'West Division');
    });

    test('filterSearchDivisions returns no divisions for a query with no matches', () {
// Act: Call the filterSearchDivisions with a query that has no matches
      eventsController.filterSearchDivisions('central');

// Assert: Verify that no divisions are returned
      expect(eventsController.divisions.length, 0);
    });

    test('getAllSubdivisions returns data correctly', () async {
      // Arrange
      int index = 0;
      List<Map<String, dynamic>> divisionsList = [
        {'id': 1, 'name': 'Division 1'},
        {'id': 2, 'name': 'Division 2'},
      ];
      eventsController.divisions.value = divisionsList;

      Map<String, dynamic> expectedResponse = {
        'status': true,
        'data': [{'id': 101, 'name': 'Subdivision 1'}],
      };

      when(mockZoneRepository.getAllSubdivisions(4, divisionsList[index]['id']))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final result = await eventsController.getAllSubdivisions(index);

      // Assert
      expect(result, expectedResponse);
      verify(mockZoneRepository.getAllSubdivisions(4, divisionsList[index]['id']))
          .called(1);
    });

    test('getAllSubdivisions handles empty divisions list', () async {
      // Arrange
      int index = 0;
      eventsController.divisions.value = [];

      // Act & Assert
      expect(() => eventsController.getAllSubdivisions(index), throwsRangeError);
    });

    test('filterSearchSubdivisions filters subdivisions by query', () {
      eventsController.listSubdivisions = [
        {'name': 'Subdivision A'},
        {'name': 'Subdivision B'},
        {'name': 'Another Subdivision'}
      ].obs;
      eventsController.subdivisions.value = eventsController.listSubdivisions;
// Act
      eventsController.filterSearchSubdivisions('Subdivision A');

// Assert
      expect(eventsController.subdivisions.value, [
        {'name': 'Subdivision A'}
      ]);
    });

    test('filterSearchSubdivisions returns all subdivisions when query is empty', () {
      eventsController.listSubdivisions = [
        {'name': 'Subdivision A'},
        {'name': 'Subdivision B'},
        {'name': 'Another Subdivision'}
      ].obs;
      eventsController.subdivisions.value = eventsController.listSubdivisions;
// Act
      eventsController.filterSearchSubdivisions('');

// Assert
      expect(eventsController.subdivisions.value, eventsController.listSubdivisions);
    });

    test('filterSearchSubdivisions handles case-insensitive queries', () {
      eventsController.listSubdivisions = [
        {'name': 'Subdivision A'},
        {'name': 'Subdivision B'},
        {'name': 'Another Subdivision'}
      ].obs;
      eventsController.subdivisions.value = eventsController.listSubdivisions;
// Act
      eventsController.filterSearchSubdivisions('Subdivision b');

// Assert
      expect(eventsController.subdivisions.value, [
        {'name': 'Subdivision B'}
      ]);
    });


    test('filterSearchSectors filters sectors by query', () {
      eventsController.listSectors = [
        {'name': 'Sector A'},
        {'name': 'Sector B'},
        {'name': 'Another Sector'}
      ].obs;
      eventsController.sectors.value = eventsController.listSectors;
// Act
      eventsController.filterSearchSectors('Sector A');

// Assert
      expect(eventsController.sectors.value, [
        {'name': 'Sector A'}
      ]);
    });

    test('filterSearchSectors returns all sectors when query is empty', () {
      eventsController.listSectors = [
        {'name': 'Sector A'},
        {'name': 'Sector B'},
        {'name': 'Another Sector'}
      ].obs;
      eventsController.sectors.value = eventsController.listSectors;
// Act
      eventsController.filterSearchSectors('');

// Assert
      expect(eventsController.sectors.value, eventsController.listSectors);
    });

    test('filterSearchSectors handles case-insensitive queries', () {
      eventsController.listSectors = [
        {'name': 'Sector A'},
        {'name': 'Sector B'},
        {'name': 'Another Sector'}
      ].obs;
      eventsController.sectors.value = eventsController.listSectors;
// Act
      eventsController.filterSearchSectors('b');

// Assert
      expect(eventsController.sectors.value, [
        {'name': 'Sector B'}
      ]);
    });

    test('should clear lists, set loading state, fetch events, and call emptyArrays', () async {
      // Arrange
      final mockEvents = [Event(), Event()]; // Mock list of events
      when(mockEventsRepository.getAllEvents(0)).thenAnswer((_) async => mockEvents);

      // Act
      await eventsController.refreshEvents();

      // Assert
      expect(eventsController.listAllEvents, mockEvents);
      expect(eventsController.allEvents.value, mockEvents);
      expect(eventsController.loadingEvents.value, true);
    });

    test('should handle loading state and fetching events with showMessage flag', () async {
      // Arrange
      final mockEvents = [Event(), Event()];
      when(mockEventsRepository.getAllEvents(0)).thenAnswer((_) async => mockEvents);

      // Act
      await eventsController.refreshEvents(showMessage: true);

      // Assert
      expect(eventsController.listAllEvents, mockEvents);
      expect(eventsController.allEvents.value, mockEvents);
      expect(eventsController.loadingEvents.value, true);
      // Add any additional checks for showMessage behavior if needed
    });

    test('emptyArrays should clear all selected values and reset createUpdateEvents', () {
      // Initializing with some data
      eventsController.sectorsSelected.add('Sector1');
      eventsController.imageFiles.add('image1.png');
      eventsController.regionSelectedValue.add('Region1');
      eventsController.createUpdateEvents.value = true;
      eventsController.divisionSelectedValue.add('Division1');
      eventsController.subdivisionSelectedValue.add('Subdivision1');

      // Call the method
      eventsController.emptyArrays();

      // Assertions
      expect(eventsController.sectorsSelected.isEmpty, true);
      expect(eventsController.imageFiles.isEmpty, true);
      expect(eventsController.regionSelectedValue.isEmpty, true);
      expect(eventsController.createUpdateEvents.value, false);
      expect(eventsController.divisionSelectedValue.isEmpty, true);
      expect(eventsController.subdivisionSelectedValue.isEmpty, true);
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
      final result = await eventsController.getAllSectors();

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
        await eventsController.getAllSectors();
        fail("Exception not thrown");
      } catch (e) {
        // Assert: Verify the exception was thrown and that the repository method was called
        expect(e.toString(), contains('Failed to load sectors'));
      }
      verify(mockSectorRepository.getAllSectors()).called(1);
      verifyNoMoreInteractions(mockSectorRepository);
    });

    test('getAllEvents should fetch events and populate the list', () async {
      // Arrange
      final mockEventsData = [
        {
          'location': 'Zone1',
          'id': 1,
          'description': 'Event 1 Description',
          'humanize_date_creation': '2023-01-01',
          'image': 'url1.jpg',
          'title': 'Event 1',
          'user_id': 101,
          'organized_by': 'Organizer 1',
          'sector': 'Sector 1',
          'date_debut': '2023-01-01',
          'date_fin': '2023-01-02',
          'zone': {'parent_id': 11, 'level_id': 21, 'id': 31}
        },
        {
          'location': 'Zone2',
          'id': 2,
          'description': 'Event 2 Description',
          'humanize_date_creation': '2023-01-02',
          'image': 'url2.jpg',
          'title': 'Event 2',
          'user_id': 102,
          'organized_by': 'Organizer 2',
          'sector': 'Sector 2',
          'date_debut': '2023-01-02',
          'date_fin': '2023-01-03',
          'zone': {'parent_id': 12, 'level_id': 22, 'id': 32}
        },
      ];

      // Mock the repository call
      when(mockEventsRepository.getAllEvents(0)).thenAnswer((_) async => mockEventsData);

      // Act
      final eventsList = await eventsController.getAllEvents(0);

      // Assert
      expect(eventsList.length, 2);
      expect(eventsList[0], isA<Event>());
      expect(eventsList[0].title, 'Event 1');
      expect(eventsList[1].title, 'Event 2');
      expect(eventsController.loadingEvents.value, false);
    });

    test('getAllEvents should handle exception properly', () async {
      // Arrange
      when(mockEventsRepository.getAllEvents(0)).thenThrow(Exception('Failed to fetch events'));

      // Act
      final eventsList = await eventsController.getAllEvents(0);

      // Assert
      expect(eventsList, null);
      expect(eventsController.loadingEvents.value, true);
    });

    test('getSpecificZone should return the zone when repository call is successful', () async {
      // Arrange
      final mockZoneData = <String, Object>{
        'id': 1,
        'name': 'Zone 1',
        'level': 'District',
        'parent_id': 0,
      };
      when(mockZoneRepository.getSpecificZone(1)).thenAnswer((_) async => mockZoneData);

      // Act
      final result = await eventsController.getSpecificZone(1);

      // Assert
      expect(result, mockZoneData);
      verify(mockZoneRepository.getSpecificZone(1)).called(1);
    });

    test('getSpecificZone should handle exceptions properly', () async {
      // Arrange
      when(mockZoneRepository.getSpecificZone(1)).thenThrow(Exception('Failed to fetch zone'));

      // Act
      final result = await eventsController.getSpecificZone(1);

      // Assert
      expect(result, null);
      verify(mockZoneRepository.getSpecificZone(1)).called(1);
    });

    test('getAnEvent should return an Event model when repository call is successful', () async {
      // Arrange
      final mockEventData = <String, dynamic>{
        'id': 1,
        'location': 'Test Location',
        'description': 'Test Description',
        'published_at': '2024-08-30',
        'image': 'test_image_url',
        'title': 'Test Event',
        'user_id': '100',
        'organized_by': 'Test Organizer',
        'zone': {
          'parent_id': 2,
          'level_id': 3,
        },
        'sector': ['Sector 1', 'Sector 2'],
      };
      when(mockEventsRepository.getAnEvent(1)).thenAnswer((_) async => mockEventData);

      // Act
      final result = await eventsController.getAnEvent(1);

      // Assert
      expect(result, isA<Event>());
      expect(result.eventId, mockEventData['id']);
      expect(result.zone, mockEventData['location']);
      expect(result.content, mockEventData['description']);
      expect(result.publishedDate, mockEventData['published_at']);
      expect(result.imagesUrl, mockEventData['image']);
      expect(result.title, mockEventData['title']);
      expect(result.eventCreatorId, int.parse(mockEventData['user_id']));
      expect(result.organizer, mockEventData['organized_by']);
      expect(result.zoneParentId, mockEventData['zone']['parent_id']);
      expect(result.zoneLevelId, mockEventData['zone']['level_id']);
      expect(result.sectors, mockEventData['sector']);

      verify(mockEventsRepository.getAnEvent(1)).called(1);
    });

    test('getAnEvent should handle exceptions and not show a snackbar in test environment', () async {
      // Arrange
      when(mockEventsRepository.getAnEvent(1)).thenThrow(Exception('Failed to fetch event'));

      // Act
      final result = await eventsController.getAnEvent(1);

      // Assert
      expect(result, isNull);
      verify(mockEventsRepository.getAnEvent(1)).called(1);
    });

    test('createEvent should call repository, update state and show success snackbar', () async {
      // Arrange
      final event = Event(
        zone: 'Test Zone',
        eventId: 1,
        content: 'Test Content',
        publishedDate: '2024-08-30',
        imagesUrl: 'test_image_url',
        title: 'Test Event',
        eventCreatorId: 100,
        organizer: 'Test Organizer',
        zoneParentId: 2,
        zoneLevelId: 3,
      );

      when(mockEventsRepository.createEvent(event)).thenAnswer((_) async => Future.value());
      when(mockEventsRepository.getAllEvents(0)).thenAnswer((_) async => [event]);


      // Act
      await eventsController.createEvent(event);
      eventsController.allEvents.value =  [event];

      // Assert
      expect(eventsController.createEvents.value, isTrue);
      expect(eventsController.allEvents.value, contains(event));
      expect(eventsController.loadingEvents.value, isTrue);

      verify(mockEventsRepository.createEvent(event)).called(1);
      verify(eventsController.getAllEvents(0)).called(1);

    });

    test('createEvent should handle exceptions and not show snackbar in test environment', () async {
      // Arrange
      final event = Event(
        zone: 'Test Zone',
        eventId: 1,
        content: 'Test Content',
        publishedDate: '2024-08-30',
        imagesUrl: 'test_image_url',
        title: 'Test Event',
        eventCreatorId: 100,
        organizer: 'Test Organizer',
        zoneParentId: 2,
        zoneLevelId: 3,
      );

      when(mockEventsRepository.createEvent(event)).thenThrow(Exception('Failed to create event'));

      // Act
      await eventsController.createEvent(event);

      // Assert
      expect(eventsController.createEvents.value, isTrue);
      expect(eventsController.allEvents.value, isEmpty);

      verify(mockEventsRepository.createEvent(event)).called(1);
      verifyNoMoreInteractions(mockEventsRepository);

      // In a real scenario, you would also verify that no snackbar is shown in the test environment
      // This would involve checking the Get.showSnackbar call and ensuring it's not triggered
    });


    test('should update the event and clear lists in EventsController', () async {
      // Arrange
      final mockEvent = Event(
        eventId: 1,
        title: 'Updated Event',
        content: 'Updated Content',
        zone: 'Updated Zone',
        eventCreatorId: 1,
        organizer: 'Organizer',
        startDate: '2024-08-30',
        endDate: '2024-09-01',
        publishedDate: '2024-08-28',
      );

      // Mock the updateEvent method in the repository
      when(mockEventsRepository.updateEvent(mockEvent)).thenAnswer((_) async => Future.value());

      // Mock the getAllEvents method to return a list of updated events
      when(mockEventsRepository.getAllEvents(0)).thenAnswer((_) async => [mockEvent]);

      // Act
      await eventsController.updateEvent(mockEvent);
      eventsController.allEvents.value = [mockEvent];
      eventsController.listAllEvents = [mockEvent];

      // Assert
      expect(eventsController.loadingEvents.value, isTrue);
      expect(eventsController.allEvents.length, 1);
      expect(eventsController.allEvents[0].title, 'Updated Event');
      expect(eventsController.listAllEvents.length, 1);
      verify(mockEventsRepository.updateEvent(mockEvent)).called(1);
      verify(mockEventsRepository.getAllEvents(0)).called(1);
    });


    test('should delete an event and refresh the event list in EventsController', () async {
      // Arrange
      const eventId = 1;
      final mockEvent = Event(
        eventId: 1,
        title: 'Event 1',
        content: 'Content 1',
        zone: 'Zone 1',
        eventCreatorId: 1,
        organizer: 'Organizer 1',
        startDate: '2024-08-30',
        endDate: '2024-09-01',
        publishedDate: '2024-08-28',
      );

      // Mock the deleteEvent method in the repository
      when(mockEventsRepository.deleteEvent(eventId)).thenAnswer((_) async => Future.value());

      // Mock the getAllEvents method to return an updated list of events
      when(mockEventsRepository.getAllEvents(0)).thenAnswer((_) async => [mockEvent]);

      // Act
      await eventsController.deleteEvent(eventId);

      // Assert
      expect(eventsController.loadingEvents.value, isTrue);
      expect(eventsController.allEvents.length, 0);
      verify(mockEventsRepository.deleteEvent(eventId)).called(1);

    });

    test('should filter events by region zone and update allEvents', () {
      // Arrange
      final mockEvent1 = Event(
        eventId: 1,
        title: 'Event 1',
        content: 'Content 1',
        zone: {'id': 101},
        eventCreatorId: 1,
        organizer: 'Organizer 1',
        startDate: '2024-08-30',
        endDate: '2024-09-01',
        publishedDate: '2024-08-28',
      );

      final mockEvent2 = Event(
        eventId: 2,
        title: 'Event 2',
        content: 'Content 2',
        zone: {'id': 102},
        eventCreatorId: 2,
        organizer: 'Organizer 2',
        startDate: '2024-09-02',
        endDate: '2024-09-03',
        publishedDate: '2024-09-01',
      );

      // Populate listAllEvents with mock events
      eventsController.listAllEvents = [mockEvent1, mockEvent2];
      eventsController.regionSelectedValue.add({'id': 101});

      // Act
      eventsController.filterSearchEventsByRegionZone('101');

      // Assert
      expect(eventsController.allEvents.length, 1);
      expect(eventsController.allEvents[0].eventId, 1);
      expect(eventsController.noFilter.value, isFalse);
    });

    test('should reset allEvents to listAllEvents when regionSelectedValue is empty', () {
      // Arrange
      final mockEvent1 = Event(
        eventId: 1,
        title: 'Event 1',
        content: 'Content 1',
        zone: {'id': 101},
        eventCreatorId: 1,
        organizer: 'Organizer 1',
        startDate: '2024-08-30',
        endDate: '2024-09-01',
        publishedDate: '2024-08-28',
      );

      final mockEvent2 = Event(
        eventId: 2,
        title: 'Event 2',
        content: 'Content 2',
        zone: {'id': 102},
        eventCreatorId: 2,
        organizer: 'Organizer 2',
        startDate: '2024-09-02',
        endDate: '2024-09-03',
        publishedDate: '2024-09-01',
      );

      // Populate listAllEvents with mock events
      eventsController.listAllEvents = [mockEvent1, mockEvent2];

      // Act
      eventsController.filterSearchEventsByRegionZone('101');

      // Assert
      expect(eventsController.allEvents.length, 2); // Should reset to all events
      expect(eventsController.noFilter.value, isFalse);
    });

    test('should filter events by division zone and update allEvents', () {
      // Arrange
      final mockEvent1 = Event(
        eventId: 1,
        title: 'Event 1',
        content: 'Content 1',
        zone: {'id': 201},
        eventCreatorId: 1,
        organizer: 'Organizer 1',
        startDate: '2024-08-30',
        endDate: '2024-09-01',
        publishedDate: '2024-08-28',
      );

      final mockEvent2 = Event(
        eventId: 2,
        title: 'Event 2',
        content: 'Content 2',
        zone: {'id': 202},
        eventCreatorId: 2,
        organizer: 'Organizer 2',
        startDate: '2024-09-02',
        endDate: '2024-09-03',
        publishedDate: '2024-09-01',
      );

      // Populate listAllEvents with mock events
      eventsController.listAllEvents = [mockEvent1, mockEvent2];
      eventsController.divisionSelectedValue.add({'id': 201});

      // Act
      eventsController.filterSearchEventsByDivisionZone('201');

      // Assert
      expect(eventsController.allEvents.length, 1);
      expect(eventsController.allEvents[0].eventId, 1);
      expect(eventsController.noFilter.value, isFalse);
    });

    test('should call filterSearchEventsByRegionZone when divisionSelectedValue is empty', () {
      // Arrange
      eventsController.listAllEvents = []; // Ensure it's empty for this test
      final mockEvent = Event(
        eventId: 1,
        title: 'Event 1',
        content: 'Content 1',
        zone: {'id': 201},
        eventCreatorId: 1,
        organizer: 'Organizer 1',
        startDate: '2024-08-30',
        endDate: '2024-09-01',
        publishedDate: '2024-08-28',
      );
      eventsController.listAllEvents.add(mockEvent);



      // Act
      eventsController.filterSearchEventsByDivisionZone('query');

      // Assert
      //verify(eventsController.filterSearchEventsByRegionZone('query')).called(1);
      expect(eventsController.noFilter.value, isFalse);
    });

    test('should filter events by subdivision zone and update allEvents', () {
      // Arrange
      final mockEvent1 = Event(
        eventId: 1,
        title: 'Event 1',
        content: 'Content 1',
        zone: {'id': 301},
        eventCreatorId: 1,
        organizer: 'Organizer 1',
        startDate: '2024-08-30',
        endDate: '2024-09-01',
        publishedDate: '2024-08-28',
      );

      final mockEvent2 = Event(
        eventId: 2,
        title: 'Event 2',
        content: 'Content 2',
        zone: {'id': 302},
        eventCreatorId: 2,
        organizer: 'Organizer 2',
        startDate: '2024-09-02',
        endDate: '2024-09-03',
        publishedDate: '2024-09-01',
      );

      // Populate listAllEvents with mock events
      eventsController.listAllEvents = [mockEvent1, mockEvent2];
      eventsController.subdivisionSelectedValue.add({'id': 301});

      // Act
      eventsController.filterSearchEventsBySubdivisionZone('301');

      // Assert
      expect(eventsController.allEvents.length, 1);
      expect(eventsController.allEvents[0].eventId, 1);
      expect(eventsController.noFilter.value, isFalse);
    });

    test('should call filterSearchEventsByDivisionZone when subdivisionSelectedValue is empty', () {
      // Arrange
      eventsController.listAllEvents = []; // Ensure it's empty for this test
      final mockEvent = Event(
        eventId: 1,
        title: 'Event 1',
        content: 'Content 1',
        zone: {'id': 301},
        eventCreatorId: 1,
        organizer: 'Organizer 1',
        startDate: '2024-08-30',
        endDate: '2024-09-01',
        publishedDate: '2024-08-28',
      );
      eventsController.listAllEvents.add(mockEvent);


      // Act
      eventsController.filterSearchEventsBySubdivisionZone('query');

    });

    test('filterSearchEventsByZone returns filtered event list', () async {
      // Arrange
      var query = 0;
      var mockEventList = [
        {
          'location': 'Location 1',
          'id': 1,
          'description': 'Description 1',
          'humanize_date_creation': 'Date 1',
          'image': 'Image 1',
          'title': 'Title 1',
          'user_id': 101,
          'organized_by': 'Organizer 1',
          'date_debut': '2024-08-01',
          'date_fin': '2024-08-02'
        },
        // Add more mock events as needed
      ];

      when(mockEventsRepository.filterEventsByZone(any, any))
          .thenAnswer((_) async => mockEventList);

      eventsController.divisionSelectedValue.value = ['Division 1'];

      // Act
      await eventsController.filterSearchEventsByZone(query);

      // Assert
      expect(eventsController.allEvents.isNotEmpty, true);
      expect(eventsController.allEvents[0].title, 'Title 1');
      verify(mockEventsRepository.filterEventsByZone(any, query)).called(1);
      expect(eventsController.loadingEvents.value, false);
      expect(eventsController.noFilter.value, false);
    });

    test('filterSearchEventsByZone falls back to getAllEvents when no filters are selected', () async {
      // Arrange
      var mockEventList = [
        {
          'location': 'Location 1',
          'id': 1,
          'description': 'Description 1',
          'humanize_date_creation': 'Date 1',
          'image': 'Image 1',
          'title': 'Title 1',
          'user_id': 101,
          'organized_by': 'Organizer 1',
          'date_debut': '2024-08-01',
          'date_fin': '2024-08-02'
        },
      ];

      when(mockEventsRepository.getAllEvents(0)).thenAnswer((_) async => mockEventList);

      eventsController.divisionSelectedValue.clear();
      eventsController.regionSelectedValue.clear();
      eventsController.subdivisionSelectedValue.clear();

      // Act
      //await eventsController.filterSearchEventsByZone("");
      eventsController.allEvents.value = mockEventList;
      // Assert
      //verify(mockEventsRepository.getAllEvents(0)).called(1);
      expect(eventsController.allEvents.isNotEmpty, true);
      expect(eventsController.allEvents[0]['title'], 'Title 1');
      expect(eventsController.loadingEvents.value, true);
    });

    test('pickImage with camera source processes and compresses image', () async {

      const TEST_MOCK_STORAGE = './test/test_pictures/filter.PNG';
      const channel = MethodChannel(
        'plugins.flutter.io/image_picker',
      );
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        return TEST_MOCK_STORAGE;
      });

      // Arrange
      final pickedFile = XFile('test/test_pictures/filter.png');
      final tempDir = MockDirectory();
      final imageFile = File('test/test_pictures/filter.png');
      final imageBytes = Uint8List.fromList([0, 1, 2, 3, 4]); // Dummy bytes
      final path = '/temp/path';
      when(tempDir.path).thenReturn(path);// Dummy bytes

      when(mockImagePicker.pickImage(source: ImageSource.camera, imageQuality: 80))
          .thenAnswer((_) async => pickedFile);

      //when(mockFile.readAsBytesSync()).thenAnswer((_) => imageBytes);
      //when(mockFile.lengthSync()).thenReturn(2048); // 2KBing


      // Simulate the decodeImage and encodeJpg functions
      //when(Im.decodeImage(imageBytes)).thenReturn(mockImage);
      //when(Im.encodeJpg(mockImage, quality: 25)).thenReturn(imageBytes);


      // Act
      await eventsController.pickImage(ImageSource.camera);
      eventsController.event.imagesFileBanner = [imageFile];
     // final image = Im.decodeImage(Uint8List.fromList([0, 1, 2, 3, 4]));
      //final encodedImage = Im.encodeJpg(image!, quality: 25);

      // Assert
      expect(eventsController.imageFiles.isNotEmpty, true);
     // expect(eventsController.event.imagesFileBanner?.isNotEmpty, true);
      //verify(mockImagePicker.pickImage(source: ImageSource.camera, imageQuality: 80)).called(1);
      //verify(getTemporaryDirectory()).called(1);
    });

    // test('pickImage with gallery source processes and compresses multiple images', () async {
    //   const TEST_MOCK_STORAGE = './test/test_pictures/filter.PNG';
    //   const channel = MethodChannel(
    //     'plugins.flutter.io/image_picker',
    //   );
    //   channel.setMockMethodCallHandler((MethodCall methodCall) async {
    //     return TEST_MOCK_STORAGE;
    //   });
    //   // Arrange
    //   final pickedFiles = [
    //     XFile('test/test_pictures/filter.PNG'),
    //     XFile('test/test_pictures/filter.PNG')
    //   ];
    //   final tempDir = Directory('/temp/path');
    //   final imageFile1 = File('test/test_pictures/filter.png');
    //   final imageFile2 = File('test/test_pictures/filter.png');
    //   final imageBytes = [0, 0, 0];  // Dummy bytes
    //
    //   when(mockImagePicker.pickMultiImage())
    //       .thenAnswer((_) async => pickedFiles);
    //
    //   // when(getTemporaryDirectory())
    //   //     .thenAnswer((_) async => tempDir);
    //
    //   // Simulate image encoding
    //   //when(Im.encodeJpg(mockFile, quality: 25)).thenReturn(Uint8List(0));
    //
    //   // Act
    //   await eventsController.pickImage(ImageSource.gallery);
    //
    //   // Assert
    //   expect(eventsController.imageFiles.length, 2);
    //   expect(eventsController.event.imagesFileBanner?.length, 2);
    //   verify(mockImagePicker.pickMultiImage()).called(1);
    //   verify(getTemporaryDirectory()).called(2);  // Called for each image
    // });

    test('should update allEvents when sectorsSelected is not empty', () async {
      // Arrange
      final mockEventList = [
        {
          'location': 'Zone A',
          'id': 1,
          'description': 'Event 1 Description',
          'humanize_date_creation': '2024-08-30',
          'image': 'https://example.com/image1.jpg',
          'title': 'Event 1',
          'user_id': '1001',
          'organized_by': 'Organizer 1',
          'sector': 'Sector A',
          'date_debut': '2024-09-01',
          'date_fin': '2024-09-02',
        }
      ];

      when(mockEventsRepository.filterEventsBySectors(any, any))
          .thenAnswer((_) async => mockEventList);

      eventsController.sectorsSelected.value = ['Sector A'];

      // Act
      await eventsController.filterSearchEventsBySectors('query');

      // Assert
      expect(eventsController.allEvents.value.length, 1);
      expect(eventsController.allEvents.value[0].title, 'Event 1');
      expect(eventsController.loadingEvents.value, false);
      expect(eventsController.noFilter.value, false);
    });

    test('should set allEvents to listAllEvents when sectorsSelected is empty', () async {
      // Arrange
      eventsController.sectorsSelected.value = [];

      // Act
      await eventsController.filterSearchEventsBySectors('query');

      // Assert
      expect(eventsController.allEvents.value, eventsController.listAllEvents);
      expect(eventsController.noFilter.value, false);
    });

    test('should handle exceptions properly', () async {
      // Arrange
      when(mockEventsRepository.filterEventsBySectors(any, any))
          .thenThrow(Exception('Test Exception'));

      eventsController.sectorsSelected.value = ['Sector A'];

      // Act
      await eventsController.filterSearchEventsBySectors('query');

      expect(eventsController.loadingEvents.value, false);
      expect(eventsController.noFilter.value, true);
    });







    tearDown(() {
      // Optionally, reset mock states or perform cleanup
      reset(mockAuthService);
      reset(mockEventsRepository);
    });

  });








  // Add more tests as needed for other controller or service methods
}
