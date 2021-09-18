import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:rechentrainer/state/history.dart';
import 'package:rechentrainer/state/trainer.dart';
import 'package:rechentrainer/state/user.dart';
import 'package:rechentrainer/utils/calculator.dart';
import 'package:rechentrainer/views/result_page.dart';
import 'package:rechentrainer/widgets/result_list.dart';

void main() {
  final u = User();
  GetIt.instance.registerSingleton<User>(u);
  final t = Trainer();
  GetIt.instance.registerSingleton<Trainer>(t);
  GetIt.instance.registerSingleton<History>(History());

  Widget _buildWidget() {
    return const MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(size: Size.square(400)),
        child: ResultPageView(),
      ),
    );
  }

  testWidgets('renders the result list', (WidgetTester tester) async {
    t.tasks.add(Equation.random(100, 1, ['+']));
    t.start();
    while (t.done == false) {
      t.solve("7");
    }
    expect(t.done, true);

    await tester.pumpWidget(_buildWidget());

    expect(find.textContaining("Ergebnis - "), findsOneWidget);
    expect(find.byType(ResultList), findsOneWidget);
  });

  testWidgets('renders the bottom navigation bar', (WidgetTester tester) async {
    t.tasks.add(Equation.random(100, 1, ['+']));
    t.start();
    while (t.done == false) {
      t.solve("7");
    }

    await tester.pumpWidget(_buildWidget());

    final BuildContext context = tester.element(find.byType(ResultPageView));

    expect(find.byIcon(context.platformIcons.clockSolid), findsOneWidget);
    expect(find.byIcon(context.platformIcons.book), findsOneWidget);
    expect(find.byIcon(context.platformIcons.settings), findsOneWidget);
  });
}
