import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_fileease/services/file_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;

class HttpService {
  static HttpClient httpClient = HttpClient();
  Future<File> downloadFile(
    String url,
    String filename, {
    void Function(String downloadPath)? downloadPath,
  }) async {
    final request = await httpClient.getUrl(Uri.parse(url));
    final response = await request.close();
    final bytes = await consolidateHttpClientResponseBytes(response);
    final dir = (await getApplicationDocumentsDirectory()).path;
    final file = File('$dir/$filename');
    if (downloadPath != null) downloadPath.call('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<File> downloadProfilePhotoFile(
    String url,
    String filename, {
    void Function(String downloadPath)? downloadPath,
  }) async {
    final request = await httpClient.getUrl(Uri.parse(url));
    final response = await request.close();
    final bytes = await consolidateHttpClientResponseBytes(response);
    final dir = await FileService().getAndControlProfilePhotoPath();
    final file = File('$dir/$filename');
    if (downloadPath != null) downloadPath.call('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  void downloadFileForWeb(String url, String fileName) {
    html.AnchorElement(href: url)
      ..setAttribute('download', fileName)
      ..click();
  }
}
