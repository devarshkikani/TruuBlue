import 'package:dating/common/buttons.dart';
import 'package:dating/common/onboarding_app_bar.dart';
import 'package:dating/constants.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/theme/textstyle.dart';
import 'package:dating/ui/onBoarding/OnBoardingQuestionSixScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingQuestionFiveScreen extends StatefulWidget {
  const OnBoardingQuestionFiveScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingQuestionFiveScreenState createState() =>
      _OnBoardingQuestionFiveScreenState();
}

bool FiveScreenCheckBoxOne = false;
bool FiveScreenCheckBoxTwo = false;
bool FiveScreenCheckBoxThree = false;
bool FiveScreenCheckBoxFour = false;
bool FiveScreenCheckBoxFive = false;
bool FiveScreenCheckBoxSix = false;

class _OnBoardingQuestionFiveScreenState
    extends State<OnBoardingQuestionFiveScreen> with TickerProviderStateMixin {
  late AnimationController animationController1;
  late AnimationController animationController2;
  GlobalKey<FormState> _key = GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  String? phoneNumber;
  bool isPhoneValid = false;
  bool userCanMove = false;

  @override
  void initState() {
    animationController1 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    animationController2 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController1.dispose();
    animationController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if ((!FiveScreenCheckBoxOne &&
            !FiveScreenCheckBoxTwo &&
            !FiveScreenCheckBoxThree) ||
        (!FiveScreenCheckBoxFour &&
            !FiveScreenCheckBoxFive &&
            !FiveScreenCheckBoxSix)) {
      userCanMove = false;
    } else {
      userCanMove = true;
    }
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
        userCanMove: userCanMove,
        nextOnTap: nextButtonOnTap,
        animationController1: animationController1,
        animationController2: animationController2,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(30),
          child: Form(
            key: _key,
            autovalidateMode: _validate,
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Directionality.of(context) == TextDirection.ltr
                      ? Alignment.topLeft
                      : Alignment.topLeft,
                  child: Text(
                    'What is your gender?',
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
                                value: FiveScreenCheckBoxOne,
                                activeColor: Color(0xFF66BB6A),
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    FiveScreenCheckBoxOne = newValue!;
                                    FiveScreenCheckBoxTwo = false;
                                    FiveScreenCheckBoxThree = false;
                                  });
                                }),
                          ),
                        ),
                        Text(
                          'Female',
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
                                value: FiveScreenCheckBoxTwo,
                                activeColor: Color(0xFF66BB6A),
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    FiveScreenCheckBoxTwo = newValue!;
                                    FiveScreenCheckBoxOne = false;
                                    FiveScreenCheckBoxThree = false;
                                  });
                                }),
                          ),
                        ),
                        Text(
                          'Male',
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
                                value: FiveScreenCheckBoxThree,
                                activeColor: Color(0xFF66BB6A),
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    FiveScreenCheckBoxThree = newValue!;
                                    FiveScreenCheckBoxOne = false;
                                    FiveScreenCheckBoxTwo = false;
                                  });
                                }),
                          ),
                        ),
                        Text(
                          'Non-Binary',
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
                      'Who do you want\nto date?',
                      textScaleFactor: 1.0,
                      style: boldText28.copyWith(
                        color: Color(0xFF0573ac),
                      ),
                      textAlign: TextAlign.start,
                    )),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Directionality.of(context) == TextDirection.ltr
                      ? Alignment.topLeft
                      : Alignment.topLeft,
                  child: Text(
                    'Select all that apply',
                    style: mediumText18,
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(
                  height: 15,
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
                                value: FiveScreenCheckBoxFour,
                                activeColor: Color(0xFF66BB6A),
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    FiveScreenCheckBoxFour = newValue!;
                                  });
                                }),
                          ),
                        ),
                        Text(
                          'Female',
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
                                value: FiveScreenCheckBoxFive,
                                activeColor: Color(0xFF66BB6A),
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    FiveScreenCheckBoxFive = newValue!;
                                  });
                                }),
                          ),
                        ),
                        Text(
                          'Male',
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
                                value: FiveScreenCheckBoxSix,
                                activeColor: Color(0xFF66BB6A),
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    FiveScreenCheckBoxSix = newValue!;
                                  });
                                }),
                          ),
                        ),
                        Text(
                          'Non-Binary',
                          textScaleFactor: 1.0,
                          style: regualrText14,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    nextButton(
                      isActive: userCanMove,
                      onTap: nextButtonOnTap,
                    ),
                  ],
                )
              ],
            ),
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
                fontSize: 13.0),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void nextButtonOnTap() {
    if (!FiveScreenCheckBoxOne &&
        !FiveScreenCheckBoxTwo &&
        !FiveScreenCheckBoxThree &&
        !FiveScreenCheckBoxFour &&
        !FiveScreenCheckBoxFive &&
        !FiveScreenCheckBoxSix) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter all fields.'),
        duration: Duration(seconds: 6),
      ));
    } else {
      var yourgen = "Male";
      if (FiveScreenCheckBoxOne) {
        yourgen = "Male";
      } else if (FiveScreenCheckBoxTwo) {
        yourgen = "Female";
      } else if (FiveScreenCheckBoxThree) {
        yourgen = "Non-Binary";
      }
      var wantto = "";
      if (FiveScreenCheckBoxFour) {
        if (wantto == "") {
          wantto = "Male";
        } else {
          wantto = wantto + ",Male";
        }
      }
      if (FiveScreenCheckBoxFive) {
        if (wantto == "") {
          wantto = "Female";
        } else {
          wantto = wantto + ",Female";
        }
      }
      if (FiveScreenCheckBoxSix) {
        if (wantto == "") {
          wantto = "Non-Binary";
        } else {
          wantto = wantto + ",Non-Binary";
        }
      }
      setSetQuestionPreferences("Your_Gender", yourgen);
      setSetQuestionPreferences("Want_Date_Gender", wantto);
      push(context, OnBoardingQuestionSixScreen());
    }
  }

  Future<bool> setSetQuestionPreferences(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }
}
