import 'package:flutter_test/flutter_test.dart';
import 'package:mapnrank/app/models/user_model.dart';

void main() {
  group('UserModel', () {
    test('fromJson creates a valid UserModel instance', () {
      // Example JSON data representing a user
      final Map<String, dynamic> json = {
        'first_name': 'John',
        'last_name': 'Doe',
        'email': 'john.doe@example.com',
        'phone': '1234567890',
        'gender': 'male',
        'id': 1,
        'date_of_birth': '1990-01-01',
        'token': 'token123',
        'zone_id': 'utc',
        'avatar': 'https://example.com/avatar.jpg',
      };

      // Create a UserModel instance from JSON
      final userModel = UserModel.fromJson(json);

      // Verify that fields are correctly populated
      expect(userModel.firstName, 'John');
      expect(userModel.lastName, 'Doe');
      expect(userModel.email, 'john.doe@example.com');
      expect(userModel.phoneNumber, '1234567890');
      expect(userModel.gender, 'male');
      expect(userModel.userId, 1);
      expect(userModel.birthdate, '1990-01-01');
      expect(userModel.authToken, 'token123');
      expect(userModel.zoneId, 'utc');
      expect(userModel.avatarUrl, 'https://example.com/avatar.jpg');
    });

    test('toJson converts UserModel instance to JSON', () {
      // Create a UserModel instance
      final userModel = UserModel(
        firstName: 'Jane',
        lastName: 'Doe',
        email: 'jane.doe@example.com',
        phoneNumber: '9876543210',
        gender: 'female',
        userId: 2,
        birthdate: '1995-02-15',
        authToken: 'auth456',
        zoneId: 'est',
        avatarUrl: 'https://example.com/avatar2.jpg',
      );

      // Convert UserModel instance to JSON
      final json = userModel.toJson();

      // Verify JSON content
      expect(json['first_name'], 'Jane');
      expect(json['last_name'], 'Doe');
      expect(json['email'], 'jane.doe@example.com');
      expect(json['phone'], '9876543210');
      expect(json['gender'], 'female');
      expect(json['id'], 2);
      expect(json['date_of_birth'], '1995-02-15');
      expect(json['token'], 'auth456');
      expect(json['zone_id'], 'est');

    });
  });
}
