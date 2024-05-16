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
    categories: {},
  ).obs;

  final _myChallenges = <ChallengeSimple>[].obs;

  User get user => _user.value;

  List<ChallengeSimple> get myChallenges => _myChallenges;

  void saveUser(User user) {
    _user.value = user;
  }

  void updateMyChallenges(List<dynamic> challenges) {
    _myChallenges.clear();
    challenges.forEach((challenge) {
      _myChallenges.add(ChallengeSimple.fromJson(challenge));
    });
  }
}
