import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:rechentrainer/state/trainer.dart';
import 'package:rechentrainer/views/calculation_page.dart';
import 'package:rechentrainer/views/result_page.dart';
import 'package:rechentrainer/views/start_page.dart';

GetIt getIt = GetIt.instance;

void main() {
  getIt.registerSingleton<Trainer>(Trainer());
  runApp(const Rechentrainer());
}

class Rechentrainer extends StatelessWidget {
  const Rechentrainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rechentrainer',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Observer(builder: (_) {
        var trainer = getIt<Trainer>();
        return Navigator(
          pages: [
            startPage,
            if (trainer.hasTasks) calculationPage,
            if (trainer.hasTasks && trainer.done) resultPage
          ],
          onPopPage: (route, result) {
            if (!route.didPop(result)) {
              return false;
            }
            return true;
          },
        );
      }),
    );
  }
}
