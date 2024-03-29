import 'package:dating/constants.dart';
import 'package:dating/main.dart';
import 'package:dating/model/User.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/ui/AppEntryOffers/AppEntryOffersScreen.dart';
import 'package:dating/ui/SwipeScreen/SwipeScreen.dart';
import 'package:dating/ui/phoneAuth/PhoneNumberInputScreen.dart';
import 'package:dating/ui/resetPasswordScreen/ResetPasswordScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart' as apple;

class LoginScreen extends StatefulWidget {
  @override
  State createState() {
    return _LoginScreen();
  }
}

class _LoginScreen extends State<LoginScreen> {
  GlobalKey<FormState> _key = GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  Position? currentLocation;
  String? email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: isDarkMode(context) ? Brightness.dark : Brightness.light,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
            color: isDarkMode(context) ? Colors.white : Colors.black),
        elevation: 0.0,
      ),
      body: Form(
        key: _key,
        autovalidateMode: _validate,
        child: ListView(
          children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: double.infinity),
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 32.0, right: 16.0, left: 16.0),
                child: Text(
                  'Sign In'.tr(),
                  style: TextStyle(
                      color: Color(COLOR_PRIMARY),
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: double.infinity),
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 32.0, right: 24.0, left: 24.0),
                child: TextFormField(
                  textAlignVertical: TextAlignVertical.center,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(fontSize: 18.0),
                  validator: (val) => validateEmail(val),
                  onSaved: (val) => email = val,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Color(COLOR_PRIMARY),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 16, right: 16),
                    hintText: 'E-mail Address'.tr(),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                            color: Color(COLOR_PRIMARY), width: 2.0)),
                    errorBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).errorColor),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).errorColor),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: double.infinity),
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 32.0, right: 24.0, left: 24.0),
                child: TextFormField(
                  textAlignVertical: TextAlignVertical.center,
                  onSaved: (val) => password = val,
                  obscureText: true,
                  validator: (val) => validatePassword(val),
                  onFieldSubmitted: (password) => _login(),
                  textInputAction: TextInputAction.done,
                  style: TextStyle(fontSize: 18.0),
                  cursorColor: Color(COLOR_PRIMARY),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 16, right: 16),
                    hintText: 'Password'.tr(),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                            color: Color(COLOR_PRIMARY), width: 2.0)),
                    errorBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).errorColor),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).errorColor),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
              ),
            ),

            /// forgot password text, navigates user to ResetPasswordScreen
            /// and this is only visible when logging with email and password
            Padding(
              padding: const EdgeInsets.only(top: 16, right: 24),
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => push(context, ResetPasswordScreen()),
                  child: Text(
                    'Forgot password?'.tr(),
                    style: TextStyle(
                        color: Colors.lightBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        letterSpacing: 1),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 40),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: double.infinity),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(COLOR_PRIMARY),
                    padding: EdgeInsets.only(top: 12, bottom: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        side: BorderSide(color: Color(COLOR_PRIMARY))),
                  ),
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode(context) ? Colors.black : Colors.white,
                    ),
                  ),
                  onPressed: () => _login(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: Text(
                  'OR'.tr(),
                  style: TextStyle(
                      color: isDarkMode(context) ? Colors.white : Colors.black),
                ),
              ),
            ),
            FutureBuilder<bool>(
              future: apple.TheAppleSignIn.isAvailable(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator.adaptive();
                }
                if (!snapshot.hasData || (snapshot.data != true)) {
                  return Container();
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(
                        right: 40.0, left: 40.0, bottom: 20),
                    child: apple.AppleSignInButton(
                      cornerRadius: 25.0,
                      type: apple.ButtonType.signIn,
                      style: isDarkMode(context)
                          ? apple.ButtonStyle.white
                          : apple.ButtonStyle.black,
                      onPressed: () => loginWithApple(),
                    ),
                  );
                }
              },
            ),

            InkWell(
              onTap: () {
                push(context, PhoneNumberInputScreen(login: true));
              },
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Login with phone number'.tr(),
                    style: TextStyle(
                        color: Colors.lightBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        letterSpacing: 1),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _login() async {
    if (_key.currentState?.validate() ?? false) {
      _key.currentState!.save();
      await _loginWithEmailAndPassword();
    } else {
      setState(() {
        _validate = AutovalidateMode.onUserInteraction;
      });
    }
  }

  /// login with email and password with firebase
  /// @param email user email
  /// @param password user password
  _loginWithEmailAndPassword() async {
    await showProgress(context, 'Logging in, please wait...'.tr(), false);
    currentLocation = await getCurrentLocation();
    if (currentLocation != null) {
      dynamic result = await FireStoreUtils.loginWithEmailAndPassword(
          email!.trim(), password!.trim(), currentLocation!);
      if (result != null && result is User) {
        MyAppState.currentUser = result;
        redirectEntryScreen(result, context);
      } else if (result != null && result is String) {
        await hideProgress();
        showAlertDialog(context, 'Couldn\'t Authenticate'.tr(), result);
      } else {
        await hideProgress();
        showAlertDialog(context, 'Couldn\'t Authenticate'.tr(),
            'Login failed, Please try again.'.tr());
      }
    } else {
      await hideProgress();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Location is required to match you with people from '
                'your area.'
            .tr()),
        duration: Duration(seconds: 6),
      ));
    }
  }

  loginWithFacebook() async {
    try {
      await showProgress(context, 'Logging in, Please wait...'.tr(), false);
      dynamic result = await FireStoreUtils.loginWithFacebook();
      await hideProgress();
      if (result != null && result is User) {
        MyAppState.currentUser = result;
        redirectEntryScreen(result, context);
      } else if (result != null && result is String) {
        showAlertDialog(context, 'Error'.tr(), result.tr());
      } else {
        showAlertDialog(
            context, 'Error', 'Couldn\'t login with facebook.'.tr());
      }
    } catch (e, s) {
      await hideProgress();
      print('_LoginScreen.loginWithFacebook $e $s');
      showAlertDialog(context, 'Error', 'Couldn\'t login with facebook.'.tr());
    }
  }

  loginWithApple() async {
    try {
      await showProgress(context, 'Logging in, Please wait...'.tr(), false);
      dynamic result = await FireStoreUtils.loginWithApple();
      await hideProgress();
      if (result != null && result is User) {
        MyAppState.currentUser = result;
        redirectEntryScreen(result, context);
      } else if (result != null && result is String) {
        showAlertDialog(context, 'Error'.tr(), result.tr());
      } else {
        showAlertDialog(context, 'Error', 'Couldn\'t login with apple.'.tr());
      }
    } catch (e, s) {
      await hideProgress();
      print('_LoginScreen.loginWithApple $e $s');
      showAlertDialog(context, 'Error', 'Couldn\'t login with apple.'.tr());
    }
  }
}

void redirectEntryScreen(User user, BuildContext context) async {
  int messageCount = 0;
  int likeCount = 0;
  user.active = true;
  user.fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
  user.lastOnlineTimestamp = DateTime.now().toUtc().millisecondsSinceEpoch;
  await FireStoreUtils.updateCurrentUser(user);
  FireStoreUtils().getConversations(user.userID).forEach((element) {
    if (element.isNotEmpty) {
      messageCount = messageCount + 1;
    }
  });
  String predefineBoostCount = await FireStoreUtils.getBoostLikeCount();
  String predefineCount = await FireStoreUtils.getUltraLikeCount();
  SharedPreferences pref = await SharedPreferences.getInstance();
  FireStoreUtils().getOtherYouLikedObject(user.userID).then((value) async {
    List friendsList = [];
    value.forEach((element) {
      if (element.otherLike == false) {
        friendsList.add(element);
      }
    });
    likeCount = friendsList.length;

    if (friendsList.length > (pref.getInt('oldNewLikesCount') ?? 0)) {
      newLikesCount = friendsList.length;
      await pref.setInt('oldNewLikesCount', newLikesCount);
    } else {
      newLikesCount = 0;
    }
  });
  FireStoreUtils().getConversations(user.userID).forEach((element) {
    if (element.isNotEmpty) {
      messageCount = messageCount + 1;
    }
  });
  await SwipeScreenState().getcurrentUser(context);
  await hideProgress();

  pushAndRemoveUntil(
      context,
      AppEntryOffersScreen(
        user: user,
        likeCount: likeCount,
        messageCount: messageCount,
        predefineCount: int.parse(predefineCount),
        predefineBoostCount: int.parse(predefineBoostCount),
      ),
      false);
}
