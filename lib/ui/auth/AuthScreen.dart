import 'package:dating/common/common_widget.dart';
import 'package:dating/theme/textstyle.dart';
import 'package:dating/ui/menu/legal_screen/cookie_policy.dart';
import 'package:dating/ui/menu/legal_screen/privacy_policy.dart';
import 'package:dating/ui/menu/legal_screen/terms_of_use.dart';
import 'package:dating/ui/onBoarding/OnBoardingSignUpInfo.dart';
import 'package:dating/ui/phoneAuth/PhoneNumberInputScreen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:dating/constants.dart';
import 'package:dating/common/colors.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/constants.dart' as Constants;
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Position? signUpLocation;

  @override
  void initState() {
    super.initState();

    getNotification();
  }

  Future<void> getNotification() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(Constants.COLOR_PRIMARY),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          height: MediaQuery.of(context).size.height,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: [
                    sizedBox30,
                    Row(
                      children: [
                        Text(
                          'Welcome to TruuBlue',
                          textAlign: TextAlign.start,
                          textScaleFactor: 1.0,
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    sizedBox10,
                    Text(
                      'Register today to meet like-minded progressives near you',
                      textScaleFactor: 1.0,
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF707070),
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                Expanded(
                  child: Image.asset(
                    'assets/images/truubluenew.png',
                    height: 100.0,
                  ),
                ),
                Column(
                  children: [
                    RichText(
                      textScaleFactor: MediaQuery.of(context).textScaleFactor,
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                '''By tapping ‘Sign In’ or ‘Sign Up’, you agree to our ''',
                            style: regualrText14.copyWith(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                            text: 'Terms of Use',
                            style: regualrText14.copyWith(
                              fontSize: 14,
                              color: Color(COLOR_BLUE_BUTTON),
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => push(
                                    context,
                                    TermsOfUseScreen(),
                                  ),
                          ),
                          TextSpan(
                            text:
                                '''. Learn how we process your data in our ''',
                            style: regualrText14.copyWith(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: regualrText14.copyWith(
                              fontSize: 14,
                              color: Color(COLOR_BLUE_BUTTON),
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap =
                                  () => push(context, PrivacyPolicyScreen()),
                          ),
                          TextSpan(
                            text: ''' and ''',
                            style: regualrText14.copyWith(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                            text: 'Cookie Policy',
                            style: regualrText14.copyWith(
                              fontSize: 14,
                              color: Color(COLOR_BLUE_BUTTON),
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap =
                                  () => push(context, CookiePolicyScreen()),
                          ),
                        ],
                      ),
                    ),
                    sizedBox20,
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),
                        backgroundColor: Color(COLOR_BLUE_BUTTON),
                        textStyle: TextStyle(color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side: BorderSide(
                            color: Color(COLOR_BLUE_BUTTON),
                          ),
                        ),
                      ),
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        push(context, PhoneNumberInputScreen(login: true));
                      },
                    ),
                    sizedBox15,
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(COLOR_BLUE_BUTTON)),
                      ),
                      onPressed: () {
                        // push(context, OnBoardingQuestionOneScreen());
                        push(context, OnBoardingSignUpInfo());
                      },
                    ),
                    sizedBox30,
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
