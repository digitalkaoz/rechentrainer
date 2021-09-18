import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:rechentrainer/state/history.dart';
import 'package:rechentrainer/state/trainer.dart';
import 'package:rechentrainer/state/user.dart';
import 'package:rechentrainer/widgets/progress_button.dart';
import 'package:rechentrainer/widgets/training_option.dart';

import 'animated_page.dart';
import 'base_view.dart';

class StartPageView extends StatelessWidget {
  final String title;

  const StartPageView({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final trainer = GetIt.instance<Trainer>();
    final history = GetIt.instance<History>();
    final user = GetIt.instance<User>();

    return BaseView(
      padding: true,
      title: "${user.current}'s Rechentrainer",
      nav: PlatformNavBar(
        currentIndex: 0,
        itemChanged: (int i) {
          if (i == 0) {
            trainer.reset();
          }
          if (i == 1 && !history.visible) {
            history.toggle();
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(context.platformIcons.clockSolid),
            label: "Start",
          ),
          BottomNavigationBarItem(
            icon: Icon(context.platformIcons.book),
            label: "Trainings",
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  name: "Zahlenraum",
                  labels: trainer.rangeKeys,
                  values: trainer.rangeValues,
                  callback: trainer.selectRange,
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
                  name: "Kette",
                  labels: trainer.chainKeys,
                  values: trainer.chainValues,
                  callback: trainer.selectChain,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: ProgressButton(
                  width: 170,
                  child: const Text("Start"),
                  callback: trainer.start,
                  preCallback: () => trainer.save(user.current!),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

AnimatedPage startPage = AnimatedPage(
  key: "Rechentrainer",
  reload: false,
  builder: (_) => const StartPageView(title: "Rechentrainer"),
);
