import 'package:get_it/get_it.dart';
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

  @action
  void toggle() {
    visible = !visible;
  }

  @action
  void hide() {
    visible = false;
  }

  @action
  void show() {
    visible = true;
  }

  DocumentRef _doc(String name) =>
      GetIt.instance<CollectionRef>().doc('history_$name');

  @action
  Future<void> save(String name, TrainingResult result) async {
    trainings.add(result);

    await _doc(name).set(
        {'trainings': trainings.map((element) => element.toMap()).toList()});
  }

  @action
  Future<void> load(String name) async {
    trainings.clear();
    var item = await _doc(name).get();
    if (item != null) {
      for (var training in item['trainings']) {
        trainings.add(TrainingResult.fromMap(training));
      }
    }
  }

  @action
  Future<void> delete(String name) async {
    await _doc(name).delete();
    trainings.clear();
  }
}
