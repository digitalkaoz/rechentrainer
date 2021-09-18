import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:localstore/localstore.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rechentrainer/state/trainer.dart';

import 'trainer_test.mocks.dart';

@GenerateMocks([CollectionRef, DocumentRef])
void main() {
  group('arithmetics', () {
    final t = Trainer();

    test('get available arithmetics', () {
      expect(t.arithmetics.keys.contains("+"), true);
      expect(t.arithmetics.keys.contains("-"), true);
      expect(t.arithmetics.keys.contains("*"), true);
      expect(t.arithmetics.keys.contains("/"), true);

      expect(t.arithmeticValues.isNotEmpty, true);
      expect(t.arithmeticKeys.isNotEmpty, true);
      for (var element in t.arithmeticValues) {
        expect(element is bool, true);
      }
      for (var element in t.arithmeticKeys) {
        expect(element is String, true);
      }
    });

    test('toggle arithmetic', () {
      var a = t.arithmetics.entries.elementAt(1);
      expect(t.arithmetics[a.key], false);

      t.selectArithmetic(1);
      expect(t.arithmetics[a.key], true);
    });

    test('require at least 1 selected', () {
      var a = t.arithmetics.entries.firstWhere((element) => element.value);
      var index = t.arithmetics.keys.toList().indexOf(a.key);

      expect(t.arithmetics[a.key], true);

      // toggle all others off
      t.arithmetics.entries.forEachIndexed((index, element) {
        if (element.key != a.key) {
          t.selectArithmetic(index, false);
        }
      });

      // toggling the last active, should keep it active
      t.selectArithmetic(index);
      expect(t.arithmetics[a.key], true);
    });
  });

  group('range', () {
    final t = Trainer();

    test('get available ranges', () {
      expect(t.range.keys.contains("10"), true);
      expect(t.range.keys.contains("100"), true);
      expect(t.range.keys.contains("1000"), true);

      expect(t.rangeValues.isNotEmpty, true);
      expect(t.rangeKeys.isNotEmpty, true);
      for (var element in t.rangeValues) {
        expect(element is bool, true);
      }
      for (var element in t.rangeKeys) {
        expect(element is String, true);
      }
    });

    test('toggle range', () {
      var a = t.range.entries.elementAt(1);
      expect(t.range[a.key], false);

      t.selectRange(1);
      expect(t.range[a.key], true);
    });

    test('selection is exclusive', () {
      var a = t.range.entries.firstWhere((element) => element.value);
      var index = t.range.keys.toList().indexOf(a.key);

      expect(t.range[a.key], true);

      // toggling one item deactivates the other
      t.selectRange(index + 1);
      expect(t.range[a.key], false);
      expect(t.range.values.elementAt(index + 1), true);
    });
  });

  group('count', () {
    final t = Trainer();

    test('get available counts', () {
      expect(t.count.keys.contains("2"), true);
      expect(t.count.keys.contains("25"), true);
      expect(t.count.keys.contains("50"), true);
      expect(t.count.keys.contains("75"), true);
      expect(t.count.keys.contains("100"), true);

      expect(t.countValues.isNotEmpty, true);
      expect(t.countKeys.isNotEmpty, true);
      for (var element in t.countValues) {
        expect(element is bool, true);
      }
      for (var element in t.countKeys) {
        expect(element is String, true);
      }
    });

    test('toggle count', () {
      var a = t.count.entries.elementAt(1);
      expect(t.count[a.key], false);

      t.selectCount(1);
      expect(t.count[a.key], true);
    });

    test('selection is exclusive', () {
      var a = t.count.entries.firstWhere((element) => element.value);
      var index = t.count.keys.toList().indexOf(a.key);

      expect(t.count[a.key], true);

      // toggling one item deactivates the other
      t.selectCount(index + 1);
      expect(t.count[a.key], false);
      expect(t.count.values.elementAt(index + 1), true);
    });
  });

  group('chain', () {
    final t = Trainer();

    test('get available rounds', () {
      expect(t.chain.keys.contains("1"), true);
      expect(t.chain.keys.contains("2"), true);
      expect(t.chain.keys.contains("3"), true);
      expect(t.chain.keys.contains("4"), true);

      expect(t.chainValues.isNotEmpty, true);
      expect(t.chainKeys.isNotEmpty, true);
      for (var element in t.chainValues) {
        expect(element is bool, true);
      }
      for (var element in t.chainKeys) {
        expect(element is String, true);
      }
    });

    test('toggle chain', () {
      var a = t.chain.entries.elementAt(1);
      expect(t.chain[a.key], false);

      t.selectChain(1);
      expect(t.chain[a.key], true);
    });

    test('selection is exclusive', () {
      var a = t.chain.entries.firstWhere((element) => element.value);
      var index = t.chain.keys.toList().indexOf(a.key);

      expect(t.chain[a.key], true);

      // toggling one item deactivates the other
      t.selectChain(index + 1);
      expect(t.chain[a.key], false);
      expect(t.chain.values.elementAt(index + 1), true);
    });
  });

  group('training', () {
    final t = Trainer();

    test('start', () {
      t.start();

      expect(t.initial, true);
      expect(t.hasTasks, true);
    });

    test('solve', () {
      t.start();

      for (var element in t.tasks) {
        t.solve("42");
      }

      expect(t.done, true);
      expect(t.formattedDuration.isNotEmpty, true);
      expect(t.result != null, true);
    });

    test('reset', () {
      t.start();

      expect(t.hasTasks, true);

      t.reset();

      expect(t.hasTasks, false);
    });
  });

  group('result', () {
    final t = Trainer();
    t.start();

    for (var element in t.tasks) {
      t.solve("42");
    }

    test('solved', () {
      //we assume not all equations have 42 s the correct answer ;)
      expect(t.result!.solved, false);
    });

    test('toMap', () {
      var res = t.result!.toMap();
      expect(res.containsKey("start"), true);
      expect(res.containsKey("duration"), true);
      expect(res.containsKey("successRate"), true);
      expect(res.containsKey("range"), true);
      expect(res.containsKey("chain"), true);
      expect(res.containsKey("count"), true);
      expect(res.containsKey("arithmetics"), true);

      expect(res["start"] is String, true);
      expect(res["duration"] is int, true);
      expect(res["successRate"] is double, true);
      expect(res["range"] is int, true);
      expect(res["chain"] is int, true);
      expect(res["count"] is int, true);
      expect(res["arithmetics"] is List, true);
    });

    test('fromMap', () {
      var d = DateTime.now();

      var res = TrainingResult.fromMap({
        "start": d.toIso8601String(),
        "duration": 300,
        "successRate": 0.5,
        "range": 100,
        "chain": 2,
        "count": 2,
        "arithmetics": ["+", "-"]
      });

      expect(res.start, d);
      expect(res.duration.inSeconds, 300);
      expect(res.successRate, 0.5);
      expect(res.range, 100);
      expect(res.chain, 2);
      expect(res.count, 2);
      expect(
          res.arithmetics.contains("+") &&
              res.arithmetics.contains("-") &&
              res.arithmetics.length == 2,
          true);
    });
  });

  group('storage', () {
    final s = MockCollectionRef();
    final d = MockDocumentRef();
    when(s.doc('trainer_foo')).thenReturn(d);
    when(d.set(any)).thenAnswer((_) => Future.value(null));
    when(d.delete()).thenAnswer((_) => Future.value(null));
    when(d.get()).thenAnswer(
      (_) => Future.value({
        'count': {'25': true},
        'chain': {'2': true},
        'range': {'1000': true},
        'arithmetics': {'+': true, '-': true, '*': true, '/': true}
      }),
    );

    GetIt.instance.registerSingleton<CollectionRef>(s);

    final t = Trainer();

    test('save', () async {
      await t.save("foo");

      verify(d.set(argThat(isNotNull)));
    });
    test('clear', () async {
      await t.delete("foo");

      verify(d.delete());
    });

    test('load', () async {
      expect(t.range['1000'], false);

      await t.load("foo");

      expect(t.range['1000'], true);
      expect(t.chain['2'], true);
      expect(t.count['25'], true);
      for (var a in t.arithmeticValues) {
        expect(a, true);
      }
    });
  });
}
