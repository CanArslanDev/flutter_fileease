import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';

class FilePickerService {
  Future<List<PlatformFile>> pickFiles() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      return result.files;
    }
    return [];
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
}
