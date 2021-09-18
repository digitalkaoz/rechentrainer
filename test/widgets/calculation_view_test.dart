import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:rechentrainer/state/history.dart';
import 'package:rechentrainer/state/trainer.dart';
import 'package:rechentrainer/state/user.dart';
import 'package:rechentrainer/utils/calculator.dart';
import 'package:rechentrainer/views/calculation_page.dart';
import 'package:rechentrainer/widgets/text_cell.dart';

void main() {
  final t = Trainer();
  GetIt.instance.registerSingleton<Trainer>(t);
  GetIt.instance.registerSingleton<User>(User());
  GetIt.instance.registerSingleton<History>(History());

  Widget _buildWidget() {
    return MaterialApp(
      home: CalculationPageView(),
    );
  }

  testWidgets('renders the equation form', (WidgetTester tester) async {
    t.tasks.add(Equation.random(100, 1, ['+']));
    await tester.pumpWidget(_buildWidget());

    expect(find.byType(PlatformTextField), findsOneWidget);
    expect(find.byType(TextCell), findsNWidgets(4));
  });
}
