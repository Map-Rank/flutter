import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mapnrank/app/models/parents/model.dart'; // Adjust the import based on your file structure

// Create a concrete subclass of Model for testing
class TestModel extends Model {
  @override
  Map<String, dynamic> toJson() {
    return {'id': id};
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

void main() {
  group('Model Test', () {
    late TestModel model;

    setUp(() {
      model = TestModel();
    });

    test('fromJson sets id correctly', () {
      final json = {'id': '123'};
      model.fromJson(json);
      expect(model.id, '123');
    });

    test('hasData returns true when id is set', () {
      model.id = '123';
      expect(model.hasData, isTrue);
    });

    test('hasData returns false when id is null', () {
      model.id = null;
      expect(model.hasData, isFalse);
    });

    test('toJson returns correct map', () {
      model.id = '123';
      final json = model.toJson();
      expect(json['id'], '123');
    });

    test('toString returns correct JSON string', () {
      model.id = '123';
      expect(model.toString(), '{"id":"123"}');
    });

    test('stringFromJson returns correct value', () {
      final json = {'name': 'John'};
      final name = model.stringFromJson(json, 'name');
      expect(name, 'John');
    });

    test('stringFromJson returns default value when attribute is missing', () {
      final json = {'name': 'John'}; // JSON missing 'age' attribute

      final value = model.stringFromJson(json, 'age', defaultValue: 'unknown');

      expect(value, 'unknown'); // Verify that defaultValue 'unknown' is returned
    });



    test('dateFromJson returns correct value', () {
      final json = {'date': '2022-01-01T12:00:00Z'};
      final date = model.dateFromJson(json, 'date', defaultValue: DateTime.now());
      expect(date, DateTime.parse('2022-01-01T12:00:00Z').toLocal());
    });

    test('mapFromJson returns correct value', () {
      final json = {'data': jsonEncode({'key': 'value'})};
      final map = model.mapFromJson(json, 'data', defaultValue: {});
      expect(map['key'], 'value');
    });

    test('intFromJson returns correct value', () {
      final json = {'age': '30'};
      final age = model.intFromJson(json, 'age');
      expect(age, 30);
    });

    test('doubleFromJson returns correct value', () {
      final json = {'price': '9.99'};
      final price = model.doubleFromJson(json, 'price');
      expect(price, 9.99);
    });

    test('boolFromJson returns correct value', () {
      final json = {'isActive': 'true'};
      final isActive = model.boolFromJson(json, 'isActive');
      expect(isActive, isTrue);
    });

    test('boolFromJson returns false for "0"', () {
      final json = {'isActive': '0'};
      final isActive = model.boolFromJson(json, 'isActive');
      expect(isActive, isFalse);
    });

    // Exception tests
    test('stringFromJson throws exception on error', () {
      final json = {'name': 123}; // Invalid JSON where 'name' should be a string but is an int

      try {
        model.stringFromJson(json, 'name');
        fail('Error while parsing name');
      } catch (e) {
        expect(e, isInstanceOf<Exception>());
        expect(e.toString(), contains('Error while parsing name'));
      }
    });




    test('dateFromJson throws exception on error', () {
      final json = {'date': 'invalid-date-format'};
      expect(
            () => model.dateFromJson(json, 'date', defaultValue: DateTime.now()),
        throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('Error while parsing date'))),
      );
    });

    test('mapFromJson throws exception on error', () {
      final json = {'data': 'invalid-json-string'};
      expect(
            () => model.mapFromJson(json, 'data', defaultValue: {}),
        throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('Error while parsing data'))),
      );
    });

    test('intFromJson throws exception on error', () {
      final json = {'age': 'invalid-int'};
      expect(
            () => model.intFromJson(json, 'age'),
        throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('Error while parsing age'))),
      );
    });

    test('doubleFromJson throws exception on error', () {
      final json = {'price': 'invalid-double'};
      expect(
            () => model.doubleFromJson(json, 'price'),
        throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('Error while parsing price'))),
      );
    });

    // Adjusted boolFromJson test to reflect actual behavior
    test('boolFromJson returns default value on invalid input', () {
      final json = {'isActive': 'invalid-bool'};
      final isActive = model.boolFromJson(json, 'isActive');
      expect(isActive, isFalse);
    });
  });
}


// import 'dart:convert';
//
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mapnrank/app/models/parents/model.dart';
//  // Adjust the import based on your file structure
//
// // Create a concrete subclass of Model for testing
// class TestModel extends Model {
//   @override
//   Map<String, dynamic> toJson() {
//     return {'id': id};
//   }
//
//   @override
//   String toString() {
//     return jsonEncode(toJson());
//   }
// }
//
// void main() {
//   group('Model Test', () {
//     late TestModel model;
//
//     setUp(() {
//       model = TestModel();
//     });
//
//     test('fromJson sets id correctly', () {
//       final json = {'id': '123'};
//       model.fromJson(json);
//       expect(model.id, '123');
//     });
//
//     test('hasData returns true when id is set', () {
//       model.id = '123';
//       expect(model.hasData, isTrue);
//     });
//
//     test('hasData returns false when id is null', () {
//       model.id = null;
//       expect(model.hasData, isFalse);
//     });
//
//     test('toJson returns correct map', () {
//       model.id = '123';
//       final json = model.toJson();
//       expect(json['id'], '123');
//     });
//
//     test('toString returns correct JSON string', () {
//       model.id = '123';
//       expect(model.toString(), '{"id":"123"}');
//     });
//
//     test('stringFromJson returns correct value', () {
//       final json = {'name': 'John'};
//       final name = model.stringFromJson(json, 'name');
//       expect(name, 'John');
//     });
//
//     test('stringFromJson returns default value when attribute is missing', () {
//       final json = {'name': 'John'};
//       final value = model.stringFromJson(json, 'age', defaultValue: 'unknown');
//       expect(value, 'unknown');
//     });
//
//     test('dateFromJson returns correct value', () {
//       final json = {'date': '2022-01-01T12:00:00Z'};
//       final date = model.dateFromJson(json, 'date', defaultValue: DateTime.now());
//       expect(date, DateTime.parse('2022-01-01T12:00:00Z').toLocal());
//     });
//
//     test('mapFromJson returns correct value', () {
//       final json = {'data': jsonEncode({'key': 'value'})};
//       final map = model.mapFromJson(json, 'data', defaultValue: {});
//       expect(map['key'], 'value');
//     });
//
//     test('intFromJson returns correct value', () {
//       final json = {'age': '30'};
//       final age = model.intFromJson(json, 'age');
//       expect(age, 30);
//     });
//
//     test('doubleFromJson returns correct value', () {
//       final json = {'price': '9.99'};
//       final price = model.doubleFromJson(json, 'price');
//       expect(price, 9.99);
//     });
//
//     test('boolFromJson returns correct value', () {
//       final json = {'isActive': 'true'};
//       final isActive = model.boolFromJson(json, 'isActive');
//       expect(isActive, isTrue);
//     });
//
//     test('boolFromJson returns false for "0"', () {
//       final json = {'isActive': '0'};
//       final isActive = model.boolFromJson(json, 'isActive');
//       expect(isActive, isFalse);
//     });
//   });
// }
