import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:localstore/localstore.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rechentrainer/state/user.dart';

import 'user_test.mocks.dart';

@GenerateMocks([CollectionRef, DocumentRef])
void main() {
  final s = MockCollectionRef();
  final d = MockDocumentRef();
  when(s.doc('users')).thenReturn(d);
  when(d.set(any)).thenAnswer((_) => Future.value(null));
  when(d.delete()).thenAnswer((_) => Future.value(null));
  when(d.get()).thenAnswer(
    (_) => Future.value({
      'current': 'Robert',
      'all': ['Robert', 'Silke', 'Charlotte', 'Elisabeth']
    }),
  );

  GetIt.instance.registerSingleton<CollectionRef>(s);

  final u = User();

  test('toggle visibility', () {
    expect(u.visible, false);
    u.toggle();
    expect(u.visible, true);
  });

  test('load', () async {
    expect(u.current, null);

    await u.load();

    expect(u.current, "Robert");
    expect(u.users, ['Robert', 'Silke', 'Charlotte', 'Elisabeth']);
  });

  test('save', () async {
    await u.save();

    verify(d.set(argThat(allOf(
      contains("current"),
      contains("all"),
    ))));
  });

  test('change', () async {
    u.users.clear();
    u.users.addAll(["Elisabeth", "Robert"]);
    u.current = "Elisabeth";

    await u.change('Silke');
    expect(u.current, "Silke");

    var capture = verify(d.set(captureThat(allOf(
      contains("current"),
      contains("all"),
    )))).captured;

    expect(capture[0]["current"], "Silke");
    expect((capture[0]["all"] as List<String>).contains("Silke"), true);
  });

  test('delete', () async {
    u.users.clear();
    u.users.addAll(["Elisabeth", "Robert"]);
    u.current = "Elisabeth";

    await u.delete('Elisabeth');
    expect(u.users.contains("Elisabeth"), false);

    var capture = verify(d.set(captureThat(allOf(
      contains("current"),
      contains("all"),
    )))).captured;

    expect((capture[0]["all"] as List<String>).contains("Elisabeth"), false);
    expect((capture[0]["all"] as List<String>).contains("Robert"), true);
    expect(u.current, null);
  });
}
