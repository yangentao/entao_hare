import 'package:package_info_plus/package_info_plus.dart';

Future<PackageInfo> packageInfo() async {
  PackageInfo info = await PackageInfo.fromPlatform();
  return info;
}
