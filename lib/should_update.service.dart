import 'package:package_info/package_info.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

Future<bool> shouldUpdate() async {
  await Firebase.initializeApp();
  const String configName = "force_update_build_number";

  final PackageInfo packageInfo = await PackageInfo.fromPlatform();
  int currentVersion = int.parse(packageInfo.buildNumber);

  // remoteConfigの初期化
  final RemoteConfig remoteConfig = RemoteConfig.instance;

  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(seconds: 10),
    minimumFetchInterval: Duration(seconds: 0),
  ));
  await remoteConfig.setDefaults(<String, dynamic>{
    configName: currentVersion,
  });
  await remoteConfig.fetchAndActivate();

  int newVersion = remoteConfig.getInt(configName);

  return newVersion > currentVersion;
}
