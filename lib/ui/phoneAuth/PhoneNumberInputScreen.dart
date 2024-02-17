import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/common/colors.dart';
import 'package:dating/constants.dart';
import 'package:dating/help/responsive_ui.dart';
import 'package:dating/main.dart';
import 'package:dating/model/User.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/theme/textstyle.dart';
import 'package:dating/ui/AppEntryOffers/AppEntryOffersScreen.dart';
import 'package:dating/ui/SwipeScreen/SwipeScreen.dart';
import 'package:dating/ui/art_board/first_art_board_screen.dart';
import 'package:dating/ui/onBoarding/OnBoardingSignUpInfo.dart';
import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

File? _image;

class PhoneNumberInputScreen extends StatefulWidget {
  final bool login;

  const PhoneNumberInputScreen({Key? key, required this.login})
      : super(key: key);

  @override
  _PhoneNumberInputScreenState createState() => _PhoneNumberInputScreenState();
}

class _PhoneNumberInputScreenState extends State<PhoneNumberInputScreen>
    with TickerProviderStateMixin {
  late AnimationController animationController1;
  late AnimationController animationController2;
  final ImagePicker _imagePicker = ImagePicker();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey();
  String? firstName, lastName, _phoneNumber, _verificationID;
  bool isPhoneValid = false, _codeSent = false;
  AutovalidateMode _validate = AutovalidateMode.disabled;
  Position? signUpLocation;
  bool? isLoading, _large, _medium;
  double? _pixelRatio, bottom1;
  Size? size;
  PhoneNumber? phone;
  String? otp;
  bool isMessageShow = false;
  Future<Position?> getlocation() async {
    Future.delayed(const Duration(milliseconds: 500), () async {
      signUpLocation = await getCurrentLocation();
    });
    return signUpLocation;
  }

  TextEditingController _phoneController = TextEditingController();
  final List<String> _allActivities = ['+1', '+91'];
  String _activity = '+1';
  @override
  void initState() {
    animationController1 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    animationController2 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..forward();
    super.initState();
    getlocation();
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
    _large = ResponsiveWidget.isScreenLarge(scrWidth, _pixelRatio!);
    _medium = ResponsiveWidget.isScreenMedium(scrWidth, _pixelRatio!);
    if (Platform.isAndroid && !widget.login) {
      retrieveLostData();
    }
    return Scaffold(
      backgroundColor: Color(COLOR_PRIMARY),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: MaterialButton(
            onPressed: () {
              animationController1.forward();
              setState(() {});
              Future.delayed(Duration(milliseconds: 500), () {
                Navigator.of(context).pop();
                animationController1.reverse();
              });
            },
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, anim) => RotationTransition(
                turns: animationController1,
                child: FadeTransition(
                    opacity: anim, child: child, alwaysIncludeSemantics: true),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 30,
                color: Color(0xFF0573ac),
                key: const ValueKey('icon2'),
              ),
            ),
            shape: CircleBorder(),
          ),
          centerTitle: true,
          title: Image.asset(
            'assets/images/truubluenew.png',
            width: 150.0,
            height: 50.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 20.0, right: 20, bottom: 16),
          child: Form(
            key: _key,
            autovalidateMode: _validate,
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    widget.login ? 'Sign In'.tr() : 'Create new account'.tr(),
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: _large! ? 32 : (_medium! ? 28 : 23),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, top: 32, right: 8, bottom: 8),
                  child: Visibility(
                    visible: !_codeSent && !widget.login,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 65,
                          backgroundColor: Colors.grey.shade400,
                          child: ClipOval(
                            child: SizedBox(
                              width: 170,
                              height: 170,
                              child: _image == null
                                  ? Image.asset(
                                      'assets/images/placeholder.jpg',
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      _image!,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 80,
                          right: 0,
                          child: FloatingActionButton(
                              backgroundColor: Color(COLOR_ACCENT),
                              child: Icon(
                                CupertinoIcons.camera,
                                color: isDarkMode(context)
                                    ? Colors.black
                                    : Colors.white,
                              ),
                              mini: true,
                              onPressed: _onCameraClick),
                        )
                      ],
                    ),
                  ),
                ),

                /// user first name text field , this is visible until we verify the
                /// code in case of sign up with phone number
                Visibility(
                  visible: !_codeSent && !widget.login,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: double.infinity),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 16.0, right: 8.0, left: 8.0),
                      child: TextFormField(
                        cursorColor: Color(COLOR_PRIMARY),
                        textAlignVertical: TextAlignVertical.center,
                        validator: validateName,
                        controller: _firstNameController,
                        onSaved: (String? val) {
                          firstName = val;
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          fillColor: Colors.white,
                          hintText: 'First Name'.tr(),
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
                ),

                /// last name of the user , this is visible until we verify the
                /// code in case of sign up with phone number
                Visibility(
                  visible: !_codeSent && !widget.login,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: double.infinity),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 16.0, right: 8.0, left: 8.0),
                      child: TextFormField(
                        validator: validateName,
                        textAlignVertical: TextAlignVertical.center,
                        cursorColor: Color(COLOR_PRIMARY),
                        onSaved: (String? val) {
                          lastName = val;
                        },
                        controller: _lastNameController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          fillColor: Colors.white,
                          hintText: 'Last Name'.tr(),
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
                ),

                /// user phone number,  this is visible until we verify the code
                Visibility(
                  visible: !_codeSent,
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
                ),

                Visibility(
                  visible: _codeSent,
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 32.0, right: 24.0, left: 24.0),
                    child: PinCodeTextField(
                      length: 6,
                      appContext: context,
                      keyboardType: TextInputType.phone,
                      backgroundColor: Colors.transparent,
                      pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 40,
                          fieldWidth: 40,
                          activeColor: Color(COLOR_PRIMARY),
                          activeFillColor: Colors.grey.shade100,
                          selectedFillColor: Colors.transparent,
                          selectedColor: Color(COLOR_PRIMARY),
                          inactiveColor: Colors.grey.shade600,
                          inactiveFillColor: Colors.transparent),
                      enableActiveFill: true,
                      onCompleted: (v) {
                        // _submitCode(v);
                        otp = v;
                      },
                      onChanged: (value) {
                        print(value);
                      },
                    ),
                  ),
                ),

                SizedBox(
                  height: 50,
                ),
                if (_codeSent)
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF70573ac),
                        textStyle: TextStyle(color: Colors.white),
                        padding: EdgeInsets.only(
                            right: 50, left: 50, top: 10, bottom: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: BorderSide(color: Color(0xFF0573ac))),
                      ),
                      child: Text(
                        'Next',
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () async {
                        if (otp != null) {
                          _submitOTP(otp!);
                        }
                      },
                    ),
                  ),

                Visibility(
                  visible: !_codeSent,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 80.0, left: 80.0, top: 20.0),
                    child: ConstrainedBox(
                      constraints:
                          const BoxConstraints(minWidth: double.infinity),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(COLOR_BLUE_BUTTON),
                          padding: EdgeInsets.only(top: 12, bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: BorderSide(
                              color: Color(COLOR_BLUE_BUTTON),
                            ),
                          ),
                        ),
                        onPressed: () => _signUp(),
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                if (!_codeSent)
                  if (isMessageShow)
                    RichText(
                      textScaleFactor: MediaQuery.of(context).textScaleFactor,
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                "No account found matching \n that cell number. \n",
                            style: mediumText16,
                          ),
                          TextSpan(
                            style: boldText16.copyWith(
                                decoration: TextDecoration.underline,
                                color: Color(COLOR_BLUE_BUTTON)),
                            text: 'Sign up here',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                push(context, OnBoardingSignUpInfo());
                              },
                          ),
                        ],
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitOTP(String smsCodes) {
    /// get the `smsCode` from the user

    /// when used different phoneNumber other than the current (running) device
    /// we need to use OTP to get `phoneAuthCredential` which is inturn used to signIn/login
    showProgress(context, 'Verifying you code...', false);
    auth.AuthCredential credential = auth.PhoneAuthProvider.credential(
        verificationId: _verificationID!, smsCode: smsCodes);
    _login(credential);
  }

  Future<void> _login(auth.AuthCredential credential) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    /// This method is used to login the user
    /// `AuthCredential`(`_phoneAuthCredential`) is needed for the signIn method
    /// After the signIn method from `AuthResult` we can get `FirebaserUser`(`_firebaseUser`)
    try {
      await auth.FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((authRes) async {
        dynamic result =
            await FireStoreUtils.getCurrentUserMobile(_phoneNumber!);
        MyAppState.currentUser = result;
        prefs.setString("loginMobile", _phoneNumber!);
        redirectEntryScreen(result, context);
      }).catchError((e) {
        hideProgress();
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
                      setState(() {
                        _codeSent = false;
                      });
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
      hideProgress();
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
                    setState(() {
                      _codeSent = false;
                    });
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

  Future<void> redirectEntryScreen(User user, BuildContext context) async {
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
    hideProgress();

    // String userCount = await getUserCount();

    // if (int.parse(userCount) >= 5000) {
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
    // } else {
    //   pushAndRemoveUntil(
    //       context,
    //       FirstArtBoardScreen(
    //         userCount: userCount,
    //       ),
    //       false);
    // }
  }

  Future<String> getUserCount() async {
    String userCount = '';
    final QuerySnapshot qSnap =
        await FireStoreUtils.firestore.collection(USERS).get();
    final int documents = qSnap.docs.length;
    for (int i = documents.toString().length; i < 4; i++) {
      userCount += '0';
    }
    userCount += documents.toString();

    return userCount;
  }

  /// submits the code to firebase to be validated, then get get the user
  /// object from firebase database
  /// @param code the code from input from code field
  /// creates a new user from phone login
  void submitCode(String code) async {
    await showProgress(context,
        widget.login ? 'Logging in...'.tr() : 'Signing up...'.tr(), false);
    try {
      signUpLocation = await getCurrentLocation();
      if (signUpLocation != null) {
        if (_verificationID != null) {
          dynamic result = await FireStoreUtils.firebaseSubmitPhoneNumberCode(
              _verificationID!, code, _phoneNumber!, signUpLocation!);
          if (result != null && result is User) {
            MyAppState.currentUser = result;
            await redirectEntryScreen(result, context);
          } else if (result != null && result is String) {
            await hideProgress();
            showAlertDialog(context, 'Failed'.tr(), result);
          } else {
            await hideProgress();
            showAlertDialog(context, 'Failed'.tr(),
                'Couldn\'t create new user with phone number.'.tr());
          }
        } else {
          await hideProgress();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Couldn\'t get verification ID'.tr()),
            duration: Duration(seconds: 6),
          ));
        }
      } else {
        await hideProgress();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Location is required to connect you with people from '
                  'your area.'
              .tr()),
          duration: Duration(seconds: 6),
        ));
      }
    } on auth.FirebaseAuthException catch (exception) {
      hideProgress();
      String message = 'An error has occurred. Please try again.'.tr();
      switch (exception.code) {
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
    } catch (e, s) {
      print('_PhoneNumberInputScreenState._submitCode $e $s');
      hideProgress();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'An error has occurred. Please try again.'.tr(),
          ),
        ),
      );
    }
  }

  /// used on android by the image picker lib, sometimes on android the image
  /// is lost
  Future<void> retrieveLostData() async {
    final LostDataResponse? response = await _imagePicker.retrieveLostData();
    if (response == null) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image = File(response.file!.path);
      });
    }
  }

  /// a set of menu options that appears when trying to select a profile
  /// image from gallery or take a new pic
  _onCameraClick() {
    final action = CupertinoActionSheet(
      message: Text(
        'Add profile picture'.tr(),
        style: TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text('Choose from gallery'.tr()),
          isDefaultAction: false,
          onPressed: () async {
            Navigator.pop(context);
            XFile? image =
                await _imagePicker.pickImage(source: ImageSource.gallery);
            if (image != null)
              setState(() {
                _image = File(image.path);
              });
          },
        ),
        CupertinoActionSheetAction(
          child: Text('Take a picture'.tr()),
          isDestructiveAction: false,
          onPressed: () async {
            Navigator.pop(context);
            XFile? image =
                await _imagePicker.pickImage(source: ImageSource.camera);
            if (image != null)
              setState(() {
                _image = File(image.path);
              });
          },
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text('Cancel'.tr()),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }

  _signUp() async {
    /*if (_key.currentState?.validate() ?? false) {
      _key.currentState!.save();
      if (_isPhoneValid)
        await _submitPhoneNumber(_phoneNumber!);
      else
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Invalid phone number, '
                    'Please try again with a different phone number.'
                .tr())));
    } else {
      setState(() {
        _validate = AutovalidateMode.onUserInteraction;
      });
    }*/
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
      bool? user = await FireStoreUtils.getCellNumber(
          (phone!.countryCode + phone!.number));
      if (user!) {
        if (phone != null) {
          if (phone!.number.length >= 10) {
            await _submitPhoneNumber(phone!.countryCode + phone!.number);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Enter cell number'.tr())));
          }
        } else
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Enter cell number'.tr())));
      } else {
        setState(() {
          isMessageShow = true;
        });
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     backgroundColor: Colors.transparent,
        //     elevation: 0.0,
        //     content: RichText(
        //       text: TextSpan(
        //         children: [
        //           TextSpan(
        //             text: "You don't have an account. ",
        //             style: mediumText20,
        //           ),
        //           TextSpan(
        //             style: boldText20.copyWith(
        //               decoration: TextDecoration.underline,
        //             ),
        //             text: 'Please sign up!',
        //             recognizer: TapGestureRecognizer()
        //               ..onTap = () async {
        //                 push(context, OnBoardingSignUpInfo());
        //               },
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter valid cell number'),
        ),
      );
    }
  }

  /// sends a request to firebase to create a new user using phone number and
  /// navigate to [ContainerScreen] after wards
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
          setState(() {
            _codeSent = true;
          });
        }
      },
      (auth.FirebaseAuthException error) {
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
      (auth.PhoneAuthCredential credential) async {
        /*if (mounted) {
          auth.UserCredential userCredential =
              await auth.FirebaseAuth.instance.signInWithCredential(credential);
          User? user = await FireStoreUtils.getCurrentUser(
              userCredential.user?.uid ?? '');
          if (user != null) {
            hideProgress();
            MyAppState.currentUser = user;
            pushAndRemoveUntil(context, HomeScreen(user: user), false);
          } else {
            /// create a new user from phone login
            User user = User(
                firstName: _firstNameController.text,
                lastName: _firstNameController.text,
                fcmToken:
                    await FireStoreUtils.firebaseMessaging.getToken() ?? '',
                phoneNumber: phoneNumber,
                active: true,
                lastOnlineTimestamp: Timestamp.now(),
                photos: [],
                settings: UserSettings(),
                location: UserLocation(
                    latitude: signUpLocation!.latitude,
                    longitude: signUpLocation!.longitude),
                signUpLocation: UserLocation(
                    latitude: signUpLocation!.latitude,
                    longitude: signUpLocation!.longitude),
                email: '',
                profilePictureURL: '',
                userID: userCredential.user?.uid ?? '');
            String? errorMessage =
                await FireStoreUtils.firebaseCreateNewUser(user);
            hideProgress();
            if (errorMessage == null) {
              MyAppState.currentUser = user;
              pushAndRemoveUntil(context, HomeScreen(user: user), false);
            } else {
              showAlertDialog(context, 'Failed'.tr(),
                  'Couldn\'t create new user with phone number.'.tr());
            }
          }
        }*/
      },
    );
  }
}
