import 'package:dating/common/common_appbar_widget.dart';
import 'package:dating/html_text/flutter_html.dart';
import 'package:dating/model/User.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/ui/profile/NewProfileScreen.dart';
import 'package:dating/ui/profile/ProfilePreferencesScreen.dart';
import 'package:dating/ui/profile/ProfileSettingsScreen.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class MainProfileScreen extends StatefulWidget {
  final User user;
  final int index;
  const MainProfileScreen({Key? key, required this.user, required this.index})
      : super(key: key);

  @override
  _MainProfileScreenState createState() => _MainProfileScreenState();
}

class _MainProfileScreenState extends State<MainProfileScreen> {
  late User user;
  var select = 1;
  late Widget _currentWidget;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    if (widget.index == 2) {
      select = 2;
      _currentWidget = ProfilePreferencesScreen(
        user: user,
      );
    } else {
      _currentWidget = NewProfileScreen(
        user: user,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        user: user,
        context: context,
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
      ),
      body: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    select = 1;
                    _currentWidget = NewProfileScreen(
                      user: user,
                    );
                  });
                },
                child: Text(
                  'Profile'.tr(),
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      fontSize: 18,
                      color: select == 1
                          ? Color(COLOR_BLUE_BUTTON)
                          : Color(0xFF949494),
                      decoration: TextDecoration.underline),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                child: Container(
                  height: 15,
                  width: 1,
                  color: Color(COLOR_BLUE_BUTTON),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    select = 2;
                    _currentWidget = ProfilePreferencesScreen(
                      user: user,
                    );
                  });
                },
                child: Text(
                  'Preferences'.tr(),
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      fontSize: 18,
                      color: select == 2
                          ? Color(COLOR_BLUE_BUTTON)
                          : Color(0xFF949494),
                      decoration: TextDecoration.underline),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                child: Container(
                  height: 15,
                  width: 1,
                  color: Color(COLOR_BLUE_BUTTON),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    select = 3;
                    _currentWidget = ProfileSettingsScreen(
                      user: user,
                    );
                  });
                },
                child: Text(
                  'Settings'.tr(),
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      fontSize: 18,
                      color: select == 3
                          ? Color(COLOR_BLUE_BUTTON)
                          : Color(0xFF949494),
                      decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          Expanded(
            child: _currentWidget,
          ),
        ],
      ),
    );
  }
}
