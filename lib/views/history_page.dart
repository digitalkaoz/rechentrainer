import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:rechentrainer/state/history.dart';
import 'package:rechentrainer/state/trainer.dart';
import 'package:rechentrainer/state/user.dart';
import 'package:rechentrainer/widgets/history_list.dart';

import 'animated_page.dart';
import 'base_view.dart';

class HistoryPageView extends StatefulWidget {
  const HistoryPageView({Key? key}) : super(key: key);

  @override
  State<HistoryPageView> createState() => _HistoryPageViewState();
}

class _HistoryPageViewState extends State<HistoryPageView> {
  int pageIndex = 1;

  @override
  void initState() {
    super.initState();
    var trainer = GetIt.instance<Trainer>();

    if (trainer.done) {
      pageIndex = 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    var trainer = GetIt.instance<Trainer>();
    var history = GetIt.instance<History>();
    var user = GetIt.instance<User>();

    return BaseView(
        title: "Trainings",
        action: history.trainings.isNotEmpty
            ? PlatformIconButton(
                onPressed: () => history.delete(user.current!),
                icon: Icon(context.platformIcons.delete),
              )
            : null,
        nav: PlatformNavBar(
          currentIndex: pageIndex,
          itemChanged: (int i) {
            if (i == 0) {
              history.toggle();
              trainer.reset();
            }
            if (trainer.currentIndex > 0 && i == 1) {
              history.toggle();
            }
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(context.platformIcons.clockSolid), label: "Start"),
            if (trainer.done)
              BottomNavigationBarItem(
                  icon: Icon(context.platformIcons.settings),
                  label: "Ergebnis"),
            BottomNavigationBarItem(
                icon: Icon(context.platformIcons.book), label: "Trainings")
          ],
        ),
        body: const HistoryList());
  }
}

AnimatedPage historyPage = AnimatedPage(
  key: "HistoryPage",
  builder: (_) => const HistoryPageView(),
);
