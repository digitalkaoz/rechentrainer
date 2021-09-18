import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:rechentrainer/state/history.dart';
import 'package:rechentrainer/state/trainer.dart';
import 'package:rechentrainer/state/user.dart';

import 'calculation_page.dart';
import 'history_page.dart';
import 'result_page.dart';
import 'start_page.dart';
import 'user_page.dart';

class PageRouter extends StatelessWidget {
  const PageRouter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final trainer = GetIt.instance<Trainer>();
    final history = GetIt.instance<History>();
    final user = GetIt.instance<User>();

    return Observer(builder: (_) {
      return Navigator(
        pages: [
          if (user.visible || user.current == null) userPage,
          if (user.current != null && !user.visible && !trainer.hasTasks)
            startPage,
          if (!user.visible && trainer.hasTasks) calculationPage,
          if (!user.visible && trainer.hasTasks && trainer.done) resultPage,
          if (!user.visible && history.visible) historyPage,
        ],
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }
          return true;
        },
      );
    });
  }
}
