import 'package:dating/constants.dart';
import 'package:dating/help/responsive_ui.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/ui/onBoarding/OnBoardingQuestionThirteenScreen.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingQuestionTwelveScreen extends StatefulWidget {
  const OnBoardingQuestionTwelveScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingQuestionTwelveScreenState createState() =>
      _OnBoardingQuestionTwelveScreenState();
}

class _OnBoardingQuestionTwelveScreenState
    extends State<OnBoardingQuestionTwelveScreen> {
  GlobalKey<FormState> _key = GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  String? _phoneNumber;
  bool _isPhoneValid = false;
  bool? _isLoading, _large, _medium;
  double? _pixelRatio, bottom1;
  Size? size;
  Position? signUpLocation;
  bool location = false;

  @override
  void initState() {
    super.initState();
    getlocation().then((value) {
      if (value != null || signUpLocation != null) {
        location = true;
      }
    });
  }

  Future<Position?> getlocation() async {
    Future.delayed(const Duration(milliseconds: 500), () async {
      signUpLocation = await getCurrentLocation();

      setState(() {
        if (signUpLocation != null) {
          location = true;
        }
      });
    });
    return signUpLocation;
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    var scrWidth = MediaQuery.of(context).size.width;
    var scrHeight = MediaQuery.of(context).size.height;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(scrWidth, _pixelRatio!);
    _medium = ResponsiveWidget.isScreenMedium(scrWidth, _pixelRatio!);
    return Scaffold(
      backgroundColor: Color(COLOR_PRIMARY),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 40.0, right: 40, bottom: 16),
          child: Form(
            key: _key,
            autovalidateMode: _validate,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Image.asset(
                    'assets/images/truubluenew.png',
                    width: 100.0,
                    height: 50.0,
                  ),
                ),
                Align(
                    alignment: Directionality.of(context) == TextDirection.ltr
                        ? Alignment.topLeft
                        : Alignment.topLeft,
                    child: Text(
                      'Where are you?'.tr(),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: _large! ? 30 : (_medium! ? 25 : 20),
                      ),
                      textAlign: TextAlign.start,
                    )),

                /// user profile picture,  this is visible until we verify the
                /// code in case of sign up with phone number
                Padding(
                  padding: const EdgeInsets.only(
                      left: 0, top: 10, right: 0, bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        textScaleFactor: MediaQuery.of(context).textScaleFactor,
                        text: new TextSpan(
                          // Note: Styles for TextSpans must be explicitly defined.
                          // Child text spans will inherit styles from parent
                          style: new TextStyle(
                            fontSize: 15.0,
                            color: Color(0xFF707070),
                          ),
                          children: <TextSpan>[
                            TextSpan(text: 'You '.tr()),
                            TextSpan(
                                text: 'must'.tr(),
                                style: new TextStyle(
                                  decoration: TextDecoration.underline,
                                )),
                            TextSpan(
                                text:
                                    ' enable location service in order to use TruuBlue'
                                        .tr()),
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
                              color: location
                                  ? Colors.orange.shade50
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                  color: location
                                      ? Colors.orange.shade50
                                      : Colors.grey.shade200)),
                          child: TextFormField(
                            readOnly: true,
                            textAlignVertical: TextAlignVertical.center,
                            textInputAction: TextInputAction.next,
                            style: TextStyle(fontSize: 18.0),
                            enabled: false,
                            onTap: () async {
                              signUpLocation = await getCurrentLocation();
                              if (signUpLocation != null) {
                                location = true;
                              }
                            },
                            onSaved: (val) => _phoneNumber = val,
                            keyboardType: TextInputType.text,
                            cursorColor: Color(COLOR_PRIMARY),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  left: 16, right: 16, bottom: 12),
                              hintText: location
                                  ? 'Location is enabled'.tr()
                                  : 'Allow Location'.tr(),
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
                ),

                SizedBox(
                  height: 20,
                ),
                Text('Tell me more ...'.tr(),
                    style: TextStyle(
                        decoration: TextDecoration.underline, fontSize: 12))
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(40, 0, 40, 50),
        child: Text(
          "You must turn on Location services to use\nTruuBlue. Your location will never be shared."
              .tr(),
          style: TextStyle(
              color: Color(0xff525354),
              fontWeight: FontWeight.normal,
              fontSize: 15.0),
          textAlign: TextAlign.center,
        ),
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    textColor: Colors.green,
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          size: 30,
                          color: Colors.green,
                        ),
                        Text(
                          "Back",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(10),
                    shape: CircleBorder(),
                  ),
                  MaterialButton(
                    onPressed: () async {
                      signUpLocation = await getCurrentLocation();
                      if (signUpLocation != null) {
                        setSetQuestionPreferences("latitude",
                            signUpLocation?.latitude.toString() ?? "");
                        setSetQuestionPreferences("longitude",
                            signUpLocation?.longitude.toString() ?? "");
                        push(context, OnBoardingQuestionThirteenScreen());
                      } else {
                        await hideProgress();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Location is required to match you with people from '
                                      'your area.'
                                  .tr()),
                          duration: Duration(seconds: 6),
                        ));
                      }
                    },
                    textColor: Colors.green,
                    child: Row(
                      children: [
                        Text(
                          "Next",
                          style: TextStyle(fontSize: 20),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 30,
                          color: Colors.green,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(10),
                    shape: CircleBorder(),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> setSetQuestionPreferences(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }
}
