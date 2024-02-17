import 'package:dating/common/common_widget.dart';
import 'package:dating/constants.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/theme/textstyle.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';

class SaftiyTipsScreen extends StatefulWidget {
  const SaftiyTipsScreen({Key? key}) : super(key: key);

  @override
  _SaftiyTipsScreenState createState() => _SaftiyTipsScreenState();
}

class _SaftiyTipsScreenState extends State<SaftiyTipsScreen> {
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
          'Safety Tips'.tr(),
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
              Text(
                'More than 44 million Americans use online dating apps. As you use TruuBlue, please keep a few safety precautions in mind. Dating apps cannot conduct criminal background checks on users, so it&rsquo;s up to each TruuBlue user to determine if they are comfortable meeting up with someone. However, it is important to remember that if you do experience sexual assault or violence while dating online or using an app, it is not your fault.',
                style: regualrText14,
              ),
              sizedBox10,
              Text(
                'Below are some steps you can take to increase your safety when interacting with others on TruuBlue, whether you are interacting virtually or in person. Like any safety tips, these are not a guarantee, but they may help you feel more secure.',
                style: regualrText14,
              ),
              sizedBox10,
              RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          '''Use different photos for your dating profile. ''',
                      style: boldText14.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text:
                          "It's easy to do a reverse image search online. If your dating profile has a photo that also shows up on one of your social media accounts, it will be easier for someone to find you on social media.",
                      style: regualrText14.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              sizedBox10,
              RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '''Avoid connecting with suspicious profiles. ''',
                      style: boldText14.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text:
                          "If the person with whom you matched has no bio and/or has only posted one photo, it may be a fake account. It&rsquo;s important to use caution if you choose to connect with someone you have so little information about.",
                      style: regualrText14.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              sizedBox10,
              RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          '''Check out your potential date on social media. ''',
                      style: boldText14.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text:
                          "If you know your match&rsquo;s name or handles on social media&mdash;or better yet if you have mutual friends online&mdash;look them up and make sure they aren&rsquo;t misleading you by using a fake social media account to create their dating profile.",
                      style: regualrText14.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              sizedBox10,
              RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '''Block and report suspicious users. ''',
                      style: boldText14.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text:
                          "You can block and report another user if you feel their profile is suspicious or if they have acted inappropriately toward you. This can be done anonymously before or after you&rsquo;ve matched. As with any personal interaction, it is always possible for people to misrepresent themselves. Trust your instincts about whether you feel someone is representing themself truthfully or not.",
                      style: regualrText14.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              sizedBox10,
              Text(
                "The list below offers a few examples of some common stories or suspicious behaviors scammers may use to build trust and sympathy so they can manipulate another user in an unhealthy way.",
                style: regualrText14,
              ),
              sizedBox10,
              rowDottedWidget(
                'Asks for financial assistance in any way, often because of a sudden personal crisis',
              ),
              rowDottedWidget(
                'Claims to be from the United States but is currently living, working, or traveling abroad',
              ),
              rowDottedWidget(
                'Claims to be recently widowed with children',
              ),
              rowDottedWidget(
                'Disappears suddenly from the site then reappears under a different name',
              ),
              rowDottedWidget(
                'Gives vague answers to specific questions',
              ),
              rowDottedWidget(
                'Overly complimentary and romantic too early in your communication',
              ),
              rowDottedWidget(
                'Pressures you to provide your phone number or talk outside the dating app or site',
              ),
              rowDottedWidget(
                'Requests your home or work address under the guise of sending flowers or gifts',
              ),
              rowDottedWidget(
                'Tells inconsistent or grandiose stories',
              ),
              rowDottedWidget(
                'Uses disjointed language and grammar, but has a high level of education',
              ),
              sizedBox10,
              Text(
                'Examples of user behavior you should report can include:',
                style: regualrText14,
              ),
              sizedBox10,
              rowDottedWidget(
                'Requests financial assistance',
              ),
              rowDottedWidget(
                'Requests photographs',
              ),
              rowDottedWidget(
                'Is a minor',
              ),
              rowDottedWidget(
                'Sends harassing or offensive messages',
              ),
              rowDottedWidget(
                'Attempts to threaten or intimidate you in any way',
              ),
              rowDottedWidget(
                'Seems to have created a fake profile',
              ),
              rowDottedWidget(
                'Tries to sell you products or services',
              ),
              sizedBox10,
              RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '''Wait to Share Personal Information. ''',
                      style: boldText14.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text:
                          "Never give someone you haven&rsquo;t met in person your personal information, including your: social security number, credit card details, bank information, or work or home address. TruuBlue will never send you an email asking for your username and password information, so if you receive a request for your login information, delete it and report the user.",
                      style: regualrText14.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              sizedBox10,
              RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          '''Don't Respond to Requests for Financial Help. ''',
                      style: boldText14.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text:
                          "No matter how convincing and compelling someone & rsquos reason may seem, never respond to a request to send money, especially overseas or via wire transfer. If you do get such a request, report it to TruuBlue immediately. For more information about how to avoid dating scams, check out the advice from the US Federal Trade Commission on the FTC website.",
                      style: regualrText14.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              sizedBox10,
              Text(
                'When Meeting in Person:',
                style: boldText14,
              ),
              sizedBox10,
              RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '''Video chat before you meet up in person. ''',
                      style: boldText14.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text:
                          "Once you have matched with a potential date and chatted, consider scheduling a video chat with them before meeting up in person for the first time. This can be a good way to help ensure your match is who they claim to be in their profile. If they strongly resist a video call, that could be a sign of suspicious activity.",
                      style: regualrText14.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              sizedBox10,
              RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '''Tell a friend where you're going. ''',
                      style: boldText14.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text:
                          "Take a screenshot of your date&rsquo;s profile and send it to a friend. Let at least one friend know where and when you plan to go on your date. If you continue your date in another place you hadn&rsquo;t planned, text a friend to let them know your new location. It may also be helpful to arrange to text or call a friend partway through the date or when you get home to check in.",
                      style: regualrText14.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              sizedBox10,
              RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '''Meet in a public place. ''',
                      style: boldText14.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text:
                          "For your first date, avoid meeting someone you don't know well in your home, apartment, or workplace. It may make both you and your date feel more comfortable to meet in a coffee shop, restaurant, or bar with plenty of other people around. Avoid meeting in public parks and other isolated locations for first dates.",
                      style: regualrText14.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              sizedBox10,
              RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '''Don''t rely on your date for transportation. ''',
                      style: boldText14.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text:
                          "It's important that you are in control of your own transportation to and from the date so that you can leave whenever you want and do not have to rely on your date in case you start feeling uncomfortable. Even if the person you're meeting volunteers to pick you up, avoid getting into a vehicle with someone you don&rsquo;t know and trust, especially if it&rsquo;s the first meeting.",
                      style: regualrText14.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              sizedBox10,
              Text(
                "Have a few rideshare apps downloaded on your phone so in case one is not working when you need it, you're have a backup. Make sure your phone is fully charged or consider bringing a portable battery with you.",
                style: regualrText14,
              ),
              sizedBox10,
              RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '''Stick to what you're most comfortable with. ''',
                      style: boldText14.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text:
                          "There's nothing wrong with having a few drinks on a date. Try to keep your limits in mind and do not feel pressured to drink just because your date is drinking. It can also be a good idea to avoid taking drugs before or during a first date with someone new because drugs could alter your perception of reality or have unexpected interactions with alcohol.",
                      style: regualrText14.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              sizedBox10,
              RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '''Trust your instincts. ''',
                      style: boldText14.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text:
                          "If you feel uncomfortable, trust your instincts. Feel free to leave a date or cut off communication with whoever is making you feel unsafe. Do not worry about feeling rude. Your safety is most important, and your date should understand that.",
                      style: regualrText14.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              sizedBox10,
              Text(
                "If you felt uncomfortable or unsafe during the date, remember you can always unmatch and/or block and report your match after meeting up in person. This will keep them from being able to access your profile in the future.",
                style: regualrText14,
              ),
              sizedBox10,
            ],
          ),
        ),
      ),
    );
  }
}
