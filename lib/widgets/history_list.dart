import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:rechentrainer/state/history.dart';
import 'package:rechentrainer/state/trainer.dart';
import 'package:rechentrainer/utils/date.dart';

class HistoryList extends StatelessWidget {
  const HistoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var history = GetIt.instance<History>();

    return Observer(
      builder: (_) {
        return ListView.builder(
          itemCount: history.trainings.length,
          itemBuilder: (_, index) => _builder(history.trainings[index]),
        );
      },
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
