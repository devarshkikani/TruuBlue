import 'package:dating/constants.dart';
import 'package:dating/main.dart';
import 'package:dating/model/User.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:dating/model/User.dart' as us;

class EmailOTPVarificationScreen extends StatefulWidget {
  const EmailOTPVarificationScreen({
    Key? key,
    required this.emailOTP,
    required this.email,
  }) : super(key: key);
  final String emailOTP;
  final String email;
  @override
  State<EmailOTPVarificationScreen> createState() =>
      _EmailOTPVarificationScreenState();
}

class _EmailOTPVarificationScreenState
    extends State<EmailOTPVarificationScreen> {
  final numberController = TextEditingController();
  User? user;

  @override
  void initState() {
    super.initState();
    user = MyAppState.currentUser;
  }

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
          'Enter Email OTP'.tr(),
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
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 32.0, right: 24.0, left: 24.0),
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
                        borderSide: BorderSide(
                            color: Colors.grey.shade500, width: 2.0)),
                    errorBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).errorColor),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).errorColor),
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
                    if (widget.emailOTP.toString() ==
                        numberController.text.toString()) {
                      showProgress(context, 'Saving changes...'.tr(), true);
                      user!.email = widget.email;
                      us.User? updateUser =
                          await FireStoreUtils.updateCurrentUser(user!);
                      hideProgress();
                      if (updateUser != null) {
                        this.user = updateUser;
                        MyAppState.currentUser = user;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: Duration(seconds: 3),
                            content: Text(
                              'Email Updated Successfully.'.tr(),
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                        );
                        setState(() {});
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Enter valid OTP.'.tr()),
                        duration: Duration(seconds: 6),
                      ));
                    }
                  },
                  textColor: Colors.green,
                  child: Row(
                    children: [
                      Text(
                        "Verify",
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
}
