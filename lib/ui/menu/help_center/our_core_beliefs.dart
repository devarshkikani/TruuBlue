import 'package:dating/common/common_widget.dart';
import 'package:dating/constants.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/theme/textstyle.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OurCoreBeliefsScreen extends StatefulWidget {
  const OurCoreBeliefsScreen({Key? key}) : super(key: key);

  @override
  State<OurCoreBeliefsScreen> createState() => _OurCoreBeliefsScreenState();
}

class _OurCoreBeliefsScreenState extends State<OurCoreBeliefsScreen> {
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
          'Our Core Beliefs'.tr(),
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
                '''At TruuBlue, our goal is to provide a tool for like-minded people to find love. We want to create a welcoming environment where our members can feel safe and secure. We believe in diversity, inclusion, and the Golden Rule &ndash; treat others as you would like to be treated.''',
                style: regualrText14.copyWith(
                  fontSize: 14,
                ),
              ),
              sizedBox15,
              Text(
                '''TruuBlue, like the United States, is a collection of people with many different backgrounds and beliefs. Every member has the right to express their opinions in a respectful and professional way. This diversity of genders, ethnicities, sexualities, and core beliefs is what makes TruuBlue special. Celebrate these diversities and seek to learn from them.''',
                style: regualrText14.copyWith(
                  fontSize: 14,
                ),
              ),
              sizedBox15,
              Text(
                '''TruuBlue will not tolerate abuse, harassment, threats, or insults of any kind. Our priority will always be the safety and security of our members. We have a Zero-Tolerance Policy for hate speech including comments that are held to be racist, sexist, homophobic, transphobic or any other type of bigotry. Any member engaged in that kind of activity will be permanently banned from TruuBlue and we encourage all members to report such activity to TruuBlue immediately.''',
                style: regualrText14.copyWith(
                  fontSize: 14,
                ),
              ),
              sizedBox15,
              Text(
                '''You can download the TruuBlue app on iOS and Android''',
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
                        ..onTap = () => launch("contact@truublue.com"),
                    )
                  ],
                ),
              ),
              sizedBox15,
              Text(
                '''United States''',
                style: regualrText14.copyWith(
                  fontSize: 14,
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
