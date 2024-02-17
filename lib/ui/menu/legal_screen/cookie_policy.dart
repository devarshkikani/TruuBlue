// ignore_for_file: deprecated_member_use

import 'package:dating/common/common_widget.dart';
import 'package:dating/constants.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/theme/textstyle.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CookiePolicyScreen extends StatelessWidget {
  const CookiePolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          'Cookie Policy'.tr(),
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
                '''At TruuBlue, our primary concern is protecting your data and privacy to ensure you have the best experience while you're on TruuBlue and after you find your relationship and leave the app.''',
              ),
              sizedBox10,
              Text(
                '''It's important for us that you understand exactly the information you share with us is being used. So please make sure to review our Privacy Policy here.''',
              ),
              sizedBox10,
              Text(
                '''We also want to offer you a rundown on what cookies are and how TruuBlue might use them.''',
              ),
              sizedBox10,
              Text(
                '''Cookies are small files stored onto your device based on sites or apps you access. They typically contain information about the source of the cookie, and if or when the cookie will expire. Cookies may also have information about your device, user settings, browsing history or activity.''',
              ),
              sizedBox10,
              Text(
                '''These are specific for web browsers, and since TruuBlue is a mobile-web app there are a few limited use-cases for cookies on TruuBlue:''',
              ),
              sizedBox10,
              rowDottedWidget(
                'When you visit our help center, you are redirected from the app to our TruuBlue Support Center',
              ),
              rowDottedWidget(
                'When you visit TruuBlue.com through a web browser (like Safari or Chrome)',
              ),
              sizedBox15,
              RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          '''For both these resources, TruuBlue uses Google Analytics. Google Analytics is a service that uses Google cookies and other data collection technology to collect information about your use of our website and help center in order to report trends. You can opt out of Google Analytics by visiting ''',
                      style: regualrText14.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: 'www.google.com/settings/ads',
                      style: regualrText14.copyWith(
                        color: Color(COLOR_BLUE_BUTTON),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () =>
                            launch("https://myadcenter.google.com/?sasb=true"),
                    ),
                    TextSpan(
                      text:
                          ''' or by downloading the Google Analytics opt-out browser add-on at ''',
                      style: regualrText14.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: 'https://tools.google.com/dlpage/gaoptout.',
                      style: regualrText14.copyWith(
                        color: Color(COLOR_BLUE_BUTTON),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () =>
                            launch("https://tools.google.com/dlpage/gaoptout"),
                    ),
                  ],
                ),
              ),
              sizedBox15,
              Text(
                '''Have more questions, contact us here''',
                style: regualrText14,
              ),
              sizedBox15,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''TruuBlue
8551 Strawberry Lane
Niwot, CO 80503
United States''',
                  style: regualrText14,
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
