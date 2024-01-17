import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fileease/core/bloc/send_file/download_file/download_file_model.dart';
import 'package:flutter_fileease/core/bloc/send_file/enums/download_status_enum.dart';
import 'package:flutter_fileease/core/bloc/send_file/file_model.dart';
import 'package:flutter_fileease/core/bloc/send_file/send_file_bloc.dart';
import 'package:flutter_fileease/services/navigation_service.dart';
import 'package:flutter_fileease/services/web_service.dart';

class FirebaseDownloadFileUtils {
  void downloadFilesInFilesList(
    List<FirebaseFileModel> filesList,
    List<FirebaseDownloadFileModel> downloadFilesList,
    void Function(
      FirebaseDownloadFileModel downloadModel,
      FirebaseFileModel fileModel,
    ) ifNotFoundedList,
  ) {
    final downloadFilesListLength = BlocProvider.of<FirebaseSendFileBloc>(
      NavigationService.navigatorKey.currentContext!,
    ).getDownloadFilesListLength();
    if (downloadFilesListLength > downloadFilesList.length) {
      return;
    }

    for (final file in filesList) {
      if (file.url != '') {
        final index = downloadFilesList.indexWhere(
          (item) => item.path == file.path &&
                  item.name == file.name &&
                  (WebService.isWeb)
              ? file.timestamp.seconds == item.fileCreatedTimestamp.seconds
              : file.timestamp == item.fileCreatedTimestamp,
        );
        if (index == -1) {
          ifNotFoundedList.call(
            FirebaseDownloadFileModel(
              path: file.path,
              name: file.name,
              fileCreatedTimestamp: file.timestamp,
              downloadPath: '',
              downloadStatus: FirebaseFileModelDownloadStatus.downloading,
            ),
            file,
          );
        }
      }
    }
  }
}
