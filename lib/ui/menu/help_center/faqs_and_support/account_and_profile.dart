import 'package:dating/common/common_widget.dart';
import 'package:dating/constants.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/theme/textstyle.dart';
import 'package:dating/ui/menu/legal_screen/terms_of_use.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountAndProfile extends StatelessWidget {
  const AccountAndProfile({Key? key}) : super(key: key);

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
          'Account & Profile'.tr(),
          textScaleFactor: 1.0,
          style: TextStyle(
            color: Color(0xff000000),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sizedBox10,
              Text(
                'How do I change my phone number?',
                style: boldText16,
              ),
              sizedBox5,
              Text(
                '''For security reasons, TruuBlue does not allow members to change the phone number associated with their accounts. Members can create a new profile using a new cell number if required.''',
                style: regualrText14.copyWith(
                  fontSize: 14,
                ),
              ),
              sizedBox15,
              RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          '''If you would like us to delete the account associated with your old phone number, simply submit a request at ''',
                      style: regualrText14.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: 'support@truublue.com',
                      style: regualrText14.copyWith(
                        color: Color(COLOR_BLUE_BUTTON),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => launch("mailto:support@truublue.com"),
                    )
                  ],
                ),
              ),
              sizedBox15,
              Text(
                'How do I update my email address?',
                style: boldText16,
              ),
              sizedBox5,
              RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          '''To update the email address associated with your account, select your ''',
                      style: regualrText14.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: 'Profile Photo ',
                      style: mediumText14.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: '''on the top, left on the main screen. Select ''',
                      style: regualrText14.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: 'Settings ',
                      style: mediumText14.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: ''', find Email and select ''',
                      style: regualrText14.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: 'Edit ',
                      style: mediumText14.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: '''on the right side. Next, select ''',
                      style: regualrText14.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: 'Update ',
                      style: mediumText14.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text:
                          '''on the right side. Enter your new email address and we will send you a code to verify your new email address.''',
                      style: regualrText14.copyWith(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              sizedBox15,
              Text(
                'How do I update my name, location, and other details?',
                style: boldText16,
              ),
              sizedBox5,
              RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          '''All profile information, preferences, and settings can be found and updated by selecting the ''',
                      style: regualrText14.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: 'Profile Photo ',
                      style: mediumText14.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text:
                          '''on the top, left on the main screen. Simply select ''',
                      style: regualrText14.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: 'Profile, Preferences, ',
                      style: mediumText14.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: '''or ''',
                      style: regualrText14.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: 'Settings ',
                      style: mediumText14.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text:
                          '''across the top of the Profile Screen. Then find the data element you want to update and select ''',
                      style: regualrText14.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: 'Edit ',
                      style: mediumText14.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: '''It’s that easy!''',
                      style: regualrText14.copyWith(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              sizedBox15,
              Text(
                'Why can’t I upload profile photos?',
                style: boldText16,
              ),
              sizedBox5,
              Text(
                '''If you're having trouble uploading a photo from your phone, make sure you've given TruuBlue access to your phone's photo album. If you denied TruuBlue access to your photos, go to your phone’s settings, find TruuBlue, and enable photo access.''',
                style: regualrText14.copyWith(
                  fontSize: 14,
                ),
              ),
              sizedBox15,
              RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          '''If you are still having issues with uploading photos, please feel free to contact TruuBlue support at ''',
                      style: regualrText14.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: 'support@truublue.com',
                      style: regualrText14.copyWith(
                        color: Color(COLOR_BLUE_BUTTON),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => launch("mailto:support@truublue.com."),
                    )
                  ],
                ),
              ),
              sizedBox15,
              Text(
                'Why was my account banned?',
                style: boldText16,
              ),
              sizedBox5,
              RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          '''Typically, if your account was banned it means you violated our ''',
                      style: regualrText14.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: 'Terms of Service.',
                      style: regualrText14.copyWith(
                        fontSize: 14,
                        color: Color(COLOR_BLUE_BUTTON),
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => push(
                              context,
                              TermsOfUseScreen(),
                            ),
                    ),
                    TextSpan(
                      text:
                          '''We take violations of our policies very seriously and we have a zero-tolerance policy in place.''',
                      style: regualrText14.copyWith(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              sizedBox15,
              Text(
                'Can I find out why I was banned?',
                style: boldText16,
              ),
              sizedBox5,
              Text(
                '''We cannot share that information with you in order to protect the identities of those who reported the account. We will not respond to inquiries seeking details about a ban.''',
                style: regualrText14.copyWith(
                  fontSize: 14,
                ),
              ),
              sizedBox15,
              Text(
                'Who makes the final decision?',
                style: boldText16,
              ),
              sizedBox5,
              Text(
                '''Our security team makes the final decision. We've taken particular care to ensure that the security team includes diverse individuals from a variety of backgrounds and experiences.''',
                style: regualrText14.copyWith(
                  fontSize: 14,
                ),
              ),
              sizedBox15,
              Text(
                '''If your account was banned, you will not be able to create a new TruuBlue account. If you had a DeepBlue Membership, you may need to cancel your subscription to prevent future payments.''',
                style: regualrText14.copyWith(
                  fontSize: 14,
                ),
              ),
              sizedBox15,
              RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '''Have more questions? Contact us at ''',
                      style: regualrText14.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: 'contact@truublue.com.',
                      style: regualrText14.copyWith(
                        color: Color(COLOR_BLUE_BUTTON),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => launch("mailto:contact@truublue.com"),
                    )
                  ],
                ),
              ),
              sizedBox20,
            ],
          ),
        ),
      ),
    );
  }
}
