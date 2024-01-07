import 'dart:io';
import 'dart:math';

class ConvertValueService {
  static String addSpaceFor6CaracterID(String text) {
    final regex = RegExp(r'^\w{3}\w{3}$');
    if (regex.hasMatch(text)) {
      return text.replaceRange(3, 3, ' ');
    } else {
      return '';
    }
  }

  String getFileSize(String filepath, int decimalsByte) {
    final file = File(filepath);
    final bytes = file.lengthSync();
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
    final i = (log(bytes) / log(1024)).floor();
    return '''${(bytes / pow(1024, i)).toStringAsFixed(decimalsByte)} ${suffixes[i]}''';
  }

  String getFileSizeFromBytes(int bytes, int decimalsByte) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
    final i = (log(bytes) / log(1024)).floor();
    return '''${(bytes / pow(1024, i)).toStringAsFixed(decimalsByte)} ${suffixes[i]}''';
  }

  String getFileSizeFromKB(int kilobytes, int decimalsByte) {
    if (kilobytes * 1024 <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
    final i = (log(kilobytes * 1024) / log(1024)).floor();
    return '''${(kilobytes * 1024 / pow(1024, i)).toStringAsFixed(decimalsByte)} ${suffixes[i]}''';
  }
}
