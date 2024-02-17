import 'dart:convert';
import 'dart:math';

import 'package:dating/common/onboarding_app_bar.dart';
import 'package:dating/constants.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/theme/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'OnBoardingQuestionFifteenScreen.dart';

class OnBoardingQuestionFourteenScreen extends StatefulWidget {
  const OnBoardingQuestionFourteenScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingQuestionFourteenScreenState createState() =>
      _OnBoardingQuestionFourteenScreenState();
}

class _OnBoardingQuestionFourteenScreenState
    extends State<OnBoardingQuestionFourteenScreen>
    with TickerProviderStateMixin {
  late AnimationController animationController1;
  late AnimationController animationController2;
  GlobalKey<FormState> _key = GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  String? phoneNumber;
  bool isPhoneValid = false;
  Size? size;
  final emailController = TextEditingController();

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
        nextOnTap: () async {
          String pattern =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          RegExp regex = RegExp(pattern);
          if (!regex.hasMatch(emailController.text)) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Enter valid email.'),
              duration: Duration(seconds: 6),
            ));
          } else {
            bool? user = await FireStoreUtils.getEmail(emailController.text);
            if (user!) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      'Email address already exist try with different email address.')));
            } else {
              setSetQuestionPreferences("email", emailController.text);
              var rnd = Random();
              var next = rnd.nextDouble() * 1000000;
              while (next < 100000) {
                next *= 10;
              }
              await sendEmail("Security code : " + (next.toInt()).toString());
              push(context, OnBoardingQuestionFifteenScreen(next.toInt()));
            }
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
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Directionality.of(context) == TextDirection.ltr
                      ? Alignment.topLeft
                      : Alignment.topLeft,
                  child: Text(
                    'Enter your email address',
                    textScaleFactor: 1.0,
                    style: boldText28.copyWith(
                      color: Color(0xFF0573ac),
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 0, top: 10, right: 0, bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        textScaleFactor: MediaQuery.of(context).textScaleFactor,
                        text: new TextSpan(
                          style: regualrText20.copyWith(
                            color: Color(0xFF707070),
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  "We use your email address for an added layer of security and protection.",
                            ),
                          ],
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
                            controller: emailController,
                            textAlignVertical: TextAlignVertical.center,
                            textInputAction: TextInputAction.done,
                            style: TextStyle(fontSize: 18.0),
                            onSaved: (val) => phoneNumber = val,
                            keyboardType: TextInputType.emailAddress,
                            cursorColor: Colors.black,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  left: 16, right: 16, bottom: 12),
                              hintText: 'name@abc.com',
                              hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.2)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 1.0)),
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
                                    BorderSide(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
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
            "Check your inbox to verify your email\naddress. Your email will never be shared.",
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

  Future<bool> setSetQuestionPreferences(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  Future sendEmail(String message) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var first_name = prefs.getString("first_name") ?? '';
    String email = emailController.text;
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    const serviceId = EMAILJSSERVICEID;
    const templateId = EMAILJSTEMPLATE;
    const userId = EMAILJSUSERID;
    final response = await http.post(url,
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'application/json'
        }, //This line makes sure it works for all platforms.
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'to_name': first_name,
            'to_email': email,
            'message': message
          }
        }));
    return response.statusCode;
  }
}
