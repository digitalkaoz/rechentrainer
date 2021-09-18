import 'package:get_it/get_it.dart';
import 'package:localstore/localstore.dart';
import 'package:mobx/mobx.dart';

part 'user.g.dart';

class User = UserBase with _$User;

abstract class UserBase with Store {
  @observable
  bool visible = false;

  @observable
  ObservableList<String> users = <String>[].asObservable();

  @observable
  String? current;

  DocumentRef get _doc => GetIt.instance<CollectionRef>().doc('users');

  @action
  void toggle() {
    visible = !visible;
  }

  @action
  Future<void> save() {
    return _doc.set({'current': current, 'all': users});
  }

  @action
  Future<void> change(String name) async {
    if (!users.contains(name)) {
      users.add(name);
    }
    current = name;
    visible = false;

    return save();
  }

  @action
  Future<void> load() async {
    var item = await _doc.get();
    if (item != null) {
      current = item['current'];
      users = List<String>.from(item['all']).asObservable();
    }
  }

  @action
  Future<void> delete(String name) async {
    users.removeWhere((element) => element == name);

    if (users.isEmpty || current == name) {
      current = null;
    }

    return save();
  }
}
