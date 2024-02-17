import 'package:dating/constants.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/ui/menu/help_center/faqs_and_support/account_and_profile.dart';
import 'package:dating/ui/menu/help_center/faqs_and_support/deepblue_widget.dart';
import 'package:dating/ui/menu/help_center/faqs_and_support/feed_and_matches.dart';
import 'package:dating/ui/menu/help_center/faqs_and_support/getting_started_widget.dart';
import 'package:dating/ui/menu/help_center/faqs_and_support/logging_in_and_onboarding.dart';
import 'package:dating/ui/menu/help_center/faqs_and_support/support_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class FAQsAndSupportScreen extends StatelessWidget {
  const FAQsAndSupportScreen({Key? key}) : super(key: key);

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
          'FAQs & Support'.tr(),
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
              push(context, GettingStartedWidget());
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Text(
                'Getting Started'.tr(),
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
              push(
                context,
                LoggingInAndOnboarding(),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Text(
                'Logging In And Onboarding'.tr(),
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
              push(context, AccountAndProfile());
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Text(
                'Account & Profile'.tr(),
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
              push(context, FeedAndMatchesScreen());
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Text(
                'Feed & Matches'.tr(),
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
              push(
                context,
                DeepBlueMembershipScreen(),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Text(
                'DeepBlue Membership'.tr(),
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
              push(
                context,
                SupportScreen(),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Text(
                'Support'.tr(),
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
  }
}
