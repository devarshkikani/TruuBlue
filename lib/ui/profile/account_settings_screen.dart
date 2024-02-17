import 'package:dating/constants.dart';
import 'package:dating/main.dart';
import 'package:dating/model/User.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/ui/profile/account_settings/delete_account/delete_account_screen.dart';
import 'package:dating/ui/profile/account_settings/edit_email/edit_email_screen.dart';
import 'package:dating/ui/profile/account_settings/edit_phone_number/edit_phone_screen.dart';
import 'package:dating/ui/profile/account_settings/pause_account/pause_account_screen.dart';
import 'package:dating/ui/profile/account_settings/push_notification/push_notification_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({Key? key}) : super(key: key);

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  User user = MyAppState.currentUser!;
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
          'Account Settings'.tr(),
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
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Phone'.tr(),
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Color(0xFF949494), fontSize: 14),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          user.phoneNumber
                              .replaceAll('+91', '')
                              .replaceAll('+1', ''),
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Color(0xFF949494), fontSize: 12),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditPhoneScreen(),
                          ),
                        ).then((value) {
                          user = MyAppState.currentUser!;
                          setState(() {});
                        });
                      },
                      child: Row(
                        children: [
                          Text(
                            'Edit',
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                color: Color(0xFF949494), fontSize: 14),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                            color: Color(0xFF949494),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                color: Color(0xFF7e7e7e),
                height: 0.3,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email'.tr(),
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Color(0xFF949494), fontSize: 14),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          user.email,
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Color(0xFF949494), fontSize: 12),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditEmailScreen(),
                            ),
                          ).then((value) {
                            user = MyAppState.currentUser!;
                            setState(() {});
                          });
                        },
                        child: Row(
                          children: [
                            Text(
                              'Edit',
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: Color(0xFF949494), fontSize: 14),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 15,
                              color: Color(0xFF949494),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                color: Color(0xFF7e7e7e),
                height: 0.3,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Push Notification'.tr(),
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Color(0xFF949494), fontSize: 14),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          "On",
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Color(0xFF949494), fontSize: 12),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PushNotificationScreen()),
                          ).then((value) {
                            user = MyAppState.currentUser!;
                            setState(() {});
                          });
                        },
                        child: Row(
                          children: [
                            Text(
                              'Edit',
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: Color(0xFF949494), fontSize: 14),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 15,
                              color: Color(0xFF949494),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                color: Color(0xFF7e7e7e),
                height: 0.3,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email Notification'.tr(),
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Color(0xFF949494), fontSize: 14),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          'On',
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Color(0xFF949494), fontSize: 12),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () {
                          push(context, PushNotificationScreen());
                        },
                        child: Row(
                          children: [
                            Text(
                              'Edit',
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: Color(0xFF949494), fontSize: 14),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 15,
                              color: Color(0xFF949494),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                color: Color(0xFF7e7e7e),
                height: 0.3,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Upgrade Account Features'.tr(),
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Color(0xFF949494), fontSize: 14),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          "Current Plan: FREE ACCOUNT",
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Color(0xFF949494), fontSize: 12),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Row(
                        children: [
                          Text(
                            'Upgrade',
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                color: Color(0xFF949494), fontSize: 14),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                            color: Color(0xFF949494),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                color: Color(0xFF7e7e7e),
                height: 0.3,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pause Account'.tr(),
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Color(0xFF949494), fontSize: 14),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          "Saves All Matches & Message",
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Color(0xFF949494), fontSize: 12),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () {
                          push(context, PauseAccountScreen());
                        },
                        child: Row(
                          children: [
                            Text(
                              'Edit',
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: Color(0xFF949494), fontSize: 14),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 15,
                              color: Color(0xFF949494),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                color: Color(0xFF7e7e7e),
                height: 0.3,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delete Account'.tr(),
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Color(0xFF949494), fontSize: 14),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          'Delete Account and All Data',
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Color(0xFF949494), fontSize: 12),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DeleteAccountScreen(),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Text(
                              'Edit',
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: Color(0xFF949494), fontSize: 14),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 15,
                              color: Color(0xFF949494),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                color: Color(0xFF7e7e7e),
                height: 0.3,
              ),
            ],
          )),
    );
  }
}
