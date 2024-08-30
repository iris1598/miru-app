import 'package:flutter/material.dart';

class ColorUtils {
  static Color getColorByText(String text) {
    final int colorIndex = text.length % 10;
    final color = [
      Colors.blueGrey[500],
      Colors.brown[500],
      Colors.deepPurple[500],
      Colors.green[500],
      Colors.indigo[500],
      Colors.lightBlue[500],
      Colors.lightGreen[500],
      Colors.orange[500],
      Colors.pink[500],
      Colors.purple[500],
      Colors.red[500],
      Colors.teal[500],
    ][colorIndex];
    return color!;
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
}
