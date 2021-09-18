import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:rechentrainer/state/tasks.dart';
import 'package:rechentrainer/widgets/user_list.dart';

import 'animated_page.dart';
import 'base_view.dart';

class UserPageView extends StatelessWidget {
  final _controller = TextEditingController();
  final String title;

  UserPageView({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView(
      padding: true,
      title: "Rechentrainer",
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.all(32),
            child: PlatformTextField(
              style: const TextStyle(fontSize: 32),
              hintText: "neuer Spieler",
              controller: _controller,
            ),
          ),
          PlatformElevatedButton(
            child: const Text("Anlegen"),
            onPressed: () => changeUser(_controller.value.text.trim()),
          ),
          const Expanded(child: UserList()),
        ],
      ),
    );
  }
}

AnimatedPage userPage = AnimatedPage(
  key: "UserPage",
  reload: false,
  builder: (_) => UserPageView(title: "Rechentrainer"),
);
