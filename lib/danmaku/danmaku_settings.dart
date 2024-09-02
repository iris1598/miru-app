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
    navigationBarState.showNavigate();
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
      navigationBarState.hideNavigate();
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
                router.push('/settings/danmaku/source');
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
          ],
        ),
      ),
    );
  }
}
