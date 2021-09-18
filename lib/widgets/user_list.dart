import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:rechentrainer/state/tasks.dart';
import 'package:rechentrainer/state/user.dart';

class UserList extends StatelessWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = GetIt.instance<User>();

    return Observer(
      builder: (_) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: user.users.length,
          itemBuilder: (_, index) => _builder(context, user.users[index]),
        );
      },
    );
  }

  _builder(BuildContext context, String name) {
    return ListTile(
      title: Text(name),
      leading: PlatformIconButton(
          icon: Icon(context.platformIcons.checkMark),
          onPressed: () => changeUser(name)),
      trailing: PlatformIconButton(
        icon: Icon(context.platformIcons.delete),
        onPressed: () => deleteUser(name),
      ),
    );
  }
}
