import 'package:miru_app/pages/settings/danmaku/danmaku_module.dart';
import 'package:miru_app/pages/my/my_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MyModule extends Module {
  @override
  void routes(r) {
    r.child("/", child: (_) => const MyPage());
    r.module("/danmaku", module: DanmakuModule(), transition: TransitionType.noTransition);
  }
}
