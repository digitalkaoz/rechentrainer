import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:localstore/localstore.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rechentrainer/state/history.dart';
import 'package:rechentrainer/state/trainer.dart';

import 'history_test.mocks.dart';

@GenerateMocks([CollectionRef, DocumentRef])
void main() {
  final t = TrainingResult(
      DateTime.now(), const Duration(seconds: 10), 0.1, 10, 10, 1, ['+', '-']);
  final s = MockCollectionRef();
  final d = MockDocumentRef();
  when(s.doc('history_foo')).thenReturn(d);
  when(d.set(any)).thenAnswer((_) => Future.value(null));
  when(d.delete()).thenAnswer((_) => Future.value(null));
  when(d.get()).thenAnswer(
    (_) => Future.value({
      'trainings': [t.toMap()]
    }),
  );

  GetIt.instance.registerSingleton<CollectionRef>(s);

  final h = History();

  test('toggle visibility', () {
    expect(h.visible, false);
    h.toggle();
    expect(h.visible, true);

    h.hide();
    expect(h.visible, false);

    h.show();
    expect(h.visible, true);
  });

  test('load', () async {
    expect(h.trainings.isEmpty, true);

    await h.load('foo');

    expect(h.trainings.isNotEmpty, true);
  });

  test('save', () async {
    h.trainings.clear();
    await h.save('foo', t);

    expect(h.trainings.contains(t), true);

    var capture = verify(d.set(captureThat(allOf(
      contains("trainings"),
    )))).captured;

    expect(capture[0]["trainings"].length, 1);
  });

  test('delete', () async {
    h.trainings.add(t);

    await h.delete('foo');
    verify(d.delete());
    expect(h.trainings.isEmpty, true);
  });
}
