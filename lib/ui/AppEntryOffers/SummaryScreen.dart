import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/common/common_widget.dart';
import 'package:dating/help/responsive_ui.dart';
import 'package:dating/main.dart';
import 'package:dating/model/User.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/ui/AppEntryOffers/deepblue_purchase_screen.dart';
import 'package:dating/ui/AppEntryOffers/boost_purchase_screen.dart';
import 'package:dating/ui/AppEntryOffers/ultra_like_purchase_screen.dart';
import 'package:dating/ui/home/HomeScreen.dart';
import 'package:dating/ui/profile/complete_my_profile/OnBoardingQuestionEightScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../constants.dart';

class SummaryScreen extends StatefulWidget {
  final Function(int)? onPressed;
  SummaryScreen({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

late User user;
bool? _large, _medium;
double? _pixelRatio, bottom1;
Size? size;
final fireStoreUtils = FireStoreUtils();
int messageCount = 0;
int likeCount = 0;
bool isProfileComplete = false;

class _SummaryScreenState extends State<SummaryScreen> {
  @override
  void initState() {
    super.initState();
    user = MyAppState.currentUser!;
    isProfileComplete = false;
    // isProfileComplete = (user.drinkWantToDate != null &&
    //     user.you_Drink != null &&
    //     user.you_Smoke != null &&
    //     user.smokeWantToDate != null &&
    //     user.have_Children != null &&
    //     user.childrenWantToDate != null);
    SchedulerBinding.instance?.addPostFrameCallback((timeStamp) async {
      getdata();
    });
  }

  getdata() async {
    fireStoreUtils.getOtherYouLikedObject(user.userID).then((value) {
      List friendsList = [];
      value.forEach((element) {
        if (element.otherLike == false) {
          friendsList.add(element);
        }
      });
      likeCount = friendsList.length;

      if (mounted) setState(() {});
    });
    messageCount = 0;
    fireStoreUtils.getConversations(user.userID).forEach(
      (element) {
        if (element.isNotEmpty) {
          messageCount = messageCount + 1;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    var scrWidth = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(scrWidth, _pixelRatio!);
    _medium = ResponsiveWidget.isScreenMedium(scrWidth, _pixelRatio!);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width - 40,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, top: 0, right: 16, bottom: 8),
                        child: Text(
                          user.firstName.toString() +
                              ', ' +
                              user.calculateAge().toString(),
                          textAlign: TextAlign.center,
                          textScaleFactor: 1.0,
                          style: TextStyle(
                            color: Color(0xFF7B7B7B),
                            fontWeight: FontWeight.bold,
                            fontSize: _large! ? 25 : (_medium! ? 22 : 22),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 32, right: 32, bottom: 10),
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
                                percent:
                                    isProfileComplete == false ? 0.55 : 1.00,
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
                      // if (isProfileComplete == false)
                      //   SizedBox(
                      //     height: 10,
                      //   ),
                      // if (isProfileComplete == false)
                      //   InkWell(
                      //     onTap: () {
                      //       push(
                      //         context,
                      //         OnBoardingQuestionEightScreen(
                      //           user: user,
                      //         ),
                      //       );
                      //     },
                      //     child: Container(
                      //       decoration: BoxDecoration(
                      //         color: Color(0xFF7B7B7B).withOpacity(0.5),
                      //         borderRadius: BorderRadius.circular(10),
                      //       ),
                      //       padding: EdgeInsets.symmetric(
                      //           horizontal: 15, vertical: 10),
                      //       child: Text(
                      //         "Complete My Profile",
                      //         style: TextStyle(
                      //           color: Colors.black,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 5.0, right: 5.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF70573ac),
                                    textStyle: TextStyle(color: Colors.white),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        side: BorderSide(
                                            color: Color(0xFF0573ac))),
                                  ),
                                  //     child: FutureBuilder(
                                  //   future: fireStoreUtils
                                  //       .getOtherYouLikedObject(user.userID),
                                  //   builder: (BuildContext context,
                                  //       AsyncSnapshot<List<User>> snapshot) {
                                  //     List<User> likes = [];
                                  //     if (snapshot.hasData) {
                                  //       likes = snapshot.data!;
                                  //     }
                                  //     return Text(
                                  //       '${likes.length} ' +
                                  //           (likes.length == 1
                                  //               ? 'Like'
                                  //               : 'Likes'),
                                  //       textScaleFactor: 1.0,
                                  //       style: TextStyle(
                                  //           fontSize: 16,
                                  //           fontWeight: FontWeight.bold),
                                  //     );
                                  //   },
                                  // ),
                                  child: Text(
                                    '${likeCount} ' +
                                        (likeCount == 1 ? 'Like' : 'Likes'),
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    widget.onPressed!(2);
                                  },
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 5.0, right: 5.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF70573ac),
                                  textStyle: TextStyle(color: Colors.white),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: BorderSide(
                                      color: Color(0xFF0573ac),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  '$messageCount Messages',
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  widget.onPressed!(3);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 5.0, right: 5.0),
                              child: Container(
                                constraints: const BoxConstraints(
                                    minWidth: double.minPositive),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF68ce09),
                                    textStyle: TextStyle(color: Colors.white),
                                    padding: EdgeInsets.only(
                                        right: 10,
                                        left: 10,
                                        top: 10,
                                        bottom: 10),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        side: BorderSide(
                                            color: Color(0xFF68ce09))),
                                  ),
                                  child: Container(
                                    child: Column(
                                      children: [
                                        StreamBuilder<
                                            DocumentSnapshot<
                                                Map<String, dynamic>>>(
                                          stream: FireStoreUtils.firestore
                                              .collection(BOOSTCOUNT)
                                              .doc(MyAppState
                                                  .currentUser!.userID)
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            String predefineBoostCount = '0';
                                            if (snapshot.hasData) {
                                              predefineBoostCount =
                                                  snapshot.data!.data() != null
                                                      ? snapshot.data!
                                                          .data()!['count']
                                                          .toString()
                                                      : '0';
                                            }
                                            return Text(
                                              '$predefineBoostCount TruuBoost',
                                              textScaleFactor: 1.0,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            );
                                          },
                                        ),
                                        Text(
                                          'Available',
                                          textScaleFactor: 1.0,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          'Click to Add More',
                                          textScaleFactor: 1.0,
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onPressed: () {
                                    push(
                                      context,
                                      BoosrPurchaseScreen(
                                        user: user,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 5.0, right: 5.0),
                              child: Container(
                                constraints: const BoxConstraints(
                                    minWidth: double.minPositive),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF68ce09),
                                    textStyle: TextStyle(color: Colors.white),
                                    padding: EdgeInsets.only(
                                        right: 10,
                                        left: 10,
                                        top: 10,
                                        bottom: 10),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        side: BorderSide(
                                            color: Color(0xFF68ce09))),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      StreamBuilder<
                                          DocumentSnapshot<
                                              Map<String, dynamic>>>(
                                        stream: FireStoreUtils.firestore
                                            .collection(ULTRALIKECOUNT)
                                            .doc(MyAppState.currentUser!.userID)
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          String predefineCount = '0';
                                          if (snapshot.hasData) {
                                            predefineCount =
                                                snapshot.data!.data() != null
                                                    ? snapshot.data!
                                                        .data()!['count']
                                                        .toString()
                                                    : '0';
                                          }
                                          return Text(
                                            '$predefineCount Ultra ' +
                                                (predefineCount == '1'
                                                    ? 'Like'
                                                    : 'Likes'),
                                            textAlign: TextAlign.center,
                                            textScaleFactor: 1.0,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          );
                                        },
                                      ),
                                      Text(
                                        'Available',
                                        textScaleFactor: 1.0,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'Click to Add More',
                                        textScaleFactor: 1.0,
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  onPressed: () {
                                    push(
                                      context,
                                      UltraLikePurchaseLike(
                                        user: user,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ])),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/wave_trans.png"),
                                  fit: BoxFit.fill,
                                ),
                                color: Color(0xFF0573ac),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/wave_trans.png"),
                                    fit: BoxFit.fill,
                                  ),
                                  color: Color(0xFF0573ac),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              width: MediaQuery.of(context).size.width - 40,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    user.isVip
                                        ? 'DeepBlue Member '
                                        : 'Upgrade To DeepBlue',
                                    textScaleFactor: 1.0,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFFffffff),
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          _large! ? 25 : (_medium! ? 22 : 20),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
                                    child: Text(
                                      user.isVip
                                          ? 'Your in complete control of your dating experince'
                                          : 'DeepBlue Members get twice as many Matches',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFffffff),
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
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),

                      // Positioned(
                      //   bottom: 10,
                      //   child: InkWell(
                      //     onTap: () {
                      //       Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (context) => DeepBluePurchaseScreen(
                      //             user: user,
                      //           ),
                      //         ),
                      //       ).then((value) {
                      //         setState(() {
                      //           user = MyAppState.currentUser!;
                      //         });
                      //       });
                      //     },
                      //     child: Container(
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(10),
                      //         color: Color(0xFF68ce09),
                      //       ),
                      //       padding: EdgeInsets.symmetric(
                      //           horizontal: 20, vertical: 10),
                      //       child: Text(
                      //         user.isVip
                      //             ? 'Current member'
                      //             : 'Click to Upgrade',
                      //         style: TextStyle(
                      //             color: Colors.white,
                      //             fontSize: 16,
                      //             fontWeight: FontWeight.w600,
                      //             decoration: TextDecoration.underline),
                      //       ),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "What's Included:",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        rowDottedWidget('Send Unlimited Messages'),
                        rowDottedWidget('See Who Likes You'),
                        rowDottedWidget('Get 1 FREE Boost/month'),
                        rowDottedWidget('Get 5 FREE Ultra Likes/month'),
                        rowDottedWidget('Revive Expired Matches'),
                        rowDottedWidget('Set Advanced Preferences'),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DeepBluePurchaseScreen(
                            user: user,
                          ),
                        ),
                      ).then((value) {
                        setState(() {
                          user = MyAppState.currentUser!;
                        });
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFF68ce09),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text(
                        user.isVip ? 'Current member' : 'Click to Upgrade',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          // decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Container(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF70573ac),
                    textStyle: TextStyle(color: Colors.white),
                    padding:
                        EdgeInsets.only(right: 20, left: 20, top: 5, bottom: 5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: Color(0xFF0573ac))),
                  ),
                  child: Text(
                    "Continue to My Feed",
                    textScaleFactor: 1.0,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    pushAndRemoveUntil(
                        context, HomeScreen(user: user, index: 0), false);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
