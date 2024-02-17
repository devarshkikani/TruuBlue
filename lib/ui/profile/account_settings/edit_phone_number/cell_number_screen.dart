import 'dart:async';

import 'package:dating/constants.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/ui/profile/account_settings/edit_phone_number/otp_verification_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class EditCellNumberScreen extends StatefulWidget {
  const EditCellNumberScreen({Key? key}) : super(key: key);

  @override
  State<EditCellNumberScreen> createState() => _EditCellNumberScreenState();
}

class _EditCellNumberScreenState extends State<EditCellNumberScreen> {
  PhoneNumber? phone;
  String? _phoneNumber, _verificationID;

  TextEditingController _phoneController = TextEditingController();
  final List<String> _allActivities = ['+1', '+91'];
  String _activity = '+1';

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
          'Enter Your Cell Number'.tr(),
          textScaleFactor: 1.0,
          style: TextStyle(
            color: Color(0xff000000),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 32.0, right: 8.0, left: 8.0),
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                    right: 8.0,
                  ),
                  child: Container(
                    color: Colors.white,
                    child: TextFormField(
                      controller: _phoneController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        prefixIcon: Padding(
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
                        border: OutlineInputBorder(),
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
                            FocusScope.of(context).unfocus();
                          }
                        } else {
                          if (value.length >= 11) {
                            FocusScope.of(context).unfocus();
                          }
                        }
                      },
                      autofocus: true,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        PhoneInputFormatter(
                          defaultCountryCode: _activity == '+1' ? 'US' : 'IN',
                          allowEndlessPhone: true,
                        )
                      ],
                    ),
                  ),
                ),
                //   child: IntlPhoneField(
                //     decoration: InputDecoration(
                //       labelText: 'Cell Number'.tr(),
                //       border: OutlineInputBorder(
                //         borderSide: BorderSide(),
                //       ),
                //     ),
                //     initialCountryCode: 'US',
                //     onChanged: (pho) {
                //       if (pho.number.length == 10) {
                //         FocusScope.of(context).requestFocus(FocusNode());
                //       }
                //       phone = pho;
                //     },
                //   ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MaterialButton(
                  onPressed: () async {
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
                          bool? user = await FireStoreUtils.getCellNumber(
                              (phone!.countryCode + phone!.number));
                          if (user!) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    '''Cell number already exist.\nTry with different cell number.'''
                                        .tr())));
                          } else {
                            await _submitPhoneNumber(
                                phone!.countryCode + phone!.number);
                            startTimer();
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Enter cell number '.tr())));
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Enter cell number '.tr())));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please enter valid cell number'),
                        ),
                      );
                    }
                  },
                  textColor: Colors.green,
                  child: Row(
                    children: [
                      Text(
                        "Submit",
                        style:
                            TextStyle(fontSize: 20, color: Color(0xFF0573ac)),
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
      ),
    );
  }

  var resendFlag = false;
  var timerFlag = true;
  late Timer _timer;
  int _start = 60;
  String seconds = "seconds";

  bool _codeSent = false;

  void startTimer() {
    try {
      const oneSec = const Duration(seconds: 1);
      _timer = Timer.periodic(
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

  _submitPhoneNumber(String phoneNumber) async {
    //send code
    await showProgress(context, 'Sending code...'.tr(), true);
    await FireStoreUtils.firebaseSubmitPhoneNumber(
      phoneNumber,
      (String verificationId) {
        if (mounted) {
          hideProgress();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Code verification timeout, request new code.'.tr(),
              ),
            ),
          );
          setState(() {
            _codeSent = false;
          });
        }
      },
      (String? verificationId, int? forceResendingToken) {
        if (mounted) {
          hideProgress();
          _verificationID = verificationId;
          push(
              context,
              OtpVerificationScreen(
                verificationID: _verificationID,
              ));
          setState(() {
            _codeSent = true;
          });
        }
      },
      (FirebaseAuthException error) {
        if (mounted) {
          hideProgress();
          print('${error.message} ${error.stackTrace}');
          String message = 'An error has occurred. Please try again.'.tr();
          switch (error.code) {
            case 'invalid-verification-code':
              message = 'Invalid code or has been expired.'.tr();
              break;
            case 'user-disabled':
              message = 'This user has been disabled.'.tr();
              break;
            default:
              message = 'An error has occurred. Please try again.'.tr();
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
      (PhoneAuthCredential credential) async {},
    );
  }
}
