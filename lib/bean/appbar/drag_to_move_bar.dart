import 'package:miru_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

/// A widget for drag to move window.
///
/// When you have hidden the title bar, you can add this widget to move the window position.
///
/// {@tool snippet}
///
/// The sample creates a red box, drag the box to move the window.
///
/// ```dart
/// DragToMoveArea(
///   child: Container(
///     width: 300,
///     height: 32,
///     color: Colors.red,
///   ),
/// )
/// ```
/// {@end-tool}
class DragToMoveArea extends StatelessWidget {
  const DragToMoveArea({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanStart: (_) => (Utils.isDesktop()) ? windowManager.startDragging() : null,
      child: child,
    );
  }
}
