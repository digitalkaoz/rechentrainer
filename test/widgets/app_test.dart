import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:localstore/localstore.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:rechentrainer/main.dart';
import 'package:rechentrainer/state/history.dart';
import 'package:rechentrainer/state/trainer.dart';
import 'package:rechentrainer/state/user.dart';
import 'package:rechentrainer/views/calculation_page.dart';
import 'package:rechentrainer/views/history_page.dart';
import 'package:rechentrainer/views/result_page.dart';
import 'package:rechentrainer/views/start_page.dart';
import 'package:rechentrainer/views/user_page.dart';

import '../helper.dart';
import '../storage.dart';

void main({bool onDevice = false}) {
  if (!onDevice) {
    PathProviderPlatform.instance = TestPathProviderPlatform();
  }

  GetIt.instance.registerSingleton<User>(User());
  GetIt.instance.registerSingleton<History>(History());
  GetIt.instance.registerSingleton<Trainer>(Trainer());
  GetIt.instance.registerSingleton<CollectionRef>(
      Localstore.instance.collection(DateTime.now().toIso8601String()));

  TestWidgetsFlutterBinding.ensureInitialized();

  Widget _buildWidget() {
    return const Rechentrainer();
  }

  testWidgets('user flow', (WidgetTester tester) async {
    var trainer = GetIt.instance<Trainer>();

    await tester.pumpWidget(_buildWidget(), const Duration(seconds: 10));
    await tester.pumpAndSettle();

    // user page
    expect(find.byType(UserPageView), findsOneWidget);
    await createUser(tester, "Robert");

    // start page
    expect(find.byType(StartPageView), findsOneWidget);
    await startTraining(tester);

    // should redirect us to the equation page
    expect(find.byType(CalculationPageView), findsOneWidget);

    while (trainer.done == false) {
      await solveEquation(tester, "7");
    }

    // once all done, we get redirect to the result page
    expect(find.byType(ResultPageView), findsOneWidget);

    // click on trainings should reveal the history page
    await gotoTrainings(tester);

    expect(find.byType(HistoryPageView), findsOneWidget);

    // click on result, should redirect us to the result page again
    await gotoResults(tester);

    expect(find.byType(ResultPageView), findsOneWidget);

    // click on start should redirect us back to the start page
    await gotoStart(tester);

    expect(find.byType(StartPageView), findsOneWidget);

    // click on profile should redirect us back to user page
    await gotoUsers(tester);

    expect(find.byType(UserPageView), findsOneWidget);
  });
}
