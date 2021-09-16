import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart' as p;
import 'package:get_it/get_it.dart';
import 'package:rechentrainer/state/history.dart';
import 'package:rechentrainer/state/trainer.dart';
import 'package:rechentrainer/views/calculation_page.dart';
import 'package:rechentrainer/views/history_page.dart';
import 'package:rechentrainer/views/result_page.dart';
import 'package:rechentrainer/views/start_page.dart';

class PlatformApp extends StatelessWidget {
  final String title;

  const PlatformApp({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final trainer = GetIt.instance<Trainer>();
    final history = GetIt.instance<History>();

    return p.PlatformProvider(
      //initialPlatform: TargetPlatform.iOS,
      settings: p.PlatformSettingsData(iosUsesMaterialWidgets: true),
      builder: (_) => p.PlatformApp(
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          DefaultMaterialLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
        ],
        title: title,
        home: Observer(builder: (_) {
          return Navigator(
            pages: [
              startPage,
              if (trainer.hasTasks) calculationPage,
              if (trainer.hasTasks && trainer.done) resultPage,
              if (history.visible) historyPage,
            ],
            onPopPage: (route, result) {
              if (!route.didPop(result)) {
                return false;
              }
              return true;
            },
          );
        }),
      ),
    );
  }
}
