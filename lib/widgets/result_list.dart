import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:rechentrainer/state/trainer.dart';
import 'package:rechentrainer/utils/calculator.dart';
import 'package:rechentrainer/widgets/text_cell.dart';

class ResultList extends StatelessWidget {
  const ResultList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var trainer = GetIt.instance<Trainer>();

    return Observer(builder: (_) {
      return ListView.builder(
        itemCount: trainer.tasks.length,
        itemBuilder: (_, index) => _builder(context, trainer.tasks[index]),
      );
    });
  }

  Widget _builder(BuildContext context, Equation eq) {
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
      leading: Icon(
          eq.solved
              ? context.platformIcons.checkMark
              : context.platformIcons.clear,
          color: eq.solved ? Colors.green : Colors.red),
    );
  }
}
