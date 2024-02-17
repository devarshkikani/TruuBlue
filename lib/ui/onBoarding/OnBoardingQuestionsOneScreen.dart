import 'package:dating/Cache.dart';
import 'package:dating/common/buttons.dart';
import 'package:dating/common/common_widget.dart';
import 'package:dating/common/onboarding_app_bar.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/theme/textstyle.dart';
import 'package:dating/ui/onBoarding/OnBoardingQuestionTwoScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

class OnBoardingQuestionOneScreen extends StatefulWidget {
  const OnBoardingQuestionOneScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingQuestionOneScreenState createState() =>
      _OnBoardingQuestionOneScreenState();
}

String selection = 'She/her/hers';
TextEditingController firstnameController = TextEditingController();

class _OnBoardingQuestionOneScreenState
    extends State<OnBoardingQuestionOneScreen> with TickerProviderStateMixin {
  late AnimationController animationController1;
  late AnimationController animationController2;
  int SelectedIndex = 0;

  final List<String> _PreferPronounList = [
    'She/her/hers',
    'He/him/his',
    'They/them/theirs',
    'Ze/hir/hirs',
    'Ze/zir/zirs',
    'Prefer not to include',
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
          nextOnTap: nextButtonOnTap,
          userCanMove: firstnameController.text.length >= 3,
          animationController1: animationController1,
          animationController2: animationController2),
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
                  "What's your first name?",
                  textScaleFactor: 1.0,
                  style: boldText28.copyWith(
                    color: Color(0xFF0573ac),
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              sizedBox10,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "This will be displayed on your profile.",
                    textScaleFactor: 1.0,
                    style: TextStyle(color: Color(0xFF707070), fontSize: 18.0),
                    textAlign: TextAlign.start,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        shape: BoxShape.rectangle,
                        border: Border.all(color: Colors.grey.shade200)),
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      autofocus: true,
                      textInputAction: TextInputAction.done,
                      textCapitalization: TextCapitalization.words,
                      style: TextStyle(fontSize: 18.0),
                      controller: firstnameController,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.grey.shade500,
                      textAlign: TextAlign.center,
                      onChanged: (_) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 16, right: 16),
                        hintText: '',
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                                color: Colors.grey.shade500, width: 2.0)),
                        errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).errorColor),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).errorColor),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Directionality.of(context) == TextDirection.ltr
                    ? Alignment.topLeft
                    : Alignment.topLeft,
                child: Text(
                  "What are your preferred pronouns?",
                  textScaleFactor: 1.0,
                  style: mediumText20,
                  textAlign: TextAlign.start,
                ),
              ),
              sizedBox10,
              Container(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: _PreferPronounList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _PreferPronounItem(
                          _PreferPronounList[index], index);
                    }),
              ),
              SizedBox(
                height: 30,
              ),
              nextButton(
                isActive: firstnameController.text.length >= 3,
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
            "This information is shared with other members.\nYou will not be able to change your name later.",
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
    if (firstnameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter your first name.',
          ),
        ),
      );
    } else {
      setSetQuestionPreferences("first_name", firstnameController.text);
      setSetQuestionPreferences("prefer_pronoun", selection);
      push(context, OnBoardingQuestionTwoScreen());
    }
  }

  _PreferPronounItem(String _list, int index) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          InkWell(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 0, top: 5, right: 5, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                    child: Transform.scale(
                      scale: 1.3,
                      child: Checkbox(
                          value: SelectedIndex == index,
                          activeColor: Color(0xFF66BB6A),
                          onChanged: (bool? newValue) {
                            setState(() {
                              SelectedIndex = index;
                              Cache().setPreferPronoun(_list);
                              selection = _list;
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
                      style: mediumText14,
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Future<bool> setSetQuestionPreferences(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }
}
