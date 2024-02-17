import 'package:dating/common/common_widget.dart';
import 'package:dating/constants.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/theme/textstyle.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

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
          'Privacy Policy'.tr(),
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
                'Last revised on December 15, 2021',
                style: regualrText14,
              ),
              sizedBox10,
              Text(
                "Welcome to TruuBlue's Privacy Policy. Thank you for taking the time to read it.",
                style: regualrText14,
              ),
              sizedBox10,
              Text(
                "We appreciate that you trust us with your information and we intend to maintain that trust. This starts with making sure you understand the information we collect, why we collect it, how it is used and the choices regarding your information.",
                style: regualrText14,
              ),
              sizedBox10,
              Text(
                "For California Consumers",
                style: regualrText14,
              ),
              sizedBox10,
              Text(
                "Please see our California Privacy Statement to learn about California privacy rights.",
                style: regualrText14,
              ),
              sizedBox15,
              rowDottedWidget(
                '''Who We Are''',
                index: 1,
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''The company responsible for your information under this Privacy Policy (the "data controller") is:''',
                  style: regualrText14,
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''TruuBlue LLC
8551 Strawberry Lane
Niwot, CO 80503
United States''',
                  style: regualrText14,
                ),
              ),
              sizedBox15,
              rowDottedWidget(
                '''Where This Privacy Policy Applies''',
                index: 2,
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''This Privacy Policy applies to websites, apps, events, and other services we operate under the TruuBlue brand. We refer to all of these as our "services" in this Privacy Policy.''',
                  style: regualrText14,
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''Some services may require their own unique privacy policy. If a service has its own privacy policy, then that policy, not this Privacy Policy, applies.''',
                  style: regualrText14,
                ),
              ),
              sizedBox15,
              rowDottedWidget(
                '''Information We Collect''',
                index: 3,
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''Obviously, we can't help you develop meaningful connections without some information about you, such as basic profile details and the types of people you'r like to meet. We also collect information about your use of our services such as access logs, as well as information from third parties, like when you access our services through your social media account or when you upload information from your social media account to complete your profile. If you want additional info, we go into more detail below.''',
                  style: regualrText14,
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''Information you give us''',
                  style: regualrText14,
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''You choose to give us certain information when using our services. This information includes the following.''',
                  style: regualrText14,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  children: [
                    sizedBox10,
                    rowDottedWidget(
                      '''When you create an account, you provide us with at least your phone number and email address, as well as some basic details necessary for the service to work, such as your gender and date of birth.''',
                    ),
                    rowDottedWidget(
                      '''When you complete your profile, you can share with us additional information, such as details on your bio, interests, and other details about you, as well as content such as photos and videos. To add certain content, like pictures, you may allow us to access your camera or photo album.''',
                    ),
                    rowDottedWidget(
                      '''When you subscribe to a paid service or make a purchase directly from us (rather than through a platform such as iOS or Android), you provide us our payment service provider with information, such as your debit or credit card number or other financial information.''',
                    ),
                    rowDottedWidget(
                      '''When you participate in surveys, focus groups or market studies, you give us your insights into our products and services, responses to our questions and testimonials.''',
                    ),
                    rowDottedWidget(
                      '''When you choose to participate in our promotions, events, or contests, we collect the information that you use to register or enter.''',
                    ),
                    rowDottedWidget(
                      '''If you contact our customer care team, we may collect the information you give us during the interaction.''',
                    ),
                    rowDottedWidget(
                      '''If you share with us information about other people (for example, if you use contact details of a friend for a given feature), we process this information on your behalf in order to complete your request.''',
                    ),
                    rowDottedWidget(
                      '''Of course, we also process your chats with other members as well as the content you publish, as necessary for the operation of the services.''',
                    ),
                    sizedBox10,
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'Information we receive from others',
                  style: regualrText14,
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'In addition to the information you may provide us directly, we receive information about you from others, including:',
                  style: regualrText14,
                ),
              ),
              sizedBox10,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '  •  ',
                    style: boldText16,
                  ),
                  Expanded(
                    child: RichText(
                      textScaleFactor: MediaQuery.of(context).textScaleFactor,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '''Members. ''',
                            style: boldText14.copyWith(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                            text:
                                "Members may provide information about you as they use our services, for instance as they interact with you or if they submit a report involving you.",
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '  •  ',
                    style: boldText16,
                  ),
                  Expanded(
                    child: RichText(
                      textScaleFactor: MediaQuery.of(context).textScaleFactor,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '''Social Media. ''',
                            style: boldText14.copyWith(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                            text:
                                "You may decide to share information with us through your social media account, for instance if you decide to create and log into your TruuBlue account via your social media or other account (e.g., Facebook, Google or Apple) or to upload onto our services information such as photos from one of your social media accounts (e.g., Instagram or Spotify).",
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '  •  ',
                    style: boldText16,
                  ),
                  Expanded(
                    child: RichText(
                      textScaleFactor: MediaQuery.of(context).textScaleFactor,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '''Affiliates. ''',
                            style: boldText14.copyWith(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                            text:
                                "TruuBlue considers the safety and security of members a top priority. If you were banned from another dating or social media service, your information can be shared with us to allow us to take necessary actions, including closing your account or preventing you from creating an account on our services.",
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '  •  ',
                    style: boldText16,
                  ),
                  Expanded(
                    child: RichText(
                      textScaleFactor: MediaQuery.of(context).textScaleFactor,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '''Other Partners. ''',
                            style: boldText14.copyWith(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                            text:
                                "We may receive information about you from our partners where TruuBlue ads are published on a partner's service (in which case they may pass along details on a campaign's success). Where legally allowed, we can also receive information about suspected or convicted bad actors from third parties as part of our efforts to ensure our member's safety and security.",
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
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'Information collected when you use our services',
                  style: regualrText14,
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "When you use our services, this generates technical data about which features you're used, how you've used them and the devices you use to access our services. See below for more details:",
                  style: regualrText14,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  children: [
                    sizedBox10,
                    rowDottedWidget(
                      '''Usage Information Using the services generates data about your activity on our services, for instance how you use them (e.g., when you logged in, features you've been using, actions taken, information shown to you, referring webpages address and ads that you interacted with) and your interactions with other members (e.g., members you connect and interact with, when you exchanged with them, number of messages you send and receive).''',
                    ),
                    rowDottedWidget(
                      '''Device information We collect information from and about the device(s) you use to access our services, including hardware and software information such as IP address, device ID and type, apps settings and characteristics, app crashes, advertising IDs (which are randomly generated numbers that you can reset by going into your device's settings), identifiers associated with cookies or other technologies that may uniquely identify a device or browser.''',
                    ),
                    rowDottedWidget(
                      '''Other information with your consent If you give us permission, we can collect your precise geolocation (latitude and longitude). The collection of your geolocation may occur in the background even when you aren&rsquo;t using the services if the permission you gave us expressly permits such collection. If you decline permission for us to collect your precise geolocation, we will not collect it. Similarly, if you consent, we may collect photos and videos (for instance, if you want to publish a photo or video or participate in streaming features on our services).''',
                    ),
                  ],
                ),
              ),
              sizedBox15,
              rowDottedWidget(
                'Cookies and Other Similar Data Collection Technologies',
                index: 4,
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''We use and may allow others to use cookies and similar technologies (e.g., web beacons, pixels, SDKs) to recognize you and/or your device(s). You may read our Cookie Policy for more information on why we use them and how you can better control their use.''',
                  style: regualrText14,
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''Some web browsers (including Safari, Internet Explorer, Firefox, and Chrome) have a "Do Not Trackr" ("DNT") feature that tells a website that a user does not want to have his or her online activity tracked. If a website that responds to a DNT signal receives a DNT signal, the browser can block that website from collecting certain information about the browser's user. Not all browsers offer a DNT option and DNT signals are not yet uniform. For this reason, many businesses, including TruuBlue, do not currently respond to DNT signals.''',
                  style: regualrText14,
                ),
              ),
              sizedBox15,
              rowDottedWidget(
                'How We Use Information',
                index: 5,
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''The main reason we use your information is to deliver and improve our services. Additionally, we use your info to help keep you safe, and to provide you with advertising that may be of interest to you. Read on for a more detailed explanation of the various reasons for which we use your information, together with practical examples.''',
                  style: regualrText14,
                ),
              ),
              sizedBox15,
              rowAlfaWidget(
                  '''To administer your account and provide our services to you''',
                  index: 'A.'),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  children: [
                    sizedBox10,
                    rowDottedWidget(
                      '''Create and manage your account''',
                    ),
                    rowDottedWidget(
                      '''Provide you with customer support and respond to your requests''',
                    ),
                    rowDottedWidget(
                      '''Complete your transactions''',
                    ),
                    rowDottedWidget(
                      '''Communicate with you about our services''',
                    ),
                    sizedBox10,
                  ],
                ),
              ),
              sizedBox10,
              rowAlfaWidget('''To help you connect with other users''',
                  index: 'B.'),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  children: [
                    sizedBox10,
                    rowDottedWidget(
                      '''Recommend other members for you to meet''',
                    ),
                    rowDottedWidget(
                      '''Show member'sprofiles to one another''',
                    ),
                  ],
                ),
              ),
              sizedBox10,
              rowAlfaWidget('''To provide new TruuBlue services to you''',
                  index: 'C.'),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  children: [
                    sizedBox10,
                    rowDottedWidget(
                      '''Register you and display your profile on new TruuBlue features and apps''',
                    ),
                    rowDottedWidget(
                      '''Administer your account on these new features and apps''',
                    ),
                  ],
                ),
              ),
              sizedBox10,
              rowAlfaWidget(
                  '''To operate advertising and marketing campaigns''',
                  index: 'D.'),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  children: [
                    sizedBox10,
                    rowDottedWidget(
                      '''Administer sweepstakes, contests, discounts, or other offers''',
                    ),
                    rowDottedWidget(
                      '''Perform and measure the effectiveness of advertising campaigns on our services and marketing campaigns promoting TruuBlue off our services''',
                    ),
                    rowDottedWidget(
                      '''Communicate with you about products or services that we believe may interest you''',
                    ),
                  ],
                ),
              ),
              sizedBox10,
              rowAlfaWidget('''To improve our services and develop new ones''',
                  index: 'E.'),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  children: [
                    sizedBox10,
                    rowDottedWidget(
                      '''Administer focus groups, market studies and surveys''',
                    ),
                    rowDottedWidget(
                      '''Review interactions with customer care teams to improve our quality of service''',
                    ),
                    rowDottedWidget(
                      '''Understand how members typically use the services to improve them (for instance, we may decide to change the look and feel or even substantially modify a given feature based on how members react to it)''',
                    ),
                    rowDottedWidget(
                      '''Develop new features and services (for example, we may decide to build a new interests-based feature further to requests received from members).''',
                    ),
                  ],
                ),
              ),
              sizedBox10,
              rowAlfaWidget(
                '''To prevent, detect and fight fraud and other illegal or unauthorized activities''',
                index: 'F.',
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  children: [
                    rowDottedWidget(
                      '''Find and address ongoing, suspected, or alleged violations of our Terms of Use, notably through the review of reports and interactions between members''',
                    ),
                    rowDottedWidget(
                      '''Better understand and design countermeasures against violations of our Terms of Use''',
                    ),
                    rowDottedWidget(
                      '''Retain data related to violations of our Terms of Use to prevent against recurrences''',
                    ),
                    rowDottedWidget(
                      '''Enforce or exercise our rights, for example our Terms of Use''',
                    ),
                    rowDottedWidget(
                      '''Communicate to individuals who submit a report, what we've done as a result of their submission''',
                    ),
                  ],
                ),
              ),
              sizedBox10,
              rowAlfaWidget(
                '''To ensure legal compliance''',
                index: 'G.',
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  children: [
                    sizedBox10,
                    rowDottedWidget(
                      '''Comply with legal requirements''',
                    ),
                    rowDottedWidget(
                      '''Assist law enforcement''',
                    ),
                  ],
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''For information on how we process personal information through profiling and automated decision-making, please see our FAQ.''',
                  style: regualrText14,
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''To process your information as described in this Privacy Policy, we rely on the following legal bases:''',
                  style: regualrText14,
                ),
              ),
              sizedBox10,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '  •  ',
                    style: boldText16,
                  ),
                  Expanded(
                    child: RichText(
                      textScaleFactor: MediaQuery.of(context).textScaleFactor,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '''Provide our service to you: ''',
                            style: boldText14.copyWith(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                            text:
                                "The reason we process your information for purposes A, B and C above is to perform the contract that you have with us. For instance, as you use our service to build meaningful connections, we use your information to maintain your account and your profile, make it viewable to other members and recommend other members to you and to otherwise provide our free and paid features to you and other members.",
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '  •  ',
                    style: boldText16,
                  ),
                  Expanded(
                    child: RichText(
                      textScaleFactor: MediaQuery.of(context).textScaleFactor,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '''Legitimate interests: ''',
                            style: boldText14.copyWith(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                            text:
                                "We process your information for purposes D, E and F above, based on our legitimate interest. For instance, we analyze users&rsquo; behavior on our services to continuously improve our offerings, we suggest offers we think might interest you and promote our own services, we process information to help keep our members safe and we process data where necessary to enforce our rights, assist law enforcement and enable us to defend ourselves in the event of a legal action.",
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '  •  ',
                    style: boldText16,
                  ),
                  Expanded(
                    child: RichText(
                      textScaleFactor: MediaQuery.of(context).textScaleFactor,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                '''Comply with applicable laws and regulations: ''',
                            style: boldText14.copyWith(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                            text:
                                "We process your information for purpose G above where it is necessary for us to comply with applicable laws and regulations and evidence our compliance with applicable laws and regulations. For example, we retain traffic data and data about transactions in line with our accounting, tax, and other statutory data retention obligations and to be able to respond to valid access requests from law enforcement. We also keep data evidencing consents members give us and decisions they may have taken to opt-out of a given feature or processing.",
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '  •  ',
                    style: boldText16,
                  ),
                  Expanded(
                    child: RichText(
                      textScaleFactor: MediaQuery.of(context).textScaleFactor,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '''Consent: ''',
                            style: boldText14.copyWith(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                            text:
                                '''If you choose to provide us with information that may be considered "special" or "sensitive" in certain jurisdictions, such as your sexual orientation, you're consenting to our processing of that information in accordance with this Privacy Policy. From time to time, we may ask for your consent to collect specific information such as your precise geolocation or use your information for certain specific reasons. In some cases, you may withdraw your consent by adapting your settings (for instance in relation to the collection of our precise geolocation) or by deleting your content (for instance where you entered information in your profile that may be considered 'special' or "sensitive"). In any case, you may withdraw your consent at any time by contacting us at the address provided at the end of this Privacy Policy.''',
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
              sizedBox15,
              rowDottedWidget(
                'How We Share Information',
                index: 6,
              ),
              sizedBox10,
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  '''Since our goal is to help you make meaningful connections, the main sharing of members&rsquo; information is, of course, with other members. We also share some members&rsquo; information with service providers and partners who assist us in operating the services, with other Match Group companies for specified reasons as laid out below and, in some cases, legal authorities. Read on for more details about how your information is shared with others.''',
                ),
              ),
              sizedBox10,
              rowDottedWidget(
                'With other members',
              ),
              sizedBox10,
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  '''You share information with other members when you voluntarily disclose information on the service (including your public profile). Please be careful with your information and make sure that the content you share is stuff that you&rsquo;re comfortable being visible.''',
                ),
              ),
              sizedBox10,
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  '''If you choose to limit the audience for all or part of your profile or for certain content or information about you, then it will be visible according to your settings.''',
                ),
              ),
              sizedBox10,
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  '''If someone submits a report involving you (such as a claim you violated our Terms of Use), We may communicate to the reporter actions, if any, we took as a result of their report.''',
                ),
              ),
              sizedBox10,
              rowDottedWidget(
                'With our service providers and partners',
              ),
              sizedBox10,
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  '''We use third parties to help us operate and improve our services. These third parties assist us with various tasks, including data hosting and maintenance, analytics, customer care, marketing, advertising, payment processing and security operations. We also share information with partners who distribute and assist us in advertising our services. For instance, we may share limited information on you in hashed, non-human readable form to advertising partners.''',
                ),
              ),
              sizedBox10,
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  '''We follow a strict vetting process prior to engaging any service provider or working with any partner. Our service providers and partners must agree to strict confidentiality obligations.''',
                ),
              ),
              sizedBox10,
              rowDottedWidget(
                'With our affiliates',
              ),
              sizedBox10,
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  '''We share your information with affiliates for limited legitimate purposes as laid out below:''',
                ),
              ),
              sizedBox10,
              rowDottedWidget(
                'to make TruuBlue safer and enable us to address bad actors and for affiliates to assist us in data processing operations, as service providers, upon our instructions and on our behalf. Their assistance may include technical processing operations, such as data hosting and maintenance, customer care, marketing and targeted advertising, analytics, finance and accounting assistance, improving our service, securing our data and systems, and fighting against spam, abuse, fraud, infringement, and other wrong doings.',
              ),
              sizedBox10,
              rowDottedWidget(
                'Sharing functionality',
              ),
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  '''You may share other members&rsquo; profiles and they may share yours with people outside of our services, using the sharing functionality.''',
                ),
              ),
              sizedBox10,
              rowDottedWidget(
                'For corporate transactions',
              ),
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  '''We may transfer your information if we are involved, whether in whole or in part, in a merger, sale, acquisition, divestiture, restructuring, reorganization, dissolution, bankruptcy or other change of ownership or control.''',
                ),
              ),
              sizedBox10,
              rowDottedWidget(
                'With law enforcement / when required by law',
              ),
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  '''We may disclose your information if reasonably necessary: (i) to comply with a legal process, such as a court order, subpoena or search warrant, government / law enforcement investigation or other legal requirements; (ii) to assist in the prevention or detection of crime (subject in each case to applicable law); or (iii) to protect the safety of any person.''',
                ),
              ),
              sizedBox10,
              rowDottedWidget(
                'To enforce legal rights',
              ),
              sizedBox10,
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  '''We may also share information: (i) if disclosure would mitigate our liability in an actual or threatened lawsuit; (ii) as necessary to protect our legal rights and legal rights of our members, business partners or other interested parties; (iii) to enforce our agreements with you; and (iv) to investigate, prevent, or take other action regarding illegal activity, suspected fraud, or other wrong doing.''',
                ),
              ),
              sizedBox10,
              rowDottedWidget(
                'With your consent or at your request',
              ),
              sizedBox10,
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  '''We may ask for your consent to share your information with third parties. In any such case, we will make it clear why we want to share the information.''',
                ),
              ),
              sizedBox10,
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  '''We may use and share non-personal information (meaning information that, by itself, does not identify who you are such as device information, general demographics, general behavioral data, geolocation in de-identified form), as well as personal information in hashed, non-human readable form, under any of the above circumstances. We may also share this information with other Match Group companies and third parties (notably advertisers) to develop and deliver targeted advertising on our services and on websites or applications of third parties, and to analyze and report on advertising you see. We may combine this information with additional non-personal information or personal information in hashed, non-human readable form collected from other sources. More information on our use of cookies and similar technologies can be found in our Cookie Policy''',
                ),
              ),
              sizedBox15,
              rowDottedWidget(
                'Cross-Border Data Transfers',
                index: 7,
              ),
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  '''Sharing of information laid out in Section 6 involves cross-border data transfers to the United States of America and other jurisdictions that may have different laws about data processing.''',
                ),
              ),
              sizedBox15,
              rowDottedWidget(
                'Your Rights',
                index: 8,
              ),
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  '''We want you to be in control of your information, so we want to remind you of the following options and tools available to you:''',
                ),
              ),
              sizedBox10,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '  •  ',
                    style: boldText16,
                  ),
                  Expanded(
                    child: RichText(
                      textScaleFactor: MediaQuery.of(context).textScaleFactor,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '''Access / Update tools in the service. ''',
                            style: boldText14.copyWith(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                            text:
                                "Tools and account settings can help you access, rectify, or remove information that you provided to us and that&rsquo;s associated with your account directly within the service. If you have any question on those tools and settings, please contact our customer care team for help here.",
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '  •  ',
                    style: boldText16,
                  ),
                  Expanded(
                    child: RichText(
                      textScaleFactor: MediaQuery.of(context).textScaleFactor,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '''Device permissions. ''',
                            style: boldText14.copyWith(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                            text:
                                "Mobile platforms can have permission systems for specific types of device data and notifications, such as phone contacts, pictures, location services, push notifications and advertising identifiers. You can change your settings on your device to either consent or oppose the collection or processing of the corresponding information or the display of the corresponding notifications. Of course, if you do that, certain services may lose functionality.",
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '  •  ',
                    style: boldText16,
                  ),
                  Expanded(
                    child: RichText(
                      textScaleFactor: MediaQuery.of(context).textScaleFactor,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '''Uninstall. ''',
                            style: boldText14.copyWith(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                            text:
                                "You can stop all information collection by an app by uninstalling it using the standard uninstall process for your device. Remember that uninstalling an app does NOT close your account. To close your account, please use the corresponding functionality on the service.",
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '  •  ',
                    style: boldText16,
                  ),
                  Expanded(
                    child: RichText(
                      textScaleFactor: MediaQuery.of(context).textScaleFactor,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '''Account closure. ''',
                            style: boldText14.copyWith(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                            text:
                                "You can close your account by using the corresponding functionality directly on the service.",
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
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'We also want you to be aware of your privacy rights. Here are a few key points to remember:',
                  style: regualrText14,
                ),
              ),
              sizedBox10,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '  •  ',
                    style: boldText16,
                  ),
                  Expanded(
                    child: RichText(
                      textScaleFactor: MediaQuery.of(context).textScaleFactor,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '''Reviewing your information. ''',
                            style: boldText14.copyWith(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                            text:
                                "Applicable privacy laws may give you the right to review the personal information we keep about you (depending on the jurisdiction, this may be called right of access, right of portability, right to know or variations of those terms). You can exercise this right by submitting such a request here.",
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '  •  ',
                    style: boldText16,
                  ),
                  Expanded(
                    child: RichText(
                      textScaleFactor: MediaQuery.of(context).textScaleFactor,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '''Updating your information. ''',
                            style: boldText14.copyWith(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                            text:
                                "If you believe that the information we hold about you is inaccurate or that we are no longer entitled to use it and want to request its rectification, deletion, object to or restrict its processing, please contact us here.",
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
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'For your protection and the protection of all our members, we may ask you to provide proof of identity before we can answer the above requests.',
                  style: regualrText14,
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'Keep in mind, we may reject requests, including if we are unable to authenticate you, if the request is unlawful or invalid, or if it may infringe on trade secrets or intellectual property or the privacy or other rights of someone else. If you wish to receive information relating to another member, such as a copy of any messages you received from them through our service, the other member will have to contact us to provide their written consent before the information is released. We may also ask them to provide proof of identity before we can answer the request.',
                  style: regualrText14,
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'Also, we may not be able to accommodate certain requests to object to or restrict the processing of personal information, notably where such requests would not allow us to provide our service to you anymore. For instance, we cannot provide our service if we do not have your date of birth and thus cannot ensure that you are 18 years of age or older.',
                  style: regualrText14,
                ),
              ),
              sizedBox15,
              rowDottedWidget(
                'How Long We Retain Your Information',
                index: 9,
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''We keep your personal information only as long as we need it for legitimate business purposes (as laid out in Section 5) and as permitted by applicable law. If you decide to stop using our services, you can close your account and your profile will stop being visible to other members. Note that we will close your account automatically if you are inactive for a period of two years. After your account is closed, we will delete your personal information, as laid out below:''',
                  style: regualrText14,
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: rowDottedWidget(
                  '''To protect the safety and security of our members, we implement a safety retention window of three months following account closure, or one year following an account ban. During this period, we keep your information in the event it might be necessary to investigate unlawful or harmful conducts. The retention of information during this safety retention window is based on our legitimate interest as well as that of potential third-party victims.''',
                  index: 1,
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: rowDottedWidget(
                  '''Once the safety retention window elapses, we delete your data and only keep limited information for specified purposes, as laid out below:''',
                  index: 2,
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: rowAlfaWidget(
                  '''We maintain limited data to comply with legal data retention obligations: in particular, we keep transaction data for 10 years to comply with tax and accounting legal requirements, credit card information for the duration the user may challenge the transaction and &ldquo;traffic data&rdquo; / logs for one year to comply with legal data retention obligations. We also keep records of consents members give us for five years to evidence our compliance with applicable law.''',
                  index: 'a)',
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: rowAlfaWidget(
                  '''We maintain limited information on the basis of our legitimate interest: we keep customer care records and supporting data as well as imprecise location of download/purchase for five years to support our customer care decisions, enforce our rights and enable us to defend ourselves in the event of a claim, information on the existence of past accounts and subscriptions, which we delete three years after the closure of your last account to ensure proper and accurate financial forecasting and reporting, profile data for one year in anticipation of potential litigation, for the establishment, exercise or defense of legal claims, and data necessary to prevent members who were banned from opening a new account, for as long as necessary to ensure the safety and vital interests of our members.''',
                  index: 'b)',
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: rowAlfaWidget(
                  '''Finally, we maintain information based on our legitimate interest where there is an outstanding or potential issue, claim or dispute requiring us to keep information (if we receive a valid legal subpoena or request asking us to preserve data (in which case we would need to keep the data to comply with our legal obligations) or if data would otherwise be necessary as part of legal proceedings).''',
                  index: 'c)',
                ),
              ),
              sizedBox15,
              rowDottedWidget(
                "Children's Privacy",
                index: 10,
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''Our services are restricted to individuals who are 18 years of age or older. We do not permit individuals under the age of 18 on our platform. If you suspect that a member is under the age of 18, please use the reporting mechanism available on the service.''',
                  style: regualrText14,
                ),
              ),
              sizedBox15,
              rowDottedWidget(
                "Job Candidates, Contractors and Vendor Representatives",
                index: 11,
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''We process the personal information of our job candidates, contractors, and vendor representatives, as part of our recruitment and talent management operations and our management of the services that contractors and vendors provide to us. If you are a job candidate, contractor, or vendor representative of TruuBlue, certain relevant terms of this Privacy Policy apply to our processing of your personal information, including the sections of this Privacy Policy that discuss the entity that is responsible for the processing of your personal information, transfers of personal information, rights you may have under applicable law, how to contact us and California-specific information.''',
                  style: regualrText14,
                ),
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''If you are a job applicant, the personal information we process about you may vary depending on the job you seek but typically includes what you provide to us as part of your job application as well as professional qualifications, background, and reference information that recruiters or other third parties share with us. We use this information to support the recruitment process, which may lead to an employment contract. For contractors and vendor representatives, we may process identification information and work-related information, as necessary to manage our relationship with you and your employer, which is necessary for the performance of the services agreement, and to establish, exercise or defend potential legal claims. We may share personal information with service providers that assist us with recruitment and technical data processing operations. We keep your personal information only as long as necessary for those purposes.''',
                  style: regualrText14,
                ),
              ),
              sizedBox15,
              rowDottedWidget(
                "Privacy Policy Changes",
                index: 12,
              ),
              sizedBox10,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '''Because we are always looking for new and innovative ways to help you build meaningful connections and strive on making sure explanations about our data practices remain up-to-date, this policy may change over time. We will notify you before any material changes take effect so that you have time to review the changes.''',
                  style: regualrText14,
                ),
              ),
              sizedBox10,
              sizedBox15,
              rowDottedWidget(
                "How to Contact Us",
                index: 13,
              ),
              sizedBox10,
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
              sizedBox20,
            ],
          ),
        ),
      ),
    );
  }
}
