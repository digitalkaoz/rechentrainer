import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:rechentrainer/state/history.dart';
import 'package:rechentrainer/state/trainer.dart';
import 'package:rechentrainer/utils/date.dart';

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
    var history = GetIt.instance<History>();

    if (history.trainings.isEmpty) {
      history.loadHistory("test");
    }

    if (trainer.done) {
      pageIndex = 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    var trainer = GetIt.instance<Trainer>();
    var history = GetIt.instance<History>();

    return BaseView(
      title: "Trainings",
      action: history.trainings.isNotEmpty
          ? PlatformIconButton(
              onPressed: () async => await history.clear("test"),
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
          if (trainer.currentIndex > 0)
            BottomNavigationBarItem(
                icon: Icon(context.platformIcons.settings), label: "Ergebnis"),
          BottomNavigationBarItem(
              icon: Icon(context.platformIcons.book), label: "Trainings")
        ],
      ),
      body: Observer(
        builder: (_) {
          return ListView.builder(
            itemCount: history.trainings.length,
            itemBuilder: (_, index) => _builder(history.trainings[index]),
          );
        },
      ),
    );
  }

  _builder(TrainingResult training) {
    return ListTile(
      isThreeLine: true,
      horizontalTitleGap: 0,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      subtitle: Text(
          "Zahlenraum: ${training.range}, Kette: ${training.chain}, Runden: ${training.count}"),
      title: Text(
        "${DateFormat.yMd().format(training.start)}: ${training.arithmetics.join(' ')}",
      ),
      trailing: Text(
        formatDuration(training.duration),
      ),
      leading: Text(
        "${training.successRate.toInt() * 100} %",
        style: TextStyle(
          color: training.successRate >= 0.8
              ? Colors.green
              : training.successRate >= 0.4
                  ? Colors.yellow
                  : Colors.red,
        ),
      ),
    );
  }
}

AnimatedPage historyPage = AnimatedPage(
  key: "HistoryPage",
  builder: (_) => const HistoryPageView(),
);
