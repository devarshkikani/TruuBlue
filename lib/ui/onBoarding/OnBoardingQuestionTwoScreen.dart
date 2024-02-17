import 'package:dating/common/buttons.dart';
import 'package:dating/common/onboarding_app_bar.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/theme/textstyle.dart';
import 'package:dating/ui/onBoarding/OnBoardingQuestionThreeScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../constants.dart';

class OnBoardingQuestionTwoScreen extends StatefulWidget {
  const OnBoardingQuestionTwoScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingQuestionOneScreenState createState() =>
      _OnBoardingQuestionOneScreenState();
}

double TwoScreenOneSliderValue = 8;
double TwoScreenTwoSliderValue = 8;
double TwoScreenThreeSliderValue = 8;

class _OnBoardingQuestionOneScreenState
    extends State<OnBoardingQuestionTwoScreen> with TickerProviderStateMixin {
  late AnimationController animationController1;
  late AnimationController animationController2;
  String? phoneNumber;
  Size? size;
  GlobalKey<FormState> _key = GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;

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
        nextOnTap: nextButtonOnTap,
        animationController1: animationController1,
        animationController2: animationController2,
        userCanMove: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: 30,
            horizontal: 15,
          ),
          child: Form(
            key: _key,
            autovalidateMode: _validate,
            child: Column(
              children: <Widget>[
                Align(
                    alignment: Directionality.of(context) == TextDirection.ltr
                        ? Alignment.topLeft
                        : Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        "Where do you stand on these issues?",
                        textScaleFactor: 1.0,
                        style: boldText28.copyWith(
                          color: Color(0xFF0573ac),
                        ),
                        textAlign: TextAlign.start,
                      ),
                    )),
                SizedBox(
                  height: 10,
                ),
                Container(
                  color: Color(0xFFf3fbff),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, top: 12, right: 16, bottom: 8),
                        child: Text(
                          "Support Pro-Choice",
                          textScaleFactor: 1.0,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0xFF707070),
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, top: 0, right: 10, bottom: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Fully\nAgainst",
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 10.0),
                            ),
                            Text(
                              "Against",
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 10.0),
                            ),
                            Text(
                              "Neutral",
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 10.0),
                            ),
                            Text(
                              "Support",
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 10.0),
                            ),
                            Text(
                              "Fully\nSupport",
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 10.0),
                            ),
                          ],
                        ),
                      ),
                      SfSlider(
                        value: TwoScreenOneSliderValue,
                        max: 16,
                        interval: 4,
                        stepSize: 4,
                        showTicks: true,
                        thumbIcon: Container(
                          width: 10.0,
                          height: 10.0,
                          decoration: new BoxDecoration(
                            color: Color(COLOR_BLUE_BUTTON),
                            shape: BoxShape.circle,
                          ),
                        ),
                        activeColor: Colors.grey,
                        inactiveColor: Colors.grey,
                        onChanged: (dynamic value) {
                          setState(() {
                            TwoScreenOneSliderValue = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  color: Color(0xFFf3fbff),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, top: 10, right: 16, bottom: 8),
                        child: Text(
                          "Better Climate Legislation",
                          textScaleFactor: 1.0,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0xFF707070),
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, top: 0, right: 10, bottom: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Fully\nAgainst",
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 10.0),
                            ),
                            Text(
                              "Against",
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 10.0),
                            ),
                            Text(
                              "Neutral",
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 10.0),
                            ),
                            Text(
                              "Support",
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 10.0),
                            ),
                            Text(
                              "Fully\nSupport",
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 10.0),
                            ),
                          ],
                        ),
                      ),
                      SfSlider(
                        value: TwoScreenTwoSliderValue,
                        max: 16,
                        interval: 4,
                        stepSize: 4,
                        showTicks: true,
                        thumbIcon: Container(
                          width: 10.0,
                          height: 10.0,
                          decoration: new BoxDecoration(
                            color: Color(COLOR_BLUE_BUTTON),
                            shape: BoxShape.circle,
                          ),
                        ),
                        activeColor: Colors.grey,
                        inactiveColor: Colors.grey,
                        onChanged: (dynamic value) {
                          setState(() {
                            TwoScreenTwoSliderValue = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  color: Color(0xFFf3fbff),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, top: 10, right: 16, bottom: 8),
                        child: Text(
                          "Expand LGBTQ+ Rights",
                          textScaleFactor: 1.0,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0xFF707070),
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, top: 0, right: 10, bottom: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Fully\nAgainst",
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 10.0),
                            ),
                            Text(
                              "Against",
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 10.0),
                            ),
                            Text(
                              "Neutral",
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 10.0),
                            ),
                            Text(
                              "Support",
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 10.0),
                            ),
                            Text(
                              "Fully\nSupport",
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 10.0),
                            ),
                          ],
                        ),
                      ),
                      SfSlider(
                        value: TwoScreenThreeSliderValue,
                        max: 16,
                        interval: 4,
                        stepSize: 4,
                        showTicks: true,
                        thumbIcon: Container(
                          width: 10.0,
                          height: 10.0,
                          decoration: new BoxDecoration(
                            color: Color(COLOR_BLUE_BUTTON),
                            shape: BoxShape.circle,
                          ),
                        ),
                        activeColor: Colors.grey,
                        inactiveColor: Colors.grey,
                        onChanged: (dynamic value) {
                          setState(() {
                            TwoScreenThreeSliderValue = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                nextButton(
                  isActive: true,
                  onTap: nextButtonOnTap,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 60,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            "These ratings are used to find like-minded matches. You will be able to change these settings later.",
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

  String getQuestion(double value) {
    if (value == 0) {
      return "-2";
    } else if (value == 4) {
      return "-1";
    } else if (value == 8) {
      return "0";
    } else if (value == 12) {
      return "1";
    } else {
      return "2";
    }
  }

  void nextButtonOnTap() {
    setSetQuestionPreferences("Q1", getQuestion(TwoScreenOneSliderValue));
    setSetQuestionPreferences("Q2", getQuestion(TwoScreenTwoSliderValue));
    setSetQuestionPreferences("Q3", getQuestion(TwoScreenThreeSliderValue));
    push(context, OnBoardingQuestionThreeScreen());
  }

  Future<bool> setSetQuestionPreferences(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }
}
