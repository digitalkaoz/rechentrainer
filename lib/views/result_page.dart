import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:rechentrainer/state/history.dart';
import 'package:rechentrainer/state/trainer.dart';
import 'package:rechentrainer/utils/calculator.dart';
import 'package:rechentrainer/widgets/text_cell.dart';

import 'animated_page.dart';
import 'base_view.dart';

class ResultPageView extends StatefulWidget {
  const ResultPageView({Key? key}) : super(key: key);

  @override
  State<ResultPageView> createState() => _ResultPageViewState();
}

class _ResultPageViewState extends State<ResultPageView> {
  late ConfettiController _confettiController;
  int pageIndex = 1;

  @override
  void initState() {
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 10));
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _confettiController.play();
    });

    super.initState();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Widget _builder(Equation eq) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: eq.parts
            .map(
              (String e) => Expanded(
                flex: e == '?' ? 2 : 1,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: e == '?'
                      ? TextCell(
                          padding: const EdgeInsets.all(8),
                          center: true,
                          borderColor: eq.solved ? Colors.green : Colors.red,
                          text: eq.solved
                              ? eq.answer.toString()
                              : "${eq.answer == null ? '' : eq.answer.toString()} (${eq.solution.toString()})"
                                  .trim(),
                          style: TextStyle(
                              color: eq.solved ? Colors.green : Colors.red),
                        )
                      : TextCell(
                          center: true,
                          text: e,
                          padding: const EdgeInsets.all(8),
                        ),
                ),
              ),
            )
            .toList(),
      ),
      leading: Icon(eq.solved ? Icons.check : Icons.cancel,
          color: eq.solved ? Colors.green : Colors.red),
    );
  }

  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    var trainer = GetIt.instance<Trainer>();
    var history = GetIt.instance<History>();

    return BaseView(
      title: "Ergebnis - ${trainer.formattedDuration} Minuten",
      nav: PlatformNavBar(
        currentIndex: pageIndex,
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
      body: Stack(
        children: [
          Observer(builder: (_) {
            return Align(
              alignment: Alignment.center,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality
                    .explosive, // don't specify a direction, blast randomly
                shouldLoop: false,
                numberOfParticles: max((trainer.successRate * 20).toInt(), 1),
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple
                ], // manually specify the colors to be used
                createParticlePath: drawStar, // define a custom shape/path.
              ),
            );
          }),
          Center(
            child: Observer(builder: (_) {
              return ListView.builder(
                itemCount: trainer.tasks.length,
                itemBuilder: (_, index) => _builder(trainer.tasks[index]),
              );
            }),
          ),
        ],
      ),
    );
  }
}

AnimatedPage resultPage = AnimatedPage(
  key: "ResultPage",
  builder: (_) => const ResultPageView(),
);
