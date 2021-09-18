import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:rechentrainer/state/user.dart';
import 'package:rechentrainer/views/user_page.dart';
import 'package:rechentrainer/widgets/user_list.dart';

void main() {
  final u = User();
  GetIt.instance.registerSingleton<User>(u);

  Widget _buildWidget() {
    return MaterialApp(
      home: UserPageView(
        title: 'Rechentrainer',
      ),
    );
  }

  testWidgets('renders the new user form', (WidgetTester tester) async {
    await tester.pumpWidget(_buildWidget());

    expect(find.text('Anlegen'), findsOneWidget);
    expect(find.byType(PlatformTextField), findsOneWidget);
  });

  testWidgets('renders the users lists', (WidgetTester tester) async {
    await tester.pumpWidget(_buildWidget());

    expect(find.byType(UserList), findsOneWidget);
  });
}
