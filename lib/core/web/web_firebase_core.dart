import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;

class WebFirebaseCore {
  Future<DateTime> getServerTimestamp() async {
    final res = await http
        .get(Uri.parse('https://worldtimeapi.org/api/timezone/Etc/UTC'));
    final json = jsonDecode(res.body) as Map;
    final nowHttp = DateTime.parse(json['datetime'] as String);
    return nowHttp;
  }

  Future<String> getToken() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.deviceInfo;
    final allInfo = deviceInfo.data;
    var token = '';
    token += 'bwName${allInfo['browserName']}';
    token += 'appCodeName${allInfo['appCodeName']}';
    token += 'appName${allInfo['appName']}';
    token += 'product${allInfo['product']}';
    token += 'productSub${allInfo['productSub']}';
    return token;
  }
}
