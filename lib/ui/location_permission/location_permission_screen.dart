import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/common/colors.dart';
import 'package:dating/common/common_widget.dart';
import 'package:dating/constants.dart';
import 'package:dating/model/User.dart';
import 'package:dating/theme/textstyle.dart';
import 'package:dating/ui/art_board/first_art_board_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:dating/main.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/ui/AppEntryOffers/AppEntryOffersScreen.dart';
import 'package:dating/ui/SwipeScreen/SwipeScreen.dart';
import 'package:dating/ui/onBoarding/OnBoardingQuestionElevenScreen.dart';
import 'package:dating/ui/onBoarding/OnBoardingQuestionFiveScreen.dart';
import 'package:dating/ui/onBoarding/OnBoardingQuestionFourScreen.dart';
import 'package:dating/ui/onBoarding/OnBoardingQuestionSevanScreen.dart';
import 'package:dating/ui/onBoarding/OnBoardingQuestionSixScreen.dart';
import 'package:dating/ui/onBoarding/OnBoardingQuestionThreeScreen.dart';
import 'package:dating/ui/onBoarding/OnBoardingQuestionTwoScreen.dart';
import 'package:dating/ui/onBoarding/OnBoardingQuestionsOneScreen.dart';
import 'package:dating/ui/onBoarding/onBoarding_hobby_question.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class LocationPermissionScreen extends StatefulWidget {
  const LocationPermissionScreen({Key? key}) : super(key: key);

  @override
  State<LocationPermissionScreen> createState() =>
      _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen>
    with WidgetsBindingObserver {
  RxBool processIndicator = false.obs;
  RxString buttonText = 'Got It!'.obs;
  Position? signUpLocation;
  late User user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      processIndicator.value = true;
      final Future<bool> isLocationGet = getCurrentPosition();
      if (await isLocationGet) {
        processIndicator.value = false;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await _signUpWithEmailAndPassword();
        user.your_details.religiose_belief =
            prefs.getString("religion").toString();
        user.your_details.univerties = prefs.getString("college").toString();
        user.your_details.home_town = prefs.getString("hometown").toString();
        setState(() {});
      } else {
        processIndicator.value = false;
      }
    }
  }

  Future<bool> getCurrentPosition() async {
    final bool hasPermission = await handleLocationPermission();

    if (!hasPermission) {
      return false;
    }
    try {
      final Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      signUpLocation = position;
      setState(() {});
      return true;
    } on Position catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      buttonText.value = 'Open Setting';
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        buttonText.value = 'Open Setting';
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      buttonText.value = 'Open Setting';
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: SizedBox(),
        title: Image.asset(
          'assets/images/app_logo__.png',
          width: 150,
          height: 150,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Center(
                      child: Text(
                        'Add Your \nCurrent Location',
                        textAlign: TextAlign.center,
                        style: boldText28.copyWith(
                          color: primaryColor,
                          fontFamily: 'source_serif_pro',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Image.asset('assets/images/location_required.png'),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        'Where are you?',
                        textAlign: TextAlign.center,
                        style: boldText28.copyWith(
                          color: primaryColor,
                          fontFamily: 'source_serif_pro',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '''TruuBlue uses your location to show you singles in your area. Make sure Location Services is turned ON so the TruuBlue app works for you.''',
                      style: regualrText14,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Column(
                      children: <Widget>[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 30,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                          child: Obx(
                            () => Text(
                              buttonText.value,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: whiteColor,
                              ),
                            ),
                          ),
                          onPressed: () async {
                            if (buttonText.value == 'Open Setting') {
                              await Geolocator.openAppSettings();
                            } else {
                              final bool isLocationGet =
                                  await getCurrentPosition();
                              if (isLocationGet == true) {
                                processIndicator.value = false;
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await _signUpWithEmailAndPassword();
                                user.your_details.religiose_belief =
                                    prefs.getString("religion").toString();
                                user.your_details.univerties =
                                    prefs.getString("college").toString();
                                user.your_details.home_town =
                                    prefs.getString("hometown").toString();
                                setState(() {});
                              }
                            }
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Obx(
                () => processIndicator.value
                    ? Center(child: CircularProgressIndicator())
                    : sizedBox5,
              )
            ],
          ),
        ),
      ),
    );
  }

  String getUserCount(int totalLength) {
    String userCount = '';
    final int documents = totalLength;
    for (int i = documents.toString().length; i < 4; i++) {
      userCount += '0';
    }
    userCount += documents.toString();
    return userCount;
  }

  _signUpWithEmailAndPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await showProgress(context, 'Creating new account, Please wait...', false);
    // signUpLocation = await getCurrentLocation();
    final QuerySnapshot qSnap =
        await FireStoreUtils.firestore.collection(USERS).get();
    final String userCount = getUserCount(qSnap.docs.length + 1);
    if (signUpLocation != null) {
      dynamic result = await FireStoreUtils.firebaseSignUpWithEmailAndPassword(
          prefs.getString("email") ?? '',
          "123456",
          File(prefs.getString("imageOne")!),
          File(prefs.getString("imageTwo")!),
          File(prefs.getString("imageThree")!),
          File(prefs.getString("imageFour")!),
          File(prefs.getString("imageFive")!),
          File(prefs.getString("imageSix")!),
          prefs.getString("first_name") ?? '',
          "x",
          signUpLocation!,
          prefs.getString("cell_number") ?? '',
          prefs.getString("prefer_pronoun") ?? '',
          prefs.getString("Q1") ?? '',
          prefs.getString("Q2") ?? '',
          prefs.getString("Q3") ?? '',
          prefs.getString("Q4") ?? '',
          prefs.getString("Q5") ?? '',
          prefs.getString("Q6") ?? '',
          prefs.getString("Q1_Deal_Breaker") ?? '',
          prefs.getString("Q2_Deal_Breaker") ?? '',
          prefs.getString("Q3_Deal_Breaker") ?? '',
          prefs.getString("Q4_Deal_Breaker") ?? '',
          prefs.getString("Q5_Deal_Breaker") ?? '',
          prefs.getString("Q6_Deal_Breaker") ?? '',
          prefs.getString("birthdate") ?? '',
          prefs.getString("age_prefrance_start") ?? '',
          prefs.getString("age_prefrance_end") ?? '',
          prefs.getString("Your_Gender") ?? '',
          prefs.getString("Want_Date_Gender") ?? '',
          prefs.getString("Your_Sexuality") ?? '',
          prefs.getString("Want_Date_Sexuality") ?? '',
          prefs.getString("Your_Ethnicity") ?? '',
          prefs.getString("Want_Date_Ethnicity") ?? '',
          userCount,
          prefs.getString('prompt') == null
              ? []
              : json.decode(prefs.getString('prompt') ?? ''));
      if (result != null && result is User) {
        answeredQuestionList = [];
        user = result;
        user.active = true;
        user.fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
        user.lastOnlineTimestamp =
            DateTime.now().toUtc().millisecondsSinceEpoch;
        MyAppState.currentUser = user;
        await FireStoreUtils.updateCurrentUser(user);
        await redirectEntryScreen(result, context, userCount);
      } else if (result != null && result is String) {
        await hideProgress();
        showAlertDialog(context, 'Failed', result);
      } else {
        await hideProgress();
        showAlertDialog(context, 'Failed', 'Couldn\'t sign up');
      }
    } else {
      await hideProgress();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Location is required to match you with people from '
            'your area.'),
        duration: Duration(seconds: 6),
      ));
    }
  }

  Future<void> redirectEntryScreen(
      User user, BuildContext context, String userCount) async {
    int messageCount = 0;
    int likeCount = 0;
    FireStoreUtils().getConversations(user.userID).forEach((element) {
      if (element.isNotEmpty) {
        messageCount = messageCount + 1;
      }
    });
    String predefineBoostCount = await FireStoreUtils.getBoostLikeCount();
    String predefineCount = await FireStoreUtils.getUltraLikeCount();
    SharedPreferences pref = await SharedPreferences.getInstance();
    FireStoreUtils().getOtherYouLikedObject(user.userID).then((value) async {
      List friendsList = [];
      value.forEach((element) {
        if (element.otherLike == false) {
          friendsList.add(element);
        }
      });
      likeCount = value.length;
      if (friendsList.length > (pref.getInt('oldNewLikesCount') ?? 0)) {
        newLikesCount = friendsList.length;
        await pref.setInt('oldNewLikesCount', newLikesCount);
      } else {
        newLikesCount = 0;
      }
    });
    FireStoreUtils().getConversations(user.userID).forEach((element) {
      if (element.isNotEmpty) {
        messageCount = messageCount + 1;
      }
    });
    await SwipeScreenState().getcurrentUser(context);
    await hideProgress();
    restartData();
    // if (int.parse(userCount) >= 5000) {
    pushAndRemoveUntil(
        context,
        AppEntryOffersScreen(
          user: user,
          likeCount: likeCount,
          messageCount: messageCount,
          predefineCount: int.parse(predefineCount),
          predefineBoostCount: int.parse(predefineBoostCount),
        ),
        false);
    // } else {
    //   pushAndRemoveUntil(
    //       context,
    //       FirstArtBoardScreen(
    //         userCount: userCount,
    //       ),
    //       false);
    // }
  }

  void restartData() {
    selection = 'She/her/hers';
    firstnameController = TextEditingController();
    TwoScreenOneSliderValue = 8;
    TwoScreenTwoSliderValue = 8;
    TwoScreenThreeSliderValue = 8;
    ThreeScreenOneSliderValue = 8;
    ThreeScreenTwoSliderValue = 8;
    ThreeScreenThreeSliderValue = 8;
    age = '';
    dateController = TextEditingController();
    religionController = TextEditingController();
    collegeController = TextEditingController();
    collegeMap = null;
    homwtownController = TextEditingController();
    homwtownMap;
    OneSliderValue = SfRangeValues(30.0, 50.0);
    answeredQuestionList = [];
    questionTextController = [
      <TextEditingController>[],
      <TextEditingController>[],
      <TextEditingController>[]
    ];
    FiveScreenCheckBoxOne = false;
    FiveScreenCheckBoxTwo = false;
    FiveScreenCheckBoxThree = false;
    FiveScreenCheckBoxFour = false;
    FiveScreenCheckBoxFive = false;
    FiveScreenCheckBoxSix = false;
    SixScreenSelectedIndex = -1;
    SixScreenSelection = null;

    SixScreenSelectedIndexOne = -1;

    SexualityMAp = {
      'Straight': false,
      'Gay': false,
      'Lesbian': false,
      'Bisexual': false,
      'Demisexual': false,
      'Pansexual': false,
      'Queer': false,
      'Questioning': false,
    };

    SevanScreenSelectedIndex = -1;
    SevanScreenSelection = null;

    SevanScreenSelectedIndexOne = -1;

    ethnicityListOne = {
      'American Indian': false,
      'Black/African Decent': false,
      'East Asian': false,
      'Hispanic Latino': false,
      'Middle Eastern': false,
      'Pacifica Islander': false,
      'South Asian': false,
      'White/Caucasian': false,
    };
    promptTextList = [];
    imageList = [];
  }
}
