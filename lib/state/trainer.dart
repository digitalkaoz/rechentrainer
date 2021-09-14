import 'package:mobx/mobx.dart';
import 'package:rechentrainer/utils/calculator.dart' as calc;
import 'package:rechentrainer/utils/calculator.dart';

part 'trainer.g.dart';

class Trainer = TrainerBase with _$Trainer;

abstract class TrainerBase with Store {
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
  bool get done => tasks.length == currentIndex;

  @computed
  bool get initial => currentIndex == 0;

  @computed
  Duration? get duration => _startTime != null && _endTime != null
      ? _endTime!.difference(_startTime!)
      : null;

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
