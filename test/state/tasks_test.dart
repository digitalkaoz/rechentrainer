import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rechentrainer/state/history.dart';
import 'package:rechentrainer/state/tasks.dart';
import 'package:rechentrainer/state/trainer.dart';
import 'package:rechentrainer/state/user.dart';

import 'tasks_test.mocks.dart';

@GenerateMocks([User, History, Trainer])
void main() {
  final t = MockTrainer();
  final u = MockUser();
  final h = MockHistory();

  GetIt.instance.registerSingleton<History>(h);
  GetIt.instance.registerSingleton<User>(u);
  GetIt.instance.registerSingleton<Trainer>(t);

  test('deleteUser', () {
    deleteUser("foo");

    verify(t.delete("foo"));
    verify(h.delete("foo"));
    verify(u.delete("foo"));
  });

  test('changeUser', () {
    changeUser("foo");

    verify(t.load("foo"));
    verify(h.load("foo"));
    verify(u.change("foo"));
  });
}
