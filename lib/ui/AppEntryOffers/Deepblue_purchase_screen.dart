import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:dating/constants.dart';
import 'package:dating/help/app_loader.dart';
import 'package:dating/main.dart';
import 'package:dating/model/User.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/ui/auth/AuthScreen.dart';
import 'package:dating/ui/home/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<ScaffoldState> deepbluePurchaseKey = GlobalKey<ScaffoldState>();
const String sixMonthSubscription = SIX_MONTH_SUBSCRIPTION;
const String monthlySubscription = MONTHLY_SUBSCRIPTION;
const String yearlySubscription = YEARLY_SUBSCRIPTION;
const List<String> _kProductIds = <String>[
  sixMonthSubscription,
  monthlySubscription,
  yearlySubscription,
];

class DeepBluePurchaseScreen extends StatefulWidget {
  final User user;
  const DeepBluePurchaseScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<DeepBluePurchaseScreen> createState() => DeepBluePurchaseScreenState();
}

RxBool deepBlueLoading = true.obs;

class DeepBluePurchaseScreenState extends State<DeepBluePurchaseScreen> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  List<ProductDetails> _products = <ProductDetails>[];
  List<PurchaseDetails> _purchases = <PurchaseDetails>[];
  bool isProfileComplete = false;
  int selectedSubscription = 1;
  bool completePendingPurchase = false;
  User? user;
  @override
  void initState() {
    user = widget.user;
    isProfileComplete = (widget.user.drinkWantToDate != null &&
        widget.user.you_Drink != null &&
        widget.user.you_Smoke != null &&
        widget.user.smokeWantToDate != null &&
        widget.user.have_Children != null &&
        widget.user.childrenWantToDate != null);
    initStoreInfo();
    super.initState();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _products = <ProductDetails>[];
        _purchases = <PurchaseDetails>[];
        deepBlueLoading.value = false;
      });
      return;
    }

    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    final ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      setState(() {
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        deepBlueLoading.value = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        deepBlueLoading.value = false;
      });
      return;
    }

    setState(() {
      _products = productDetailResponse.productDetails;
      deepBlueLoading.value = false;
    });
  }

  Future<void> handlePurchase(PurchaseDetails purchase) async {
    await showProgress(deepbluePurchaseKey.currentState!.context,
        'Processing purchase...', false);
    await FireStoreUtils.recordPurchase(purchase);
    await hideProgress();
    Navigator.pop(deepbluePurchaseKey.currentState!.context);
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
      key: deepbluePurchaseKey,
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            pushAndRemoveUntil(
                context, HomeScreen(user: widget.user, index: 0), false);
          },
          child: Image.asset(
            'assets/images/truubluenew.png',
            width: 150,
            height: 150,
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
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 40,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, bottom: 8),
                            child: Text(
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
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 3.0, left: 32, right: 32),
                            child: InkWell(
                              onTap: () {
                                // setState(() {
                                //   main.streamController.add(2);
                                // });
                              },
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: Center(
                                      child: displayCircleImage(
                                        widget.user.profilePictureURL,
                                        120,
                                        true,
                                      ),
                                    ),
                                  ),
                                  Container(
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
                                      isProfileComplete == false
                                          ? '55%'
                                          : '100%',
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                          color: Color(0xFFFFFFFF),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                      textAlign: TextAlign.center,
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
                            'Go DeepBlue!',
                            style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  width: 2,
                                  color: Color(0xFF0573ac),
                                )),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF0573ac),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Unlock Your Full Potential',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "What's Included:",
                                  style: TextStyle(
                                      color: Color(0xFF0573ac),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Unlimited Messages",
                                  style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 16),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "See Who Likes You",
                                  style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 16),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "1 FREE TruuBoost/Month",
                                  style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 16),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "5 FREE Ultra Likes/Month",
                                  style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 16),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Revive Expired Matches",
                                  style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 16),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Set Advanced Preferences",
                                  style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 16),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                _pricing(),
                                SizedBox(
                                  height: 20,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      deepBlueLoading.value = true;
                                    });
                                    final Map<String, PurchaseDetails>
                                        purchases = Map<String,
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
                                    if (selectedSubscription != '') {
                                      await confirmPriceChange(context);
                                      late PurchaseParam purchaseParam;

                                      if (Platform.isAndroid) {
                                        final GooglePlayPurchaseDetails?
                                            oldSubscription =
                                            _getOldSubscription(
                                                _products[selectedSubscription],
                                                purchases);

                                        purchaseParam = GooglePlayPurchaseParam(
                                            productDetails:
                                                _products[selectedSubscription],
                                            changeSubscriptionParam:
                                                (oldSubscription != null)
                                                    ? ChangeSubscriptionParam(
                                                        oldPurchaseDetails:
                                                            oldSubscription,
                                                        prorationMode: ProrationMode
                                                            .immediateWithTimeProration,
                                                      )
                                                    : null);
                                      } else {
                                        purchaseParam = PurchaseParam(
                                          productDetails:
                                              _products[selectedSubscription],
                                        );
                                      }
                                      try {
                                        await _inAppPurchase.buyNonConsumable(
                                            purchaseParam: purchaseParam);
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
                                          deepBlueLoading.value = false;
                                        });
                                      }
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: selectedSubscription == ''
                                            ? Colors.grey.shade400
                                            : Color(0xFF68ce09),
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 10),
                                    child: Text(
                                      'Continue',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'No thanks',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, top: 0, right: 16, bottom: 8),
                              child: DefaultTextStyle(
                                style: TextStyle(
                                  color: Color(0xff9c9c9c),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                                child: Text(
                                  "By tapping Continue, your payment will be charged to your nuns account and your subscription will automatically renew for the same package length at the same price until you cancel in settings in the 'Tunes store at least 24 hours prior to the end of the current period. By tapping Continue, you agree to our Privacy Policy and Terms.",
                                  textAlign: TextAlign.center,
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                    color: Color(0xff9c9c9c),
                                    fontSize: 12,
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (deepBlueLoading.value || completePendingPurchase) AppLoader(),
          ],
        ),
      ),
    );
  }

  Future<void> _select(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    switch (value) {
      case 'Safety Tips':
        setState(() {});
        break;

      case 'Help Center':
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
                      user?.active = false;
                      user?.lastOnlineTimestamp =
                          DateTime.now().toUtc().millisecondsSinceEpoch;
                      await FireStoreUtils.updateCurrentUser(user!);
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
  }

  _pricing() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: selectedSubscription == 0
                  ? Color(0xFF68ce09)
                  : Color(0xFF70573ac),
              textStyle: TextStyle(color: Colors.white),
              padding: EdgeInsets.symmetric(
                vertical: selectedSubscription == 0 ? 15 : 10,
                horizontal: 10,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(
                  color: selectedSubscription == 0
                      ? Color(0xFF68ce09)
                      : Color(0xFF70573ac),
                ),
              ),
            ),
            child: Column(
              children: [
                Text(
                  '6 Months',
                  textScaleFactor: 1.0,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: selectedSubscription == 0 ? 18 : 16,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "\$24.99",
                  textScaleFactor: 1.0,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: selectedSubscription == 0 ? 14 : 12,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            onPressed: () {
              setState(() {
                selectedSubscription = 0;
              });
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: selectedSubscription == 1
                  ? Color(0xFF68ce09)
                  : Color(0xFF70573ac),
              textStyle: TextStyle(color: Colors.white),
              padding: EdgeInsets.symmetric(
                vertical: selectedSubscription == 1 ? 15 : 10,
                horizontal: 10,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(
                  color: selectedSubscription == 1
                      ? Color(0xFF68ce09)
                      : Color(0xFF70573ac),
                ),
              ),
            ),
            child: Column(
              children: [
                Text(
                  '12 Months',
                  textScaleFactor: 1.0,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: selectedSubscription == 1 ? 18 : 16,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "\$17.99",
                  textScaleFactor: 1.0,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: selectedSubscription == 1 ? 14 : 12,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            onPressed: () {
              setState(() {
                selectedSubscription = 1;
              });
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: selectedSubscription == 2
                  ? Color(0xFF68ce09)
                  : Color(0xFF70573ac),
              textStyle: TextStyle(color: Colors.white),
              padding: EdgeInsets.symmetric(
                vertical: selectedSubscription == 2 ? 15 : 10,
                horizontal: 10,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(
                  color: selectedSubscription == 2
                      ? Color(0xFF68ce09)
                      : Color(0xFF70573ac),
                ),
              ),
            ),
            child: Column(
              children: [
                Text(
                  '1 Months',
                  textScaleFactor: 1.0,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: selectedSubscription == 2 ? 18 : 16,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "\$38.99",
                  textScaleFactor: 1.0,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: selectedSubscription == 2 ? 14 : 12,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            onPressed: () {
              setState(() {
                selectedSubscription = 2;
              });
            },
          ),
        ],
      ),
    );
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

  GooglePlayPurchaseDetails? _getOldSubscription(
      ProductDetails productDetails, Map<String, PurchaseDetails> purchases) {
    GooglePlayPurchaseDetails? oldSubscription;
    if (productDetails.id == monthlySubscription &&
        purchases[yearlySubscription] != null) {
      oldSubscription =
          purchases[yearlySubscription]! as GooglePlayPurchaseDetails;
    } else if (productDetails.id == yearlySubscription &&
        purchases[monthlySubscription] != null) {
      oldSubscription =
          purchases[monthlySubscription]! as GooglePlayPurchaseDetails;
    }
    return oldSubscription;
  }
}

class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}

class ConsumableStore {
  static const String _kPrefKey = 'consumables';
  static Future<void> _writes = Future<void>.value();

  static Future<void> save(String id) {
    _writes = _writes.then((void _) => _doSave(id));
    return _writes;
  }

  static Future<void> consume(String id) {
    _writes = _writes.then((void _) => _doConsume(id));
    return _writes;
  }

  /// Returns the list of consumables from the store.
  static Future<List<String>> load() async {
    return (await SharedPreferences.getInstance()).getStringList(_kPrefKey) ??
        <String>[];
  }

  static Future<void> _doSave(String id) async {
    final List<String> cached = await load();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    cached.add(id);
    await prefs.setStringList(_kPrefKey, cached);
  }

  static Future<void> _doConsume(String id) async {
    final List<String> cached = await load();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    cached.remove(id);
    await prefs.setStringList(_kPrefKey, cached);
  }
}
