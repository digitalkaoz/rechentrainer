import 'package:get_it/get_it.dart';
import 'package:rechentrainer/state/history.dart';
import 'package:rechentrainer/state/trainer.dart';
import 'package:rechentrainer/state/user.dart';

final user = GetIt.instance<User>();
final history = GetIt.instance<History>();
final trainer = GetIt.instance<Trainer>();

Future<void> deleteUser(String name) => Future.wait([
      user.delete(name),
      trainer.delete(name),
      history.delete(name),
    ]);

Future<void> changeUser(String name) => Future.wait([
      Future(history.hide),
      user.change(name),
      trainer.load(name),
      history.load(name),
    ]);
