import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:rechentrainer/state/history.dart';
import 'package:rechentrainer/state/trainer.dart';
import 'package:rechentrainer/widgets/history_list.dart';

void main() {
  final h = History();
  GetIt.instance.registerSingleton<History>(h);
  final t = TrainingResult(
      DateTime.now(), const Duration(seconds: 10), 0.1, 10, 10, 1, ['+', '-']);

  Widget _buildWidget() {
    return const Material(
      child: MediaQuery(
        data: MediaQueryData(),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: HistoryList(),
        ),
      ),
    );
  }

  testWidgets('renders lines', (WidgetTester tester) async {
    h.trainings.add(t);

    await tester.pumpWidget(_buildWidget());

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(ListTile), findsOneWidget);
    expect(find.byType(Text), findsNWidgets(4));
  });
}
