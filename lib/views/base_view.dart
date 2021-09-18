import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:rechentrainer/state/user.dart';

class BaseView extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? action;
  final PlatformNavBar? nav;
  final bool? padding;

  const BaseView({
    Key? key,
    required this.title,
    required this.body,
    this.action,
    this.nav,
    this.padding = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = GetIt.instance<User>();

    return PlatformScaffold(
      iosContentPadding: padding!,
      appBar: PlatformAppBar(
          automaticallyImplyLeading: false,
          leading: Observer(builder: (_) {
            return user.current == null
                ? const Text("")
                : PlatformIconButton(
                    icon: Icon(context.platformIcons.accountCircle),
                    onPressed: user.toggle,
                  );
          }),
          title: Center(child: Text(title)),
          trailingActions: action != null ? [action!] : []),
      body: body,
      bottomNavBar: nav,
    );
  }
}
