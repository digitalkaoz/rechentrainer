import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:rechentrainer/state/trainer.dart';
import 'package:rechentrainer/utils/calculator.dart';
import 'package:rechentrainer/widgets/result_list.dart';
import 'package:rechentrainer/widgets/text_cell.dart';

void main() {
  final t = Trainer();
  GetIt.instance.registerSingleton<Trainer>(t);

  Widget _buildWidget() {
    return const Material(
      child: MediaQuery(
        data: MediaQueryData(),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: ResultList(),
        ),
      ),
    );
  }

  testWidgets('renders lines', (WidgetTester tester) async {
    var e = Equation.random(10, 2, ['+', '-']);
    t.tasks.add(e);

    await tester.pumpWidget(_buildWidget());

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(Row), findsOneWidget);
    expect(find.byType(TextCell), findsNWidgets(7)); // 5 + 4 + 3 = 12
    expect(find.byType(Icon), findsOneWidget);
  });

  testWidgets('renders a successful line', (WidgetTester tester) async {
    var e = Equation("4 + 5");
    e.answer = e.solution;
    t.tasks.clear();
    t.tasks.add(e);

    await tester.pumpWidget(_buildWidget());

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(Row), findsOneWidget);
    expect(find.byType(TextCell), findsNWidgets(5)); // 4 + 5 = 9
    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('renders faulty line', (WidgetTester tester) async {
    var e = Equation("4 + 5");
    e.answer = 99;
    t.tasks.clear();
    t.tasks.add(e);

    await tester.pumpWidget(_buildWidget());

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(Row), findsOneWidget);
    expect(find.byType(TextCell), findsNWidgets(5)); // 4 + 5 = 9
    expect(find.byIcon(Icons.clear), findsOneWidget);
  });
}
