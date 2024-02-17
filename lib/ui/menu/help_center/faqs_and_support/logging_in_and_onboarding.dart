import 'package:dating/common/common_widget.dart';
import 'package:dating/constants.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/theme/textstyle.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LoggingInAndOnboarding extends StatelessWidget {
  const LoggingInAndOnboarding({Key? key}) : super(key: key);

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
          'Logging and Onboarding'.tr(),
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
                'How do I create a free TruuBlue account?',
                style: boldText16,
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: RichText(
                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            '''1.  Download the TruuBlue app for iOS or Android ''',
                        style: regualrText14.copyWith(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(
                        text: '''iOS ''',
                        style: regualrText14.copyWith(
                          color: Color(COLOR_BLUE_BUTTON),
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(
                        text: '''or ''',
                        style: regualrText14.copyWith(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(
                        text: '''Android ''',
                        style: regualrText14.copyWith(
                          color: Color(COLOR_BLUE_BUTTON),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              rowDottedWidget(
                  'Open the TruuBlue app and enter your cell number.',
                  index: 2),
              rowDottedWidget(
                  'Receive a unique code from TruuBlue via text message.',
                  index: 3),
              rowDottedWidget(
                  'Enter the unique code and complete your profile.',
                  index: 4),
              rowDottedWidget(
                  'Allow Notifications and Location Services so TruuBlue can function properly.',
                  index: 5),
              rowDottedWidget(
                  'Start meeting like-minded progressives in your area.',
                  index: 6),
              sizedBox15,
              Text(
                '''TruuBlue requires all members to verify their account with a cell number. This is required to ensure the safety and security of our members.''',
                style: regualrText14.copyWith(
                  fontSize: 14,
                ),
              ),
              sizedBox15,
              Text(
                '''I can’t log in.''',
                style: boldText16,
              ),
              sizedBox5,
              Text(
                '''If you’re having trouble logging in, try closing TruuBlue and reopening it. If the issue persists, perform the following tasks:''',
                style: regualrText14.copyWith(
                  fontSize: 14,
                ),
              ),
              sizedBox15,
              rowDottedWidget(
                  'Make sure you have a strong internet connection.'),
              rowDottedWidget(
                  'Try switching between Wi-Fi and mobile data to determine whether the problem is related to your connection.'),
              rowDottedWidget(
                  'Check the App Store or Google Play Store to be sure that you have the latest version of TruuBlue installed.'),
              rowDottedWidget(
                  'Delete TruuBlue from your phone. Then download it again and reload it. Your account will not be affected when you delete TruuBlue.'),
              rowDottedWidget(
                  'Be sure you are using the cell number that you previously used.'),
              sizedBox15,
              RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          '''If none of these fixes work, contact TruuBlue support at ''',
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
                'I entered my cell number, but I did not receive a code via text message.',
                style: boldText16,
              ),
              sizedBox5,
              Text(
                '''First, make sure you are using the device associated with the cell number you entered. Also, verify you entered the correct cell number during onboarding. If the cell number you entered is not accurate, click the back button and enter the correct cell number.''',
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
                          '''If none of these fixes work, contact TruuBlue support at ''',
                      style: regualrText14.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: 'support@truublue.com',
                      style: regualrText14.copyWith(
                        fontSize: 14,
                        color: Color(COLOR_BLUE_BUTTON),
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
                'Do you share my birthdate with other members?',
                style: boldText16,
              ),
              sizedBox5,
              Text(
                '''No, we never share your birthdate with anyone. We only show your age to potential matches.''',
                style: regualrText14.copyWith(
                  fontSize: 14,
                ),
              ),
              sizedBox15,
              Text(
                'How many photos should I upload?',
                style: boldText16,
              ),
              sizedBox5,
              Text(
                '''Studies show that a minimum of three quality photos should be uploaded to your profile. Uploading more than three photos increases your chances of additional matches! In addition, as a security measure, we recommend you upload unique photos not found on your social media pages.''',
                style: regualrText14.copyWith(
                  fontSize: 14,
                ),
              ),
              sizedBox15,
              Text(
                'Why should I turn on Location Services for TruuBlue?',
                style: boldText16,
              ),
              sizedBox5,
              Text(
                '''TruuBlue is a geolocation-based dating application. In order to locate potential matches for you in your area, Location Services must be turned ON.''',
                style: regualrText14.copyWith(
                  fontSize: 14,
                ),
              ),
              sizedBox15,
              Text(
                'Why should I turn on Notifications for TruuBlue?',
                style: boldText16,
              ),
              sizedBox5,
              Text(
                '''When you have a match, time is of the essence. Matches expire over time, so we use Notification services to instantly let you know you have a match waiting to hear from you.''',
                style: regualrText14.copyWith(
                  fontSize: 14,
                ),
              ),
              sizedBox15,
              Text(
                'Why do you need my email address?',
                style: boldText16,
              ),
              sizedBox5,
              Text(
                '''We use your email address for two things: First, we use it as a second verification to make sure our members are real and serious about using the app. Second, we periodically send you important announcements about updates, upgrades, news, and other less time-sensitive information.''',
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
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: 'contact@truublue.com',
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
