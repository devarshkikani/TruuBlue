import 'package:dating/common/common_widget.dart';
import 'package:dating/constants.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/theme/textstyle.dart';
import 'package:dating/ui/onBoarding/OnBoardingSignUpInfo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GettingStartedWidget extends StatefulWidget {
  const GettingStartedWidget({Key? key}) : super(key: key);

  @override
  State<GettingStartedWidget> createState() => _GettingStartedWidgetState();
}

class _GettingStartedWidgetState extends State<GettingStartedWidget> {
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
          'Getting Started'.tr(),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              sizedBox10,
              Text(
                'What is TruuBlue?',
                style: boldText16,
              ),
              sizedBox5,
              Text(
                "TruuBlue is a new kind of dating app. It is designed for busy progressives who prefer to interact with like-minded people in their area.",
                style: regualrText14.copyWith(
                  fontSize: 14,
                ),
              ),
              sizedBox15,
              Text(
                "Political affiliation is the fourth highest dating priority after children, smoking, and religion. Matching political views has become so important that most socially progressive people prefer to mingle and date those who share their social views. Further, data shows that most married couples belong to the same political party.",
                style: regualrText14.copyWith(
                  fontSize: 14,
                ),
              ),
              sizedBox15,
              Text(
                "Our matching algorithms were designed to place a high priority on your core political beliefs including:",
                style: regualrText14.copyWith(
                  fontSize: 14,
                ),
              ),
              sizedBox15,
              rowDottedWidget(
                '''A Woman’s Right to Choose''',
              ),
              rowDottedWidget(
                '''Climate Change Legislation''',
              ),
              rowDottedWidget(
                '''Expanded LGBTQ+ Rights''',
              ),
              rowDottedWidget(
                '''Better Gun Controls''',
              ),
              rowDottedWidget(
                '''Immigration Laws.''',
              ),
              rowDottedWidget(
                '''Same-Sex Marriage''',
              ),
              sizedBox15,
              Text(
                'Is TruuBlue free to use?',
                style: boldText16,
              ),
              sizedBox5,
              RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          '''Yes, TruuBlue is free to use. However, you are limited in the number of members you can “Like” each day. You can unlock the full potential of TruuBlue, including seeing a list of people who have liked you and getting TruuBoosts, by upgrading to our premium package, DeepBlue. You can sign up for DeepBlue ''',
                      style: regualrText14.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: 'here',
                      style: TextStyle(
                        color: Color(COLOR_BLUE_BUTTON),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => push(context, OnBoardingSignUpInfo()),
                    )
                  ],
                ),
              ),
              sizedBox15,
              Text(
                'Where can I use TruuBlue?',
                style: boldText16,
              ),
              sizedBox5,
              Text(
                '''Currently, TruuBlue is only available in Colorado. We plan on expanding the TruuBlue footprint to include the entire United States and Canada very soon. We will notify you immediately as we open new regions.''',
                style: regualrText14.copyWith(
                  fontSize: 14,
                ),
              ),
              sizedBox15,
              Text(
                'Does TruuBlue impose an age restriction?',
                style: boldText16,
              ),
              sizedBox5,
              Text(
                '''Yes, you must be at least 18 years old to create a TruuBlue profile.''',
                style: regualrText14.copyWith(
                  fontSize: 14,
                ),
              ),
              sizedBox15,
              Text(
                'What is DeepBlue?',
                style: boldText16,
              ),
              sizedBox5,
              Text(
                '''DeepBlue is our premium membership that unlocks the full strength of TruuBlue. In fact, DeepBlue members get twice as many dates!''',
                style: regualrText14.copyWith(
                  fontSize: 14,
                ),
              ),
              sizedBox15,
              Text(
                '''DeepBlue members enjoy the following premium features:''',
                style: regualrText14.copyWith(
                  fontSize: 14,
                ),
              ),
              sizedBox15,
              rowDottedWidget('Send Unlimited Messages'),
              rowDottedWidget('See Who Likes You'),
              rowDottedWidget('Get 1 FREE Boost/month'),
              rowDottedWidget('Get 5 FREE Ultra Likes/month'),
              sizedBox15,
              RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          '''Improve your profile exposure and increase your matches. You can sign up for DeepBlue ''',
                      style: regualrText14.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: 'here',
                      style: regualrText14.copyWith(
                        fontSize: 14,
                        color: Color(COLOR_BLUE_BUTTON),
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => push(context, OnBoardingSignUpInfo()),
                    )
                  ],
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
