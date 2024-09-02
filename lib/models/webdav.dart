import 'package:hive/hive.dart';
import 'package:miru_app/utils/storage.dart';
import 'package:miru_app/utils/webdav.dart';

class webdavinit {
static Future init() async {
    Box setting = GStorage.setting;
    late bool webDavEnable = setting.get(SettingBoxKey.webDavEnable, defaultValue: false);
    if (webDavEnable) {
        var webDav = WebDav();
        await webDav.init();
        webDav.downloadAndMigrateIsar();
    }
  }
}