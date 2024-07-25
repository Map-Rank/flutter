import 'dart:convert';
import 'dart:io';

import 'package:coverage/coverage.dart';

Future<void> main() async {
  // Start the test process with coverage collection
  // final process = await Process.start(
  //   'flutter',
  //   ['test', '--coverage'],
  // );
  //
  // // Forward the standard output and error to the current console
  // process.stdout.pipe(stdout);
  // process.stderr.pipe(stderr);
  //
  // // Wait for the process to complete
  // final exitCode = await process.exitCode;
  // if (exitCode != 0) {
  //   exit(exitCode);
  // }

  // Read the coverage file
  final coverageFile = File('coverage/lcov.info');
  if (!coverageFile.existsSync()) {
    print('Coverage file not found');
    exit(1);
  }

  final coverageData = await coverageFile.readAsString();

  // Parse the LCOV data
  final coverage = await parseLcov(coverageData);

  // Print function-level coverage details
  for (final record in coverage) {
    print('File: ${record.source}');
    for (final func in record.functions ?? []) {
      print('  Function: ${func.name}');
      print('    Start Line: ${func.start}');
      print('    Execution Count: ${func.executionCount}');
    }
  }
}

Future<List<CoverageData>> parseLcov(String lcov) async {
  final List<CoverageData> coverageData = [];
  final List<String> lines = lcov.split('\n');

  CoverageData? currentData;
  FunctionCoverage? currentFunction;
  for (final line in lines) {
    if (line.startsWith('SF:')) {
      if (currentData != null) {
        coverageData.add(currentData);
      }
      currentData = CoverageData(line.substring(3), []);
    } else if (line.startsWith('FN:')) {
      final parts = line.substring(3).split(',');
      currentFunction = FunctionCoverage(parts[1], int.parse(parts[0]), 0);
      currentData?.functions.add(currentFunction);
    } else if (line.startsWith('FNDA:')) {
      final parts = line.substring(5).split(',');
      final count = int.parse(parts[0]);
      currentFunction?.executionCount = count;
    }
  }
  if (currentData != null) {
    coverageData.add(currentData);
  }

  return coverageData;
}

class CoverageData {
  final String source;
  final List<FunctionCoverage> functions;

  CoverageData(this.source, this.functions);
}

class FunctionCoverage {
  final String name;
  final int start;
  int executionCount;

  FunctionCoverage(this.name, this.start, this.executionCount);
}
