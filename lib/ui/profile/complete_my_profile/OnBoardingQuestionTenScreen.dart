// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/constants.dart';
import 'package:dating/main.dart';
import 'package:dating/model/User.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/theme/textstyle.dart';
import 'package:dating/ui/home/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingQuestionTenScreen extends StatefulWidget {
  User user;
  OnBoardingQuestionTenScreen({Key? key, required this.user}) : super(key: key);

  @override
  _OnBoardingQuestionTenScreenState createState() =>
      _OnBoardingQuestionTenScreenState();
}

class _OnBoardingQuestionTenScreenState
    extends State<OnBoardingQuestionTenScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController1;
  GlobalKey<FormState> _key = GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  String want_children = '';
  String date_with_children = '';

  bool checkBoxOne = false;
  bool checkBoxTwo = false;
  bool checkBoxThree = false;
  bool checkBoxThreeOne = false;
  bool checkBoxThreeTwo = false;
  bool checkBoxFour = false;
  bool checkBoxFive = false;
  bool checkBoxSix = false;
  bool checkBoxSixOne = false;

  User user = MyAppState.currentUser!;
  @override
  void initState() {
    super.initState();
    animationController1 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    checkBoxOne = user.have_Children == "Someday";
    checkBoxTwo = user.have_Children == "Don't want";
    checkBoxThree = user.have_Children == "Have & want more";
    checkBoxThreeOne = user.have_Children == "Have & do not want more";
    checkBoxThreeTwo = user.have_Children == "Not sure yet";
    checkBoxFour = user.childrenWantToDate == "Yes";
    checkBoxFive = user.childrenWantToDate == "No";
    checkBoxSix = user.childrenWantToDate == "No Preference";
  }

  @override
  void dispose() {
    animationController1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(COLOR_PRIMARY),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    animationController1.forward();
                    setState(() {});
                    Future.delayed(Duration(milliseconds: 500), () {
                      Navigator.of(context).pop();
                      animationController1.reverse();
                    });
                  },
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, anim) => RotationTransition(
                      turns: animationController1,
                      child: FadeTransition(
                          opacity: anim,
                          child: child,
                          alwaysIncludeSemantics: true),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 30,
                      color: Color(0xFF0573ac),
                      key: const ValueKey('icon2'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Image.asset(
                    'assets/images/truubluenew.png',
                  ),
                ),
                InkWell(
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    if (!checkBoxOne &&
                        !checkBoxTwo &&
                        !checkBoxThree &&
                        !checkBoxThreeOne &&
                        !checkBoxThreeTwo) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Please enter all fields.'),
                        duration: Duration(seconds: 6),
                      ));
                    } else if (!checkBoxFour && !checkBoxFive && !checkBoxSix) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Please enter all fields.'),
                        duration: Duration(seconds: 6),
                      ));
                    } else {
                      var yourgen = "Someday";
                      if (checkBoxOne) {
                        yourgen = "Someday";
                      } else if (checkBoxTwo) {
                        yourgen = "Don't want";
                      } else if (checkBoxThree) {
                        yourgen = "Have & want more";
                      } else if (checkBoxThreeOne) {
                        yourgen = "Have & do not want more";
                      } else if (checkBoxThreeTwo) {
                        yourgen = "Not sure yet";
                      }
                      var wantto = "Yes";
                      if (checkBoxFour) {
                        wantto = "Yes";
                      } else if (checkBoxFive) {
                        wantto = "No";
                      } else if (checkBoxSix) {
                        wantto = "No Preference";
                      }

                      await setSetQuestionPreferences("You_Children", yourgen);
                      await setSetQuestionPreferences(
                          "Want_Date_Children", wantto);

                      await firestore
                          .collection(USERS)
                          .doc(MyAppState.currentUser!.userID)
                          .update({
                        'drinkWantToDate': prefs.getString("Want_Date_Drink"),
                        'you_Drink': prefs.getString("You_Drink"),
                        'you_Smoke': prefs.getString("You_Smoke"),
                        'smokeWantToDate': prefs.getString("Want_Date_Smoke"),
                        'have_Children': prefs.getString("You_Children"),
                        'childrenWantToDate':
                            prefs.getString("Want_Date_Children"),
                      });
                      widget.user = (await FireStoreUtils.getCurrentUser(
                          widget.user.userID))!;
                      pushAndRemoveUntil(context,
                          HomeScreen(user: widget.user, index: 0), false);
                    }
                  },
                  child: SizedBox(
                    width: 40,
                    child: Text(
                      'Save',
                      style: boldText18.copyWith(
                        color: Color(0xFF0573ac),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(30),
          child: Form(
            key: _key,
            autovalidateMode: _validate,
            child: Column(children: <Widget>[
              Align(
                alignment: Directionality.of(context) == TextDirection.ltr
                    ? Alignment.topLeft
                    : Alignment.topLeft,
                child: Text(
                  'Do you want children?',
                  textScaleFactor: 1.0,
                  style: boldText28.copyWith(
                    color: Color(0xFF0573ac),
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                        child: Transform.scale(
                          scale: 1.3,
                          child: Checkbox(
                              value: checkBoxOne,
                              activeColor: Color(0xFF66BB6A),
                              onChanged: (bool? newValue) {
                                setState(() {
                                  want_children = 'Someday';
                                  checkBoxOne = newValue!;
                                  checkBoxTwo = false;
                                  checkBoxThree = false;
                                  checkBoxThreeOne = false;
                                  checkBoxThreeTwo = false;
                                });
                              }),
                        ),
                      ),
                      Text(
                        'Someday',
                        textScaleFactor: 1.0,
                        style: regualrText14,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                        child: Transform.scale(
                          scale: 1.3,
                          child: Checkbox(
                              value: checkBoxTwo,
                              activeColor: Color(0xFF66BB6A),
                              onChanged: (bool? newValue) {
                                setState(() {
                                  want_children = "Don't want";
                                  checkBoxTwo = newValue!;
                                  checkBoxOne = false;
                                  checkBoxThree = false;
                                  checkBoxThreeOne = false;
                                  checkBoxThreeTwo = false;
                                });
                              }),
                        ),
                      ),
                      Text(
                        "Don't want",
                        textScaleFactor: 1.0,
                        style: regualrText14,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                        child: Transform.scale(
                          scale: 1.3,
                          child: Checkbox(
                              value: checkBoxThree,
                              activeColor: Color(0xFF66BB6A),
                              onChanged: (bool? newValue) {
                                setState(() {
                                  want_children = "Have & want more";
                                  checkBoxThree = newValue!;
                                  checkBoxOne = false;
                                  checkBoxTwo = false;
                                  checkBoxThreeOne = false;
                                  checkBoxThreeTwo = false;
                                });
                              }),
                        ),
                      ),
                      Text(
                        'Have & want more',
                        textScaleFactor: 1.0,
                        style: regualrText14,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                        child: Transform.scale(
                          scale: 1.3,
                          child: Checkbox(
                              value: checkBoxThreeOne,
                              activeColor: Color(0xFF66BB6A),
                              onChanged: (bool? newValue) {
                                setState(() {
                                  want_children = "Have & do not want more";
                                  checkBoxThreeOne = newValue!;
                                  checkBoxOne = false;
                                  checkBoxTwo = false;
                                  checkBoxThree = false;
                                  checkBoxThreeTwo = false;
                                });
                              }),
                        ),
                      ),
                      Text(
                        'Have & do not want more',
                        textScaleFactor: 1.0,
                        style: regualrText14,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                        child: Transform.scale(
                          scale: 1.3,
                          child: Checkbox(
                              value: checkBoxThreeTwo,
                              activeColor: Color(0xFF66BB6A),
                              onChanged: (bool? newValue) {
                                setState(() {
                                  want_children = "Not sure yet";
                                  checkBoxThreeTwo = newValue!;
                                  checkBoxOne = false;
                                  checkBoxTwo = false;
                                  checkBoxThree = false;
                                  checkBoxThreeOne = false;
                                });
                              }),
                        ),
                      ),
                      Text(
                        'Not sure yet',
                        textScaleFactor: 1.0,
                        style: regualrText14,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Align(
                  alignment: Directionality.of(context) == TextDirection.ltr
                      ? Alignment.topLeft
                      : Alignment.topLeft,
                  child: Text(
                    'Would you date someone with children?',
                    textScaleFactor: 1.0,
                    style: boldText28.copyWith(
                      color: Color(0xFF0573ac),
                    ),
                    textAlign: TextAlign.start,
                  )),
              SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                        child: Transform.scale(
                          scale: 1.3,
                          child: Checkbox(
                              value: checkBoxFour,
                              activeColor: Color(0xFF66BB6A),
                              onChanged: (bool? newValue) {
                                setState(() {
                                  date_with_children = 'Yes';
                                  checkBoxFour = newValue!;
                                  checkBoxFive = false;
                                  checkBoxSix = false;
                                  checkBoxSixOne = false;
                                });
                              }),
                        ),
                      ),
                      Text(
                        'Yes',
                        textScaleFactor: 1.0,
                        style: regualrText14,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                        child: Transform.scale(
                          scale: 1.3,
                          child: Checkbox(
                              value: checkBoxFive,
                              activeColor: Color(0xFF66BB6A),
                              onChanged: (bool? newValue) {
                                setState(() {
                                  date_with_children = 'No';
                                  checkBoxFive = newValue!;
                                  checkBoxFour = false;
                                  checkBoxSix = false;
                                  checkBoxSixOne = false;
                                });
                              }),
                        ),
                      ),
                      Text(
                        'No',
                        textScaleFactor: 1.0,
                        style: regualrText14,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                        child: Transform.scale(
                          scale: 1.3,
                          child: Checkbox(
                              value: checkBoxSix,
                              activeColor: Color(0xFF66BB6A),
                              onChanged: (bool? newValue) {
                                setState(() {
                                  date_with_children = 'No Preference';
                                  checkBoxSix = newValue!;
                                  checkBoxFour = false;
                                  checkBoxFive = false;
                                  checkBoxSixOne = false;
                                });
                              }),
                        ),
                      ),
                      Text(
                        'No Preference',
                        textScaleFactor: 1.0,
                        style: regualrText14,
                      ),
                    ],
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 50,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            "You can change these settings later.",
            textScaleFactor: 1.0,
            style: TextStyle(
              color: Color(0xff525354),
              fontWeight: FontWeight.normal,
              fontSize: 13.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Future<bool> setSetQuestionPreferences(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }
}
