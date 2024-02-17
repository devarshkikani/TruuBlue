import 'package:dating/common/buttons.dart';
import 'package:dating/common/common_widget.dart';
import 'package:dating/common/onboarding_app_bar.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/theme/textstyle.dart';
import 'package:dating/ui/onBoarding/OnBoardingQuestionSevanScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

class OnBoardingQuestionSixScreen extends StatefulWidget {
  const OnBoardingQuestionSixScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingQuestionSixScreenState createState() =>
      _OnBoardingQuestionSixScreenState();
}

int SixScreenSelectedIndex = -1;
String? SixScreenSelection;

int SixScreenSelectedIndexOne = -1;

Map<String, bool> SexualityMAp = {
  'Straight': false,
  'Gay': false,
  'Lesbian': false,
  'Bisexual': false,
  'Demisexual': false,
  'Pansexual': false,
  'Queer': false,
  'Questioning': false,
};

class _OnBoardingQuestionSixScreenState
    extends State<OnBoardingQuestionSixScreen> with TickerProviderStateMixin {
  late AnimationController animationController1;
  late AnimationController animationController2;

  final List<String> _SexualityList = [
    'Straight',
    'Gay',
    'Lesbian',
    'Bisexual',
    'Demisexual',
    'Pansexual',
    'Queer',
    'Questioning',
    // 'No Preference',
  ];

  final List<String> SexualityListOne = [
    'Straight',
    'Gay',
    'Lesbian',
    'Bisexual',
    'Demisexual',
    'Pansexual',
    'Queer',
    'Questioning',
  ];

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
        userCanMove:
            SexualityMAp.values.where((element) => element).length != 0,
        nextOnTap: nextButtonOnTap,
        animationController1: animationController1,
        animationController2: animationController2,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(30),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Directionality.of(context) == TextDirection.ltr
                    ? Alignment.topLeft
                    : Alignment.topLeft,
                child: Text(
                  'What is your sexuality?',
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
              Container(
                  child: GridView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _SexualityList.length,
                itemBuilder: (BuildContext context, int index) {
                  return _PreferPronounItem(_SexualityList[index], index);
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 5, crossAxisCount: 2),
              )),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Directionality.of(context) == TextDirection.ltr
                    ? Alignment.topLeft
                    : Alignment.topLeft,
                child: Text(
                  'Who do you want to date?',
                  textScaleFactor: 1.0,
                  style: boldText28.copyWith(
                    color: Color(0xFF0573ac),
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
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
                height: 10,
              ),
              Container(
                child: GridView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: SexualityMAp.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _WhoYItem(
                        SexualityMAp.entries.elementAt(index).key, index);
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 5, crossAxisCount: 2),
                ),
              ),
              sizedBox30,
              nextButton(
                isActive:
                    SexualityMAp.values.where((element) => element).length != 0,
                onTap: nextButtonOnTap,
              ),
            ],
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

  _PreferPronounItem(String _list, int index) {
    return Container(
      color: Colors.white,
      child: Padding(
          padding: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
          child: Column(
            children: [
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 0, top: 4, right: 0, bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                        child: Transform.scale(
                          scale: 1.3,
                          child: Checkbox(
                              value: SixScreenSelectedIndex == index,
                              activeColor: Color(0xFF66BB6A),
                              onChanged: (bool? newValue) {
                                setState(() {
                                  SixScreenSelectedIndex = index;
                                  SixScreenSelection = _list;
                                });
                              }),
                        ),
                      ),
                      Text(
                        _list,
                        textScaleFactor: 1.0,
                        style: regualrText14,
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  setState(() {});
                },
              ),
            ],
          )),
    );
  }

  _WhoYItem(String _list, int index) {
    return Container(
      color: Colors.white,
      child: Padding(
          padding: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
          child: Column(
            children: [
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 0, top: 4, right: 0, bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                        child: Transform.scale(
                          scale: 1.3,
                          child: Checkbox(
                              value:
                                  SexualityMAp.entries.elementAt(index).value,
                              activeColor: Color(0xFF66BB6A),
                              onChanged: (bool? newValue) {
                                setState(() {
                                  SexualityMAp[_list] = newValue!;
                                  SixScreenSelectedIndexOne = index;
                                });
                              }),
                        ),
                      ),
                      /*Visibility(
                        visible:SelectedIndex==index,child: Icon(Icons.check,color: Colors.blue,)),*/
                      Padding(
                        padding: const EdgeInsets.only(top: 0, bottom: 0),
                        child: Text(
                          _list,
                          textScaleFactor: 1.0,
                          style: regualrText14,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  setState(() {
                    /* SelectedIndex=index;
                Cache().setPreferPronoun(_list);
                selection=_list;*/
                  });
                },
              ),
              //Divider(color: Colors.grey,height: 1,)
            ],
          )),
    );
  }

  void nextButtonOnTap() {
    if (SixScreenSelection == null &&
        SexualityMAp.values.where((element) => element).length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter all fields.'),
        duration: Duration(seconds: 6),
      ));
    } else {
      String whowant = "";
      SexualityMAp.forEach((key, value) {
        if (value) {
          if (whowant == "") {
            whowant = key;
          } else {
            whowant = whowant + "," + key;
          }
        }
      });
      setSetQuestionPreferences("Your_Sexuality", SixScreenSelection!);
      setSetQuestionPreferences("Want_Date_Sexuality", whowant);
      push(context, OnBoardingQuestionSevanScreen());
    }
  }

  Future<bool> setSetQuestionPreferences(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }
}
