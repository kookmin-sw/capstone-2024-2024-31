import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:frontend/model/data/user.dart';

class UserController extends GetxController {
  final _user = User(
    id: 0,
    email: "",
    avatar: "",
    name: "",
    level: 0,
    xp: 0,
    point: 0,
  ).obs;

  User get user => _user.value;

  @override
  void onInit() {
    // 앱 시작 시 저장된 데이터 로드
    _loadUser();
    super.onInit();
  }

  void _loadUser() async {
    final box = GetStorage();
    if (box.hasData('user')) {
      final json = box.read('user');
      _user(User.fromJson(json));
    }
  }

  void saveUser(User user) async {
    final box = GetStorage();
    await box.write('user', user.toJson());
    _user(user);
  }
}
