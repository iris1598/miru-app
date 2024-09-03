import 'dart:io';

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:miru_app/danmaku/danmaku_source_settings.dart';
import 'package:miru_app/router/router.dart';
import 'package:miru_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:miru_app/bean/settings/settings.dart';
import 'package:miru_app/utils/storage.dart';
import 'package:hive/hive.dart';
import 'package:miru_app/bean/appbar/sys_app_bar.dart';

class DanmakuSettingsPage extends StatefulWidget {
  const DanmakuSettingsPage({super.key});

  @override
  State<DanmakuSettingsPage> createState() => _DanmakuSettingsPageState();
}

class _DanmakuSettingsPageState extends State<DanmakuSettingsPage> {
  dynamic navigationBarState;
  Box setting = GStorage.setting;
  late dynamic defaultDanmakuArea;
  late dynamic defaultDanmakuOpacity;
  late dynamic defaultDanmakuFontSize;

  @override
  void initState() {
    super.initState();
    defaultDanmakuArea =
        setting.get(SettingBoxKey.danmakuArea, defaultValue: 1.0);
    defaultDanmakuOpacity =
        setting.get(SettingBoxKey.danmakuOpacity, defaultValue: 1.0);
    defaultDanmakuFontSize = setting.get(SettingBoxKey.danmakuFontSize,
        defaultValue: (Utils.isCompact()) ? 16.0 : 25.0);
  }

  void onBackPressed(BuildContext context) {
    //navigationBarState.showNavigate();
    // Navigator.of(context).pop();
  }

  void updateDanmakuArea(double i) async {
    await setting.put(SettingBoxKey.danmakuArea, i);
    setState(() {
      defaultDanmakuArea = i;
    });
  }

  void updateDanmakuOpacity(double i) async {
    await setting.put(SettingBoxKey.danmakuOpacity, i);
    setState(() {
      defaultDanmakuOpacity = i;
    });
  }

  void updateDanmakuFontSize(double i) async {
    await setting.put(SettingBoxKey.danmakuFontSize, i);
    setState(() {
      defaultDanmakuFontSize = i;
    });
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
        appBar: const SysAppBar(title: Text('弹幕设置')),
        body: ListView(
          children: [
            ListTile(
              onTap: () {
                if (!Platform.isAndroid) {
                  router.push('/settings/danmaku/source');
                } else {
                  Get.to(() => const DanmakuSourceSettingsPage());
                } 
              },
              dense: false,
              title: const Text('弹幕来源'),
            ),
            const InkWell(
              child: SetSwitchItem(
                title: '默认开启',
                subTitle: '默认是否随视频播放弹幕',
                setKey: SettingBoxKey.danmakuEnabledByDefault,
                defaultVal: false,
              ),
            ),
            const InkWell(
              child: SetSwitchItem(
                title: '弹幕描边',
                setKey: SettingBoxKey.danmakuBorder,
                defaultVal: true,
              ),
            ),
            const InkWell(
              child: SetSwitchItem(
                title: '顶部弹幕',
                setKey: SettingBoxKey.danmakuTop,
                defaultVal: true,
              ),
            ),
            const InkWell(
              child: SetSwitchItem(
                title: '底部弹幕',
                setKey: SettingBoxKey.danmakuBottom,
                defaultVal: false,
              ),
            ),
            const InkWell(
              child: SetSwitchItem(
                title: '滚动弹幕',
                setKey: SettingBoxKey.danmakuScroll,
                defaultVal: true,
              ),
            ),
            const InkWell(
              child: SetSwitchItem(
                title: '弹幕颜色',
                setKey: SettingBoxKey.danmakuColor,
                defaultVal: true,
              ),
            ),
            const InkWell(
              child: SetSwitchItem(
                title: '海量弹幕',
                subTitle: '弹幕过多时进行叠加绘制',
                setKey: SettingBoxKey.danmakuMassive,
                defaultVal: false,
              ),
            ),
            ListTile(
              onTap: () async {
                final List<double> danFontList = [
                  10.0,
                  11.0,
                  12.0,
                  13.0,
                  14.0,
                  15.0,
                  16.0,
                  17.0,
                  18.0,
                  19.0,
                  20.0,
                  21.0,
                  22.0,
                  23.0,
                  24.0,
                  25.0,
                  26.0,
                  27.0,
                  28.0,
                  29.0,
                  30.0,
                  31.0,
                  32.0,
                ];
                SmartDialog.show(
                    useAnimation: false,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('字体大小'),
                        content: StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          return Wrap(
                            spacing: 8,
                            runSpacing: 2,
                            children: [
                              for (final double i in danFontList) ...<Widget>[
                                if (i == defaultDanmakuFontSize) ...<Widget>[
                                  FilledButton(
                                    onPressed: () async {
                                      updateDanmakuFontSize(i);
                                      SmartDialog.dismiss();
                                    },
                                    child: Text(i.toString()),
                                  ),
                                ] else ...[
                                  FilledButton.tonal(
                                    onPressed: () async {
                                      updateDanmakuFontSize(i);
                                      SmartDialog.dismiss();
                                    },
                                    child: Text(i.toString()),
                                  ),
                                ]
                              ]
                            ],
                          );
                        }),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => SmartDialog.dismiss(),
                            child: Text(
                              '取消',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.outline),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              updateDanmakuFontSize(
                                  (Utils.isCompact())
                                      ? 16.0
                                      : 25.0);
                              SmartDialog.dismiss();
                            },
                            child: const Text('默认设置'),
                          ),
                        ],
                      );
                    });
              },
              dense: false,
              title: const Text('字体大小'),
              subtitle: Text('$defaultDanmakuFontSize',
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Theme.of(context).colorScheme.outline)),
            ),
            ListTile(
              onTap: () async {
                final List<double> danOpacityList = [
                  0.1,
                  0.2,
                  0.3,
                  0.4,
                  0.5,
                  0.6,
                  0.7,
                  0.8,
                  0.9,
                  1.0,
                ];
                SmartDialog.show(
                    useAnimation: false,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('弹幕不透明度'),
                        content: StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          return Wrap(
                            spacing: 8,
                            runSpacing: 2,
                            children: [
                              for (final double i
                                  in danOpacityList) ...<Widget>[
                                if (i == defaultDanmakuOpacity) ...<Widget>[
                                  FilledButton(
                                    onPressed: () async {
                                      updateDanmakuOpacity(i);
                                      SmartDialog.dismiss();
                                    },
                                    child: Text(i.toString()),
                                  ),
                                ] else ...[
                                  FilledButton.tonal(
                                    onPressed: () async {
                                      updateDanmakuOpacity(i);
                                      SmartDialog.dismiss();
                                    },
                                    child: Text(i.toString()),
                                  ),
                                ]
                              ]
                            ],
                          );
                        }),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => SmartDialog.dismiss(),
                            child: Text(
                              '取消',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.outline),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              updateDanmakuOpacity(1.0);
                              SmartDialog.dismiss();
                            },
                            child: const Text('默认设置'),
                          ),
                        ],
                      );
                    });
              },
              dense: false,
              title: const Text('弹幕不透明度'),
              subtitle: Text('$defaultDanmakuOpacity',
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
