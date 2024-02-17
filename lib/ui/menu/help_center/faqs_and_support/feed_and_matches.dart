import 'package:dating/common/common_widget.dart';
import 'package:dating/constants.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/theme/textstyle.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedAndMatchesScreen extends StatelessWidget {
  const FeedAndMatchesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            color:
                isDarkMode(context) ? Colors.white : Color(COLOR_BLUE_BUTTON),
          ),
        ),
        title: Text(
          'Feed & Matches'.tr(),
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
                "Why am I seeing profiles that don’t match my preferences?",
                style: boldText16,
              ),
              sizedBox5,
              Text(
                '''The TruuBlue algorithm uses your preference settings to make meaningful matches. Potential matches are presented in order of priority. You can adjust your preferences anytime. The TruuBlue algorithm will adjust your new settings the next time you log-in.''',
                style: regualrText14.copyWith(
                  fontSize: 14,
                ),
              ),
              sizedBox15,
              Text(
                "Why am I seeing profiles that are too far away?",
                style: boldText16,
              ),
              sizedBox5,
              Text(
                '''Some members cast a wide area for potential Matches. We prioritize potential Matches within your designated distance setting, but sometime show you profiles that extend outside of your setting. Other times, potential members will be in your area and are attempting to match with people from that region.''',
                style: regualrText14.copyWith(
                  fontSize: 14,
                ),
              ),
              sizedBox15,
              Text(
                "Why did one of my matches disappear?",
                style: boldText16,
              ),
              sizedBox5,
              Text(
                '''If one of your matches disappeared, either:''',
                style: regualrText14.copyWith(
                  fontSize: 14,
                ),
              ),
              sizedBox5,
              rowDottedWidget(
                'That member manually or accidentally unmatched your profile from their Matches screen.',
                index: 1,
              ),
              rowDottedWidget(
                'That member deleted their TruuBlue profile.',
                index: 2,
              ),
              sizedBox15,
              Text(
                "Why did all of my matches disappear?",
                style: boldText16,
              ),
              sizedBox5,
              Text(
                '''When you update your TruuBlue app, it may take some time for your Matches to repopulate as your app re-syncs with our servers. This can depend on how many Matches you have and how strong your WIFI connection is at the time your app updated. Logging out and back into the TruuBlue app will refresh your Matches and bring everyone back into your Activity queue.''',
                style: regualrText14.copyWith(
                  fontSize: 14,
                ),
              ),
              sizedBox15,
              Text(
                "I’m not getting many matches.",
                style: boldText16,
              ),
              sizedBox5,
              Text(
                '''As a new TruuBlue member, it may take a while to accumulate potential matches. TruuBlue puts an emphasis on quality of matches over quantity. Our focus is on generating real potential matches for you, so you may not see quite the volume of potential matches as you might see with other hook-up apps.''',
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
