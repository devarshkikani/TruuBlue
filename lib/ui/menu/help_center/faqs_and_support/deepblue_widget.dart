import 'package:dating/common/common_widget.dart';
import 'package:dating/constants.dart';
import 'package:dating/main.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/theme/textstyle.dart';
import 'package:dating/ui/home/HomeScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:dating/ui/onBoarding/OnBoardingSignUpInfo.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DeepBlueMembershipScreen extends StatelessWidget {
  const DeepBlueMembershipScreen({Key? key}) : super(key: key);

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
          'DeepBlue Membership'.tr(),
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
              sizedBox5,
              rowDottedWidget(
                'Send Unlimited Messages',
              ),
              rowDottedWidget(
                'See who likes you',
              ),
              rowDottedWidget(
                'Get 1 FREE TruuBoost/month',
              ),
              rowDottedWidget(
                'Get 5 FREE Ultra Likes/month',
              ),
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
              Text(
                'I am unable to join DeepBlue.',
                style: boldText16,
              ),
              sizedBox5,
              Text(
                '''If you get an error message when attempting to join DeepBlue, it potentially means your Apple ID is already associated with a DeepBlue membership on a different TruuBlue account. An Apple ID can only be associated with one TruuBlue account at a time. If you created a new TruuBlue account and want to join DeepBlue, you need to make sure you permanently deleted your old TruuBlue account first. Deleting your account will permanently delete your matches, messages and other information associated with that account.''',
                style: regualrText14.copyWith(
                  fontSize: 14,
                ),
              ),
              sizedBox15,
              Text(
                'To delete your old TruuBlue account:',
                style: regualrText14.copyWith(
                  fontSize: 14,
                ),
              ),
              sizedBox5,
              rowDottedWidget('Sign in to your old TruuBlue account', index: 1),
              rowDottedWidget(
                  'Click your Profile photo on the top left side of the TruuBlue screen',
                  index: 2),
              rowDottedWidget('Click Settings and then Account', index: 3),
              rowDottedWidget('Scroll down to Delete Account and select Edit',
                  index: 4),
              rowDottedWidget(
                  'Select Delete My Account – remember, all of your matches, messages and other information associated with that account will be permanently deleted',
                  index: 5),
              sizedBox15,
              Text(
                '''I subscribed to DeepBlue, but it doesn’t work.''',
                style: boldText16,
              ),
              sizedBox5,
              Text(
                '''A Payment Verification Error may occur if you have multiple TruuBlue accounts and you attempt to join DeepBlue. Make sure you do not have any other TruuBlue accounts associated with your cellphone number. If you find that you do have another account, please delete one of your accounts and attempt to join DeepBlue again.''',
                style: regualrText14.copyWith(
                  fontSize: 14,
                ),
              ),
              sizedBox15,
              Text(
                '''How can I update my payment information?''',
                style: boldText16,
              ),
              sizedBox5,
              Text(
                '''If you want to change your payment method, you must update it on the platform that you used to subscribe originally (iOS or Android).''',
                style: regualrText14.copyWith(
                  fontSize: 14,
                ),
              ),
              sizedBox15,
              Text(
                'On iPhone:',
                style: boldText16.copyWith(fontSize: 17),
              ),
              sizedBox5,
              rowDottedWidget(
                  '''On your iPhone, go to your Settings app > Apple ID > Payment & Shipping > Add Payment Method or Select Edit to update your payment method.'''),
              sizedBox10,
              Text(
                'On Android:',
                style: boldText16.copyWith(fontSize: 17),
              ),
              sizedBox5,
              rowDottedWidget(
                  '''Open the Google Play Store > Select the Menu icon > My Account > Add Payment Method or Edit Payment Method.'''),
              sizedBox15,
              Text(
                'I believe I was charged the wrong amount.',
                style: boldText16.copyWith(fontSize: 17),
              ),
              sizedBox5,
              Text(
                'On iOS:',
                style: boldText16.copyWith(fontSize: 17),
              ),
              sizedBox5,
              RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          '''If you've made an in-app purchase using your Apple ID and have noticed duplicate or incorrect charges on your bank statement, please verify this information with your bank and contact ''',
                      style: regualrText14.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: 'Apple Support ',
                      style: regualrText14.copyWith(
                        fontSize: 14,
                        color: Color(COLOR_BLUE_BUTTON),
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => launch("https://getsupport.apple.com/"),
                    ),
                    TextSpan(
                      text:
                          ''' to report this issue. Apple handles all transactions directly, including refunds.''',
                      style: regualrText14.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              sizedBox15,
              Text(
                'On Android:',
                style: boldText16.copyWith(fontSize: 17),
              ),
              sizedBox5,
              RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          '''If you've made an in-app purchase using your Google Play Store account and have noticed duplicate or incorrect charges on your bank statement, please verify this information with your bank and contact ''',
                      style: regualrText14.copyWith(
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: 'Google Play Support',
                      style: regualrText14.copyWith(
                        fontSize: 14,
                        color: Color(COLOR_BLUE_BUTTON),
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => launch(
                            "https://support.google.com/googleplay/answer/7018481"),
                    ),
                    TextSpan(
                      text: ''' to report this issue.''',
                      style: regualrText14.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              sizedBox15,
              Text(
                'Can I suspend my DeepBlue membership?',
                style: boldText16,
              ),
              sizedBox5,
              Text(
                'Currently, there is no way to suspend your TruuBlue membership. ',
                style: regualrText14.copyWith(
                  fontSize: 14,
                ),
              ),
              sizedBox15,
              Text(
                'How do I cancel my DeepBlue membership?',
                style: boldText16,
              ),
              sizedBox5,
              Text(
                'On your iPhone: ',
                style: boldText16,
              ),
              sizedBox5,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '  1.  ',
                    style: regualrText14.copyWith(
                      fontSize: 14,
                    ),
                  ),
                  Expanded(
                    child: RichText(
                      textScaleFactor: MediaQuery.of(context).textScaleFactor,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '''Tap ''',
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
                              ..onTap = () => push(
                                    context,
                                    HomeScreen(
                                      user: MyAppState.currentUser!,
                                      index: 1,
                                    ),
                                  ),
                          ),
                          TextSpan(
                            text: ''' to view your Subscriptions page''',
                            style: regualrText14.copyWith(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              rowDottedWidget(
                'Select TruuBlue',
                index: 2,
              ),
              rowDottedWidget(
                'Select Cancel Subscription',
                index: 3,
              ),
              sizedBox5,
              RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '''To learn more, please visit ''',
                      style: regualrText14.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: "Apple's support page.",
                      style: regualrText14.copyWith(
                        fontSize: 14,
                        color: Color(COLOR_BLUE_BUTTON),
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () =>
                            launch("https://support.apple.com/en-us/HT202039"),
                    )
                  ],
                ),
              ),
              sizedBox15,
              Text(
                '''If you don't see an option to cancel your subscription, that usually means that your subscription has already been successfully cancelled.''',
                style: regualrText14.copyWith(
                  fontSize: 14,
                ),
              ),
              sizedBox15,
              Text(
                'I want to request a refund.',
                style: boldText16,
              ),
              sizedBox5,
              Text(
                'If you subscribed through Apple/iTunes:',
                style: boldText16,
              ),
              sizedBox5,
              RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          '''Apple handles all refunds and cancellations for DeepBlue purchases on iOS devices. All refunds are granted entirely at the discretion of Apple. To request a refund from Apple, please contact iTunes Customer Support directly at ''',
                      style: regualrText14.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: 'https://getsupport.apple.com/.',
                      style: regualrText14.copyWith(
                        fontSize: 14,
                        color: Color(COLOR_BLUE_BUTTON),
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => launch("https://getsupport.apple.com/"),
                    )
                  ],
                ),
              ),
              sizedBox15,
              Text(
                'If you subscribed through Google Play:',
                style: boldText16,
              ),
              sizedBox5,
              RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          '''The fastest way to get a refund for a DeepBlue membership on your Google Play account is to request it directly from Google. You can find instructions at Google's support page:  ''',
                      style: regualrText14.copyWith(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text:
                          'https://support.google.com/googleplay/answer/7205930.',
                      style: regualrText14.copyWith(
                        fontSize: 14,
                        color: Color(COLOR_BLUE_BUTTON),
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => launch(
                            "https://support.google.com/googleplay/answer/7205930"),
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
