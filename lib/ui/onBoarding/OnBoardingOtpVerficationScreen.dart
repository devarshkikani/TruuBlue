// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:dating/common/buttons.dart';
import 'package:dating/common/colors.dart';
import 'package:dating/common/common_widget.dart';
import 'package:dating/common/onboarding_app_bar.dart';
import 'package:dating/constants.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/theme/textstyle.dart';
import 'package:dating/ui/onBoarding/OnBoardingQuestionsOneScreen.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
// import 'package:otp_text_field/otp_text_field.dart';
// import 'package:otp_text_field/style.dart';

late UserCredential credential;

class OnBoardingOtpVerficationScreen extends StatefulWidget {
  String? cellNumber;
  OnBoardingOtpVerficationScreen(this.cellNumber);

  @override
  _OnBoardingOtpVerficationScreenState createState() =>
      _OnBoardingOtpVerficationScreenState();
}

class _OnBoardingOtpVerficationScreenState
    extends State<OnBoardingOtpVerficationScreen>
    with TickerProviderStateMixin {
  GlobalKey<FormState> _key = GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  String? phoneNumber, _verificationID;
  bool isPhoneValid = false;
  double? pixelRatio, bottom1;
  bool codeSent = false;
  Size? size;
  Position? signUpLocation;
  RxString otpValue = ''.obs;
  // OtpFieldController otpController = OtpFieldController();
  bool isLoading = false;

  String? verificationId;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late AuthCredential phoneAuthCredential;
  var resendFlag = false;
  var timerFlag = true;
  late Timer timer;
  int _start = 50;
  String seconds = "seconds";
  late AnimationController animationController1;
  late AnimationController animationController2;

  @override
  initState() {
    animationController1 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animationController2 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..forward();
    super.initState();
    //phoneSignIn(phoneNumber: widget.cellNumber!);
    _submitPhoneNumber(widget.cellNumber!);
    startTimer();
  }

  void startTimer() {
    try {
      const oneSec = const Duration(seconds: 1);
      timer = new Timer.periodic(
        oneSec,
        (Timer timer) {
          if (_start == 0) {
            setState(() {
              timer.cancel();
              seconds = "second";
              resendFlag = true;
              timerFlag = false;
            });
          } else {
            if (mounted)
              setState(() {
                _start--;
              });
          }
        },
      );
    } catch (e) {
      print(e);
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
    pixelRatio = MediaQuery.of(context).devicePixelRatio;
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
          userCanMove: otpValue.value.length >= 6,
          nextOnTap: () {
            if (otpValue.value.length < 6) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Enter Code.'),
                duration: Duration(seconds: 6),
              ));
            } else {
              _submitOTP(otpValue.value);
            }
          },
          animationController1: animationController1,
          animationController2: animationController2),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 30.0, right: 30, bottom: 16),
          child: Form(
            key: _key,
            autovalidateMode: _validate,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Enter the verification code sent to your phone number',
                  style: mediumText22.copyWith(
                    color: Color(0xFF0573ac),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 60,
                    ),
                    // OTPTextField(
                    //   controller: otpController,
                    //   length: 6,
                    //   width: MediaQuery.of(context).size.width,
                    //   textFieldAlignment: MainAxisAlignment.spaceAround,
                    //   fieldWidth: 45,
                    //   fieldStyle: FieldStyle.box,
                    //   outlineBorderRadius: 15,
                    //   style: regualrText18,
                    //   otpFieldStyle: OtpFieldStyle(
                    //     borderColor: Color(0xFF0573ac),
                    //     enabledBorderColor: blackColor,
                    //     focusBorderColor: Color(0xFF0573ac).withOpacity(0.8),
                    //   ),
                    //   onChanged: (String value) {
                    //     otpValue.value = value;
                    //     if (otpValue.value.length == 6) {
                    //       FocusScope.of(context).requestFocus(FocusNode());
                    //     }
                    //   },
                    //   onCompleted: (String pin) async {
                    // otpValue.value = pin;
                    // if (otpValue.value.length == 6) {
                    //   FocusScope.of(context).requestFocus(FocusNode());
                    // }
                    //   },
                    // ),
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Container(
                                width: 70,
                                child: TextFormField(
                                  style: TextStyle(fontSize: 18.0),
                                  onChanged: (c) {
                                    otpValue.value = c;
                                    if (c.length == 6) {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                    }
                                    setState(() {});
                                  },
                                  onSaved: (val) => phoneNumber = val,
                                  keyboardType: TextInputType.phone,
                                  cursorColor: Colors.black,
                                  decoration: InputDecoration(
                                    // contentPadding:
                                    //     EdgeInsets.only(left: 16, right: 16),
                                    hintText: '- - - - - ',
                                    hintStyle: TextStyle(fontSize: 18.0),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(
                    //       top: 32.0, right: 12.0, left: 12.0),
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //         color: Colors.white,
                    //         borderRadius: BorderRadius.circular(10),
                    //         shape: BoxShape.rectangle,
                    //         border: Border.all(color: Colors.grey.shade200)),
                    //     child: TextFormField(
                    //       textAlignVertical: TextAlignVertical.center,
                    //       textInputAction: TextInputAction.next,
                    //       style: TextStyle(fontSize: 18.0),
                    //       onChanged: (c) {
                    //         otpValue.value = c;
                    //         if (c.length == 6) {
                    //           FocusScope.of(context).requestFocus(FocusNode());
                    //         }
                    //         setState(() {});
                    //       },
                    //       onSaved: (val) => phoneNumber = val,
                    //       keyboardType: TextInputType.phone,
                    //       cursorColor: Colors.black,
                    //       textAlign: TextAlign.center,
                    //       decoration: InputDecoration(
                    //         contentPadding:
                    //             EdgeInsets.only(left: 16, right: 16),
                    //         hintText: '------',
                    //         focusedBorder: OutlineInputBorder(
                    //             borderRadius: BorderRadius.circular(10.0),
                    //             borderSide: BorderSide(
                    //                 color: Colors.grey.shade500, width: 2.0)),
                    //         errorBorder: OutlineInputBorder(
                    //           borderSide: BorderSide(
                    //               color: Theme.of(context).errorColor),
                    //           borderRadius: BorderRadius.circular(10.0),
                    //         ),
                    //         focusedErrorBorder: OutlineInputBorder(
                    //           borderSide: BorderSide(
                    //               color: Theme.of(context).errorColor),
                    //           borderRadius: BorderRadius.circular(10.0),
                    //         ),
                    //         enabledBorder: OutlineInputBorder(
                    //           borderSide:
                    //               BorderSide(color: Colors.grey.shade500),
                    //           borderRadius: BorderRadius.circular(10.0),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: RichText(
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    textAlign: TextAlign.center,
                    text: new TextSpan(
                      style: mediumText14.copyWith(
                        color: greyColor,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text:
                                "Didn't receive a verification code via text message? "),
                        TextSpan(
                          text: 'Click here',
                          style: new TextStyle(
                            decoration: TextDecoration.underline,
                            color: Color(COLOR_BLUE_BUTTON),
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pop(context);
                            },
                        ),
                        TextSpan(
                            text:
                                ' to verify your cell number is entered correctly.'),
                      ],
                    ),
                  ),
                ),
                sizedBox30,
                nextButton(
                  isActive: otpValue.value.length >= 6,
                  onTap: () {
                    if (otpValue.value.length < 6) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Enter Code.'),
                        duration: Duration(seconds: 6),
                      ));
                    } else {
                      _submitOTP(otpValue.value);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitOTP(String smsCodes) {
    AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationID!, smsCode: smsCodes);
    _login(credential);
  }

  Future<void> _login(AuthCredential cred) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(cred).then((authRes) {
        setState(() {
          credential = authRes;
        });
        push(context, OnBoardingQuestionOneScreen());
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

  _submitPhoneNumber(String phoneNumber) async {
    await showProgress(context, 'Sending code...', true);
    await FireStoreUtils.firebaseSubmitPhoneNumber(
      phoneNumber,
      (String verificationId) {
        if (mounted) {
          hideProgress();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Code verification timeout, request new code.',
              ),
            ),
          );
          setState(() {
            codeSent = false;
          });
        }
      },
      (String? verificationId, int? forceResendingToken) {
        if (mounted) {
          hideProgress();
          _verificationID = verificationId;
          setState(() {
            codeSent = true;
          });
        }
      },
      (auth.FirebaseAuthException error) {
        if (mounted) {
          hideProgress();
          print('${error.message} ${error.stackTrace}');
          String message = 'An error has occurred. Please try again.';
          switch (error.code) {
            case 'invalid-verification-code':
              message = 'Invalid code or has been expired.';
              break;
            case 'user-disabled':
              message = 'This user has been disabled.';
              break;
            default:
              message = 'An error has occurred. Please try again.';
              break;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                message,
              ),
            ),
          );
        }
      },
      (auth.PhoneAuthCredential credential) async {
        if (mounted) {}
      },
    );
  }

  Future<void> phoneSignIn({required String phoneNumber}) async {
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: _onVerificationCompleted,
        verificationFailed: _onVerificationFailed,
        codeSent: _onCodeSent,
        codeAutoRetrievalTimeout: _onCodeTimeout);
  }

  _onVerificationCompleted(PhoneAuthCredential authCredential) async {
    print("verification completed ${authCredential.smsCode}");
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      this.otpValue.value = authCredential.smsCode!;
    });
    if (authCredential.smsCode != null) {
      try {
        await user!.linkWithCredential(authCredential);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'provider-already-linked') {
          await _auth.signInWithCredential(authCredential);
        }
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  _onVerificationFailed(FirebaseAuthException exception) {
    if (exception.code == 'invalid-phone-number') {
      showMessage("The phone number entered is invalid!");
    }
  }

  _onCodeSent(String verificationId, int? forceResendingToken) {
    this.verificationId = verificationId;
    print(forceResendingToken);
    print("code sent");
  }

  _onCodeTimeout(String timeout) {
    return null;
  }

  void showMessage(String errorMessage) {
    showDialog(
        context: context,
        builder: (BuildContext builderContext) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(errorMessage),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () async {
                  Navigator.of(builderContext).pop();
                },
              )
            ],
          );
        }).then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }
}
