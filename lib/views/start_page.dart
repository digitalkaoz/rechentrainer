import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:rechentrainer/state/trainer.dart';
import 'package:rechentrainer/widgets/training_option.dart';

import 'animated_page.dart';
import 'base_view.dart';

class StartPageView extends StatelessWidget {
  final String title;

  const StartPageView({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var trainer = GetIt.instance<Trainer>();

    return BaseView(
      title: "Rechentrainer",
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Observer(
                builder: (_) => TrainingOption(
                  name: "Recheroperationen",
                  labels: trainer.arithmeticKeys,
                  values: trainer.arithmeticValues,
                  callback: trainer.selectArithmetic,
                ),
              ),
              Observer(
                builder: (_) => TrainingOption(
                  name: "Runden",
                  labels: trainer.countKeys,
                  values: trainer.countValues,
                  callback: trainer.selectCount,
                ),
              ),
              Observer(
                builder: (_) => TrainingOption(
                  name: "Zahlenraum",
                  labels: trainer.rangeKeys,
                  values: trainer.rangeValues,
                  callback: trainer.selectRange,
                ),
              ),
              Observer(
                builder: (_) => TrainingOption(
                  name: "Kette",
                  labels: trainer.chainKeys,
                  values: trainer.chainValues,
                  callback: trainer.selectChain,
                ),
              ),
            ],
          ),
        ),
      ),
      action: FloatingActionButton(
        onPressed: () => {trainer.start()},
        tooltip: 'Start',
        child: const Icon(Icons.timer),
      ),
    );
  }
}

AnimatedPage startPage = AnimatedPage(
  key: "Rechentrainer",
  builder: (_) => const StartPageView(title: "Rechentrainer"),
);
