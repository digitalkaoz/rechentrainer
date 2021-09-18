import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AnimatedPage extends Page {
  final Widget Function(BuildContext) builder;
  final bool reload;

  AnimatedPage({
    required String key,
    required this.builder,
    this.reload = true,
  }) : super(key: ValueKey(key));

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      maintainState: reload,
      pageBuilder: (context, animation, animation2) {
        final tween = Tween(begin: const Offset(0.0, 1.0), end: Offset.zero);
        final curveTween = CurveTween(curve: Curves.easeInOut);
        return SlideTransition(
          position: animation.drive(curveTween).drive(tween),
          child: builder(context),
        );
      },
    );
  }
}
