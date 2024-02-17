import 'dart:convert';
import 'package:dating/model/User.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreenController extends GetxController {
  List<User> tinderUsers = <User>[];
  FireStoreUtils fireStoreUtils = FireStoreUtils();
  User? currentuser;
  int boostCount = 0;
  int ultraLikeCount = 0;
  RxBool isLoading = true.obs;

  getcurrentUser(user) async {
    ultraLikeCount = int.parse(await FireStoreUtils.getUltraLikeCount());
    await updateFeedData();
  }

  Future<void> updateFeedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (boostCount <= 0) {
      int? lastDay = prefs.getInt('lastDay');
      int today = DateTime.now().day;

      if (lastDay == null || lastDay != today) {
        tinderUsers = await fireStoreUtils.getTinderUsers();
        prefs.setInt('lastDay', today);
      } else {
        final String? getStoreUsers = prefs.getString('storeUsers');
        if (getStoreUsers != null) {
          tinderUsers = await fireStoreUtils.getTinderUsers(
            getStoredUser: jsonDecode(getStoreUsers),
          );
        } else {
          tinderUsers = await fireStoreUtils.getTinderUsers();
          prefs.setInt('lastDay', today);
        }
      }
      List<String> usersIDs = [];
      for (int i = 0; i < tinderUsers.length; i++) {
        usersIDs.add(tinderUsers[i].userID);
      }
      final String encodedData = jsonEncode(usersIDs);
      await prefs.setString('storeUsers', encodedData);
    } else {
      tinderUsers = await fireStoreUtils.getTinderUsers();
      await fireStoreUtils.matchChecker();
    }

    print(tinderUsers.toString());
    isLoading.value = false;
    update();
  }
}
