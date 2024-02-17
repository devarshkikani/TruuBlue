// ignore_for_file: must_be_immutable

import 'package:dating/common/colors.dart';
import 'package:dating/constants.dart';
import 'package:dating/main.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/theme/textstyle.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:dating/model/User.dart' as us;

class OtpVerificationScreen extends StatefulWidget {
  OtpVerificationScreen({Key? key, required this.verificationID})
      : super(key: key);
  String? verificationID;
  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final numberController = TextEditingController();
  PhoneNumber? phone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color:
                isDarkMode(context) ? Colors.white : Color(COLOR_BLUE_BUTTON),
          ),
        ),
        title: Text(
          'Enter OTP'.tr(),
          textScaleFactor: 1.0,
          style: TextStyle(
            color: Color(0xff000000),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 32.0, right: 24.0, left: 24.0),
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
                //   onSaved: (val) => _phoneNumber = val,
                keyboardType: TextInputType.phone,
                cursorColor: Colors.grey.shade500,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 16, right: 16),
                  hintText: '------'.tr(),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                          BorderSide(color: Colors.grey.shade500, width: 2.0)),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).errorColor),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).errorColor),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MaterialButton(
                onPressed: () async {
                  if (numberController.text.length < 6) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Enter Code.'.tr()),
                      duration: Duration(seconds: 6),
                    ));
                  } else {
                    _submitOTP(numberController.text);
                  }
                },
                textColor: Colors.green,
                child: Row(
                  children: [
                    Text(
                      "Verify",
                      style: TextStyle(fontSize: 20, color: Color(0xFF0573ac)),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 30,
                      color: Color(0xFF0573ac),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(10),
                shape: CircleBorder(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _submitOTP(String smsCodes) {
    /// get the `smsCode` from the user

    /// when used different phoneNumber other than the current (running) device
    /// we need to use OTP to get `phoneAuthCredential` which is inturn used to signIn/login
    AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationID!, smsCode: smsCodes);

    _login(credential);
  }

  Future<void> _login(AuthCredential credential) async {
    /// This method is used to login the user
    /// `AuthCredential`(`_phoneAuthCredential`) is needed for the signIn method
    /// After the signIn method from `AuthResult` we can get `FirebaserUser`(`_firebaseUser`)
    try {
      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((authRes) async {
        // push(context, OnBoardingQuestionOneScreen());
        showProgress(context, 'Saving changes...'.tr(), true);
        MyAppState.currentUser!.phoneNumber =
            phone!.countryCode + phone!.number;
        us.User? updateUser =
            await FireStoreUtils.updateCurrentUser(MyAppState.currentUser!);
        hideProgress();
        if (updateUser != null) {
          MyAppState.currentUser = updateUser;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 3),
              content: Text(
                'Cell Number Updated Successfully.'.tr(),
                style: TextStyle(fontSize: 17),
              ),
            ),
          );
          setState(() {});
          Navigator.pop(context);
          Navigator.pop(context);
        }
      }).catchError((e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: RichText(
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyText1,
              children: [
                TextSpan(
                  text: 'Invalid verification code. Tap ',
                  style: regualrText14.copyWith(
                    color: whiteColor,
                  ),
                ),
                TextSpan(
                  text: 'Click here',
                  style: regualrText14.copyWith(
                    color: primaryColor,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      Navigator.pop(context);
                    },
                ),
                TextSpan(
                  text: ' above to verify your cell number.',
                  style: regualrText14.copyWith(
                    color: whiteColor,
                  ),
                ),
              ],
            ),
          ),
          duration: Duration(seconds: 6),
        ));
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: RichText(
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyText1,
            children: [
              TextSpan(
                text: 'Invalid verification code. Tap ',
                style: regualrText14.copyWith(
                  color: whiteColor,
                ),
              ),
              TextSpan(
                text: 'Click here',
                style: regualrText14.copyWith(
                  color: primaryColor,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    Navigator.pop(context);
                  },
              ),
              TextSpan(
                text: ' above to verify your cell number.',
                style: regualrText14.copyWith(
                  color: whiteColor,
                ),
              ),
            ],
          ),
        ),
        duration: Duration(seconds: 6),
      ));
    }
  }
}
