import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:miru_app/router/router.dart';
import 'package:miru_app/utils/utils.dart';
import 'package:miru_app/bean/settings/settings.dart';
import 'package:miru_app/utils/storage.dart';
import 'package:miru_app/utils/webdav.dart';
import 'package:hive/hive.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:miru_app/bean/appbar/sys_app_bar.dart';
import 'package:miru_app/webdav_editor/webdav_editor_page.dart';

class WebDavSettingsPage extends StatefulWidget {
  const WebDavSettingsPage({super.key});

  @override
  State<WebDavSettingsPage> createState() => _PlayerSettingsPageState();
}

class _PlayerSettingsPageState extends State<WebDavSettingsPage> {
  dynamic navigationBarState;
  Box setting = GStorage.setting;

  @override
  void initState() {
    super.initState();
  }

  void onBackPressed(BuildContext context) {
    //navigationBarState.showNavigate();
  }

  checkWebDav() async {
    var webDav = WebDav();
    await webDav.init();
    var webDavURL =
        await setting.get(SettingBoxKey.webDavURL, defaultValue: '');
    if (webDavURL == '') {
      await setting.put(SettingBoxKey.webDavEnable, false);
      debugPrint('未找到有效的webdav配置');
      return;
    }
    try {
      debugPrint('尝试从WebDav同步');
      var webDav = WebDav();
      await webDav.downloadAndMigrateIsar();
      debugPrint('同步成功');
    } catch (e) {
      if (e.toString().contains('Error: Not Found')) {
        debugPrint('配置成功, 这是一个不存在已有同步文件的全新WebDav');
      } else {
        debugPrint('同步失败 ${e.toString()}');
      }
    }
  }

  updateWebdav() async {
    var webDavEnable =
        await setting.get(SettingBoxKey.webDavEnable, defaultValue: false);
    if (webDavEnable) {
      try {
        debugPrint('尝试上传到WebDav');
        var webDav = WebDav();
        await webDav.uploadDefaultIsar();
        debugPrint('同步成功');
      } catch (e) {
        debugPrint('同步失败 ${e.toString()}');
      }
    } else {
      debugPrint('未开启WebDav同步或配置无效');
    }
  }

  downloadWebdav() async {
    var webDavEnable =
        await setting.get(SettingBoxKey.webDavEnable, defaultValue: false);
    if (webDavEnable) {
      try {
        debugPrint('尝试从WebDav同步');
        var webDav = WebDav();
        await webDav.downloadAndMigrateIsar();
        debugPrint('同步成功');
      } catch (e) {
        debugPrint('同步失败 ${e.toString()}');
      }
    } else {
      debugPrint('未开启WebDav同步或配置无效');
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //navigationBarState.hideNavigate();
    });
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        onBackPressed(context);
      },
      child: Scaffold(
        appBar: const SysAppBar(title: Text('同步设置')),
        body: Column(
          children: [
            InkWell(
              child: SetSwitchItem(
                title: 'WEBDAV同步',
                subTitle: '使用WEBDAV自动同步观看记录',
                setKey: SettingBoxKey.webDavEnable,
                callFn: (val) {
                  if (val) {
                    checkWebDav();
                  }
                },
                defaultVal: false,
              ),
            ),
            ListTile(
              onTap: () async {
                if (!Platform.isAndroid) {
                  router.push('/settings/webdav/editor');
                } else {
                  Get.to(() => const WebDavEditorPage());
                } 
              },
              dense: false,
              title: Text(
                'WEBDAV配置',
                style: Theme.of(context).textTheme.titleMedium!,
              ),
            ),
            ListTile(
              onTap: () {
                updateWebdav();
              },
              dense: false,
              title: const Text('手动上传'),
              subtitle: Text('立即上传观看记录到WEBDAV',
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Theme.of(context).colorScheme.outline)),
            ),
            ListTile(
              onTap: () {
                downloadWebdav();
              },
              dense: false,
              title: const Text('手动下载'),
              subtitle: Text('立即下载观看记录到本地',
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Theme.of(context).colorScheme.outline)),
            ),
          ],
        ),
      ),
    );
  }
}
