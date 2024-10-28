import 'package:flutter_test/flutter_test.dart';
import 'package:mapnrank/app/models/event_model.dart';
// Adjust import path as necessary

void main() {
  group('Event Model Tests', () {
    test('fromJson creates a valid Event instance', () {
      // Example JSON data representing an event
      final Map<String, dynamic> json = {
        'content': 'Sample event description',
        'id': 2,
        'zone_id': '1',
        'published_at': '2023-07-03',
      };

      // Create an Event instance from JSON
      final event = Event.fromJson(json);

      // Verify that fields are correctly populated
      expect(event.content, 'Sample event description');
      expect(event.eventId, 2);
      expect(event.zoneEventId, 1);
      expect(event.publishedDate, '2023-07-03');
    });

    test('toJson converts Event instance to JSON', () {
      // Create an Event instance
      final event = Event(
        content: 'Another event description',
        eventId: 2,
        zoneEventId: '1',
        publishedDate: '2023-07-04',
      );

      // Convert Event instance to JSON
      final json = event.toJson();

      // Verify JSON content
      expect(json['content'], 'Another event description');
      expect(json['id'], 2);
      expect(json['zone_id'], '1');
      expect(json['published_at'], '2023-07-04');
    });

    // Additional test cases can be added as needed
  });
}
