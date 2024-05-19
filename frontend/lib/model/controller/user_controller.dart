import 'package:frontend/model/data/challenge/challenge_simple.dart';
import 'package:get/get.dart';
import 'package:frontend/model/data/user.dart';
import '../data/challenge/challenge_category.dart';

class UserController extends GetxController {
  final _user = User(
    id: 1,
    email: 'example@example.com',
    name: 'John Doe',
    following: [],
    followers: [],
    categories: [],
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

  // 카테고리를 업데이트하는 메서드
  void updateCategories(List<ChallengeCategory> newCategories) {
    user.categories = newCategories;
    update(); // 상태를 업데이트하여 UI를 리프레시
  }


  // 카테고리를 업데이트하는 메서드
  void updateFollowing(List<ChallengeCategory> newCategories) {
    user.categories = newCategories;
    update(); // 상태를 업데이트하여 UI를 리프레시
  }
}
