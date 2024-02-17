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
import 'package:dating/ui/SwipeScreen/SwipeScreen.dart';
import 'package:dating/ui/auth/AuthScreen.dart';
import 'package:dating/ui/home/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:dating/main.dart' as main;

final GlobalKey<ScaffoldState> boosrPurchaseKey = GlobalKey<ScaffoldState>();

class BoosrPurchaseScreen extends StatefulWidget {
  final User user;

  const BoosrPurchaseScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<BoosrPurchaseScreen> createState() => BoosrPurchaseScreenState();
}

RxBool boostLoading = true.obs;

class BoosrPurchaseScreenState extends State<BoosrPurchaseScreen> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  List<ProductDetails> _products = <ProductDetails>[];
  List<PurchaseDetails> _purchases = <PurchaseDetails>[];
  late User user;
  Size? size;
  int predefineCount = 0;
  bool isProfileComplete = false;
  int boostIndex = 0;
  int selectedIndex = 0;
  final CarouselController boostController = CarouselController();
  int ultraLikeIndex = 0;
  final CarouselController ultraLikeController = CarouselController();
  final List boostList = [
    {
      'title': 'Give it a try',
      'boost': '2',
      'saving': '',
      'price': '15.99',
      'purchase_key': TWO_BOOSTS,
    },
    {
      'title': 'Most Popular',
      'boost': '10',
      'saving': '25%',
      'price': '59.99',
      'purchase_key': TEN_BOOSTS,
    },
    {
      'title': 'Best Value',
      'boost': '30',
      'saving': '63%',
      'price': '89.99',
      'purchase_key': THERTY_BOOSTS,
    },
    {
      'title': 'Go DeepBlue',
      'boost': '1 Month',
      'saving': '',
      'price': '38.99/month',
      'purchase_key': MONTHLY_SUBSCRIPTION,
    },
  ];
  @override
  void initState() {
    super.initState();
    user = widget.user;
    boostLoading.value = true;
    isProfileComplete = (user.drinkWantToDate != null &&
        user.you_Drink != null &&
        user.you_Smoke != null &&
        user.smokeWantToDate != null &&
        user.have_Children != null &&
        user.childrenWantToDate != null);
    // SchedulerBinding.instance?.addPostFrameCallback((timeStamp) async {
    //   predefineCount = ;
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
        boostLoading.value = false;
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
    boostList.forEach((element) {
      ids.add(element['purchase_key']);
    });
    print(ids);
    final ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(ids.toSet());
    if (user.isVip) {
      productDetailResponse.productDetails
          .removeWhere((element) => element.id == MONTHLY_SUBSCRIPTION);
    }
    if (productDetailResponse.error != null) {
      setState(() {
        _products = productDetailResponse.productDetails.reversed.toList();
        _purchases = <PurchaseDetails>[];
        boostLoading.value = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _products = productDetailResponse.productDetails.reversed.toList();
        _purchases = <PurchaseDetails>[];
        boostLoading.value = false;
      });
      return;
    }

    setState(() {
      _products = productDetailResponse.productDetails.reversed.toList();
      boostLoading.value = false;
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: boosrPurchaseKey,
        appBar: AppBar(
          title: GestureDetector(
            onTap: () {
              setState(() {
                pushAndRemoveUntil(
                    context, HomeScreen(user: widget.user, index: 0), false);
              });
            },
            child: Image.asset(
              'assets/images/truubluenew.png',
              width: 150,
              height: 150,
              /*color: _appBarTitle == 'Swipe'
                      ? Color(COLOR_PRIMARY)
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
                                image: NetworkImage(
                                    widget.user.profilePictureURL))))
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
                            ),
                          ),
                        ),
                      ),
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
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Color(0xFF0573ac),
                              )),
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
                        padding: const EdgeInsets.only(
                            top: 5.0, left: 30, right: 30),
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
                        'You need a TruuBoost!',
                        style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Get up to 5x more Likes with a 30 minute Boost',
                        style: TextStyle(
                            color: Colors.grey.shade700, fontSize: 14),
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
                        items: List.generate(
                          user.isVip ? 3 : boostList.length,
                          (index) => Container(
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
                                        boostList[index]['title'],
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
                                    boostList[index]['boost'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 40,
                                        color: Color(0xFF0573ac)),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    index == 3 ? 'Membership' : "Boosts",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF0573ac),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Image.asset(
                                    index == 3
                                        ? 'assets/images/logo_green.png'
                                        : 'assets/images/thunder.png',
                                    height: index == 3 ? 80 : 50,
                                    width: index == 3 ? 80 : 50,
                                    color:
                                        index == 3 ? null : Color(0xFF0573ac),
                                  ),
                                  if (index != 3)
                                    SizedBox(
                                      height: 10,
                                    ),
                                  boostList[index]['saving'] != ''
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
                                            'Save ' +
                                                boostList[index]['saving'],
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
                                    '\$' + boostList[index]['price'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF0573ac),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 20),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF70573ac),
                                        textStyle:
                                            TextStyle(color: Colors.white),
                                        padding: EdgeInsets.only(
                                            right: 50,
                                            left: 50,
                                            top: 15,
                                            bottom: 15),
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
                                        for (var i = 0;
                                            i < _products.length;
                                            i++) {
                                          if (_products[i].id ==
                                              boostList[index]
                                                  ['purchase_key']) {
                                            setState(() {
                                              productDetails = _products[i];
                                              selectedIndex = index;
                                              boostLoading.value = true;
                                            });
                                          }
                                        }
                                        purchaseParam = PurchaseParam(
                                          productDetails: productDetails,
                                        );
                                        Map<String,
                                            PurchaseDetails>.fromEntries(
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
                                            await _inAppPurchase
                                                .buyNonConsumable(
                                                    purchaseParam:
                                                        purchaseParam);
                                          } else {
                                            await _inAppPurchase.buyConsumable(
                                                purchaseParam: purchaseParam);
                                          }
                                        } catch (e) {
                                          if (e.toString().contains(
                                              'storekit_duplicate_product_object')) {
                                            if (_purchases.isNotEmpty) {
                                              await _inAppPurchase
                                                  .completePurchase(
                                                      _purchases.first);
                                            }
                                            if (Platform.isIOS) {
                                              var iapStoreKitPlatformAddition =
                                                  _inAppPurchase
                                                      .getPlatformAddition<
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
                                            boostLoading.value = false;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: boostList.asMap().entries.map((entry) {
                          return GestureDetector(
                            onTap: () =>
                                boostController.animateToPage(entry.key),
                            child: Container(
                              width: 12.0,
                              height: 12.0,
                              margin: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 4.0),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.grey.shade700),
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
              if (boostLoading.value) AppLoader(),
            ],
          ),
        ));
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

  handlePurchase(PurchaseDetails purchase) async {
    await showProgress(boosrPurchaseKey.currentState!.context,
        'Processing purchase...', false);
    int count = 0;
    for (var i = 0; i < boostList.length; i++) {
      if (boostList[i]['purchase_key'] == purchase.productID) {
        count = int.parse(boostList[i]['boost']);
      }
    }
    if (purchase.productID.contains('truubooster')) {
      await FireStoreUtils.recordPurchase(purchase);
    } else {
      predefineCount = int.parse(await FireStoreUtils.getBoostLikeCount());
      int totalCount = (predefineCount + count);
      await FireStoreUtils.recordBoostPurchase(purchase, totalCount.toString());
      boostCount = totalCount;
    }
    await _inAppPurchase.completePurchase(purchase);
    await hideProgress();
    Navigator.pop(
        boosrPurchaseKey.currentState!.context, (predefineCount + count));
  }
}
