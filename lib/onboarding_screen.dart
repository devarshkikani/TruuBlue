import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/constants.dart';
import 'package:dating/main.dart';
import 'package:dating/model/User.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/ui/AppEntryOffers/AppEntryOffersScreen.dart';
import 'package:dating/ui/SwipeScreen/SwipeScreen.dart';
import 'package:dating/ui/art_board/first_art_board_screen.dart';
import 'package:dating/ui/auth/AuthScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'constants.dart' as Constants;
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoarding extends StatefulWidget {
  @override
  State createState() {
    return OnBoardingState();
  }
}

class OnBoardingState extends State<OnBoarding> {
  List splashImages = [
    'assets/images/splash-V2.png',
    'assets/images/splash-V3.png',
    'assets/images/splash-V4.png',
    'assets/images/splash-V5.png',
    'assets/images/splash-V6.png',
    'assets/images/splash-V7.png',
  ];

  Future hasFinishedOnBoarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // bool finishedOnBoarding =
    //     (prefs.getBool(Constants.FINISHED_ON_BOARDING) ?? false);
    var isMobileLogin = prefs.getString("loginMobile");
    if (isMobileLogin != null && isMobileLogin != "") {
      dynamic result = await FireStoreUtils.getCurrentUserMobile(isMobileLogin);
      MyAppState.currentUser = result;
      // MyAppState.currentUser?.fcmToken =
      //     await FirebaseMessaging.instance.getToken() ?? '';
      MyAppState.currentUser?.lastOnlineTimestamp =
          DateTime.now().toUtc().millisecondsSinceEpoch;
      MyAppState.currentUser?.active = true;
      if (MyAppState.currentUser != null) if (result != null) {
        redirectEntryScreen(MyAppState.currentUser!);
      } else {
        pushReplacement(context, AuthScreen());
      }
    } else {
      auth.User? firebaseUser = auth.FirebaseAuth.instance.currentUser;
      Future.delayed(Duration(seconds: 3), () async {
        if (firebaseUser != null) {
          User? user = await FireStoreUtils.getCurrentUser(firebaseUser.uid);
          if (user != null) {
            user.active = true;
            user.fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
            user.lastOnlineTimestamp =
                DateTime.now().toUtc().millisecondsSinceEpoch;
            await FireStoreUtils.updateCurrentUser(user);
            MyAppState.currentUser = user;
            redirectEntryScreen(user);
          } else {
            pushReplacement(context, AuthScreen());
          }
        } else {
          pushReplacement(context, AuthScreen());
        }
      });
    }
  }

  void redirectEntryScreen(User user) async {
    int messageCount = 0;
    int likeCount = 0;
    FireStoreUtils().getConversations(user.userID).forEach((element) {
      if (element.isNotEmpty) {
        messageCount = messageCount + 1;
      }
    });
    String predefineBoostCount = await FireStoreUtils.getBoostLikeCount();
    String predefineCount = await FireStoreUtils.getUltraLikeCount();
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<User> value =
        await FireStoreUtils().getOtherYouLikedObject(user.userID);
    List friendsList = [];
    value.forEach((element) {
      if (element.otherLike == false) {
        friendsList.add(element);
      }
    });
    if (friendsList.length > (pref.getInt('oldNewLikesCount') ?? 0)) {
      newLikesCount = friendsList.length;
      await pref.setInt('oldNewLikesCount', newLikesCount);
    } else {
      newLikesCount = 0;
    }
    await SwipeScreenState().getcurrentUser(context);
    likeCount = friendsList.length;

    // String userCount = await getUserCount();
    // if (int.parse(userCount) >= 5000) {
    pushAndRemoveUntil(
        context,
        AppEntryOffersScreen(
          user: user,
          likeCount: likeCount,
          messageCount: messageCount,
          predefineCount: int.parse(predefineCount),
          predefineBoostCount: int.parse(predefineBoostCount),
        ),
        false);
    // } else {
    //   pushAndRemoveUntil(
    //       context,
    //       FirstArtBoardScreen(
    //         userCount: user.userCount,
    //       ),
    //       false);
    // }
  }

  Future<String> getUserCount() async {
    String userCount = '';
    final QuerySnapshot qSnap =
        await FireStoreUtils.firestore.collection(USERS).get();
    final int documents = qSnap.docs.length;
    for (int i = documents.toString().length; i < 4; i++) {
      userCount += '0';
    }
    userCount += documents.toString();
    return userCount;
  }

  @override
  void initState() {
    super.initState();
    hasFinishedOnBoarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(Constants.COLOR_PRIMARY),
      body: Stack(
        children: [
          Image.asset(
            splashImages[Random().nextInt(splashImages.length)],
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.fill,
          ),
          Center(
            child: CupertinoActivityIndicator(),
          ),
        ],
      ),
    );
  }
}
