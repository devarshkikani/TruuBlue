import 'package:dating/constants.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/ui/menu/help_center/faqs_and_support_screen.dart';
import 'package:dating/ui/menu/help_center/our_core_beliefs.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({Key? key}) : super(key: key);

  @override
  _HelpCenterScreenState createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, StateSetter setStat) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
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
              'Help Center'.tr(),
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
                  push(context, OurCoreBeliefsScreen());
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Text(
                    'Our Core Beliefs'.tr(),
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
                  push(context, FAQsAndSupportScreen());
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Text(
                    'FAQs & Support'.tr(),
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
            ],
          ),
        );
      },
    );
  }
}
