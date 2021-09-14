import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:rechentrainer/state/trainer.dart';
import 'package:rechentrainer/utils/calculator.dart';

import 'animated_page.dart';
import 'base_view.dart';

class ResultPageView extends StatelessWidget {
  const ResultPageView({Key? key}) : super(key: key);

  Widget _builder(Equation eq) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: eq.parts
            .map(
              (String e) => e == '?'
                  ? Expanded(
                      child: Text(
                        eq.solved
                            ? eq.answer.toString()
                            : "${eq.answer.toString()} (${eq.solution.toString()})",
                        style: TextStyle(
                            color: eq.solved ? Colors.green : Colors.red),
                      ),
                    )
                  : Expanded(child: Text(e)),
            )
            .toList(),
      ),
      leading: Icon(eq.solved ? Icons.check : Icons.cancel,
          color: eq.solved ? Colors.green : Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    var trainer = GetIt.instance<Trainer>();

    return BaseView(
      title: "Ergebnis",
      body: Center(
        child: Observer(builder: (_) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: ListView.builder(
                  itemCount: trainer.tasks.length,
                  itemBuilder: (_, index) {
                    return _builder(trainer.tasks[index]);
                  },
                ),
              ),
              Text(trainer.duration.toString())
            ],
          );
        }),
      ),
      action: FloatingActionButton(
        onPressed: trainer.reset,
        tooltip: 'Reset',
        child: const Icon(Icons.restart_alt),
      ),
    );
  }
}

AnimatedPage resultPage = AnimatedPage(
  key: "ResultPage",
  builder: (_) => const ResultPageView(),
);
