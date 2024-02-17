import 'package:dating/constants.dart';
import 'package:dating/main.dart';
import 'package:dating/model/User.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PushNotificationScreen extends StatefulWidget {
  const PushNotificationScreen({Key? key}) : super(key: key);

  @override
  State<PushNotificationScreen> createState() => _PushNotificationScreenState();
}

class _PushNotificationScreenState extends State<PushNotificationScreen> {
  GlobalKey<_PushNotificationScreenState> _myKey = GlobalKey();
  bool notificationNewLkeFlag = false;
  bool newLike = false;
  bool notificationNewMatchFlag = false;
  bool newMatch = false;
  bool notificationNewMessageFlag = false;
  bool newMessage = false;
  bool notificationNewFeaturesFlag = false;
  bool newFeatures = false;
  bool notificationOffersNewsFlag = false;
  bool newOffersNews = false;
  User user = MyAppState.currentUser!;

  @override
  void initState() {
    super.initState();
    newLike = user.settings.pushSuperLikesEnabled;
    newMatch = user.settings.pushNewMatchesEnabled;
    newMessage = user.settings.pushNewMessages;
    newFeatures = user.settings.pushFeaturesUpdatesEnabled;
    newOffersNews = user.settings.pushOffersNewsEnabled;
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
          'Push Notification'.tr(),
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
        key: _myKey,
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              "Push Notifications MUST be turned on to effectively use TruuBlue.",
              textScaleFactor: 1.0,
              style: TextStyle(color: Colors.red, fontSize: 12),
              textAlign: TextAlign.start,
            ),
            Text(
              "Setting Push Notification Services Off will severely limit results.",
              textScaleFactor: 1.0,
              style: TextStyle(color: Color(0xFF949494), fontSize: 12),
              textAlign: TextAlign.start,
            ),
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
                        'New Likes'.tr(),
                        textScaleFactor: 1.0,
                        style:
                            TextStyle(color: Color(0xFF949494), fontSize: 14),
                        textAlign: TextAlign.start,
                      ),
                      notificationNewLkeFlag
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 200,
                                  child: SwitchListTile.adaptive(
                                      activeColor: Color(COLOR_ACCENT),
                                      value: newLike,
                                      onChanged: (bool newValue) {
                                        newLike = newValue;
                                        setState(() {});
                                      }),
                                ),
                                InkWell(
                                  onTap: () async {
                                    showProgress(context,
                                        'Saving changes...'.tr(), true);
                                    user.settings.pushSuperLikesEnabled =
                                        newLike;
                                    User? updateUser =
                                        await FireStoreUtils.updateCurrentUser(
                                            user);
                                    hideProgress();
                                    if (updateUser != null) {
                                      this.user = updateUser;
                                      MyAppState.currentUser = user;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          duration: Duration(seconds: 3),
                                          content: Text(
                                            'Settings saved successfully'.tr(),
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                      setState(() {
                                        notificationNewLkeFlag = false;
                                      });
                                    }
                                  },
                                  child: Text(
                                    'Save',
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                        color: Color(0xFF949494),
                                        decoration: TextDecoration.underline,
                                        fontSize: 14),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              user.settings.pushSuperLikesEnabled
                                  ? "ON"
                                  : "OFF",
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: Color(0xFF949494), fontSize: 12),
                              textAlign: TextAlign.start,
                            ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (notificationNewLkeFlag) {
                          notificationNewLkeFlag = false;
                        } else {
                          notificationNewLkeFlag = true;
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          'Toggle ON/OFF',
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Color(0xFF949494), fontSize: 14),
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
                        'New Matches'.tr(),
                        textScaleFactor: 1.0,
                        style:
                            TextStyle(color: Color(0xFF949494), fontSize: 14),
                        textAlign: TextAlign.start,
                      ),
                      notificationNewMatchFlag
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 200,
                                  child: SwitchListTile.adaptive(
                                      activeColor: Color(COLOR_ACCENT),
                                      value: newMatch,
                                      onChanged: (bool newValue) {
                                        newMatch = newValue;
                                        setState(() {});
                                      }),
                                ),
                                InkWell(
                                  onTap: () async {
                                    showProgress(context,
                                        'Saving changes...'.tr(), true);
                                    user.settings.pushNewMatchesEnabled =
                                        newMatch;
                                    User? updateUser =
                                        await FireStoreUtils.updateCurrentUser(
                                            user);
                                    hideProgress();
                                    if (updateUser != null) {
                                      this.user = updateUser;
                                      MyAppState.currentUser = user;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          duration: Duration(seconds: 3),
                                          content: Text(
                                            'Settings saved successfully'.tr(),
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                      setState(() {
                                        notificationNewMatchFlag = false;
                                      });
                                    }
                                  },
                                  child: Text(
                                    'Save',
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                        color: Color(0xFF949494),
                                        decoration: TextDecoration.underline,
                                        fontSize: 14),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              user.settings.pushNewMatchesEnabled
                                  ? "ON"
                                  : "OFF",
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: Color(0xFF949494), fontSize: 12),
                              textAlign: TextAlign.start,
                            ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (notificationNewMatchFlag) {
                          notificationNewMatchFlag = false;
                        } else {
                          notificationNewMatchFlag = true;
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          'Toggle ON/OFF',
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Color(0xFF949494), fontSize: 14),
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
                        'New Messages'.tr(),
                        textScaleFactor: 1.0,
                        style:
                            TextStyle(color: Color(0xFF949494), fontSize: 14),
                        textAlign: TextAlign.start,
                      ),
                      notificationNewMessageFlag
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 200,
                                  child: SwitchListTile.adaptive(
                                      activeColor: Color(COLOR_ACCENT),
                                      value: newMessage,
                                      onChanged: (bool newValue) {
                                        newMessage = newValue;
                                        setState(() {});
                                      }),
                                ),
                                InkWell(
                                  onTap: () async {
                                    showProgress(context,
                                        'Saving changes...'.tr(), true);
                                    user.settings.pushNewMessages = newMessage;
                                    User? updateUser =
                                        await FireStoreUtils.updateCurrentUser(
                                            user);
                                    hideProgress();
                                    if (updateUser != null) {
                                      this.user = updateUser;
                                      MyAppState.currentUser = user;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          duration: Duration(seconds: 3),
                                          content: Text(
                                            'Settings saved successfully'.tr(),
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                      setState(() {
                                        notificationNewMessageFlag = false;
                                      });
                                    }
                                  },
                                  child: Text(
                                    'Save',
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                        color: Color(0xFF949494),
                                        decoration: TextDecoration.underline,
                                        fontSize: 14),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              user.settings.pushNewMessages ? "ON" : "OFF",
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: Color(0xFF949494), fontSize: 12),
                              textAlign: TextAlign.start,
                            ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (notificationNewMessageFlag) {
                          notificationNewMessageFlag = false;
                        } else {
                          notificationNewMessageFlag = true;
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          'Toggle ON/OFF',
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Color(0xFF949494), fontSize: 14),
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
                        'New Features & Updates'.tr(),
                        textScaleFactor: 1.0,
                        style:
                            TextStyle(color: Color(0xFF949494), fontSize: 14),
                        textAlign: TextAlign.start,
                      ),
                      notificationNewFeaturesFlag
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 200,
                                  child: SwitchListTile.adaptive(
                                      activeColor: Color(COLOR_ACCENT),
                                      value: newFeatures,
                                      onChanged: (bool newValue) {
                                        newFeatures = newValue;
                                        setState(() {});
                                      }),
                                ),
                                InkWell(
                                  onTap: () async {
                                    showProgress(context,
                                        'Saving changes...'.tr(), true);
                                    user.settings.pushFeaturesUpdatesEnabled =
                                        newFeatures;
                                    User? updateUser =
                                        await FireStoreUtils.updateCurrentUser(
                                            user);
                                    hideProgress();
                                    if (updateUser != null) {
                                      this.user = updateUser;
                                      MyAppState.currentUser = user;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          duration: Duration(seconds: 3),
                                          content: Text(
                                            'Settings saved successfully'.tr(),
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                      setState(() {
                                        notificationNewFeaturesFlag = false;
                                      });
                                    }
                                  },
                                  child: Text(
                                    'Save',
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                        color: Color(0xFF949494),
                                        decoration: TextDecoration.underline,
                                        fontSize: 14),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              user.settings.pushFeaturesUpdatesEnabled
                                  ? "ON"
                                  : "OFF",
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: Color(0xFF949494), fontSize: 12),
                              textAlign: TextAlign.start,
                            ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (notificationNewFeaturesFlag) {
                          notificationNewFeaturesFlag = false;
                        } else {
                          notificationNewFeaturesFlag = true;
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          'Toggle ON/OFF',
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Color(0xFF949494), fontSize: 14),
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
                        'Exclusive offers & News'.tr(),
                        textScaleFactor: 1.0,
                        style:
                            TextStyle(color: Color(0xFF949494), fontSize: 14),
                        textAlign: TextAlign.start,
                      ),
                      notificationOffersNewsFlag
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 200,
                                  child: SwitchListTile.adaptive(
                                      activeColor: Color(COLOR_ACCENT),
                                      value: newOffersNews,
                                      onChanged: (bool newValue) {
                                        newOffersNews = newValue;
                                        setState(() {});
                                      }),
                                ),
                                InkWell(
                                  onTap: () async {
                                    showProgress(context,
                                        'Saving changes...'.tr(), true);
                                    user.settings.pushOffersNewsEnabled =
                                        newOffersNews;
                                    User? updateUser =
                                        await FireStoreUtils.updateCurrentUser(
                                            user);
                                    hideProgress();
                                    if (updateUser != null) {
                                      this.user = updateUser;
                                      MyAppState.currentUser = user;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          duration: Duration(seconds: 3),
                                          content: Text(
                                            'Settings saved successfully'.tr(),
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                      setState(() {
                                        notificationOffersNewsFlag = false;
                                      });
                                    }
                                  },
                                  child: Text(
                                    'Save',
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                        color: Color(0xFF949494),
                                        decoration: TextDecoration.underline,
                                        fontSize: 14),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              user.settings.pushOffersNewsEnabled
                                  ? "ON"
                                  : "OFF",
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: Color(0xFF949494), fontSize: 12),
                              textAlign: TextAlign.start,
                            ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (notificationOffersNewsFlag) {
                          notificationOffersNewsFlag = false;
                        } else {
                          notificationOffersNewsFlag = true;
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          'Toggle ON/OFF',
                          textScaleFactor: 1.0,
                          style:
                              TextStyle(color: Color(0xFF949494), fontSize: 14),
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
          ],
        ),
      ),
    );
  }
}
