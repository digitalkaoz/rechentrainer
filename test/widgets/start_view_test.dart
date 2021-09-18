import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:rechentrainer/state/history.dart';
import 'package:rechentrainer/state/trainer.dart';
import 'package:rechentrainer/state/user.dart';
import 'package:rechentrainer/views/start_page.dart';
import 'package:rechentrainer/widgets/progress_button.dart';
import 'package:rechentrainer/widgets/training_option.dart';

void main() {
  final t = Trainer();
  final u = User();
  GetIt.instance.registerSingleton<User>(u);
  GetIt.instance.registerSingleton<Trainer>(t);
  GetIt.instance.registerSingleton<History>(History());

  Widget _buildWidget() {
    return const MaterialApp(
      home: StartPageView(
        title: 'Rechentrainer',
      ),
    );
  }

  testWidgets('renders the training configuration',
      (WidgetTester tester) async {
    await tester.pumpWidget(_buildWidget());

    expect(find.byType(TrainingOption), findsNWidgets(4));
    expect(find.byType(ProgressButton), findsOneWidget);
  });

  testWidgets('renders the bottom navigation', (WidgetTester tester) async {
    await tester.pumpWidget(_buildWidget());

    final BuildContext context = tester.element(find.byType(StartPageView));

    expect(find.byIcon(context.platformIcons.clockSolid), findsOneWidget);
    expect(find.byIcon(context.platformIcons.book), findsOneWidget);
    expect(find.byIcon(context.platformIcons.settings), findsNothing);
  });

  testWidgets('renders the profile switcher', (WidgetTester tester) async {
    u.current = "Robert";

    await tester.pumpWidget(_buildWidget());

    final BuildContext context = tester.element(find.byType(StartPageView));

    expect(find.byIcon(context.platformIcons.accountCircle), findsOneWidget);
  });
}
