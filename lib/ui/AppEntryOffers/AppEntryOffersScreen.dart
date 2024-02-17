// ignore_for_file: must_be_immutable

import 'package:dating/common/common_appbar_widget.dart';
import 'package:dating/common/common_widget.dart';
import 'package:dating/help/responsive_ui.dart';
import 'package:dating/main.dart';
import 'package:dating/model/User.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/ui/AppEntryOffers/Deepblue_purchase_screen.dart';
import 'package:dating/ui/AppEntryOffers/boost_purchase_screen.dart';
import 'package:dating/ui/AppEntryOffers/ultra_like_purchase_screen.dart';
import 'package:dating/ui/home/HomeScreen.dart';
import 'package:dating/ui/profile/complete_my_profile/OnBoardingQuestionEightScreen.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

class AppEntryOffersScreen extends StatefulWidget {
  final User user;
  int predefineCount = 0;
  int predefineBoostCount = 0;
  int messageCount = 0;
  int likeCount = 0;

  AppEntryOffersScreen({
    Key? key,
    required this.user,
    required this.likeCount,
    required this.messageCount,
    required this.predefineCount,
    required this.predefineBoostCount,
  }) : super(key: key);

  @override
  _AppEntryOffersState createState() => _AppEntryOffersState();
}

int newLikesCount = 0;

class _AppEntryOffersState extends State<AppEntryOffersScreen> {
  late User user;
  bool? _large, _medium;
  double? _pixelRatio, bottom1;
  Size? size;
  GlobalKey<FormState> key = GlobalKey();
  final fireStoreUtils = FireStoreUtils();
  int predefineCount = 0;
  int predefineBoostCount = 0;
  int messageCount = 0;
  int likesCount = 0;
  bool isProfileComplete = false;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  @override
  void initState() {
    super.initState();
    if (widget.user.drinkWantToDate != null &&
        widget.user.you_Drink != null &&
        widget.user.you_Smoke != null &&
        widget.user.smokeWantToDate != null &&
        widget.user.have_Children != null &&
        widget.user.childrenWantToDate != null) {
      isProfileComplete = true;
    } else {
      isProfileComplete = false;
    }
    user = widget.user;
    predefineCount = widget.predefineCount;
    predefineBoostCount = widget.predefineBoostCount;
    messageCount = widget.messageCount;
    likesCount = widget.likeCount;
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen(
        (List<PurchaseDetails> purchaseDetailsList) async {
          if (purchaseDetailsList.length <= 1) {
            _listenToPurchaseUpdated(purchaseDetailsList);
          } else {
            await extraTransaction(purchaseDetailsList);
          }
        },
        onDone: () {
          _subscription.cancel();
        },
        cancelOnError: true,
        onError: (Object error) {
          _subscription.cancel();
        });
  }

  Future<void> extraTransaction(purchaseDetailsList) async {
    for (var i = 0; i < purchaseDetailsList.length; i++) {
      await _inAppPurchase.completePurchase(purchaseDetailsList[i]);
      if (Platform.isIOS) {
        var iapStoreKitPlatformAddition = _inAppPurchase
            .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
        await iapStoreKitPlatformAddition.showPriceConsentIfNeeded();
      }
    }
  }

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      log(purchaseDetails.status.toString());

      if (purchaseDetails.status == PurchaseStatus.error ||
          purchaseDetails.status == PurchaseStatus.canceled) {
        await _inAppPurchase.completePurchase(purchaseDetails);
        if (purchaseDetails.productID.contains('truubooster')) {
          deepBlueLoading.value = false;
        } else if (purchaseDetails.productID.contains('ultralike')) {
          ultraLikeLoading.value = false;
        } else if (purchaseDetails.productID.contains('truuboost')) {
          boostLoading.value = false;
        }
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        final bool valid = await _verifyPurchase(purchaseDetails);
        if (valid) {
          if (purchaseDetails.productID.contains('truubooster')) {
            DeepBluePurchaseScreenState().handlePurchase(purchaseDetails);
          } else if (purchaseDetails.productID.contains('ultralike')) {
            UltraLikePurchaseLikeState().handlePurchase(purchaseDetails);
          } else if (purchaseDetails.productID.contains('truuboost')) {
            BoosrPurchaseScreenState().handlePurchase(purchaseDetails);
          }
        } else {
          _handleInvalidPurchase(purchaseDetails);
          return;
        }
      }
      if (Platform.isAndroid) {
        final InAppPurchaseAndroidPlatformAddition androidAddition =
            _inAppPurchase
                .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
        await androidAddition.consumePurchase(purchaseDetails);
      }
      if (purchaseDetails.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchaseDetails);
      }
      // setState(() {
      //   isLoading = false;
      // });

    }
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
    // setState(() {
    //   isLoading = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    var scrWidth = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(scrWidth, _pixelRatio!);
    _medium = ResponsiveWidget.isScreenMedium(scrWidth, _pixelRatio!);

    return Scaffold(
        appBar: appBarWidget(user: user, context: context),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, top: 0, right: 16, bottom: 8),
                        child: Text(
                          user.firstName.toString() +
                              ', ' +
                              user.calculateAge().toString(),
                          textAlign: TextAlign.center,
                          textScaleFactor: 1.0,
                          style: TextStyle(
                            color: Color(0xFF7B7B7B),
                            fontWeight: FontWeight.bold,
                            fontSize: _large! ? 25 : (_medium! ? 22 : 22),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 32, right: 32, bottom: 10),
                        child: InkWell(
                          onTap: () {
                            // setState(() {
                            //   main.streamController.add(2);
                            // });
                            if (isProfileComplete == false) {
                              push(
                                context,
                                OnBoardingQuestionEightScreen(
                                  user: user,
                                ),
                              );
                            }
                          },
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            clipBehavior: Clip.none,
                            children: <Widget>[
                              CircularPercentIndicator(
                                radius: 60.0,
                                lineWidth: 8.0,
                                percent:
                                    isProfileComplete == false ? 0.55 : 1.00,
                                center: Text('80%'),
                                circularStrokeCap: CircularStrokeCap.round,
                                startAngle: 180,
                                progressColor: Color(0xFF0573ac),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Center(
                                  child: displayCircleImage(
                                    user.profilePictureURL,
                                    100,
                                    true,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: -10,
                                child: InkWell(
                                  onTap: () {
                                    if (isProfileComplete == false) {
                                      push(
                                        context,
                                        OnBoardingQuestionEightScreen(
                                          user: user,
                                        ),
                                      );
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      // color: Color(COLOR_BLUE_BUTTON),
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                        color: Colors.green,
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 5),
                                    child: Text(
                                      isProfileComplete == false
                                          ? '55% Complete'
                                          : '100% Complete',
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                          color: Color(0xFFFFFFFF),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 5.0, right: 5.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF70573ac),
                                    textStyle: TextStyle(color: Colors.white),
                                    padding: EdgeInsets.only(
                                        right: 50, left: 50, top: 5, bottom: 5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        side: BorderSide(
                                            color: Color(0xFF0573ac))),
                                  ),
                                  child: Text(
                                    '${likesCount} ' +
                                        (likesCount == 1 ? 'Like' : 'Likes'),
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    pushAndRemoveUntil(
                                        context,
                                        HomeScreen(user: user, index: 2),
                                        false);
                                  },
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 5.0, right: 5.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF70573ac),
                                    textStyle: TextStyle(color: Colors.white),
                                    padding: EdgeInsets.only(
                                        right: 20, left: 20, top: 5, bottom: 5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        side: BorderSide(
                                            color: Color(0xFF0573ac))),
                                  ),
                                  child: Text(
                                    '${messageCount} Messages'.tr(),
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    pushAndRemoveUntil(
                                        context,
                                        HomeScreen(user: user, index: 3),
                                        false);
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 5.0, right: 5.0),
                              child: Container(
                                constraints: const BoxConstraints(
                                    minWidth: double.minPositive),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF68ce09),
                                    textStyle: TextStyle(color: Colors.white),
                                    padding: EdgeInsets.only(
                                        right: 10,
                                        left: 10,
                                        top: 10,
                                        bottom: 10),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        side: BorderSide(
                                            color: Color(0xFF68ce09))),
                                  ),
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Text(
                                          '$predefineBoostCount Boosts',
                                          textScaleFactor: 1.0,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Available'.tr(),
                                          textScaleFactor: 1.0,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          'Click to Add More'.tr(),
                                          textScaleFactor: 1.0,
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BoosrPurchaseScreen(
                                          user: widget.user,
                                        ),
                                      ),
                                    ).then((value) {
                                      if (value != null) {
                                        setState(() {
                                          predefineBoostCount = value;
                                        });
                                      }
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 5.0, right: 5.0),
                              child: Container(
                                constraints: const BoxConstraints(
                                    minWidth: double.minPositive),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF68ce09),
                                    textStyle: TextStyle(color: Colors.white),
                                    padding: EdgeInsets.only(
                                        right: 10,
                                        left: 10,
                                        top: 10,
                                        bottom: 10),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        side: BorderSide(
                                            color: Color(0xFF68ce09))),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '$predefineCount Ultra ' +
                                            (predefineCount == 1
                                                ? 'Like'
                                                : 'Likes'),
                                        textAlign: TextAlign.center,
                                        textScaleFactor: 1.0,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Available'.tr(),
                                        textScaleFactor: 1.0,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'Click to Add More'.tr(),
                                        textScaleFactor: 1.0,
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            UltraLikePurchaseLike(
                                          user: widget.user,
                                        ),
                                      ),
                                    ).then((value) {
                                      if (value != null) {
                                        setState(() {
                                          predefineCount = value;
                                        });
                                      }
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Column(
                            children: [
                              Container(
                                height: 85,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/wave_trans.png"),
                                    fit: BoxFit.fill,
                                  ),
                                  color: Color(0xFF0573ac),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                width: MediaQuery.of(context).size.width - 40,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      user.isVip
                                          ? 'DeepBlue Member '
                                          : 'Upgrade To DeepBlue',
                                      textScaleFactor: 1.0,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFFffffff),
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            _large! ? 25 : (_medium! ? 22 : 20),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                      ),
                                      child: Text(
                                        user.isVip
                                            ? 'Your in complete control of your dating experince'
                                            : 'DeepBlue Members get twice as many Matches',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFffffff),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                          // Positioned(
                          //   bottom: 0,
                          //   child: InkWell(
                          //     onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) =>
                          //         DeepBluePurchaseScreen(
                          //       user: user,
                          //     ),
                          //   ),
                          // ).then((value) {
                          //   setState(() {
                          //     user = MyAppState.currentUser!;
                          //   });
                          // });
                          //     },
                          //     child: Container(
                          //       decoration: BoxDecoration(
                          //         borderRadius: BorderRadius.circular(10),
                          //         color: Color(0xFF68ce09),
                          //       ),
                          //       padding: EdgeInsets.symmetric(
                          //           horizontal: 20, vertical: 10),
                          //       child: Text(
                          //         user.isVip
                          //             ? 'Current member'
                          //             : 'Click to Upgrade',
                          //         style: TextStyle(
                          //             color: Colors.white,
                          //             fontSize: 16,
                          //             fontWeight: FontWeight.w600,
                          //             decoration: TextDecoration.underline),
                          //       ),
                          //     ),
                          //   ),
                          // )
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "What's Included:",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            rowDottedWidget('Send Unlimited Messages'),
                            rowDottedWidget('See Who Likes You'),
                            rowDottedWidget('Get 1 FREE Boost/month'),
                            rowDottedWidget('Get 5 FREE Ultra Likes/month'),
                            rowDottedWidget('Revive Expired Matches'),
                            rowDottedWidget('Set Advanced Preferences'),
                          ],
                        ),
                      ),
                      // Text(
                      //   "Rekindle Expired Matches",
                      //   style:
                      //       TextStyle(color: Colors.grey.shade700, fontSize: 16),
                      // ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DeepBluePurchaseScreen(
                                user: user,
                              ),
                            ),
                          ).then((value) {
                            setState(() {
                              user = MyAppState.currentUser!;
                            });
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFF68ce09),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(
                            user.isVip ? 'Current member' : 'Click to Upgrade',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              // decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                // Center(
                //   child: Padding(
                //     padding: const EdgeInsets.only(top: 5, right: 20.0, left: 20),
                //     child: InkWell(
                //       onTap: () {
                //         pushAndRemoveUntil(
                //             context, HomeScreen(user: user, index: 0), false);
                //       },
                //       child: Text(
                //         "Continue to My Feed".tr(),
                //         textScaleFactor: 1.0,
                //         style: TextStyle(
                //           color: Color(0xFF7B7B7B),
                //           fontSize: 18.0,
                //           decoration: TextDecoration.underline,
                //         ),
                //         textAlign: TextAlign.center,
                //       ),
                //     ),
                //   ),
                // ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF70573ac),
                        textStyle: TextStyle(color: Colors.white),
                        padding: EdgeInsets.only(
                            right: 20, left: 20, top: 5, bottom: 5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: BorderSide(color: Color(0xFF0573ac))),
                      ),
                      child: Text(
                        "Continue to My Feed",
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () async {
                        // pushAndRemoveUntil(
                        //     context, HomeScreen(user: user, index: 3), false);
                        pushAndRemoveUntil(
                            context, HomeScreen(user: user, index: 0), false);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
