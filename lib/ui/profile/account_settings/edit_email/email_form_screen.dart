import 'dart:convert';
import 'dart:math';

import 'package:dating/constants.dart';
import 'package:dating/main.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/ui/profile/account_settings/edit_email/email_otp_verification_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class EmailFormScreen extends StatefulWidget {
  const EmailFormScreen({Key? key}) : super(key: key);

  @override
  State<EmailFormScreen> createState() => _EmailFormScreenState();
}

class _EmailFormScreenState extends State<EmailFormScreen> {
  final emailController = TextEditingController();
  int? emailOTP;

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
          'Enter Your Email Addres'.tr(),
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
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32.0, right: 24.0, left: 24.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  shape: BoxShape.rectangle,
                  border: Border.all(color: Colors.grey.shade200)),
              child: TextFormField(
                controller: emailController,
                textAlignVertical: TextAlignVertical.center,
                textInputAction: TextInputAction.next,
                style: TextStyle(fontSize: 18.0),
                keyboardType: TextInputType.emailAddress,
                cursorColor: Color(COLOR_PRIMARY),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 16, right: 16),
                  hintText: 'name@abc.com'.tr(),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                          BorderSide(color: Color(COLOR_PRIMARY), width: 2.0)),
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
                  String pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regex = RegExp(pattern);
                  if (!regex.hasMatch(emailController.text)) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Enter valid email.'.tr()),
                      duration: Duration(seconds: 6),
                    ));
                  } else {
                    bool? user =
                        await FireStoreUtils.getEmail(emailController.text);
                    if (user!) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Email address already exist try with different email address.'
                                  .tr())));
                    } else {
                      var rnd = Random();
                      var next = rnd.nextDouble() * 1000000;
                      while (next < 100000) {
                        next *= 10;
                      }
                      emailOTP = (next.toInt());
                      await sendEmail("OTP :" + (next.toInt()).toString());
                      push(
                          context,
                          EmailOTPVarificationScreen(
                            email: emailController.text,
                            emailOTP: emailOTP.toString(),
                          ));
                    }
                  }
                },
                textColor: Colors.green,
                child: Row(
                  children: [
                    Text(
                      "Send OTP",
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

  Future sendEmail(String message) async {
    String email = emailController.text;
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    const serviceId = EMAILJSSERVICEID;
    const templateId = EMAILJSTEMPLATE;
    const userId = EMAILJSUSERID;
    final response = await http.post(url,
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'application/json'
        },
        //This line makes sure it works for all platforms.
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'to_name': MyAppState.currentUser!.firstName,
            'to_email': email,
            'message': message
          }
        }));
    return response.statusCode;
  }
}
