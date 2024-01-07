import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

class FileService {
  Future<List<File>> pickFiles() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      return result.paths.map((path) => File(path!)).toList();
    } else {
      return [];
      // User canceled the picker
    }
  }

  Future<File?> getDownloadedFile(String name, {String? dirPath}) async {
    final filePath = (dirPath != null)
        ? dirPath
        : (await getApplicationDocumentsDirectory()).path;
    final relativePath = '$filePath/$name';
    final file = File(relativePath);
    if (file.existsSync()) {
      return file;
    }
    return null;
  }

  Future<List<FileSystemEntity>> listDownloadedFiles() async {
    final dir = Directory((await getApplicationDocumentsDirectory()).path);
    final entities = await dir.list().toList();
    return entities;
  }

  Future<List<FileSystemEntity>> listDownloadedFiles1() async {
    final dir = Directory((await getApplicationDocumentsDirectory()).path);
    final entities = await dir.list().toList();
    return entities;
  }

  Future<void> deleteDownloadedFiles() async {
    final list = await listDownloadedFiles();
    for (final file in list) {
      await file.delete();
    }
  }

  Future<void> deleteDownloadedProfilePhotosFolder() async {
    final tempDirPath = (await getTemporaryDirectory()).path;
    final relativePath = '$tempDirPath/profilePhotos';
    final directory = Directory(relativePath);
    if (!directory.existsSync()) return;
    final list = await directory.list().toList();
    for (final file in list) {
      await file.delete();
    }
  }

  Future<String> getAndControlProfilePhotoPath() async {
    final tempDirPath = (await getTemporaryDirectory()).path;
    final relativePath = '$tempDirPath/profilePhotos';
    final directory = Directory(relativePath);
    if (!directory.existsSync()) {
      await Directory(relativePath).create(recursive: true);
    }
    return relativePath;
  }

  Future<bool> checkExistProfilePhoto(String name, {String? dirPath}) async {
    final profilePhotoPath =
        (dirPath != null) ? dirPath : await getAndControlProfilePhotoPath();
    final relativePath = '$profilePhotoPath/$name';
    final directory = File(relativePath);
    return directory.existsSync();
  }

  Future<File> getProfilePhoto(String name, {String? dirPath}) async {
    final profilePhotoPath =
        (dirPath != null) ? dirPath : await getAndControlProfilePhotoPath();
    final relativePath = '$profilePhotoPath/$name';
    final directory = File(relativePath);
    return directory;
  }
}
