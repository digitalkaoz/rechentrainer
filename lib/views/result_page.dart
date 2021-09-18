import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:rechentrainer/state/history.dart';
import 'package:rechentrainer/state/trainer.dart';
import 'package:rechentrainer/widgets/confetti_widget.dart';
import 'package:rechentrainer/widgets/result_list.dart';

import 'animated_page.dart';
import 'base_view.dart';

class ResultPageView extends StatelessWidget {
  const ResultPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var trainer = GetIt.instance<Trainer>();
    var history = GetIt.instance<History>();

    return BaseView(
      title: "Ergebnis - ${trainer.formattedDuration} Minuten",
      nav: PlatformNavBar(
        currentIndex: 1,
        itemChanged: (int i) {
          if (i == 0) {
            trainer.reset();
            if (history.visible) {
              history.toggle();
            }
          } else {
            history.toggle();
          }
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(context.platformIcons.clockSolid), label: "Start"),
          BottomNavigationBarItem(
              icon: Icon(context.platformIcons.settings), label: "Ergebnis"),
          BottomNavigationBarItem(
              icon: Icon(context.platformIcons.book), label: "Trainings")
        ],
      ),
      body: Observer(
        builder: (_) {
          return ConfettiWidget(
            children: const [ResultList()],
            particles: max((trainer.successRate * 20).toInt(), 1),
          );
        },
      ),
    );
  }
}

AnimatedPage resultPage = AnimatedPage(
  key: "ResultPage",
  reload: false,
  builder: (_) => const ResultPageView(),
);
