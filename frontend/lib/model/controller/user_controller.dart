import 'package:frontend/model/data/challenge/challenge_simple.dart';
import 'package:get/get.dart';
import 'package:frontend/model/data/user.dart';
import 'package:frontend/model/data/challenge/challenge_category.dart';

class UserController extends GetxController {
  final _user = User(
    id: 0,
    email: '',
    name: '',
    avatar: '',
    point: 0,
    categories: [],
    following: [],
    followers: [],
  ).obs;

  final _myChallenges = <ChallengeSimple>[].obs;

  User get user => _user.value;

  List<ChallengeSimple> get myChallenges => _myChallenges;

  void saveUser(User user) {
    _user.value = user;
  }

  void updateMyChallenges(List<dynamic> challenges) {
    _myChallenges.clear();
    for (var challenge in challenges) {
      _myChallenges.add(ChallengeSimple.fromJson(challenge));
    }
  }

  void updateCategories(List<dynamic> categories) {
    _user.value.categories.clear();
    for (final category in categories) {
      _user.value.categories.add(ChallengeCategory.fromJson(category));
    }
  }
}
