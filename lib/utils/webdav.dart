import 'dart:io';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hive/hive.dart';
import 'package:isar/isar.dart';
import 'package:miru_app/controllers/home_controller.dart';
import 'package:miru_app/models/favorite.dart';
import 'package:miru_app/models/history.dart';
import 'package:miru_app/utils/miru_directory.dart';
import 'package:miru_app/utils/miru_storage.dart';
import 'package:webdav_client/webdav_client.dart' as webdav;
import 'package:miru_app/utils/storage.dart';
import 'package:logger/logger.dart';
import 'package:miru_app/utils/logger.dart';

class WebDav {
  late String webDavURL;
  late String webDavUsername;
  late String webDavPassword;
  late Directory webDavLocalTempDirectory;
  late webdav.Client client;
  late Isar isar;

  WebDav._internal();
  static final WebDav _instance = WebDav._internal();
  factory WebDav() => _instance;

  Future init() async {
    var directory = MiruDirectory.getDirectory;
    webDavLocalTempDirectory = Directory('${directory}/webdavTemp');
    Box setting = GStorage.setting;
    webDavURL = setting.get(SettingBoxKey.webDavURL, defaultValue: '');
    webDavUsername = setting.get(SettingBoxKey.webDavUsername, defaultValue: '');
    webDavPassword = setting.get(SettingBoxKey.webDavPassword, defaultValue: '');
    client = webdav.newClient(
      webDavURL,
      user: webDavUsername,
      password: webDavPassword,
      debug: false,
    );
    isar = MiruStorage.database;
    client.setHeaders({'accept-charset': 'utf-8'});
    try {
      await client.mkdir('/kazumiSync');
      KazumiLogger().log(Level.info, 'webDav backup diretory create success');
    } catch (_) {
      KazumiLogger().log(Level.error, 'webDav backup diretory create failed');
    }
  }

  Future uploadDefaultIsar() async {
    var directory = MiruDirectory.getDirectory;
    String isarFilePath = '${directory}/default.isar';
    await client.writeFromFile(isarFilePath, '/kazumiSync/default.isar',
        onProgress: (c, t) {
      // print(c / t);
    });
  }

  Future downloadAndMigrateIsar() async {
    var directory = MiruDirectory.getDirectory;
    String newIsarFilePath = '${directory}/defaultnew.isar';
    if (!await webDavLocalTempDirectory.exists()) {
      await webDavLocalTempDirectory.create(recursive: true);
    }
    final newIsarFile = File(newIsarFilePath);
    await client.read2File('/kazumiSync/default.isar', newIsarFile.path,
        onProgress: (c, t) {
      // 打印进度信息
      // print(c / t);
    });

    // 打开新的Isar数据库
    final newIsar = await Isar.open([HistorySchema, FavoriteSchema], name: 'defaultnew',directory: '${directory}');

    // 迁移历史和收藏夹数据
    await migrateData(newIsar, isar);
    // 关闭新的Isar数据库
   await newIsar.close();

    // 删除新的Isar文件，因为它已经不再需要
    await newIsarFile.delete();
    await Get.find<HomePageController>().onRefresh();
  }

  Future migrateData(Isar newIsar, Isar oldIsar) async {
    // 假设History和Favorite是具有适当架构的Isar集合
    final newHistories = await newIsar.historys.where().findAll();
    final newFavorites = await newIsar.favorites.where().findAll();

    // 在插入新数据之前清除旧数据
    await oldIsar.writeTxn(() async {
      await oldIsar.historys.clear();
      await oldIsar.favorites.clear();
    });

    // 将新数据插入到旧的Isar数据库中
    await oldIsar.writeTxn(() async {
      await oldIsar.historys.putAll(newHistories);
      await oldIsar.favorites.putAll(newFavorites);
    });
  }

  Future ping() async {
    await client.ping();
  }
}