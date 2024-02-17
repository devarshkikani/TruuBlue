// ignore_for_file: deprecated_member_use

import 'package:dating/common/common_widget.dart';
import 'package:dating/constants.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/theme/textstyle.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({Key? key}) : super(key: key);

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
          'Terms of Use'.tr(),
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
                "Last revised on December 15, 2021",
                style: regualrText14,
              ),
              sizedBox15,
              Text(
                "Welcome to TruuBlue, operated by TruuBlue LLC ('us', 'we', the 'Company' or 'TruuBlue').",
                style: regualrText14,
              ),
              sizedBox15,
              RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          '''Notice to California subscribers: You may cancel your subscription, without penalty or obligation, at any time prior to midnight of the third business day following the date you subscribed. If you subscribed using your Apple ID, refunds are handled by Apple, not TruuBlue. If you wish to request a refund, please visit ''',
                      style: regualrText14.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: 'https://getsupport.apple.com',
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
                          '''. If you subscribed using your Google Play Store account or through TruuBlue Online, contact customer support.''',
                      style: regualrText14.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              sizedBox15,
              rowDottedWidget(
                'Acceptance of Terms of Use Agreement.',
                index: 1,
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''By creating a TruuBlue account or by using any TruuBlue service, whether through a mobile device, mobile application or computer (collectively, the "Service") you agree to be bound by (i) these Terms of Use, (ii) our Privacy Policy, Cookie Policy, Arbitration Procedures, Safety Tips, and Community Guidelines, each of which is incorporated by reference into this Agreement, and (iii) any terms disclosed to you if you purchase or have purchased additional features, products or services we offer on the Service (collectively, this "Agreement"). If you do not accept and agree to be bound by all the terms of this Agreement (other than the limited one-time opt-out right for certain members provided for in Section 15), you should not use the Service.''',
                  style: regualrText14,
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''We may make changes to this Agreement and to the Service from time to time. We may do this for a variety of reasons including to reflect changes in or requirements of the law, new features, or changes in business practices. The most recent version of this Agreement will be posted on the Service under Settings and on TruuBlue.com, and you should regularly check for the most recent version. The most recent version is the version that applies. If the changes include material changes to your rights or obligations, we will notify you in advance of the changes (unless we&rsquo;re unable to do so under applicable law) by reasonable means, which could include notification through the Service or via email. If you continue to use the Service after the changes become effective, then you agree to the revised Agreement. You agree that this Agreement shall supersede any prior agreements (except as specifically stated herein), and shall govern your entire relationship with TruuBlue, including but not limited to events, agreements, and conduct preceding your acceptance of this Agreement.''',
                  style: regualrText14,
                ),
              ),
              sizedBox15,
              rowDottedWidget(
                'Eligibility.',
                index: 2,
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''You must be at least 18 years of age to create an account on TruuBlue and use the Service. By creating an account and using the Service, you represent and warrant that:''',
                  style: regualrText14,
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  children: [
                    rowDottedWidget(
                      'you can form a binding contract with TruuBlue;',
                    ),
                    rowDottedWidget(
                      "you are not a person who is barred from using the Service under the laws of the United States or any other applicable jurisdiction (for example, you do not appear on the U.S. Treasury Department's list of Specially Designated Nationals or face any other similar prohibition);",
                    ),
                    rowDottedWidget(
                      'you will comply with this Agreement and all applicable local, state, national and international laws, rules and regulations;',
                    ),
                    rowDottedWidget(
                      'you have never been convicted of or pled no contest to a felony, a sex crime, or any crime involving violence, and that you are not required to register as a sex offender with any state, federal or local sex offender registry.',
                    ),
                  ],
                ),
              ),
              sizedBox15,
              rowDottedWidget(
                'Your Account.',
                index: 3,
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''To use TruuBlue, you may sign in using several ways, including by telephone number, Apple login, or Facebook login. If you choose to use your Facebook login, you authorize us to access and use certain Facebook account information, including but not limited to your public Facebook profile. For more information regarding the information we collect from you and how we use it, please consult our Privacy Policy.''',
                  style: regualrText14,
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''You are responsible for maintaining the confidentiality of the login credentials you use to sign up for TruuBlue and you are solely responsible for all activities that occur under those credentials. If you think someone has gained access to your account, please immediately contact us.''',
                  style: regualrText14,
                ),
              ),
              sizedBox15,
              rowDottedWidget(
                'Modifying the Service and Termination.',
                index: 4,
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''TruuBlue is always striving to improve the Service and bring you additional functionality that you will find engaging and useful. This means we may add new product features or enhancements from time to time as well as remove some features, and if these actions do not materially affect your rights or obligations, we may not provide you with notice before taking them. We may even suspend the Service entirely, in which event we will notify you in advance unless extenuating circumstances, such as safety or security concerns, prevent us from doing so.''',
                  style: regualrText14,
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''You may terminate your account at any time, for any reason, by following the instructions in "Settings" in the Service. However, if you use a third-party payment account, you will need to manage in-app purchases through such account (e.g., iTunes, Google Play) to avoid additional billing.''',
                  style: regualrText14,
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''TruuBlue may terminate your account at any time without notice if it believes that you have violated this Agreement. Upon such termination, you will not be entitled to any refund for purchases. After your account is terminated, this Agreement will terminate, except that the following provisions will still apply to you and TruuBlue: Section 4, Section 5, and Sections 12 through 19.''',
                  style: regualrText14,
                ),
              ),
              sizedBox15,
              rowDottedWidget(
                'Safety; Your Interactions with Other Members.',
                index: 5,
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''Though TruuBlue strives to encourage a respectful member experience through features like the double opt-in that allows members to communicate only after they have both indicated interest in one another, TruuBlue is not responsible for the conduct of any member on or off the Service. You agree to use caution in all interactions with other members, particularly if you decide to communicate off the Service or meet in person. In addition, you agree to review and follow TruuBlue's Safety Tips prior to using the Service. You agree that you will not provide your financial information (for example, your credit card or bank account information), or wire or otherwise send money to other members.''',
                  style: regualrText14,
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''You may terminate your account at any time, for any reason, by following the instructions in "Settings" in the Service. However, if you use a third-party payment account, you will need to manage in-app purchases through such account (e.g., iTunes, Google Play) to avoid additional billing.''',
                  style: regualrText14,
                ),
              ),
              sizedBox15,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: RichText(
                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            '''YOU ARE SOLELY RESPONSIBLE FOR YOUR INTERACTIONS WITH OTHER MEMBERS. YOU UNDERSTAND THAT TRUUBLUE DOES NOT CONDUCT CRIMINAL BACKGROUND CHECKS ON ITS MEMBERS OR OTHERWISE INQUIRE INTO THE BACKGROUND OF ITS MEMBERS.''',
                        style: mediumText14.copyWith(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(
                        text:
                            '''TRUUBLUE MAKES NO REPRESENTATIONS OR WARRANTIES AS TO THE CONDUCT OR COMPATIBILITY OF MEMBERS. TRUUBLUE RESERVES THE RIGHT TO CONDUCT - AND YOU AUTHORIZE TRUUBLUE TO CONDUCT - ANY CRIMINAL BACKGROUND CHECK OR OTHER SCREENINGS (SUCH AS SEX OFFENDER REGISTER SEARCHES) AT ANY TIME USING AVAILABLE PUBLIC RECORDS OBTAINED BY IT OR WITH THE ASSISTANCE OF A CONSUMER REPORTING AGENCY, AND YOU AGREE THAT ANY INFORMATION YOU PROVIDE MAY BE USED FOR THAT PURPOSE.''',
                        style: regualrText14.copyWith(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              sizedBox15,
              rowDottedWidget(
                '''Rights TruuBlue Grants You.''',
                index: 6,
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''TruuBlue grants you a personal, worldwide, royalty-free, non-assignable, nonexclusive, revocable, and non-sublicensable license to access and use the Service. This license is for the sole purpose of letting you use and enjoy the Service's benefits as intended by TruuBlue and permitted by this Agreement. Therefore, you agree not to:''',
                  style: regualrText14,
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: rowDottedWidget(
                  '''use the Service or any content contained in the Service for any commercial purposes without our written consent;''',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: rowDottedWidget(
                  '''copy, modify, transmit, create any derivative works from, make use of, or reproduce in any way any copyrighted material, images, trademarks, trade names, service marks, or other intellectual property, content or proprietary information accessible through the Service without TruuBlue's prior written consent;''',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: rowDottedWidget(
                  '''express or imply that any statements you make are endorsed by TruuBlue;''',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: rowDottedWidget(
                  '''use any robot, bot, spider, crawler, scraper, site search/retrieval application, proxy or other manual or automatic device, method or process to access, retrieve, index, "data mine" or in any way reproduce or circumvent the navigational structure or presentation of the Service or its contents;''',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: rowDottedWidget(
                  '''use the Service in any way that could interfere with, disrupt, or negatively affect the Service or the servers or networks connected to the Service;''',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: rowDottedWidget(
                  '''upload viruses or other malicious code or otherwise compromise the security of the Service;''',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: rowDottedWidget(
                  '''use the Service or any content contained in the Service for any commercial purposes without our written consent;''',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: rowDottedWidget(
                  '''forge headers or otherwise manipulate identifiers in order to disguise the origin of any information transmitted to or through the Service;''',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: rowDottedWidget(
                  '''"frame" or "mirror" any part of the Service without TruuBlue's prior written authorization;''',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: rowDottedWidget(
                  '''use meta tags or code or other devices containing any reference to TruuBlue or the Service (or any trademark, trade name, service mark, logo, or slogan of TruuBlue) to direct any person to any other website for any purpose;''',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: rowDottedWidget(
                  '''modify, adapt, sublicense, translate, sell, reverse engineer, decipher, decompile, or otherwise disassemble any portion of the Service, or cause others to do so;''',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: rowDottedWidget(
                  '''use, access, or publish the TruuBlue application programming interface without our written consent;''',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: rowDottedWidget(
                  '''probe, scan or test the vulnerability of our Service or any system or network;''',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: rowDottedWidget(
                  '''encourage or promote any activity that violates this Agreement.''',
                ),
              ),
              sizedBox15,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''TruuBlue may investigate and take any available legal action in response to illegal and/ or unauthorized uses of the Service, including termination of your account.''',
                  style: regualrText14,
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''Any software that we provide you may automatically download and install upgrades, updates, or other new features. You may be able to adjust these automatic downloads through your device's settings.''',
                  style: regualrText14,
                ),
              ),
              sizedBox15,
              rowDottedWidget(
                ''' Rights you Grant TruuBlue.''',
                index: 7,
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''By creating an account, you grant to TruuBlue a worldwide, transferable, sub-licensable, royalty-free, right and license to host, store, use, copy, display, reproduce, adapt, edit, publish, modify and distribute information you authorize us to access from third parties such as Facebook, Google, or Apple, as well as any information you post, upload, display or otherwise make available (collectively, &ldquo;post&rdquo;) on the Service or transmit to other members (collectively, &ldquo;Content&rdquo;). TruuBlue&rsquo;s license to your Content shall be non-exclusive, except that TruuBlue&rsquo;s license shall be exclusive with respect to derivative works created through use of the Service. For example, TruuBlue would have an exclusive license to screenshots of the Service that include your Content. In addition, so that TruuBlue can prevent the use of your Content outside of the Service, you authorize TruuBlue to act on your behalf with respect to infringing uses of your Content taken from the Service by other members or third parties. This expressly includes the authority, but not the obligation, to send notices pursuant to 17 U.S.C. &sect; 512(c)(3) (i.e., DMCA Takedown Notices) on your behalf if your Content is taken and used by third parties outside of the Service. Our license to your Content is subject to your rights under applicable law (for example laws regarding personal data protection to the extent any Content contains personal information as defined by those laws) and is for the limited purpose of operating, developing, providing, and improving the Service and researching and developing new ones. You agree that any Content you place or that you authorize us to place on the Service may be viewed by other members and may be viewed by any person visiting or participating in the Service (such as individuals who may receive shared Content from other TruuBlue members).''',
                  style: regualrText14,
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''You agree that all information that you submit upon creation of your account, including information submitted from your Facebook account, is accurate and truthful and you have the right to post the Content on the Service and grant the license to TruuBlue above.''',
                  style: regualrText14,
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''You understand and agree that we may monitor or review any Content you post as part of a Service. We may delete any Content, in whole or in part, that in our sole judgment violates this Agreement or may harm the reputation of the Service.''',
                  style: regualrText14,
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''When communicating with our customer care representatives, you agree to be respectful and kind. If we feel that your behavior towards any of our customer care representatives or other employees is at any time threatening, harassing, or offensive, we reserve the right to immediately terminate your account.''',
                  style: regualrText14,
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''In consideration for TruuBlue allowing you to use the Service, you agree that we, our affiliates, and our third-party partners may place advertising on the Service. By submitting suggestions or feedback to TruuBlue regarding our Service, you agree that TruuBlue may use and share such feedback for any purpose without compensating you.''',
                  style: regualrText14,
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''You agree that TruuBlue may access, preserve and disclose your account information and Content if required to do so by law or in a good faith belief that such access, preservation or disclosure is reasonably necessary, such as to: (i) comply with legal process; (ii) enforce this Agreement; (iii) respond to claims that any Content violates the rights of third parties; (iv) respond to your requests for customer service; or (v) protect the rights, property or personal safety of the Company or any other person.''',
                  style: regualrText14,
                ),
              ),
              sizedBox15,
              rowDottedWidget(
                '''Community Rules.''',
                index: 8,
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''By using the Service, you agree that you will not:''',
                  style: regualrText14,
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: rowDottedWidget(
                  '''use the Service for any purpose that is illegal or prohibited by this Agreement;''',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: rowDottedWidget(
                  '''use the Service for any harmful or nefarious purpose;''',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: rowDottedWidget(
                  '''use the Service in order to damage TruuBlue;''',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: rowDottedWidget(
                  '''violate our Community Guidelines, as updated from time to time;''',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: rowDottedWidget(
                  '''spam, solicit money from or defraud any members;''',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: rowDottedWidget(
                  '''impersonate any person or entity or post any images of another person without his or her permission;''',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: rowDottedWidget(
                  '''bully, "stalk", intimidate, assault, harass, mistreat or defame any person;''',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: rowDottedWidget(
                  '''post any Content that violates or infringes anyone&rsquo;s rights, including rights of publicity, privacy, copyright, trademark or other intellectual property or contract right;''',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: rowDottedWidget(
                  '''post any Content that is hate speech, threatening, sexually explicit or pornographic; incites violence; or contains nudity or graphic or gratuitous violence;''',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: rowDottedWidget(
                  '''post any Content that promotes racism, bigotry, hatred or physical harm of any kind against any group or individual;''',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: rowDottedWidget(
                  '''solicit passwords for any purpose, or personal identifying information for commercial or unlawful purposes from other users or disseminate another person&rsquo;s personal information without his or her permission;''',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: rowDottedWidget(
                  '''use another user&rsquo;s account, share an account with another user, or maintain more than one account;''',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: rowDottedWidget(
                  '''create another account if we have already terminated your account, unless you have our permission.''',
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''TruuBlue reserves the right to investigate and/or terminate your account without a refund of any purchases if you have violated this Agreement, misused the Service or behaved in a way that TruuBlue regards as inappropriate or unlawful, including actions or communications that occur on or off the Service.''',
                  style: regualrText14,
                ),
              ),
              sizedBox15,
              rowDottedWidget(
                '''Other Member's Content.''',
                index: 9,
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''Although TruuBlue reserves the right to review and remove Content that violates this Agreement, such Content is the sole responsibility of the member who posts it, and TruuBlue cannot guarantee that all Content will comply with this Agreement. If you see Content on the Service that violates this Agreement, please report it within the Service or via our contact form.''',
                  style: regualrText14,
                ),
              ),
              sizedBox15,
              rowDottedWidget(
                '''Purchases.''',
                index: 10,
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: RichText(
                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '''Generally. ''',
                        style: boldText14.copyWith(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(
                        text:
                            '''From time to time, TruuBlue may offer products and services for purchase ("in-app purchases") through the App Store, Google Play Store, carrier billing, TruuBlue direct billing or other payment platforms authorized by TruuBlue. If you choose to make an in-app purchase, you will be prompted to confirm your purchase with the applicable payment provider, and your method of payment (be it your card or a third party account such as Google Play Store or the App Store) (your "Payment Method") will be charged at the prices displayed to you for the service(s) you've selected as well as any sales or similar taxes that may be imposed on your payments, and you authorize TruuBlue or the third party account, as applicable, to charge you.''',
                        style: regualrText14.copyWith(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: RichText(
                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '''Auto-Renewal. ''',
                        style: boldText14.copyWith(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(
                        text:
                            '''If you purchase an auto-recurring periodic subscription, your Payment Method will continue to be billed for the subscription until you cancel. After your initial subscription commitment period, and again after any subsequent subscription period, your subscription will automatically continue for an additional equivalent period, at the price you agreed to when subscribing. ''',
                        style: regualrText14.copyWith(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(
                        text:
                            '''If you do not wish your subscription to renew automatically, or if you want to change or terminate your subscription, you will need to access your third-party account (or Account Settings on TruuBlue, if applicable) and follow the instructions to cancel your subscription, even if you have otherwise deleted your account with us or deleted the TruuBlue application from your device. ''',
                        style: boldText14.copyWith(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(
                        text:
                            '''Deleting your account on TruuBlue or deleting the TruuBlue application from your device does not cancel your subscription; TruuBlue will retain all funds charged to your Payment Method until you cancel your subscription on TruuBlue or the third-party account, as applicable. If you cancel your subscription, you may use your subscription until the end of your then-current subscription term, and your subscription will not be renewed after your then-current term expires.''',
                        style: regualrText14.copyWith(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
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
                            '''Additional Terms that apply if you pay TruuBlue directly with your Payment Method. ''',
                        style: boldText14.copyWith(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(
                        text:
                            '''If you pay TruuBlue directly, TruuBlue may correct any billing errors or mistakes that it makes even if it has already requested or received payment. If you initiate a chargeback or otherwise reverse a payment made with your Payment Method, TruuBlue may terminate your account immediately in its sole discretion.''',
                        style: regualrText14.copyWith(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''You may edit your Payment Method information by visiting TruuBlue and going to Settings. If a payment is not successfully settled, due to expiration, insufficient funds, or otherwise, and you do not edit your Payment Method information or cancel your subscription, you remain responsible for any uncollected amounts and authorize us to continue billing the Payment Method, as it may be updated. This may result in a change to your payment billing dates. In addition, you authorize us to obtain updated or replacement expiration dates and card numbers for your credit or debit card as provided by your credit or debit card issuer. The terms of your payment will be based on your Payment Method and may be determined by agreements between you and the financial institution, credit card issuer or other provider of your chosen Payment Method. If you reside outside of the Americas, you agree that your payment to TruuBlue will be through TruuBlue LLL.''',
                  style: regualrText14,
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: RichText(
                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '''Virtual Items. ''',
                        style: boldText14.copyWith(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(
                        text:
                            '''From time to time, you may be able to purchase a limited, personal, non-transferable, non-sublicensable, revocable license to use &ldquo;virtual items,&rdquo; which could include virtual products or virtual &ldquo;coins&rdquo; or other units that are exchangeable within the Service for virtual products (collectively, &ldquo;Virtual Items&rdquo;). Any Virtual Item balance shown in your account does not constitute a real-world balance or reflect any stored value, but instead constitutes a measurement of the extent of your license. Virtual Items do not incur fees for non-use, however, the license granted to you in Virtual Items will terminate in accordance with the terms of this Agreement, when TruuBlue ceases providing the Service, or your account is otherwise closed or terminated. TruuBlue, in its sole discretion, reserves the right to charge fees for the right to access or use Virtual Items and may distribute Virtual Items with or without charge. TruuBlue may manage, regulate, control, modify or eliminate Virtual Items at any time. TruuBlue shall have no liability to you or any third party if TruuBlue exercises any such rights. Virtual Items may only be redeemed through the Service. ALL PURCHASES AND REDEMPTIONS OF VIRTUAL ITEMS MADE THROUGH THE SERVICE ARE FINAL AND NON-REFUNDABLE. The provision of Virtual Items for use in the Service is a service that commences immediately upon the acceptance of your purchase of such Virtual Items. YOU ACKNOWLEDGE THAT TRUUBLUE IS NOT REQUIRED TO PROVIDE A REFUND FOR ANY REASON, AND THAT YOU WILL NOT RECEIVE MONEY OR OTHER COMPENSATION FOR UNUSED VIRTUAL ITEMS WHEN AN ACCOUNT IS CLOSED, WHETHER SUCH CLOSURE WAS VOLUNTARY OR INVOLUNTARY.''',
                        style: regualrText14.copyWith(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: RichText(
                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '''Refunds. ''',
                        style: boldText14.copyWith(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(
                        text:
                            '''Generally, all charges for purchases are nonrefundable, and there are no refunds or credits for partially used periods. We may make an exception if a refund for a subscription offering is requested within fourteen days of the transaction date, or if the laws applicable in your jurisdiction provide for refunds.''',
                        style: regualrText14.copyWith(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''For subscribers residing in Arizona, California, Connecticut, Illinois, Iowa, Minnesota, New York, North Carolina, Ohio and Wisconsin, the terms below apply:''',
                  style: regualrText14,
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''You may cancel your subscription, without penalty or obligation, at any time prior to midnight of the third business day following the date you subscribed. In the event you die before the end of your subscription period, your estate shall be entitled to a refund of that portion of any payment you had made for your subscription which is allocable to the period after your death. In the event you become disabled (such that you are unable to use the services of TruuBlue) before the end of your subscription period, you shall be entitled to a refund of that portion of any payment you had made for your subscription which is allocable to the period after your disability by providing the company notice in the same manner as you request a refund as described below.''',
                  style: regualrText14,
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''To request a refund:''',
                  style: regualrText14,
                ),
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
                            '''If you subscribed using your Apple ID, refunds are handled by Apple, not TruuBlue. To request a refund, go to the App Store, click on your Apple ID, select &ldquo;Purchase history,&rdquo; find the transaction and select &ldquo;Report Problem&rdquo;. You can also submit a request at ''',
                        style: regualrText14.copyWith(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(
                        text: 'https://getsupport.apple.com',
                        style: regualrText14.copyWith(
                          fontSize: 14,
                          color: Color(COLOR_BLUE_BUTTON),
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap =
                              () => launch("https://getsupport.apple.com/"),
                      ),
                    ],
                  ),
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''If you subscribed using your Google Play Store account or through TruuBlue directly: please contact customer support with your order number for the Google Play Store (you can find the order number in the order confirmation email or by logging in to Google Wallet) or TruuBlue (you can find this on your confirmation email). You may also mail or deliver a signed and dated notice which states that you, the buyer, are canceling this Agreement, or words of similar effect. Please also include the email address or mobile number associated with your account along with your order number. This notice shall be sent to: TruuBlue, Attn: Cancellations, 8551 Strawberry Lane, Niwot, CO, USA (in addition, Ohio members may send a facsimile to 000-000-0000).''',
                  style: regualrText14,
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: RichText(
                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '''Pricing. ''',
                        style: boldText14.copyWith(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(
                        text:
                            '''TruuBlue operates a global business, and our pricing varies by a number of factors. We frequently offer promotional rates - which can vary based on region, length of subscription, bundle size and more. We also regularly test new features and payment options.''',
                        style: regualrText14.copyWith(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              sizedBox15,
              rowDottedWidget(
                '''Notice and Procedure for Making Claims of Copyright Infringement.''',
                index: 11,
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''If you believe that your work has been copied and posted on the Service in a way that constitutes copyright infringement, please submit a takedown request using the form here.''',
                  style: regualrText14,
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''If you contact us regarding alleged copyright infringement, please be sure to include the following information:''',
                  style: regualrText14,
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: rowDottedWidget(
                  '''an electronic or physical signature of the person authorized to act on behalf of the owner of the copyright interest;''',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: rowDottedWidget(
                  '''a description of the copyrighted work that you claim has been infringed;''',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: rowDottedWidget(
                  '''a description of where the material that you claim is infringing is located on the Service (and such description must be reasonably sufficient to enable us to find the alleged infringing material);''',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: rowDottedWidget(
                  '''your contact information, including address, telephone number and email address, and the copyright owner&rsquo;s identity;''',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: rowDottedWidget(
                  '''a written statement by you that you have a good faith belief that the disputed use is not authorized by the copyright owner, its agent, or the law;''',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: rowDottedWidget(
                  '''a written statement by you that you have a good faith belief that the disputed use is not authorized by the copyright owner, its agent, or the law;''',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: rowDottedWidget(
                  '''statement by you, made under penalty of perjury, that the above information in your notice is accurate and that you are the copyright owner or authorized to act on the copyright owner&rsquo;s behalf.''',
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''TruuBlue will terminate the accounts of repeat infringers.''',
                  style: regualrText14,
                ),
              ),
              sizedBox15,
              rowDottedWidget(
                'Disclaimers.',
                index: 12,
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''TRUUBLUE PROVIDES THE SERVICE ON AN "AS IS" AND "AS AVAILABLE" BASIS AND TO THE EXTENT PERMITTED BY APPLICABLE LAW, GRANTS NO WARRANTIES OF ANY KIND, WHETHER EXPRESS, IMPLIED, STATUTORY OR OTHERWISE WITH RESPECT TO THE SERVICE (INCLUDING ALL CONTENT CONTAINED THEREIN), INCLUDING, WITHOUT LIMITATION, ANY IMPLIED WARRANTIES OF SATISFACTORY QUALITY, MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE OR NON-INFRINGEMENT. TRUUBLUE DOES NOT REPRESENT OR WARRANT THAT (A) THE SERVICE WILL BE UNINTERRUPTED, SECURE OR ERROR FREE, (B) ANY DEFECTS OR ERRORS IN THE SERVICE WILL BE CORRECTED, OR (C) THAT ANY CONTENT OR INFORMATION YOU OBTAIN ON OR THROUGH THE SERVICE WILL BE ACCURATE.''',
                  style: regualrText14,
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''TRUUBLUE TAKES NO RESPONSIBILITY FOR ANY CONTENT THAT YOU OR ANOTHER MEMBER OR THIRD PARTY POSTS, SENDS OR RECEIVES THROUGH THE SERVICE. ANY MATERIAL DOWNLOADED OR OTHERWISE OBTAINED THROUGH THE USE OF THE SERVICE IS ACCESSED AT YOUR OWN DISCRETION AND RISK.''',
                  style: regualrText14,
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''TRUUBLUE DISCLAIMS AND TAKES NO RESPONSIBILITY FOR ANY CONDUCT OF YOU OR ANY OTHER MEMBER, ON OR OFF THE SERVICE.''',
                  style: regualrText14,
                ),
              ),
              sizedBox15,
              rowDottedWidget(
                'Third Party Services.',
                index: 13,
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''The Service may contain advertisements and promotions offered by third parties and links to other websites or resources. TruuBlue is not responsible for the availability (or lack of availability) of such external websites or resources. If you choose to interact with the third parties made available through our Service, such party's terms will govern their relationship with you. TruuBlue is not responsible or liable for such third parties&rsquo; terms or actions.''',
                  style: regualrText14,
                ),
              ),
              sizedBox15,
              rowDottedWidget(
                'Limitation of Liability.',
                index: 14,
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''TO THE FULLEST EXTENT PERMITTED BY APPLICABLE LAW, IN NO EVENT SHALL TRUUBLUE, ITS AFFILIATES, EMPLOYEES, LICENSORS OR SERVICE PROVIDERS BE LIABLE FOR ANY INDIRECT, CONSEQUENTIAL, EXEMPLARY, INCIDENTAL, SPECIAL, PUNITIVE, OR ENHANCED DAMAGES, INCLUDING, WITHOUT LIMITATION, LOSS OF PROFITS, WHETHER INCURRED DIRECTLY OR INDIRECTLY, OR ANY LOSS OF DATA, USE, GOODWILL, OR OTHER INTANGIBLE LOSSES, RESULTING FROM: (I) YOUR ACCESS TO OR USE OF OR INABILITY TO ACCESS OR USE THE SERVICE; (II) THE CONDUCT OR CONTENT OF OTHER MEMBERS OR THIRD PARTIES ON, THROUGH OR FOLLOWING USE OF THE SERVICE; OR (III) UNAUTHORIZED ACCESS, USE OR ALTERATION OF YOUR CONTENT, EVEN IF TRUUBLUE HAS BEEN ADVISED AT ANY TIME OF THE POSSIBILITY OF SUCH DAMAGES. NOTWITHSTANDING THE FOREGOING, IN NO EVENT SHALL TRUUBLUE's AGGREGATE LIABILITY TO YOU FOR ANY AND ALL CLAIMS ARISING OUT OF OR RELATING TO THE SERVICE OR THIS AGREEMENT EXCEED THE AMOUNT PAID, IF ANY, BY YOU TO TRUUBLUE DURING THE TWENTY-FOUR (24) MONTH PERIOD IMMEDIATELY PRECEDING THE DATE THAT YOU FIRST FILE A LAWSUIT, ARBITRATION OR ANY OTHER LEGAL PROCEEDING AGAINST TRUUBLUE, WHETHER IN LAW OR IN EQUITY, IN ANY TRIBUNAL. THE DAMAGES LIMITATION SET FORTH IN THE IMMEDIATELY PRECEDING SENTENCE APPLIES (i) REGARDLESS OF THE GROUND UPON WHICH LIABILITY IS BASED (WHETHER DEFAULT, CONTRACT, TORT, STATUTE, OR OTHERWISE), (ii) IRRESPECTIVE OF THE TYPE OF BREACH OF OBLIGATIONS, AND (iii) WITH RESPECT TO ALL EVENTS, THE SERVICE, AND THIS AGREEMENT.''',
                  style: regualrText14,
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''THE LIMITATION OF LIABILITY PROVISIONS SET FORTH IN THIS SECTION 14 SHALL APPLY EVEN IF YOUR REMEDIES UNDER THIS AGREEMENT FAIL WITH RESPECT TO THEIR ESSENTIAL PURPOSE.''',
                  style: regualrText14,
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''SOME JURISDICTIONS DO NOT ALLOW THE EXCLUSION OR LIMITATION OF CERTAIN DAMAGES, SO SOME OR ALL OF THE EXCLUSIONS AND LIMITATIONS IN THIS SECTION MAY NOT APPLY TO YOU.''',
                  style: regualrText14,
                ),
              ),
              sizedBox15,
              rowDottedWidget(
                '''Retroactive and Prospective Arbitration, Class-Action Waiver, and Jury Waiver.''',
                index: 15,
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''Except where prohibited by applicable law:''',
                  style: regualrText14,
                ),
              ),
              sizedBox15,
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: rowDottedWidget(
                  '''The exclusive means of resolving any dispute or claim arising out of or relating to this Agreement (including any alleged breach thereof), or the Service, regardless of the date of accrual and including past, pending, and future claims, shall be BINDING ARBITRATION administered by JAMS under the JAMS Streamlined Arbitration Rules & Procedures, except as modified by our Arbitration Procedures. The one exception to the exclusivity of arbitration is that either party has the right to bring an individual claim against the other in a small claims court of competent jurisdiction, or, if filed in arbitration, the responding party may request that the dispute proceed in small claims court instead if the claim is within the jurisdiction of the small claims court. If the request to proceed in small claims court is made before an arbitrator has been appointed, the arbitration shall be administratively closed. If the request to proceed in small claims court is made after an arbitrator has been appointed, the arbitrator shall determine whether the dispute should remain in arbitration or instead be decided in small claims court. Such arbitration shall be conducted by written submissions only, unless either you or TruuBlue elect to invoke the right to an oral hearing before the Arbitrator. But whether you choose arbitration or small claims court, you agree that you will not under any circumstances commence, maintain, or participate in any class action, class arbitration, or other representative action or proceeding against TruuBlue.''',
                  index: 1,
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: rowDottedWidget(
                  '''By accepting this Agreement, you agree to the Arbitration Agreement in this Section 15. In doing so, BOTH YOU AND TRUUBLUE GIVE UP THE RIGHT TO GO TO COURT to assert or defend any claims between you and TruuBlue (except for matters that may be properly taken to a small claims court and are within such court's jurisdiction). YOU ALSO GIVE UP YOUR RIGHT TO PARTICIPATE IN A CLASS ACTION OR OTHER CLASS PROCEEDING, including, without limitation, any past, pending or future class actions, including those existing as of the date of this Agreement.''',
                  index: 2,
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: rowDottedWidget(
                  '''If you assert a claim against TruuBlue outside of small claims court (and TruuBlue does not request that the claim be moved to small claims court), your rights will be determined by a NEUTRAL ARBITRATOR, NOT A JUDGE OR JURY, and the arbitrator shall determine all claims and all issues regarding the arbitrability of the dispute. The same is true for TruuBlue. Both you and TruuBlue are entitled to a fair hearing before the arbitrator. The arbitrator can generally grant the relief that a court can, including the ability to hear a dispositive motion (which may include a dispositive motion based upon the partie's pleadings, as well as a dispositive motion based upon the partie's pleadings along with the evidence submitted), but you should note that arbitration proceedings are usually simpler and more streamlined than trials and other judicial proceedings. Decisions by the arbitrator are enforceable in court and may be overturned by a court only for very limited reasons. For details on the arbitration process, see our Arbitration Procedures.''',
                  index: 3,
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: rowDottedWidget(
                  '''The Jurisdiction and Venue provisions in Sections 16 and 17 are incorporated and are applicable to this Arbitration Agreement.''',
                  index: 4,
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''As you decide whether to agree to this Arbitration Agreement, here are some important considerations:''',
                  style: regualrText14,
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: rowDottedWidget(
                  '''Arbitration is a process of private dispute resolution that does not involve the civil courts, a civil judge, or a jury. Instead, the partie's dispute is decided by a private arbitrator selected by the parties under the JAMS Streamlined Arbitration Rules & Procedures. Arbitration does not limit or affect the legal claims you as an individual may bring against TruuBlue. Agreeing to arbitration will only affect where those claims may be brought and how they will be resolved.''',
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: rowDottedWidget(
                  '''Arbitration is generally considered to be a more rapid dispute resolution process than the judicial system, but that is not always the case. The Arbitrator will typically determine whether TruuBlue or you will be required to pay or split the cost of any arbitration with TruuBlue, based on the circumstances presented.''',
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: rowDottedWidget(
                  '''IMPORTANT: THERE ARE NOW, AND MAY BE IN THE FUTURE, LAWSUITS AGAINST TRUUBLUE ALLEGING CLASS AND/OR REPRESENTATIVE CLAIMS ON YOUR BEHALF INCLUDING BUT NOT LIMITED TO CLASS ACTIONS DESCRIBED IN THIS SECTION 15, WHICH IF SUCCESSFUL, COULD POTENTIALLY RESULT IN SOME MONETARY OR OTHER RECOVERY TO YOU, IF YOU ELECT TO OPT OUT OF THE RETROACTIVE APPLICATION OF THIS ARBITRATION AGREEMENT. THE MERE EXISTENCE OF SUCH CLASS AND/OR REPRESENTATIVE LAWSUITS, HOWEVER, DOES NOT MEAN THAT SUCH LAWSUITS WILL ULTIMATELY SUCCEED, OR, EVEN IF SUCCESSFUL, THAT YOU WOULD BE ENTITLED TO ANY RECOVERY.''',
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: rowDottedWidget(
                  '''You will be precluded from bringing any class or representative action against TruuBlue, unless you timely opt out of the retroactive application of this Arbitration Agreement, and you will also be precluded from participating in any recovery resulting from any class or representative action brought against TruuBlue, in each case provided you are not already bound by an arbitration agreement and class action waiver previously agreed to with TruuBlue.''',
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''WHETHER TO AGREE TO THIS ARBITRATION AGREEMENT IS AN IMPORTANT DECISION. IT IS YOUR DECISION TO MAKE, AND YOU SHOULD TAKE CARE TO CONDUCT FURTHER RESEARCH AND TO CONSULT WITH OTHERS - INCLUDING BUT NOT LIMITED TO AN ATTORNEY - REGARDING THE CONSEQUENCES OF YOUR DECISION, JUST AS YOU WOULD WHEN MAKING ANY OTHER IMPORTANT BUSINESS OR LIFE DECISION.''',
                  style: regualrText14,
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''IF FOR ANY REASON THIS ARBITRATION AGREEMENT IS FOUND TO BE INVALID, YOU WILL NEVERTHELESS STILL BE BOUND BY ANY PRIOR VALID ARBITRATION AGREEMENT THAT YOU ENTERED INTO WITH TRUUBLUE.''',
                  style: regualrText14,
                ),
              ),
              sizedBox15,
              rowDottedWidget(
                '''Governing Law.''',
                index: 16,
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''Except where our arbitration agreement is prohibited by law, the laws of Colorado, U.S.A., without regard to its conflict of laws rules, shall apply to any disputes arising out of or relating to this Agreement, the Service, or your relationship with TruuBlue. Notwithstanding the foregoing, the Arbitration Agreement in Section 15 above shall be governed by the Federal Arbitration Act.''',
                  style: regualrText14,
                ),
              ),
              sizedBox15,
              rowDottedWidget(
                '''Venue.''',
                index: 17,
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''Except for claims that may be properly brought in a small claims court of competent jurisdiction, all claims arising out of or relating to this Agreement, to the Service, or to your relationship with TruuBlue that for whatever reason are not submitted to arbitration will be litigated exclusively in the federal or state courts of Boulder County, Colorado, U.S.A. You and TruuBlue consent to the exercise of personal jurisdiction of courts in the State of Colorado and waive any claim that such courts constitute an inconvenient forum.''',
                  style: regualrText14,
                ),
              ),
              sizedBox15,
              rowDottedWidget(
                '''Indemnity by You.''',
                index: 18,
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''You agree, to the extent permitted under applicable law, to indemnify, defend and hold harmless TruuBlue, its affiliates, and their and our respective officers, directors, agents, and employees from and against any and all complaints, demands, claims, damages, losses, costs, liabilities and expenses, including attorney&rsquo;s fees, due to, arising out of, or relating in any way to your access to or use of the Service, your Content, or your breach of this Agreement.''',
                  style: regualrText14,
                ),
              ),
              sizedBox15,
              rowDottedWidget(
                '''Entire Agreement.''',
                index: 19,
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''This Agreement, which includes the Privacy Policy, Cookie Policy, Safety Tips, Community Guidelines, and Arbitration Procedures, and any terms disclosed to you if you purchase or have purchased additional features, products, or services we offer on the Service, contains the entire agreement between you and TruuBlue regarding your relationship with TruuBlue and the use of the Service. If any provision of this Agreement is held invalid, the remainder of this Agreement shall continue in full force and effect. The failure of TruuBlue to exercise or enforce any right or provision of this Agreement shall not constitute a waiver of such right or provision. You agree that your TruuBlue account is non-transferable and all your rights to your account and its Content terminate upon your death. No agency, partnership, joint venture, fiduciary or other special relationship or employment is created as a result of this Agreement and you may not make any representations on behalf of or bind TruuBlue in any manner.''',
                  style: regualrText14,
                ),
              ),
              sizedBox15,
            ],
          ),
        ),
      ),
    );
  }
}
