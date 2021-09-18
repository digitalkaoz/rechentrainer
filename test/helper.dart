import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rechentrainer/views/base_view.dart';
import 'package:rechentrainer/widgets/progress_button.dart';

Future<dynamic> createUser(WidgetTester tester, String name) async {
  await tester.enterText(find.byType(PlatformTextField), name);
  await tester.pumpAndSettle();
  await tester.tap(find.text('Anlegen'));
  await tester.pumpAndSettle(const Duration(seconds: 1));
}

Future<dynamic> startTraining(WidgetTester tester) async {
  await tester.scrollUntilVisible(find.byType(ProgressButton), 100);
  await tester.tap(find.byType(ProgressButton));
  await tester.pumpAndSettle(const Duration(seconds: 1));
}

Future<dynamic> solveEquation(WidgetTester tester, String value) async {
  await tester.enterText(find.byType(PlatformTextField), value);
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pumpAndSettle();
}

Future<dynamic> gotoTrainings(WidgetTester tester) async {
  final BuildContext context = tester.element(find.byType(BaseView));
  await tester.tap(find.byIcon(context.platformIcons.book));
  await tester.pumpAndSettle();
}

Future<dynamic> gotoResults(WidgetTester tester) async {
  final BuildContext context = tester.element(find.byType(BaseView));
  await tester.tap(find.byIcon(context.platformIcons.settings));
  await tester.pumpAndSettle();
}

Future<dynamic> gotoStart(WidgetTester tester) async {
  final BuildContext context = tester.element(find.byType(BaseView));
  await tester.tap(find.byIcon(context.platformIcons.clockSolid));
  await tester.pumpAndSettle();
}

Future<dynamic> gotoUsers(WidgetTester tester) async {
  final BuildContext context = tester.element(find.byType(BaseView));
  await tester.tap(find.byIcon(context.platformIcons.accountCircle));
  await tester.pumpAndSettle();
}
