import 'package:dating/common/buttons.dart';
import 'package:dating/common/colors.dart';
import 'package:dating/common/onboarding_app_bar.dart';
import 'package:dating/constants.dart';
import 'package:dating/help/responsive_ui.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/theme/textstyle.dart';
import 'package:dating/ui/onBoarding/OnBoardingOtpVerficationScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingCellNumberScreen extends StatefulWidget {
  const OnBoardingCellNumberScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingCellNumberScreenState createState() =>
      _OnBoardingCellNumberScreenState();
}

class _OnBoardingCellNumberScreenState extends State<OnBoardingCellNumberScreen>
    with TickerProviderStateMixin {
  GlobalKey<FormState> _key = GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  String? _phoneNumber;
  bool isPhoneValid = false;
  bool? isLoading, large, medium;
  double? _pixelRatio, bottom1;
  Size? size;
  final numberController = TextEditingController();
  PhoneNumber? phone;
  TextEditingController _phoneController = TextEditingController();
  final List<String> _allActivities = ['+1', '+91'];
  String _activity = '+1';
  late AnimationController animationController1;
  late AnimationController animationController2;
  bool userCanMove = false;
  @override
  void initState() {
    animationController1 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animationController2 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..forward();
    super.initState();
    if (numberController.text.length == 10) {
      print(numberController.text.length.toString());
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }

  @override
  void dispose() {
    animationController1.dispose();
    animationController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    var scrWidth = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    large = ResponsiveWidget.isScreenLarge(scrWidth, _pixelRatio!);
    medium = ResponsiveWidget.isScreenMedium(scrWidth, _pixelRatio!);
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
        userCanMove: userCanMove,
        nextOnTap: () async {
          int length = 0;
          if (_activity == '+1') {
            length = 14;
          } else {
            length = 11;
          }
          if (_phoneController.text.length == length) {
            _phoneNumber = _activity +
                _phoneController.text
                    .replaceAll('(', '')
                    .replaceAll(')', '')
                    .replaceAll('-', '')
                    .replaceAll(' ', '');
            phone = PhoneNumber(
              countryISOCode: _activity == '+1' ? 'US' : 'IND',
              countryCode: _activity,
              number: _phoneNumber!.replaceAll(_activity, ''),
            );
            if (phone != null) {
              if (phone!.number.length >= 10) {
                //await _submitPhoneNumber(_phoneNumber!);
                bool? user = await FireStoreUtils.getCellNumber(
                    (phone!.countryCode + phone!.number));
                if (user!) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          '''Cell number already exists.\nTry with different cell number.''')));
                } else {
                  setSetQuestionPreferences(
                      "cell_number", phone!.countryCode + phone!.number);
                  push(
                      context,
                      OnBoardingOtpVerficationScreen(
                          phone!.countryCode + phone!.number));
                  //  push(context, OnBoardingQuestionOneScreen());
                }
              } else
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Enter cell number ')));
            } else {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Enter cell number ')));
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Please enter valid cell number'),
              ),
            );
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
                    'Enter Your Cell Number',
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
                      "We will send you a registration code to verify your account",
                      textScaleFactor: 1.0,
                      style: regualrText20.copyWith(
                        color: Color(0xFF707070),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 32.0, right: 12, left: 12),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: primaryColor,
                          ),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: 12,
                              ),
                              child: DropdownButton(
                                value: _activity,
                                underline: SizedBox(),
                                focusColor: Colors.transparent,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _activity = newValue.toString();
                                    switch (newValue) {
                                      case '+1':
                                        break;
                                      case '+91':
                                        break;
                                    }
                                  });
                                },
                                items: _allActivities.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Container(
                                  width: 125,
                                  child: TextFormField(
                                    controller: _phoneController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      border: InputBorder.none,
                                      hintText: '000-000-0000',
                                      hintStyle: TextStyle(
                                        color: Colors.black.withOpacity(.3),
                                      ),
                                      errorStyle: TextStyle(
                                        color: Colors.red,
                                      ),
                                      counterText: '',
                                    ),
                                    maxLength: _activity == '+1' ? 14 : 11,
                                    onChanged: (value) {
                                      if (_activity == '+1') {
                                        if (value.length >= 14) {
                                          userCanMove = true;
                                          FocusScope.of(context).unfocus();
                                        } else {
                                          userCanMove = false;
                                        }
                                      } else {
                                        if (value.length >= 11) {
                                          userCanMove = true;
                                          FocusScope.of(context).unfocus();
                                        } else {
                                          userCanMove = false;
                                        }
                                      }
                                      setState(() {});
                                    },
                                    autofocus: true,
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: [
                                      PhoneInputFormatter(
                                        defaultCountryCode:
                                            _activity == '+1' ? 'US' : 'IN',
                                        allowEndlessPhone: true,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 150,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                nextButton(
                  isActive: true,
                  onTap: () async {
                    int length = 0;
                    if (_activity == '+1') {
                      length = 14;
                    } else {
                      length = 11;
                    }
                    if (_phoneController.text.length == length) {
                      _phoneNumber = _activity +
                          _phoneController.text
                              .replaceAll('(', '')
                              .replaceAll(')', '')
                              .replaceAll('-', '')
                              .replaceAll(' ', '');
                      phone = PhoneNumber(
                        countryISOCode: _activity == '+1' ? 'US' : 'IND',
                        countryCode: _activity,
                        number: _phoneNumber!.replaceAll(_activity, ''),
                      );
                      if (phone != null) {
                        if (phone!.number.length >= 10) {
                          //await _submitPhoneNumber(_phoneNumber!);
                          bool? user = await FireStoreUtils.getCellNumber(
                              (phone!.countryCode + phone!.number));
                          if (user!) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    '''Cell number already exists.\nTry with different cell number.''')));
                          } else {
                            setSetQuestionPreferences("cell_number",
                                phone!.countryCode + phone!.number);
                            push(
                                context,
                                OnBoardingOtpVerficationScreen(
                                    phone!.countryCode + phone!.number));
                            //  push(context, OnBoardingQuestionOneScreen());
                          }
                        } else
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Enter cell number ')));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Enter cell number ')));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please enter valid cell number'),
                        ),
                      );
                    }
                  },
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
            "Great news - no password required.",
            textScaleFactor: 1.0,
            style: TextStyle(
                color: Color(0xff525354),
                fontWeight: FontWeight.normal,
                fontSize: 15.0),
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
}
