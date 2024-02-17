import 'package:dating/constants.dart';
import 'package:dating/services/helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PauseAccountScreen extends StatefulWidget {
  const PauseAccountScreen({Key? key}) : super(key: key);

  @override
  State<PauseAccountScreen> createState() => _PauseAccountScreenState();
}

class _PauseAccountScreenState extends State<PauseAccountScreen> {
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
          'Pause Account'.tr(),
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
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Text(
                "Hide your profile from all TruuBlue users for a selected period. You will not lose any Likes, Matches, or Messages when you pause your account. Subscriptions do not pause.",
                textScaleFactor: 1.0,
                style: TextStyle(color: Color(0xFF949494), fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Text(
                "How long would you like to pause your account?",
                textScaleFactor: 1.0,
                style: TextStyle(color: Color(0xFF949494), fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Divider(
              color: Color(0xFF7e7e7e),
              height: 0.3,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Text(
                '24 Hours'.tr(),
                textScaleFactor: 1.0,
                style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
            Divider(
              color: Color(0xFF7e7e7e),
              height: 0.3,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Text(
                '48 Hours'.tr(),
                textScaleFactor: 1.0,
                style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
            Divider(
              color: Color(0xFF7e7e7e),
              height: 0.3,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Text(
                '1 week'.tr(),
                textScaleFactor: 1.0,
                style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                textAlign: TextAlign.start,
              ),
            ),
            Divider(
              color: Color(0xFF7e7e7e),
              height: 0.3,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Text(
                '1 month'.tr(),
                textScaleFactor: 1.0,
                style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                textAlign: TextAlign.start,
              ),
            ),
            Divider(
              color: Color(0xFF7e7e7e),
              height: 0.3,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Text(
                'indefinitely'.tr(),
                textScaleFactor: 1.0,
                style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                textAlign: TextAlign.start,
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
