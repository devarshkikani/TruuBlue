import 'package:dating/constants.dart';
import 'package:dating/services/helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({Key? key}) : super(key: key);

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
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
          'Delete Account'.tr(),
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
                "If you delete your account, all Likes, Matches, Messages, and Settings will be deleted. Alternatively, we strongly recommend pausing your account instead.",
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
                'Pause my account instead'.tr(),
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
                'Delete My Account'.tr(),
                textScaleFactor: 1.0,
                style: TextStyle(color: Color(0xFF949494), fontSize: 14),
                textAlign: TextAlign.center,
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
