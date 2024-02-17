// ignore_for_file: must_be_immutable

import 'package:dating/common/onboarding_app_bar.dart';
import 'package:dating/constants.dart';
import 'package:dating/main.dart';
import 'package:dating/model/User.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/theme/textstyle.dart';
import 'package:dating/ui/profile/complete_my_profile/OnBoardingQuestionNineScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingQuestionEightScreen extends StatefulWidget {
  User user;
  OnBoardingQuestionEightScreen({Key? key, required this.user})
      : super(key: key);

  @override
  _OnBoardingQuestionEightScreenState createState() =>
      _OnBoardingQuestionEightScreenState();
}

class _OnBoardingQuestionEightScreenState
    extends State<OnBoardingQuestionEightScreen> with TickerProviderStateMixin {
  late AnimationController animationController1;
  late AnimationController animationController2;
  GlobalKey<FormState> _key = GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  bool checkBoxOne = false;
  bool checkBoxTwo = false;
  bool checkBoxThree = false;
  bool checkBoxThreeOne = false;
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
    animationController2 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..forward();
    checkBoxOne = user.you_Drink == "No";
    checkBoxTwo = user.you_Drink == "Socially";
    checkBoxThree = user.you_Drink == "Frequently";
    checkBoxThreeOne = user.you_Drink == "No Preference";
    checkBoxFour = user.drinkWantToDate == "No";
    checkBoxFive = user.drinkWantToDate == "Yes,Socially";
    checkBoxSix = user.drinkWantToDate == "Yes,Regularly";
    checkBoxSixOne = user.drinkWantToDate == "No Preference";
  }

  @override
  void dispose() {
    animationController1.dispose();
    animationController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(COLOR_PRIMARY),
      appBar: onBoardingAppBar(
        backOnTap: () {
          animationController1.forward();
          setState(() {});
          Future.delayed(Duration(milliseconds: 500), () {
            Navigator.of(context).pop();
            animationController1.reverse();
          });
        },
        nextOnTap: () async {
          if (!checkBoxOne &&
              !checkBoxTwo &&
              !checkBoxThree &&
              !checkBoxThreeOne) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Please enter all fields.'),
              duration: Duration(seconds: 6),
            ));
          } else if (!checkBoxFour &&
              !checkBoxFive &&
              !checkBoxSix &&
              !checkBoxSixOne) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Please enter all fields.'),
              duration: Duration(seconds: 6),
            ));
          } else {
            var yourgen = "No";
            if (checkBoxOne) {
              yourgen = "No";
            } else if (checkBoxTwo) {
              yourgen = "Socially";
            } else if (checkBoxThree) {
              yourgen = "Frequently";
            } else if (checkBoxThreeOne) {
              yourgen = "No Preference";
            }
            var wantto = "No";
            if (checkBoxFour) {
              wantto = "No";
            } else if (checkBoxFive) {
              wantto = "Yes,Socially";
            } else if (checkBoxSix) {
              wantto = "Yes,Regularly";
            } else if (checkBoxSixOne) {
              wantto = "No Preference";
            }
            await setSetQuestionPreferences("You_Drink", yourgen);
            await setSetQuestionPreferences("Want_Date_Drink", wantto);
            push(
                context,
                OnBoardingQuestionNineScreen(
                  user: widget.user,
                ));
          }
        },
        animationController1: animationController1,
        animationController2: animationController2,
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
                  'Do you drink?',
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
                                  checkBoxOne = newValue!;
                                  checkBoxTwo = false;
                                  checkBoxThree = false;
                                  checkBoxThreeOne = false;
                                });
                              }),
                        ),
                      ),
                      Text(
                        'Never',
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
                                  checkBoxTwo = newValue!;
                                  checkBoxOne = false;
                                  checkBoxThree = false;
                                  checkBoxThreeOne = false;
                                });
                              }),
                        ),
                      ),
                      Text(
                        'Socially',
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
                                  checkBoxThree = newValue!;
                                  checkBoxOne = false;
                                  checkBoxTwo = false;
                                  checkBoxThreeOne = false;
                                });
                              }),
                        ),
                      ),
                      Text(
                        'Frequently',
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
                                  checkBoxThreeOne = newValue!;
                                  checkBoxOne = false;
                                  checkBoxTwo = false;
                                  checkBoxThree = false;
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
              SizedBox(
                height: 40,
              ),
              Align(
                  alignment: Directionality.of(context) == TextDirection.ltr
                      ? Alignment.topLeft
                      : Alignment.topLeft,
                  child: Text(
                    'Would you date someone who drinks?',
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
                                  checkBoxFour = newValue!;
                                  checkBoxFive = false;
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
                              value: checkBoxFive,
                              activeColor: Color(0xFF66BB6A),
                              onChanged: (bool? newValue) {
                                setState(() {
                                  checkBoxFive = newValue!;
                                  checkBoxFour = false;
                                  checkBoxSix = false;
                                  checkBoxSixOne = false;
                                });
                              }),
                        ),
                      ),
                      Text(
                        'Yes, socially',
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
                                  checkBoxSix = newValue!;
                                  checkBoxFour = false;
                                  checkBoxFive = false;
                                  checkBoxSixOne = false;
                                });
                              }),
                        ),
                      ),
                      Text(
                        'Yes, regularly',
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
                              value: checkBoxSixOne,
                              activeColor: Color(0xFF66BB6A),
                              onChanged: (bool? newValue) {
                                setState(() {
                                  checkBoxSixOne = newValue!;
                                  checkBoxFour = false;
                                  checkBoxFive = false;
                                  checkBoxSix = false;
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
