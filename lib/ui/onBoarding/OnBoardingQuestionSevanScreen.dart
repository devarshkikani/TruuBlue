import 'package:dating/common/buttons.dart';
import 'package:dating/common/common_widget.dart';
import 'package:dating/common/onboarding_app_bar.dart';
import 'package:dating/constants.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/theme/textstyle.dart';
import 'package:dating/ui/onBoarding/OnBoardingQuestionElevenScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingQuestionSevanScreen extends StatefulWidget {
  const OnBoardingQuestionSevanScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingQuestionSevanScreenState createState() =>
      _OnBoardingQuestionSevanScreenState();
}

int SevanScreenSelectedIndex = -1;
String? SevanScreenSelection;

int SevanScreenSelectedIndexOne = -1;

Map<String, bool> ethnicityListOne = {
  'American Indian': false,
  'Black/African Decent': false,
  'East Asian': false,
  'Hispanic Latino': false,
  'Middle Eastern': false,
  'Pacifica Islander': false,
  'South Asian': false,
  'White/Caucasian': false,
};

class _OnBoardingQuestionSevanScreenState
    extends State<OnBoardingQuestionSevanScreen> with TickerProviderStateMixin {
  late AnimationController animationController1;
  late AnimationController animationController2;
  GlobalKey<FormState> _key = GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  String? phoneNumber;
  bool isPhoneValid = false;

  final List<String> _SexualityListOne = [
    'American Indian',
    'Black/African Decent',
    'East Asian',
    'Hispanic Latino',
    'Middle Eastern',
    'Pacifica Islander',
    'South Asian',
    'White/Caucasian',
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
            ethnicityListOne.values.where((element) => element).length != 0,
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
                    'What is your ethnicity?',
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
                GridView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: _SexualityListOne.length,
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return _PreferPronounItem(_SexualityListOne[index], index);
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 5,
                    crossAxisCount: 2,
                  ),
                ),
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
                  height: 200,
                  child: GridView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: ethnicityListOne.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return _WhoYItem(
                          ethnicityListOne.entries.elementAt(index).key, index);
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 5, crossAxisCount: 2),
                  ),
                ),
                sizedBox30,
                nextButton(
                  isActive: ethnicityListOne.values
                          .where((element) => element)
                          .length !=
                      0,
                  onTap: nextButtonOnTap,
                ),
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
              fontSize: 13.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  _PreferPronounItem(String _list, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 25,
          child: Transform.scale(
            scale: 1.3,
            child: Checkbox(
                value: SevanScreenSelectedIndex == index,
                activeColor: Color(0xFF66BB6A),
                onChanged: (bool? newValue) {
                  setState(() {
                    SevanScreenSelectedIndex = index;
                    SevanScreenSelection = _list;
                  });
                }),
          ),
        ),
        Flexible(
          flex: 1,
          child: Text(
            _list,
            textScaleFactor: 1.0,
            style: regualrText14,
          ),
        ),
      ],
    );
  }

  _WhoYItem(String _list, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 25,
          child: Transform.scale(
            scale: 1.3,
            child: Checkbox(
                value: ethnicityListOne.entries.elementAt(index).value,
                activeColor: Color(0xFF66BB6A),
                onChanged: (bool? newValue) {
                  setState(() {
                    ethnicityListOne[_list] = newValue!;
                  });
                }),
          ),
        ),
        Flexible(
          flex: 1,
          child: Text(
            _list,
            textScaleFactor: 1.0,
            style: regualrText14,
          ),
        ),
      ],
    );
  }

  void nextButtonOnTap() {
    if (SevanScreenSelection == null &&
        ethnicityListOne.values.where((element) => element).length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter all fields.'),
      ));
    } else {
      String whowant = "";
      ethnicityListOne.forEach((key, value) {
        if (value) {
          if (whowant == "") {
            whowant = key;
          } else {
            whowant = whowant + "," + key;
          }
        }
      });

      setSetQuestionPreferences("Your_Ethnicity", SevanScreenSelection!);
      setSetQuestionPreferences("Want_Date_Ethnicity", whowant);
      push(context, OnBoardingQuestionElevenScreen());
    }
  }

  Future<bool> setSetQuestionPreferences(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }
}
