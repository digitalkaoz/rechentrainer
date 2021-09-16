import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_it/get_it.dart';
import 'package:rechentrainer/state/history.dart';
import 'package:rechentrainer/state/trainer.dart';
import 'package:rechentrainer/widgets/training_option.dart';

import 'animated_page.dart';
import 'base_view.dart';

class StartPageView extends StatefulWidget {
  final String title;

  const StartPageView({Key? key, required this.title}) : super(key: key);

  @override
  State<StartPageView> createState() => _StartPageViewState();
}

class _StartPageViewState extends State<StartPageView> {
  bool isGenerating = false;

  @override
  void initState() {
    super.initState();
    final trainer = GetIt.instance<Trainer>();
    trainer.loadConfiguration();
  }

  @override
  Widget build(BuildContext context) {
    final trainer = GetIt.instance<Trainer>();
    final history = GetIt.instance<History>();

    return BaseView(
      title: "Rechentrainer",
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
            label: "Einstellungen",
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
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: SizedBox(
                  width: 170,
                  child: PlatformElevatedButton(
                    child: isGenerating
                        ? const SpinKitThreeInOut(
                            size: 14,
                            color: Colors.white,
                          )
                        : const Text(
                            "Start",
                          ),
                    onPressed: () async {
                      await trainer.saveConfiguration();

                      setState(() {
                        isGenerating = !isGenerating;
                        trainer.start();
                        isGenerating = !isGenerating;
                      });
                    },
                  ),
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
  builder: (_) => const StartPageView(title: "Rechentrainer"),
);
