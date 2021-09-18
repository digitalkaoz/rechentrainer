import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
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
import 'package:rechentrainer/widgets/history_list.dart';
import 'package:rechentrainer/widgets/progress_button.dart';
import 'package:rechentrainer/widgets/result_list.dart';
import 'package:rechentrainer/widgets/text_cell.dart';
import 'package:rechentrainer/widgets/training_option.dart';

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

    // first we should see the users page
    expect(find.byType(UserPageView), findsOneWidget);
    expect(find.text('Anlegen'), findsOneWidget);
    expect(find.byType(PlatformTextField), findsOneWidget);

    await tester.enterText(find.byType(PlatformTextField), "Robert");
    await tester.pumpAndSettle();
    await tester.tap(find.text('Anlegen'));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // should redirect us to the config page
    expect(find.byType(StartPageView), findsOneWidget);

    // TODO refactor out the separate view test
    expect(find.byType(TrainingOption), findsNWidgets(4));
    expect(find.byType(ProgressButton), findsOneWidget);
    expect(find.byIcon(Icons.watch_later), findsOneWidget);
    expect(find.byIcon(Icons.book), findsOneWidget);

    await tester.scrollUntilVisible(find.byType(ProgressButton), 100);
    await tester.tap(find.byType(ProgressButton));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // should redirect us to the equation page
    expect(find.byType(CalculationPageView), findsOneWidget);

    // TODO refactor out the separate view test
    expect(find.byType(PlatformTextField), findsOneWidget);
    expect(find.byType(TextCell), findsNWidgets(4));

    while (trainer.done == false) {
      await tester.enterText(find.byType(PlatformTextField), "7");
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
    }

    // once all done, we get redirect to the result page
    expect(find.byType(ResultPageView), findsOneWidget);

    // TODO refactor out the separate view test
    expect(find.textContaining("Ergebnis - "), findsOneWidget);
    expect(find.byType(ResultList), findsOneWidget);
    expect(find.byIcon(Icons.watch_later), findsOneWidget);
    expect(find.byIcon(Icons.book), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);

    // click on trainings should reveal the history page
    await tester.tap(find.byIcon(Icons.book));
    await tester.pumpAndSettle();

    expect(find.byType(HistoryPageView), findsOneWidget);

    // TODO refactor out the separate view test
    expect(find.byType(HistoryList), findsOneWidget);
    expect(find.byIcon(Icons.watch_later), findsOneWidget);
    expect(find.byIcon(Icons.book), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);

    // click on result, should redirect us to the result page again
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    expect(find.byType(ResultPageView), findsOneWidget);

    // click on start should redirect us back to the start page
    await tester.tap(find.byIcon(Icons.watch_later));
    await tester.pumpAndSettle();

    expect(find.byType(StartPageView), findsOneWidget);

    // TODO refactor out the separate view test
    expect(find.byIcon(Icons.account_circle_outlined), findsOneWidget);

    // click on profile should redirect us back to user page
    await tester.tap(find.byIcon(Icons.account_circle_outlined));
    await tester.pumpAndSettle();

    expect(find.byType(UserPageView), findsOneWidget);
  });
}
