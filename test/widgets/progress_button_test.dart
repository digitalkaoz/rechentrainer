import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rechentrainer/widgets/progress_button.dart';

void main() {
  Widget _buildWidget(Function cb, [Function? pre, Function? post]) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: ProgressButton(
        child: const Text("foo"),
        callback: cb,
        preCallback: pre,
        postCallback: post,
      ),
    );
  }

  testWidgets('successful callback', (WidgetTester tester) async {
    var called = false;

    await tester.pumpWidget(_buildWidget(() => called = true));

    expect(find.text('foo'), findsOneWidget);

    await tester.tap(find.text("foo"));
    await tester.pump();

    expect(find.text('foo'), findsOneWidget);
    expect(called, true);
  });

  testWidgets('faulty callback', (WidgetTester tester) async {
    await tester.pumpWidget(_buildWidget(() => throw Exception('foo')));

    expect(find.text('foo'), findsOneWidget);

    await tester.tap(find.text("foo"));
    await tester.pump();

    expect(find.text('foo'), findsNothing);
    expect(find.byType(SpinKitThreeInOut), findsOneWidget);
  });

  testWidgets('pre & post callbacks', (WidgetTester tester) async {
    var pre = false;
    var cb = false;
    var post = false;

    await tester.pumpWidget(_buildWidget(
      () => cb = true,
      () async => pre = true,
      () async => post = true,
    ));

    expect(find.text('foo'), findsOneWidget);

    await tester.tap(find.text("foo"));
    await tester.pump();

    expect(find.text('foo'), findsOneWidget);
    expect(cb, true);
    expect(pre, true);
    expect(post, true);
  });
}
