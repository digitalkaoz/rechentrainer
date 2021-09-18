import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart' as p;
import 'package:rechentrainer/views/page_router.dart';

class PlatformApp extends StatelessWidget {
  final String title;

  const PlatformApp({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return p.PlatformProvider(
      initialPlatform: TargetPlatform.iOS,
      settings: p.PlatformSettingsData(iosUsesMaterialWidgets: true),
      builder: (_) => p.PlatformApp(
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          DefaultMaterialLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
        ],
        title: title,
        home: const PageRouter(),
      ),
    );
  }
}
