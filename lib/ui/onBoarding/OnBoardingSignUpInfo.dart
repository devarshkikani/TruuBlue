import 'package:dating/common/buttons.dart';
import 'package:dating/common/colors.dart';
import 'package:dating/common/onboarding_app_bar.dart';
import 'package:dating/constants.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/theme/textstyle.dart';
import 'package:dating/ui/onBoarding/OnBoardingCellNumberScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class OnBoardingSignUpInfo extends StatefulWidget {
  const OnBoardingSignUpInfo({Key? key}) : super(key: key);

  @override
  _OnBoardingSignUpInfoState createState() => _OnBoardingSignUpInfoState();
}

class _OnBoardingSignUpInfoState extends State<OnBoardingSignUpInfo>
    with TickerProviderStateMixin {
  late AnimationController animationController1;
  late AnimationController animationController2;
  GlobalKey<FormState> _key = GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  Position? signUpLocation;
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
    getlocation().then((value) {
      if (value != null || signUpLocation != null) {
        getNotification();
      }
    });
    getNotification();
  }

  Future<Position?> getlocation() async {
    Future.delayed(const Duration(milliseconds: 500), () async {
      signUpLocation = await getCurrentLocation();

      setState(() {
        if (signUpLocation != null) {
          getNotification();
        }
      });
    });
    return signUpLocation;
  }

  @override
  void dispose() {
    animationController1.dispose();
    animationController2.dispose();
    super.dispose();
  }

  getNotification() async {
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
      setState(() {});
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
      setState(() {});
    } else {
      print('User declined or has not accepted permission');
    }
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
        nextOnTap: () {
          push(context, OnBoardingCellNumberScreen());
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
                      : Alignment.center,
                  child: Text(
                    'Create a New Account',
                    textScaleFactor: 1.0,
                    style: boldText28.copyWith(
                      color: primaryColor,
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
                      'Please review the TruuBlue code of ethics',
                      textScaleFactor: 1.0,
                      style: regualrText20.copyWith(
                        color: Color(0xFF707070),
                      ),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    RichText(
                      textScaleFactor: MediaQuery.of(context).textScaleFactor,
                      text: new TextSpan(
                        // Note: Styles for TextSpans must be explicitly defined.
                        // Child text spans will inherit styles from parent
                        style: new TextStyle(
                          fontSize: 20.0,
                          color: Color(0xFF707070),
                        ),

                        children: <TextSpan>[
                          TextSpan(
                              text: 'Be Honest - ',
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 18.0)),
                          TextSpan(
                              text:
                                  'Ensure that your bio, photos and age are accurate and reflect who you really are',
                              style: new TextStyle(
                                  fontSize: 18.0, color: Color(0xFF707070))),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RichText(
                      textScaleFactor: MediaQuery.of(context).textScaleFactor,
                      text: new TextSpan(
                        // Note: Styles for TextSpans must be explicitly defined.
                        // Child text spans will inherit styles from parent
                        style: new TextStyle(
                          fontSize: 20.0,
                          color: Color(0xFF707070),
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Be Safe - ',
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 18.0)),
                          TextSpan(
                              text:
                                  'Make sure you are comfortable with a match before you give out personal information',
                              style: new TextStyle(
                                  fontSize: 18.0, color: Color(0xFF707070))),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RichText(
                      textScaleFactor: MediaQuery.of(context).textScaleFactor,
                      text: new TextSpan(
                        // Note: Styles for TextSpans must be explicitly defined.
                        // Child text spans will inherit styles from parent
                        style: new TextStyle(
                          fontSize: 20.0,
                          color: Color(0xFF707070),
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Be Respectful - ',
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 18.0)),
                          TextSpan(
                              text:
                                  'Treat all members with the respect and dignity you would like in return',
                              style: new TextStyle(
                                  fontSize: 18.0, color: Color(0xFF707070))),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RichText(
                      textScaleFactor: MediaQuery.of(context).textScaleFactor,
                      text: new TextSpan(
                        // Note: Styles for TextSpans must be explicitly defined.
                        // Child text spans will inherit styles from parent
                        style: new TextStyle(
                          fontSize: 20.0,
                          color: Color(0xFF707070),
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Be Diligent - ',
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 18.0)),
                          TextSpan(
                              text:
                                  'Always report bad behavior immediately and help us maintain a safe environment',
                              style: new TextStyle(
                                  fontSize: 18.0, color: Color(0xFF707070))),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                nextButton(
                  isActive: true,
                  title: 'I agree',
                  onTap: () {
                    push(context, OnBoardingCellNumberScreen());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
