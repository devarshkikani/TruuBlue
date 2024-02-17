import 'dart:async';

import 'package:dating/constants.dart';
import 'package:dating/main.dart';
import 'package:dating/model/User.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/ui/AppEntryOffers/boost_purchase_screen.dart';
import 'package:dating/ui/home/HomeScreen.dart';
import 'package:dating/ui/profile/complete_my_profile/OnBoardingQuestionEightScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/state_manager.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

RxBool isBossted = false.obs;

class TruuBoostScreen extends StatefulWidget {
  TruuBoostScreen({Key? key}) : super(key: key);

  @override
  State<TruuBoostScreen> createState() => _TruuBoostScreenState();
}

class _TruuBoostScreenState extends State<TruuBoostScreen> {
  late User user;
  int predefineBoostCount = 0;
  // int usedpredefineBoostCount = 0;
  final fireStoreUtils = FireStoreUtils();
  String? expiredDate;
  bool isProfileComplete = false;
  bool isBoostLoading = false;

  Timer? _timer;
  @override
  void initState() {
    super.initState();
    print('TRUUBOOST SCREEN');
    user = MyAppState.currentUser!;
    isProfileComplete = (user.drinkWantToDate != null &&
        user.you_Drink != null &&
        user.you_Smoke != null &&
        user.smokeWantToDate != null &&
        user.have_Children != null &&
        user.childrenWantToDate != null);
    getUserData();
  }

  getUserData() async {
    SchedulerBinding.instance?.addPostFrameCallback((timeStamp) async {
      predefineBoostCount = int.parse(await FireStoreUtils.getBoostLikeCount());
      // usedpredefineBoostCount =
      //     int.parse(await FireStoreUtils.getusedBoostLikeCount());
      if (mounted) setState(() {});
    });
    if (user.profileBoostAt != null && user.isUserBoost == 1) {
      _timer?.cancel();
      _timer = Timer.periodic(Duration(seconds: 1), (v) async {
        if (user.profileBoostAt != null) {
          Duration remainingTime = user.profileBoostAt!
              .add(Duration(hours: 12))
              .difference(DateTime.now());
          if (remainingTime.isNegative) {
            user.profileBoostAt = null;
            user.isUserBoost = 0;
            await FireStoreUtils.updateCurrentUser(user);
            MyAppState.currentUser = user;
            expiredDate = null;
            setState(() {});
          } else {
            expiredDate =
                "${remainingTime.inHours}h ${remainingTime.inMinutes.remainder(60)}m ${remainingTime.inSeconds.remainder(60)}s";
          }
        } else {
          expiredDate = null;
          _timer?.cancel();
        }
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 16, top: 0, right: 16, bottom: 10),
                child: Text(
                  user.firstName.toString() +
                      ', ' +
                      user.calculateAge().toString(),
                  textScaleFactor: 1.0,
                  style: TextStyle(
                    color: Color(0xFF7B7B7B),
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 32, right: 32, bottom: 10),
                child: InkWell(
                  onTap: () {
                    // setState(() {
                    //   main.streamController.add(2);
                    // });
                    if (isProfileComplete == false) {
                      push(
                        context,
                        OnBoardingQuestionEightScreen(
                          user: user,
                        ),
                      );
                    }
                  },
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      CircularPercentIndicator(
                        radius: 60.0,
                        lineWidth: 8.0,
                        percent: isProfileComplete == false ? 0.55 : 1.00,
                        center: Text('80%'),
                        circularStrokeCap: CircularStrokeCap.round,
                        startAngle: 180,
                        progressColor: Color(0xFF0573ac),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Center(
                          child: displayCircleImage(
                            user.profilePictureURL,
                            100,
                            true,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -10,
                        child: InkWell(
                          onTap: () {
                            if (isProfileComplete == false) {
                              push(
                                context,
                                OnBoardingQuestionEightScreen(
                                  user: user,
                                ),
                              );
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              // color: Color(COLOR_BLUE_BUTTON),
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.green,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            child: Text(
                              isProfileComplete == false
                                  ? '55% Complete'
                                  : '100% Complete',
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: GestureDetector(
                  onTap: () async {
                    if (user.isUserBoost <= 0) {
                      setState(() {
                        isBoostLoading = true;
                      });
                      int predefineBoostCount =
                          int.parse(await FireStoreUtils.getBoostLikeCount());
                      // int usedpredefineBoostCount = int.parse(
                      //     await FireStoreUtils.getusedBoostLikeCount());
                      if (predefineBoostCount > 0) {
                        String getNewCount =
                            (predefineBoostCount - 1).toString();
                        // String getNewUsedCount =
                        //     (usedpredefineBoostCount + 1).toString();
                        await FireStoreUtils().boostCountUpdate(
                          count: getNewCount.toString(),
                          // getNewUsedCount: getNewUsedCount.toString(),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Successfully, Your Profile Boost For 12 Hours'),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ));
                        user.isUserBoost = 1;
                        user.profileBoostAt = DateTime.now();
                        push(
                          context,
                          HomeScreen(
                            user: user,
                            index: 0,
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BoosrPurchaseScreen(
                              user: MyAppState.currentUser!,
                            ),
                          ),
                        ).then((value) async {
                          predefineBoostCount = value;
                          setState(() {});
                        });
                      }
                      setState(() {
                        isBoostLoading = false;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Your profile Already Boost'),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      );
                    }
                  },
                  child: isBoostLoading
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 15,
                            height: 15,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                            ),
                          ),
                        )
                      : user.isUserBoost <= 0
                          ? Text(
                              'Boost',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF949494),
                              ),
                            )
                          : Text(
                              'Boosted',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(COLOR_BLUE_BUTTON),
                              ),
                            ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 80,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Color(0xFF68ce09),
                  ),
                  // color:  Color(0xFF68ce09),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TruuBoost Available'.tr(),
                      textScaleFactor: 1.0,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Text(
                      '$predefineBoostCount',
                      textScaleFactor: 1.0,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              if (expiredDate != null)
                Container(
                  height: 80,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Color(0xFF68ce09),
                    ),
                    // color: Color(0xFF68ce09),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'TruuBoost Expires:',
                          textScaleFactor: 1.0,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        expiredDate!,
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              if (expiredDate != null)
                SizedBox(
                  height: 20,
                ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BoosrPurchaseScreen(
                        user: MyAppState.currentUser!,
                      ),
                    ),
                  ).then((value) async {
                    if (value != null) {
                      predefineBoostCount = value;
                      setState(() {});
                    }
                  });
                },
                child: Container(
                  height: 80,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Color(0xFF68ce09),
                    ),
                    // color: Color(0xFF68ce09),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Purchase TruuBoost'.tr(),
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
              // if (user.isUserBoost <= 0)
              SizedBox(
                height: 20,
              ),
              // if (user.isUserBoost <= 0)
              InkWell(
                onTap: () async {
                  if (user.isUserBoost <= 0) {
                    int predefineBoostCount =
                        int.parse(await FireStoreUtils.getBoostLikeCount());

                    if (predefineBoostCount > 0) {
                      String getNewCount = (predefineBoostCount - 1).toString();

                      await FireStoreUtils().boostCountUpdate(
                        count: getNewCount.toString(),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                        content: Text(
                            'Successfully, Your Profile Boost For 12 Hours'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ));
                      isBossted.value = true;
                      user.isUserBoost = 1;
                      user.profileBoostAt = DateTime.now();
                      push(
                        context,
                        HomeScreen(
                          user: user,
                          index: 0,
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BoosrPurchaseScreen(
                            user: MyAppState.currentUser!,
                          ),
                        ),
                      ).then((value) async {
                        predefineBoostCount = value;
                        setState(() {});
                      });
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Your profile Already Boost'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30)),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    user.isUserBoost <= 0
                        ? 'Boost My Profile Now!'
                        : 'Boost Is In Progress',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
