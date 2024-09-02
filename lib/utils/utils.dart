import 'dart:io';
import 'dart:math';
import 'package:hive/hive.dart';
import 'package:miru_app/utils/storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:miru_app/utils/constans.dart';

class Utils {
  static final Random random = Random();

  static String getRandomUA() {
    final random = Random();
    String randomElement = userAgentsList[random.nextInt(userAgentsList.length)];
    return randomElement;
  }
  static generateDanmakuColor(int colorValue) {
    // 提取颜色分量
    int red = (colorValue >> 16) & 0xFF;
    int green = (colorValue >> 8) & 0xFF;
    int blue = colorValue & 0xFF;
    // 创建Color对象
    Color color = Color.fromARGB(255, red, green, blue);
    return color;
  }

  /// 判断是否为桌面设备
  static bool isDesktop() {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      return true;
    }
    return false;
  }

  /// 判断设备是否为宽屏
  static bool isWideScreen() {
    Box setting = GStorage.setting;
    bool isWideScreen =
        setting.get(SettingBoxKey.isWideScreen, defaultValue: false);
    return isWideScreen;
  }

  /// 判断设备是否为平板
  static bool isTablet() {
    return isWideScreen() && !isDesktop();
  }

  /// 判断设备是否需要紧凑布局
  static bool isCompact() {
    return !isDesktop() && !isWideScreen();
  }
}