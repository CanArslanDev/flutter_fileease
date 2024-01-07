import 'dart:math';

import 'package:flutter_fileease/core/bloc/send_file/send_file_internet_bandwidth_speed/send_file_internet_bandwidth_speed_model.dart';

class SendFileInternetBandwidthSpeed {
  final bandwidthSpeedModel = SendFileInternetBandwidthSpeedModel(
    internetSpeedDateTime: DateTime.now(),
    differenceSpaceAsKB: 0,
  );

  String getInternetSendSpeed(double fileNowSpaceKB) {
    final differenceTime = DateTime.now()
        .difference(bandwidthSpeedModel.internetSpeedDateTime)
        .inMilliseconds;
    final differenceSpace =
        fileNowSpaceKB - bandwidthSpeedModel.differenceSpaceAsKB;
    final speedAsByte = (differenceSpace * 1000 / differenceTime) * 1024;
    bandwidthSpeedModel
      ..differenceSpaceAsKB = fileNowSpaceKB
      ..internetSpeedDateTime = DateTime.now();
    if (speedAsByte <= 0 || speedAsByte.isNaN || speedAsByte.isInfinite) {
      return '0MB/s';
    }
    return getSpeedSizeFromBytes(speedAsByte.toInt(), 1);
  }

  String getSpeedSizeFromBytes(int bytes, int decimalsByte) {
    if (bytes <= 0) return '0 B';
    const suffixes = [
      'B/s',
      'KB/s',
      'MB/s',
      'GB/s',
      'TB/s',
      'PB/s',
      'EB/s',
      'ZB/s',
      'YB/s',
    ];
    final i = (log(bytes) / log(1024)).floor();
    return '''${(bytes / pow(1024, i)).toStringAsFixed(decimalsByte)} ${suffixes[i]}''';
  }
}
