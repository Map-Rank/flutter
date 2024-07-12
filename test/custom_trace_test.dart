import 'package:flutter_test/flutter_test.dart';
import 'package:mapnrank/common/custom_trace.dart';
// Adjust the import based on your file structure

void main() {
  group('CustomTrace', () {
    test('parses trace and extracts function name, caller function name, file name, line number, and column number correctly', () {
      // Simulating a stack trace
      final trace = StackTrace.fromString('''
#0      CustomTrace._parseTrace (package:your_package_name/custom_trace.dart:30:15)
#1      CustomTrace.<init> (package:your_package_name/custom_trace.dart:15:7)
#2      main.<init> (package:your_package_name/main.dart:5:3)
''');

      final customTrace = CustomTrace(trace);

      expect(customTrace.functionName, 'CustomTrace._parseTrace');
      expect(customTrace.callerFunctionName, 'CustomTrace.<init>');
      expect(customTrace.fileName, 'custom_trace.dart');
      expect(customTrace.lineNumber, 30);
      expect(customTrace.columnNumber, 15);
    });

    test('parses trace with message', () {
      // Simulating a stack trace with a message
      final trace = StackTrace.fromString('''
#0      CustomTrace._parseTrace (package:your_package_name/custom_trace.dart:30:15)
#1      CustomTrace.<init> (package:your_package_name/custom_trace.dart:15:7)
#2      main.<init> (package:your_package_name/main.dart:5:3)
''');

      final customTrace = CustomTrace(trace, message: 'An error occurred');

      expect(customTrace.functionName, 'CustomTrace._parseTrace');
      expect(customTrace.callerFunctionName, 'CustomTrace.<init>');
      expect(customTrace.fileName, 'custom_trace.dart');
      expect(customTrace.lineNumber, 30);
      expect(customTrace.columnNumber, 15);
      expect(customTrace.message, 'An error occurred');
      expect(customTrace.toString(), 'An error occurred | (CustomTrace._parseTrace)');
    });

    test('handles malformed trace gracefully', () {
      // Simulating a malformed stack trace
      final trace = StackTrace.fromString('''
#0      CustomTrace._parseTrace (package:your_package_name/custom_trace.dart)
#1      CustomTrace.<init> (package:your_package_name/custom_trace.dart)
#2      main.<init> (package:your_package_name/main.dart)
''');

      final customTrace = CustomTrace(trace);

      expect(customTrace.functionName, 'CustomTrace._parseTrace');
      expect(customTrace.callerFunctionName, 'CustomTrace.<init>');
      expect(customTrace.fileName, 'custom_trace.dart');
      expect(customTrace.lineNumber, isNull);
      expect(customTrace.columnNumber, isNull);
    });
  });
}
