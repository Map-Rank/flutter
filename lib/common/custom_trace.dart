// coverage:ignore-file
class CustomTrace {
  final StackTrace _trace;

  String? fileName;
  String? functionName;
  String? callerFunctionName;
  String? message;
  int? lineNumber;
  int? columnNumber;

  CustomTrace(this._trace, {this.message}) {
    _parseTrace();
  }

  String _getFunctionNameFromFrame(String frame) {
    var currentTrace = frame;
    var indexOfWhiteSpace = currentTrace.indexOf(' ');
    var subStr = currentTrace.substring(indexOfWhiteSpace);
    var indexOfFunction = subStr.indexOf(RegExp(r'[A-Za-z0-9]'));
    subStr = subStr.substring(indexOfFunction);
    indexOfWhiteSpace = subStr.indexOf(' ');
    subStr = subStr.substring(0, indexOfWhiteSpace);
    return subStr;
  }

  void _parseTrace() {
    var frames = this._trace.toString().split("\n");

    this.functionName = _getFunctionNameFromFrame(frames[0]);
    this.callerFunctionName = _getFunctionNameFromFrame(frames[1]);

    var traceString = frames[0];
    var indexOfFileName = traceString.indexOf(RegExp(r'[A-Za-z_]+.dart'));

    if (indexOfFileName == -1) {
      return;
    }

    var fileInfo = traceString.substring(indexOfFileName);

    var listOfInfos = fileInfo.split(":");
    try {
      this.fileName = listOfInfos[0].replaceAll(')', '');
      this.lineNumber = int.tryParse(listOfInfos[1]);
      var columnStr = listOfInfos[2];
      columnStr = columnStr.replaceFirst(")", "");
      this.columnNumber = int.tryParse(columnStr);
    } catch (e) {}
  }

  @override
  String toString() {
    return "$message | ($functionName)";
  }
}
