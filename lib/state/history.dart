import 'package:localstore/localstore.dart';
import 'package:mobx/mobx.dart';
import 'package:rechentrainer/state/trainer.dart';

part 'history.g.dart';

class History = HistoryBase with _$History;

abstract class HistoryBase with Store {
  @observable
  bool visible = false;

  @observable
  ObservableList<TrainingResult> trainings = <TrainingResult>[].asObservable();

  Localstore get storage => Localstore.instance;

  @action
  void toggle() {
    visible = !visible;
  }

  @action
  Future<void> saveTraining(String name, TrainingResult result) async {
    var saving = storage
        .collection(name)
        .doc(result.start.toIso8601String())
        .set(result.toMap());
    trainings.add(result);

    return ObservableFuture(saving);
  }

  @action
  Future<void> loadHistory(String name) async {
    var items = await storage.collection(name).get();
    if (items != null) {
      items.forEach(
          (key, value) => trainings.add(TrainingResult.fromMap(value)));
    }
  }

  @action
  Future<void> clear(String name) async {
    var items = await storage.collection(name).get();
    if (items != null) {
      var deletion = Future.wait(items
          .map((key, value) => MapEntry(
              key,
              storage
                  .collection(name)
                  .doc(key.replaceFirst('/$name/', ''))
                  .delete()))
          .values);
      trainings.clear();
      return ObservableFuture(deletion);
    }

    //var clearing = storage.collection(name)
    return ObservableFuture(Future.delayed(const Duration(milliseconds: 1)));
  }
}
