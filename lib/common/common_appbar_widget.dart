import 'package:dating/constants.dart';
import 'package:dating/main.dart';
import 'package:dating/model/User.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/ui/auth/AuthScreen.dart';
import 'package:dating/ui/home/HomeScreen.dart';
import 'package:dating/ui/menu/help_center/help_center_screen.dart';
import 'package:dating/ui/menu/legal_screen/legal_screen.dart';
import 'package:dating/ui/menu/saftiy_tips_screen/saftiy_tips_screen.dart';
import 'package:dating/ui/profile/MainProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

AppBar appBarWidget(
    {required User user, required BuildContext context, Widget? leading}) {
  return AppBar(
    title: GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(user: user, index: 0),
          ),
        );
      },
      child: Image.asset(
        'assets/images/truubluenew.png',
        width: 150,
        height: 150,
      ),
    ),
    leading: leading ??
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: GestureDetector(
            child: user.profilePictureURL != ''
                ? Container(
                    height: 24,
                    width: 24,
                    // width: _appBarTitle == 'Profile'.tr() ? 35 : 24,
                    // height: _appBarTitle == 'Profile'.tr() ? 35 : 24,
                    decoration: new BoxDecoration(
                      color: const Color(0xff7c94b6),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      border: Border.all(
                        color: Colors.blue,
                        width: 0.5,
                      ),
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(user.profilePictureURL),
                      ),
                    ),
                  )
                : Container(
                    height: 24,
                    width: 24,
                    // width: _appBarTitle == 'Profile'.tr() ? 35 : 24,
                    // height: _appBarTitle == 'Profile'.tr() ? 35 : 24,
                    decoration: new BoxDecoration(
                      color: const Color(0xff7c94b6),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      border: Border.all(
                        color: Colors.blue,
                        width: 0.5,
                      ),
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(
                          'assets/images/placeholder.jpg',
                        ),
                      ),
                    ),
                  ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainProfileScreen(user: user, index: 1),
                ),
              );
            },
          ),
        ),
    actions: <Widget>[
      PopupMenuButton(
        icon: Icon(
          Icons.view_headline_rounded,
          color: Color(COLOR_BLUE_BUTTON),
          size: 24,
        ),
        offset: Offset(0, 55),
        onSelected: (value) => _select(value, context, user),
        itemBuilder: (BuildContext context) {
          return {'Safety Tips', 'Legal', 'Help Center', 'Logout'}
              .map((String choice) {
            return PopupMenuItem(
              value: choice,
              child: Text(choice),
            );
          }).toList();
        },
      )
    ],
    backgroundColor: Colors.transparent,
    brightness: Brightness.light,
    centerTitle: true,
    elevation: 0,
  );
}

Future<void> _select(value, context, user) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  switch (value) {
    case 'Safety Tips':
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SaftiyTipsScreen()));
      break;

    case 'Help Center':
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HelpCenterScreen()));
      break;

    case 'Legal':
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LegalScreen()));
      break;
    case 'Logout':
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Are you sure you want to Log out?'),
              insetPadding: EdgeInsets.symmetric(horizontal: 20),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); //close Dialog
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    user.active = false;
                    user.lastOnlineTimestamp =
                        DateTime.now().toUtc().millisecondsSinceEpoch;
                    await FireStoreUtils.updateCurrentUser(user);
                    await auth.FirebaseAuth.instance.signOut();
                    MyAppState.currentUser = null;
                    prefs.clear();
                    prefs.setString("loginMobile", "");
                    pushAndRemoveUntil(context, AuthScreen(), false);
                  },
                  child: Text('Logout'),
                ),
              ],
            );
          });
  }
  //print(value);
}
