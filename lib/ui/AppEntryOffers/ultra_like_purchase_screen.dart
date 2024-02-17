// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:io';
import 'package:dating/ui/AppEntryOffers/deepblue_purchase_screen.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dating/constants.dart';
import 'package:dating/help/app_loader.dart';
import 'package:dating/main.dart';
import 'package:dating/model/User.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/ui/auth/AuthScreen.dart';
import 'package:dating/ui/home/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:dating/main.dart' as main;

final GlobalKey<ScaffoldState> ultraLikePurchaseKey =
    GlobalKey<ScaffoldState>();

class UltraLikePurchaseLike extends StatefulWidget {
  final User user;
  UltraLikePurchaseLike({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<UltraLikePurchaseLike> createState() => UltraLikePurchaseLikeState();
}

RxBool ultraLikeLoading = true.obs;

class UltraLikePurchaseLikeState extends State<UltraLikePurchaseLike> {
  late User user;
  Size? size;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  List<ProductDetails> _products = <ProductDetails>[];
  List<PurchaseDetails> _purchases = <PurchaseDetails>[];
  int predefineCount = 0;
  bool isProfileComplete = false;
  int boostIndex = 0;
  int selectedIndex = 0;
  String selectedCount = '0';
  final CarouselController boostController = CarouselController();
  final List ultaLikeList = [
    {
      'title': 'Give it a try',
      'boost': '4',
      'saving': '',
      'price': '11.99',
      'purchase_key': FOUR_ULTRALIKES,
    },
    {
      'title': 'Most Popular',
      'boost': '12',
      'saving': '16%',
      'price': '29.99',
      'purchase_key': TEWELVE_UTRALIKES,
    },
    {
      'title': 'Best Value',
      'boost': '30',
      'saving': '33%',
      'price': '59.99',
      'purchase_key': THERTY_ULTRALIKES,
    },
    {
      'title': 'Go DeepBlue',
      'boost': '1 Month',
      'saving': '',
      'price': '38.99/month',
      'purchase_key': UNLIMITED_ULTRALIKES,
    },
  ];
  @override
  void initState() {
    super.initState();
    user = widget.user;
    ultraLikeLoading.value = true;
    isProfileComplete = (user.drinkWantToDate != null &&
        user.you_Drink != null &&
        user.you_Smoke != null &&
        user.smokeWantToDate != null &&
        user.have_Children != null &&
        user.childrenWantToDate != null);
    // SchedulerBinding.instance?.addPostFrameCallback((timeStamp) async {
    //   predefineCount = int.parse(await FireStoreUtils.getUltraLikeCount());
    //   print("count:" + predefineCount.toString());
    // });
    initStoreInfo();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _products = <ProductDetails>[];
        _purchases = <PurchaseDetails>[];
        ultraLikeLoading.value = false;
      });
      return;
    }

    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }
    List<String> ids = [];
    ultaLikeList.forEach((element) {
      ids.add(element['purchase_key']);
    });
    print(ids);
    final ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(ids.toSet());
    if (user.isVip) {
      productDetailResponse.productDetails
          .removeWhere((element) => element.title == 'Unlimited Ultra Likes');
    }
    if (productDetailResponse.error != null) {
      setState(() {
        _products = productDetailResponse.productDetails.reversed.toList();
        _purchases = <PurchaseDetails>[];
        ultraLikeLoading.value = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _products = productDetailResponse.productDetails.reversed.toList();
        _purchases = <PurchaseDetails>[];
        ultraLikeLoading.value = false;
      });
      return;
    }

    setState(() {
      _products = productDetailResponse.productDetails.reversed.toList();
      ultraLikeLoading.value = false;
    });
  }

  @override
  void dispose() {
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    // _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ultraLikePurchaseKey,
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            setState(() {
              pushAndRemoveUntil(
                  context, HomeScreen(user: user, index: 0), false);
            });
          },
          child: Image.asset(
            'assets/images/truubluenew.png',
            width: 150,
            height: 150,
            /*color: _appBarTitle == 'Swipe'
                      ? Color(COLOR_backgroundColor)
                      : Colors.grey,*/
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: GestureDetector(
              child: widget.user.profilePictureURL != ''
                  ? Container(
                      width: 24,
                      height: 24,
                      decoration: new BoxDecoration(
                          color: const Color(0xff7c94b6),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          border: Border.all(
                            color: Colors.blue,
                            width: 0.5,
                          ),
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image:
                                  NetworkImage(widget.user.profilePictureURL))))
                  : Container(
                      width: 24,
                      height: 24,
                      decoration: new BoxDecoration(
                          color: const Color(0xff7c94b6),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          border: Border.all(
                            color: Colors.blue,
                            width: 0.5,
                          ),
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(
                                'assets/images/placeholder.jpg',
                              )))),
              onTap: () {
                setState(() {});
              }),
        ),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(
              Icons.view_headline_rounded,
              color: Color(COLOR_BLUE_BUTTON),
              size: 24,
            ),
            offset: Offset(0, 55),
            onSelected: _select,
            itemBuilder: (BuildContext context) {
              return {'Safety Tips', 'Legal', 'Help Center', 'Logout'}
                  .map((String choice) {
                return PopupMenuItem(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(
        () => Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Color(0xFF0573ac),
                          ),
                        ),
                        Text(
                          widget.user.firstName.toString() +
                              ', ' +
                              widget.user.calculateAge().toString(),
                          textAlign: TextAlign.center,
                          textScaleFactor: 1.0,
                          style: TextStyle(
                            color: Color(0xFF7B7B7B),
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(
                          width: 24,
                        ),
                      ],
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 5.0, left: 32, right: 32),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            main.streamController.add(2);
                          });
                        },
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Center(
                                child: displayCircleImage(
                                  widget.user.profilePictureURL,
                                  120,
                                  true,
                                ),
                              ),
                            ),
                            Positioned(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(COLOR_BLUE_BUTTON),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: Color(COLOR_BLUE_BUTTON),
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                child: Text(
                                  isProfileComplete == false ? '55%' : '100%',
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'More Ultra Likes',
                      style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Get up 10x more Matches\n Ultra Likes Never Expire',
                      style:
                          TextStyle(color: Colors.grey.shade700, fontSize: 14),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CarouselSlider(
                      carouselController: boostController,
                      options: CarouselOptions(
                          aspectRatio: 1.0,
                          viewportFraction: 0.7,
                          onPageChanged: (index, reason) {
                            setState(() {
                              boostIndex = index;
                            });
                          }),
                      items: List.generate(user.isVip ? 3 : ultaLikeList.length,
                          (ind) {
                        final index = ind;
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: index == 3
                                  ? Color(0xFF0573ac)
                                  : Color(0xFF68ce09),
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: index == 3
                                      ? Color(0xFF0573ac)
                                      : Color(0xFF68ce09),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 15),
                                child: Center(
                                  child: Text(
                                    ultaLikeList[index]['title'],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                ultaLikeList[index]['boost'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 40,
                                    color: Color(0xFF0573ac)),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                index == 3 ? 'Membership' : "Ultra Likes",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0573ac),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              index == 3
                                  ? Image.asset(
                                      'assets/images/logo_green.png',
                                      width: 90,
                                    )
                                  : Icon(
                                      Icons.star_border_outlined,
                                      size: 70,
                                      color: Color(0xFF0573ac),
                                    ),
                              ultaLikeList[index]['saving'] != ''
                                  ? Container(
                                      height: 30,
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 50),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 3,
                                        horizontal: 20,
                                      ),
                                      decoration: BoxDecoration(
                                          color: Color(0xFF9edaff),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Text(
                                        'Save ' + ultaLikeList[index]['saving'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF0573ac),
                                        ),
                                      ),
                                    )
                                  : SizedBox(
                                      height: index == 3 ? 30 : 50,
                                    ),
                              Text(
                                '\$' + ultaLikeList[index]['price'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF0573ac),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 15),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF70573ac),
                                    textStyle: TextStyle(color: Colors.white),
                                    padding: EdgeInsets.only(
                                        right: 50,
                                        left: 50,
                                        top: 10,
                                        bottom: 10),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        side: BorderSide(
                                            color: Color(0xFF0573ac))),
                                  ),
                                  child: Text(
                                    "Select",
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () async {
                                    late PurchaseParam purchaseParam;
                                    late ProductDetails productDetails;
                                    for (var i = 0; i < _products.length; i++) {
                                      if (_products[i].id ==
                                          ultaLikeList[index]['purchase_key']) {
                                        productDetails = _products[i];
                                        ultraLikeLoading.value = true;
                                        setState(() {});
                                      }
                                    }
                                    purchaseParam = PurchaseParam(
                                      productDetails: productDetails,
                                    );
                                    Map<String, PurchaseDetails>.fromEntries(
                                      _purchases.map(
                                        (PurchaseDetails purchase) {
                                          if (purchase
                                              .pendingCompletePurchase) {
                                            _inAppPurchase
                                                .completePurchase(purchase);
                                          }
                                          return MapEntry<String,
                                                  PurchaseDetails>(
                                              purchase.productID, purchase);
                                        },
                                      ),
                                    );
                                    await confirmPriceChange(context);

                                    // if (Platform.isAndroid) {
                                    //   final GooglePlayPurchaseDetails?
                                    //       oldSubscription = _getOldSubscription(
                                    //           _products[selectedSubscription],
                                    //           purchases);

                                    //   purchaseParam = GooglePlayPurchaseParam(
                                    //       productDetails:
                                    //           _products[selectedSubscription],
                                    //       changeSubscriptionParam:
                                    //           (oldSubscription != null)
                                    //               ? ChangeSubscriptionParam(
                                    //                   oldPurchaseDetails:
                                    //                       oldSubscription,
                                    //                   prorationMode: ProrationMode
                                    //                       .immediateWithTimeProration,
                                    //                 )
                                    //               : null);
                                    // } else {

                                    // }
                                    try {
                                      if (index == 3) {
                                        await _inAppPurchase.buyNonConsumable(
                                            purchaseParam: purchaseParam);
                                      } else {
                                        await _inAppPurchase.buyConsumable(
                                            purchaseParam: purchaseParam);
                                      }
                                    } catch (e) {
                                      if (e.toString().contains(
                                          'storekit_duplicate_product_object')) {
                                        if (_purchases.isNotEmpty) {
                                          await _inAppPurchase.completePurchase(
                                              _purchases.first);
                                        }
                                        if (Platform.isIOS) {
                                          var iapStoreKitPlatformAddition =
                                              _inAppPurchase.getPlatformAddition<
                                                  InAppPurchaseStoreKitPlatformAddition>();
                                          await iapStoreKitPlatformAddition
                                              .showPriceConsentIfNeeded();
                                        }
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                            '''There is transaction pending. Please wait for it to complete or try again later.''',
                                          ),
                                        ));
                                      }
                                      setState(() {
                                        ultraLikeLoading.value = false;
                                      });
                                    }

                                    // initStoreInfo(
                                    // ultaLikeList[index]['purchase_key'],
                                    // (index == 3)
                                    //     ? 'All'
                                    //     : ultaLikeList[index]['boost']);
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: ultaLikeList.asMap().entries.map((entry) {
                        return GestureDetector(
                          onTap: () => boostController.animateToPage(entry.key),
                          child: Container(
                            width: 12.0,
                            height: 12.0,
                            margin: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 4.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey.shade700),
                                color: (Colors.grey.shade700).withOpacity(
                                    boostIndex == entry.key ? 0.9 : 0.4)),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            if (ultraLikeLoading.value) AppLoader(),
          ],
        ),
      ),
    );
  }

  Future<void> _select(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    switch (value) {
      case 'Safety Tips':
        // Navigator.push(context, MaterialPageRoute(builder: (context) => SaftiyTipsScreen()));
        setState(() {});
        break;

      case 'Help Center':
        // Navigator.push(context, MaterialPageRoute(builder: (context) => HelpCenterMainScreen()));
        setState(() {});
        break;

      case 'Legal':
        setState(() {});
        break;
      case 'Logout':
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Are you sure you want to Log out?'),
                insetPadding: EdgeInsets.symmetric(horizontal: 20),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); //close Dialog
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      user.active = false;
                      user.lastOnlineTimestamp =
                          DateTime.now().toUtc().millisecondsSinceEpoch;
                      await FireStoreUtils.updateCurrentUser(user);
                      await auth.FirebaseAuth.instance.signOut();
                      MyAppState.currentUser = null;
                      prefs.setString("loginMobile", "");
                      pushAndRemoveUntil(context, AuthScreen(), false);
                    },
                    child: Text('Logout'),
                  ),
                ],
              );
            });
        break;
    }
    //print(value);
  }

  Future<void> confirmPriceChange(BuildContext context) async {
    if (Platform.isAndroid) {
      final InAppPurchaseAndroidPlatformAddition androidAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
      final BillingResultWrapper priceChangeConfirmationResult =
          await androidAddition.launchPriceChangeConfirmationFlow(
        sku: 'purchaseId',
      );
      if (priceChangeConfirmationResult.responseCode == BillingResponse.ok) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Price change accepted'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            priceChangeConfirmationResult.debugMessage ??
                'Price change failed with code ${priceChangeConfirmationResult.responseCode}',
          ),
        ));
      }
    }
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iapStoreKitPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iapStoreKitPlatformAddition.showPriceConsentIfNeeded();
    }
  }

  Future<void> handlePurchase(PurchaseDetails purchase) async {
    if (mounted)
      setState(() {
        ultraLikeLoading.value = false;
      });
    await showProgress(ultraLikePurchaseKey.currentState!.context,
        'Processing purchase...', false);
    int count = 0;
    for (var i = 0; i < ultaLikeList.length; i++) {
      if (ultaLikeList[i]['purchase_key'] == purchase.productID) {
        count = int.parse(ultaLikeList[i]['boost']);
      }
    }
    if (purchase.productID.contains('truubooster')) {
      await FireStoreUtils.recordPurchase(purchase);
    } else {
      predefineCount = int.parse(await FireStoreUtils.getUltraLikeCount());

      int totalCount = (predefineCount + count);
      await FireStoreUtils.recordUltraLikePurchase(
          purchase, totalCount.toString());
      // widget.updateCount(totalCount);
    }
    await _inAppPurchase.completePurchase(purchase);
    await hideProgress();
    Navigator.pop(
        ultraLikePurchaseKey.currentState!.context, (predefineCount + count));
  }
}
