import 'package:get/get.dart';
import 'package:frontend/model/data/user.dart';

class UserController extends GetxController {
  final _user = User(
    id: 0,
    email: "",
    avatar: "",
    name: "",
    point: 0,
  ).obs;

  User get user => _user.value;

  void saveUser(User user) {
    _user.value = user;
  }
}
