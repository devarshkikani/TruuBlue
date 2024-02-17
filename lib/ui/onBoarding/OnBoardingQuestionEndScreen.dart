import 'package:flutter/material.dart';
import 'package:dating/constants.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/common/onboarding_app_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:dating/ui/location_permission/location_permission_screen.dart';

class OnBoardingQuestionEndScreen extends StatefulWidget {
  const OnBoardingQuestionEndScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingQuestionEndScreenState createState() =>
      _OnBoardingQuestionEndScreenState();
}

class _OnBoardingQuestionEndScreenState
    extends State<OnBoardingQuestionEndScreen> with TickerProviderStateMixin {
  late AnimationController animationController1;
  late AnimationController animationController2;

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
    getNotification();
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
        userCanMove: true,
        nextOnTap: () async {
          push(context, LocationPermissionScreen());
        },
        animationController1: animationController1,
        animationController2: animationController2,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 40.0,
              right: 40,
              bottom: 20,
              top: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Directionality.of(context) == TextDirection.ltr
                      ? Alignment.topLeft
                      : Alignment.topLeft,
                  child: Text(
                    'Awesome!',
                    textScaleFactor: 1.0,
                    style: TextStyle(
                      color: Color(0xFF0573ac),
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                RichText(
                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                  text: new TextSpan(
                    style: new TextStyle(
                      fontSize: 13.0,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text:
                              "Are you ready to start meeting like-minded progressives in your area?"),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Remember:',
                  style: TextStyle(
                    color: Color(0xFF4a4a4a),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VerticalDivider(
                          endIndent: 2,
                          indent: 2,
                          color: Colors.black,
                          thickness: 2,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 10,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Do not give out personal data like your home address or cell number",
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Never respond to requests to send money, especially overseas or via wire transfer, and do not share personal financial information with any matches",
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Tell a friend where you are going on a date, always meet at a public place, and take your own transportation",
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Report any bad actors to TruuBlue immediately",
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'DeepBlue members go on twice as many dates as free users',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF70573ac),
                      textStyle: TextStyle(color: Colors.white),
                      padding: EdgeInsets.only(
                          right: 20, left: 20, top: 10, bottom: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(color: Color(0xFF0573ac))),
                    ),
                    child: Text(
                      "Let's Go!",
                      textScaleFactor: 1.0,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      push(context, LocationPermissionScreen());
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
