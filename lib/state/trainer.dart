import 'package:localstore/localstore.dart';
import 'package:mobx/mobx.dart';
import 'package:rechentrainer/utils/calculator.dart' as calc;
import 'package:rechentrainer/utils/calculator.dart';
import 'package:rechentrainer/utils/date.dart';

part 'trainer.g.dart';

class TrainingResult {
  DateTime start;
  Duration duration;
  double successRate;
  int range;
  int chain;
  List<String> arithmetics;
  int count;

  TrainingResult(this.start, this.duration, this.successRate, this.range,
      this.count, this.chain, this.arithmetics);

  bool get solved => successRate == 1;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {
      "start": start.toIso8601String(),
      "duration": duration.inSeconds,
      "successRate": successRate,
      "range": range,
      "chain": chain,
      "count": count,
      "arithmetics": arithmetics
    };

    return data;
  }

  factory TrainingResult.fromMap(Map<String, dynamic> data) {
    return TrainingResult(
      DateTime.parse(data['start']),
      Duration(seconds: data['duration']),
      data['successRate'],
      data['range'],
      data['chain'],
      data['count'],
      List<String>.from(data['arithmetics']),
    );
  }
}

class Trainer = TrainerBase with _$Trainer;

abstract class TrainerBase with Store {
  Localstore get storage => Localstore.instance;

  @observable
  ObservableMap<String, bool> arithmetics =
      {"+": true, "-": false, "*": false, "/": false}.asObservable();

  @observable
  ObservableMap<String, bool> count = {
    "2": true,
    "25": false,
    "50": false,
    "75": false,
    "100": false
  }.asObservable();

  @observable
  ObservableMap<String, bool> range = {
    "10": true,
    "100": false,
    "1000": false,
  }.asObservable();

  @observable
  ObservableMap<String, bool> chain = {
    "1": true,
    "2": false,
    "3": false,
    "4": false,
  }.asObservable();

  @computed
  List<bool> get arithmeticValues => arithmetics.values.toList();

  @computed
  List<String> get arithmeticKeys => arithmetics.keys.toList();

  @computed
  List<bool> get countValues => count.values.toList();

  @computed
  List<String> get countKeys => count.keys.toList();

  @computed
  List<bool> get rangeValues => range.values.toList();

  @computed
  List<String> get rangeKeys => range.keys.toList();

  @computed
  List<bool> get chainValues => chain.values.toList();

  @computed
  List<String> get chainKeys => chain.keys.toList();

  @observable
  DateTime? _startTime;

  @observable
  DateTime? _endTime;

  @observable
  int currentIndex = 0;

  @observable
  ObservableList<Equation> tasks = <Equation>[].asObservable();

  @computed
  Equation? get currentTask =>
      tasks.length > currentIndex ? tasks[currentIndex] : null;

  @computed
  bool get hasTasks => tasks.isNotEmpty;

  @computed
  bool get done => tasks.isNotEmpty && tasks.length == currentIndex;

  @computed
  double get successRate => tasks.isNotEmpty
      ? tasks.where((element) => element.solved).length / tasks.length
      : 0;

  @computed
  bool get initial => currentIndex == 0;

  @computed
  Duration? get duration => _startTime != null && _endTime != null
      ? _endTime!.difference(_startTime!)
      : null;

  @computed
  TrainingResult? get result => done
      ? TrainingResult(
          _startTime!,
          duration!,
          successRate,
          _currentOption(range),
          _currentOption(count),
          _currentOption(chain),
          arithmetics.entries
              .where((element) => element.value == true)
              .map((e) => e.key)
              .toList())
      : null;

  @computed
  String get formattedDuration => formatDuration(duration!);

  @action
  void selectArithmetic(int index) {
    arithmetics[arithmetics.keys.elementAt(index)] =
        !arithmetics.values.elementAt(index);
  }

  @action
  void selectCount(int index) {
    String _index = count.keys.elementAt(index);

    count.forEach((key, value) => count[key] = key == _index);
  }

  @action
  void selectRange(int index) {
    String _index = range.keys.elementAt(index);

    range.forEach((key, value) => range[key] = key == _index);
  }

  @action
  void selectChain(int index) {
    String _index = chain.keys.elementAt(index);

    chain.forEach((key, value) => chain[key] = key == _index);
  }

  @action
  void start() {
    computeTasks();
    _startTime = DateTime.now();
  }

  @action
  void solve(String answer) {
    currentTask!.answer = int.tryParse(answer);
    currentIndex++;
    if (done) {
      _endTime = DateTime.now();
    }
  }

  @action
  void reset() {
    tasks.clear();
    currentIndex = 0;
    _startTime = null;
    _endTime = null;
  }

  int _currentOption(Map<String, bool> options) {
    return int.parse(
        options.entries.firstWhere((element) => element.value).key);
  }

  @action
  Future<void> saveConfiguration() async {
    var saving = storage.collection('rechentrainer').doc('config').set({
      'count': count,
      'chain': chain,
      'range': range,
      'arithmetics': arithmetics
    });

    return ObservableFuture(saving);
  }

  @action
  Future<void> loadConfiguration() async {
    var config = await storage.collection('rechentrainer').doc('config').get();

    if (config == null) {
      return Future.value();
    }

    count = (config['count'] as Map).cast<String, bool>().asObservable();
    range = (config['range'] as Map).cast<String, bool>().asObservable();
    chain = (config['chain'] as Map).cast<String, bool>().asObservable();
    arithmetics =
        (config['arithmetics'] as Map).cast<String, bool>().asObservable();

    return Future.value();
  }

  void computeTasks() {
    tasks.clear();

    var _range = _currentOption(range);
    var _count = _currentOption(count);
    var _chain = _currentOption(chain);

    var _arithmetics =
        arithmetics.entries.where((element) => element.value == true);

    tasks = calc
        .createSet(
            _count, _range, _chain, _arithmetics.map((e) => e.key).toList())
        .asObservable();
  }
}
