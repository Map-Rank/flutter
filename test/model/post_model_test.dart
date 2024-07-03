import 'package:flutter_test/flutter_test.dart';
import 'package:mapnrank/app/models/post_model.dart';


void main() {
  group('Post Model Tests', () {
    test('fromJson creates a valid Post instance', () {
      // Example JSON data representing a post
      final Map<String, dynamic> json = {
        'content': 'This is a test post',
        'id': 1,
        'published_at': '2023-07-03',
        'zone_id': 'utc',
      };

      // Create a Post instance from JSON
      final post = Post.fromJson(json);

      // Verify that fields are correctly populated
      expect(post.content, 'This is a test post');
      expect(post.postId, 1);
      expect(post.publishedDate, '2023-07-03');
      expect(post.zonePostId, 'utc');
    });

    test('toJson converts Post instance to JSON', () {
      // Create a Post instance
      final post = Post(
        content: 'Another test post',
        postId: 2,
        publishedDate: '2023-07-04',
        zonePostId: 'est',
      );

      // Convert Post instance to JSON
      final json = post.toJson();

      // Verify JSON content
      expect(json['content'], 'Another test post');
      expect(json['id'], 2);
      expect(json['published_at'], '2023-07-04');
      expect(json['zone_id'], 'est');
    });

    // Additional test cases can be added as needed
  });
}
