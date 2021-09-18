import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart' as p;
import 'package:get_it/get_it.dart';
import 'package:localstore/localstore.dart';
import 'package:rechentrainer/state/history.dart';
import 'package:rechentrainer/state/trainer.dart';
import 'package:rechentrainer/state/user.dart';
import 'package:rechentrainer/theme.dart';
import 'package:rechentrainer/widgets/platform_app.dart';

GetIt getIt = GetIt.instance;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  getIt.registerSingleton<Trainer>(Trainer());
  getIt.registerSingleton<History>(History());
  getIt.registerSingleton<User>(User());
  getIt.registerSingleton<CollectionRef>(
      Localstore.instance.collection('rechentrainer'));

  runApp(const Rechentrainer());
}

class Rechentrainer extends StatelessWidget {
  const Rechentrainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = GetIt.instance<User>();
    final history = GetIt.instance<History>();
    final trainer = GetIt.instance<Trainer>();

    return Theme(
      data: platformTheme,
      child: FutureBuilder<void>(future: Future(() async {
        await user.load();

        if (user.current != null) {
          trainer.load(user.current!);
          history.load(user.current!);
        }
      }), builder: (context, AsyncSnapshot snap) {
        if (snap.connectionState != ConnectionState.done) {
          return Container(
              color: Colors.white,
              child: p.PlatformCircularProgressIndicator());
        }

        return const PlatformApp(
          title: "Rechentrainer",
        );
      }),
    );
  }
}
