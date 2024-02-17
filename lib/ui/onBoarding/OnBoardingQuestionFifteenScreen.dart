// ignore_for_file: must_be_immutable

import 'package:dating/constants.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/theme/textstyle.dart';
import 'package:dating/ui/onBoarding/OnBoardingQuestionEndScreen.dart';
import 'package:dating/ui/onBoarding/OnBoardingQuestionFourteenScreen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class OnBoardingQuestionFifteenScreen extends StatefulWidget {
  int otp;
  OnBoardingQuestionFifteenScreen(this.otp);

  @override
  _OnBoardingQuestionFifteenScreenState createState() =>
      _OnBoardingQuestionFifteenScreenState();
}

class _OnBoardingQuestionFifteenScreenState
    extends State<OnBoardingQuestionFifteenScreen>
    with TickerProviderStateMixin {
  late AnimationController animationController1;
  GlobalKey<FormState> _key = GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  String? phoneNumber;
  bool isPhoneValid = false;

  final numberController = TextEditingController();

  @override
  void initState() {
    animationController1 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    super.initState();
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
                Image.asset(
                  'assets/images/truubluenew.png',
                ),
                SizedBox(
                  width: 30,
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
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Directionality.of(context) == TextDirection.ltr
                      ? Alignment.topLeft
                      : Alignment.topLeft,
                  child: Text(
                    'Verify your email address',
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Check your inbox and enter the code provided within the message box below:",
                      style: regualrText18.copyWith(
                        color: Color(0xFF707070),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 32.0, right: 24.0, left: 24.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            shape: BoxShape.rectangle,
                            border: Border.all(color: Colors.grey.shade200)),
                        child: TextFormField(
                          textAlignVertical: TextAlignVertical.center,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(fontSize: 18.0),
                          controller: numberController,
                          onChanged: (c) {
                            print(numberController.text.length.toString());
                            if (numberController.text.length == 6) {
                              FocusScope.of(context).requestFocus(FocusNode());
                            }
                          },
                          onSaved: (val) => phoneNumber = val,
                          keyboardType: TextInputType.number,
                          cursorColor: Color(COLOR_PRIMARY),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(left: 16, right: 16),
                            hintText: '------',
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                    color: Color(COLOR_PRIMARY), width: 2.0)),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).errorColor),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).errorColor),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade200),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                RichText(
                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                  text: TextSpan(
                    style: new TextStyle(
                      fontSize: 15.0,
                      color: Color(0xFF707070),
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text:
                              'If you have not received your security code, please check your spam folder or '),
                      TextSpan(
                        text: 'click here',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            push(context, OnBoardingQuestionFourteenScreen());
                          },
                        style: new TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      TextSpan(text: ' to re-enter your email address.'),
                    ],
                  ),
                ),
                SizedBox(
                  height: 80,
                ),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF70573ac),
                      textStyle: TextStyle(color: Colors.white),
                      padding: EdgeInsets.only(
                          right: 50, left: 50, top: 10, bottom: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(color: Color(0xFF0573ac))),
                    ),
                    child: Text(
                      'Next',
                      textScaleFactor: 1.0,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      if (widget.otp.toString() ==
                          numberController.text.toString()) {
                        push(context, OnBoardingQuestionEndScreen());
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Enter valid OTP.'),
                            duration: Duration(seconds: 6),
                          ),
                        );
                      }
                    },
                  ),
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
            "Check your inbox to verify your email address. Your email will never be shared.",
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
}
