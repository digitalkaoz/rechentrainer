import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:localstore/localstore.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:rechentrainer/state/history.dart';
import 'package:rechentrainer/state/trainer.dart';
import 'package:rechentrainer/state/user.dart';
import 'package:rechentrainer/widgets/user_list.dart';

import '../storage.dart';

void main() {
  final u = User();
  PathProviderPlatform.instance = TestPathProviderPlatform();

  GetIt.instance.registerSingleton<User>(u);
  GetIt.instance.registerSingleton<History>(History());
  GetIt.instance.registerSingleton<Trainer>(Trainer());
  GetIt.instance
      .registerSingleton<CollectionRef>(Localstore.instance.collection("test"));

  Widget _buildWidget() {
    return const Material(
      child: MediaQuery(
        data: MediaQueryData(),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: UserList(),
        ),
      ),
    );
  }

  testWidgets('renders lines', (WidgetTester tester) async {
    u.users.addAll(['Foo']);

    await tester.pumpWidget(_buildWidget());

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(ListTile), findsNWidgets(1));
    expect(find.text("Foo"), findsOneWidget);
    expect(find.byIcon(Icons.check), findsOneWidget);
    expect(find.byIcon(Icons.delete), findsOneWidget);
  });

  testWidgets('select user', (WidgetTester tester) async {
    u.users.clear();
    u.users.addAll(['Foo']);
    u.current = null;

    await tester.pumpWidget(_buildWidget());

    await tester.tap(find.byIcon(Icons.check));
    await tester.pumpAndSettle();

    expect(u.current, "Foo");
  });

  testWidgets('delete user', (WidgetTester tester) async {
    u.users.clear();
    u.users.addAll(['Foo']);
    u.current = null;

    await tester.pumpWidget(_buildWidget());

    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();

    expect(u.current, null);
    expect(u.users.isEmpty, true);
  });
}
