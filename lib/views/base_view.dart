import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class BaseView extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? action;
  final PlatformNavBar? nav;

  const BaseView({
    Key? key,
    required this.title,
    required this.body,
    this.action,
    this.nav,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      iosContentPadding: true,
      appBar: PlatformAppBar(
          automaticallyImplyLeading: false,
          title: Text(title),
          trailingActions: action != null ? [action!] : []),
      body: body,
      bottomNavBar: nav,
    );
  }
}
