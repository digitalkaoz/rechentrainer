import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:rechentrainer/state/history.dart';
import 'package:rechentrainer/state/trainer.dart';
import 'package:rechentrainer/state/user.dart';
import 'package:rechentrainer/utils/calculator.dart';
import 'package:rechentrainer/views/history_page.dart';
import 'package:rechentrainer/widgets/history_list.dart';

void main() {
  final h = History();
  final t = Trainer();
  GetIt.instance.registerSingleton<User>(User());
  GetIt.instance.registerSingleton<Trainer>(t);
  GetIt.instance.registerSingleton<History>(h);

  Widget _buildWidget() {
    return const MaterialApp(
      home: HistoryPageView(),
    );
  }

  testWidgets('renders the result list', (WidgetTester tester) async {
    h.trainings.add(TrainingResult(
        DateTime.now(), const Duration(seconds: 10), 0.1, 10, 10, 1, ['+']));

    await tester.pumpWidget(_buildWidget());

    expect(find.byType(HistoryList), findsOneWidget);
  });

  testWidgets('renders the bottom navigation bar without prior training',
      (WidgetTester tester) async {
    await tester.pumpWidget(_buildWidget());

    final BuildContext context = tester.element(find.byType(HistoryPageView));

    expect(find.byIcon(context.platformIcons.clockSolid), findsOneWidget);
    expect(find.byIcon(context.platformIcons.book), findsOneWidget);
    expect(find.byIcon(context.platformIcons.settings), findsNothing);
  });

  testWidgets('renders the bottom navigation bar with prior training',
      (WidgetTester tester) async {
    t.tasks.add(Equation.random(100, 1, ['+']));
    t.currentIndex = 1;
    await tester.pumpWidget(_buildWidget());

    final BuildContext context = tester.element(find.byType(HistoryPageView));

    expect(find.byIcon(context.platformIcons.clockSolid), findsOneWidget);
    expect(find.byIcon(context.platformIcons.book), findsOneWidget);
    expect(find.byIcon(context.platformIcons.settings), findsOneWidget);
  });
}
