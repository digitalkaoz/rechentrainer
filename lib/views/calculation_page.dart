import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:rechentrainer/state/history.dart';
import 'package:rechentrainer/state/trainer.dart';
import 'package:rechentrainer/views/base_view.dart';
import 'package:rechentrainer/widgets/text_cell.dart';

import 'animated_page.dart';

class CalculationPageView extends StatelessWidget {
  final _controller = TextEditingController();

  CalculationPageView({Key? key}) : super(key: key);

  Future<void> _saveAnswer(Trainer trainer, History history) async {
    trainer.solve(_controller.value.text);
    if (trainer.done) {
      await history.saveTraining("test", trainer.result!);
    }
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final trainer = GetIt.instance<Trainer>();
    final history = GetIt.instance<History>();

    return Observer(builder: (_) {
      return BaseView(
        action: PlatformIconButton(
          onPressed: trainer.reset,
          icon: Icon(context.platformIcons.reply),
        ),
        title:
            "Rechentrainer - ${(trainer.currentIndex + 1).toString()} / ${trainer.tasks.length.toString()}",
        body: trainer.currentTask != null
            ? Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: trainer.currentTask!.parts
                      .map((e) => e == "?"
                          ? Expanded(
                              child: SizedBox(
                                height: 60,
                                child: PlatformTextField(
                                  style: const TextStyle(fontSize: 40),
                                  onEditingComplete: () async =>
                                      await _saveAnswer(trainer, history),
                                  controller: _controller,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]')),
                                  ],
                                  autofocus: true,
                                  /*decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),*/
                                ),
                              ),
                            )
                          : Expanded(
                              child: Center(
                              child: TextCell(text: e),
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
