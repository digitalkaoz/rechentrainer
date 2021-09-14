import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:rechentrainer/state/trainer.dart';
import 'package:rechentrainer/views/base_view.dart';

import 'animated_page.dart';

class CalculationPageView extends StatelessWidget {
  final _controller = TextEditingController();

  CalculationPageView({Key? key}) : super(key: key);

  void _saveAnswer(Trainer trainer) {
    trainer.solve(_controller.value.text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    var trainer = GetIt.instance<Trainer>();

    return Observer(builder: (_) {
      return BaseView(
        title:
            "Rechentrainer - ${(trainer.currentIndex + 1).toString()} / ${trainer.tasks.length.toString()}",
        body: trainer.currentTask != null
            ? Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: trainer.currentTask!.parts
                      .map((e) => e == "?"
                          ? Expanded(
                              child: TextFormField(
                                onEditingComplete: () => _saveAnswer(trainer),
                                controller: _controller,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                ],
                                autofocus: true,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            )
                          : Expanded(
                              child: Center(
                              child: Text(
                                e,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            )))
                      .toList(),
                ),
              )
            : const Text(""),
      );
    });
  }
}

AnimatedPage calculationPage = AnimatedPage(
  key: "CalculationPage",
  builder: (_) => CalculationPageView(),
);
