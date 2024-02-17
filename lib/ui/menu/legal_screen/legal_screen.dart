import 'package:dating/constants.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/ui/menu/legal_screen/cookie_policy.dart';
import 'package:dating/ui/menu/legal_screen/privacy_policy.dart';
import 'package:dating/ui/menu/legal_screen/terms_of_use.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';

class LegalScreen extends StatefulWidget {
  const LegalScreen({
    Key? key,
  }) : super(key: key);

  @override
  _LegalScreenState createState() => _LegalScreenState();
}

class _LegalScreenState extends State<LegalScreen> {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, StateSetter setStat) {
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
                  color: isDarkMode(context)
                      ? Colors.white
                      : Color(COLOR_BLUE_BUTTON),
                ),
              ),
              title: Text(
                'Legal'.tr(),
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
                Divider(
                  color: Color(0xFF7e7e7e),
                  height: 0.3,
                ),
                InkWell(
                  onTap: () {
                    push(context, TermsOfUseScreen());
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Text(
                      'Terms of Use'.tr(),
                      textScaleFactor: 1.0,
                      style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Divider(
                  color: Color(0xFF7e7e7e),
                  height: 0.3,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      push(context, PrivacyPolicyScreen());
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Text(
                      'Privacy Policy'.tr(),
                      textScaleFactor: 1.0,
                      style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Divider(
                  color: Color(0xFF7e7e7e),
                  height: 0.3,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      push(context, CookiePolicyScreen());
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Text(
                      'Cookie Policy'.tr(),
                      textScaleFactor: 1.0,
                      style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                Divider(
                  color: Color(0xFF7e7e7e),
                  height: 0.3,
                ),
              ],
            ));
      },
    );
  }
}
