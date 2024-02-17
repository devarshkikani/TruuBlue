import 'package:dating/constants.dart';
import 'package:dating/model/User.dart' as us;
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/ui/profile/account_settings_screen.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';

class ProfileSettingsScreen extends StatefulWidget {
  final us.User user;

  const ProfileSettingsScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ProfileSettingsScreenState createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  late us.User user;
  FireStoreUtils fireStoreUtils = FireStoreUtils();

  @override
  void initState() {
    user = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 32, right: 32),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  Center(
                      child: displayCircleImage(
                          user.profilePictureURL, 100, false)),
                  Positioned(
                    left: 80,
                    right: 80,
                    child: Container(
                      width: 150,
                      decoration: BoxDecoration(
                          color: Color(COLOR_BLUE_BUTTON),
                          borderRadius: BorderRadius.circular(5),
                          shape: BoxShape.rectangle,
                          border: Border.all(color: Color(COLOR_BLUE_BUTTON))),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                        child: Text(
                          user.isVip
                              ? 'Paid Account'.tr()
                              : 'Free Account'.tr(),
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Divider(
              color: Color(0xFF7e7e7e),
              height: 0.3,
            ),
            InkWell(
              onTap: () {
                push(context, AccountSettingsScreen());
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Account'.tr(),
                      textScaleFactor: 1.0,
                      style: TextStyle(
                          color: Color(0xFF949494),
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                      textAlign: TextAlign.start,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: Color(0xFF949494),
                        ),
                      ],
                    )
                  ],
                ),
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
