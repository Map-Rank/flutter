import 'package:flutter_test/flutter_test.dart';
import 'package:mapnrank/app/models/setting_model.dart';
// Adjust import path as necessary

void main() {
  group('Setting Model Tests', () {
    test('Setting class initializes correctly', () {
      // Example of creating a Setting instance
      final setting = Setting(
        appName: 'My App',
        mainColor: '#FFFFFF',
        secondColor: '#000000',
        accentColor: '#FF0000',
        accentDarkColor: '#990000',
        defaultTheme: 'light',
      );

      // Verify that fields are correctly populated
      expect(setting.appName, 'My App');
      expect(setting.mainColor, '#FFFFFF');
      expect(setting.secondColor, '#000000');
      expect(setting.accentColor, '#FF0000');
      expect(setting.accentDarkColor, '#990000');
      expect(setting.defaultTheme, 'light');
    });

    // Additional test cases can be added as needed
  });
}
