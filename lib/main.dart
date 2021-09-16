import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rechentrainer/state/history.dart';
import 'package:rechentrainer/state/trainer.dart';
import 'package:rechentrainer/theme.dart';
import 'package:rechentrainer/widgets/platform_app.dart';

GetIt getIt = GetIt.instance;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  getIt.registerSingleton<Trainer>(Trainer());
  getIt.registerSingleton<History>(History());

  runApp(const Rechentrainer());
}

class Rechentrainer extends StatelessWidget {
  const Rechentrainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: platformTheme,
      child: const PlatformApp(
        title: "Rechentrainer",
      ),
    );
  }
}
