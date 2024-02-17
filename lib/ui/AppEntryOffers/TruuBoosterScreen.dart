import 'dart:ui';

import 'package:dating/html_text/flutter_html.dart';
import 'package:dating/model/User.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/ui/SwipeScreen/SwipeScreen.dart';
import 'package:dating/ui/upgradeAccount/UpgradeAccount.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../constants.dart';
import '../../services/FirebaseHelper.dart';

class TruuBoosterScreen extends StatefulWidget {
  final User user;
  final Function(int count) updateCount;
  const TruuBoosterScreen(
      {Key? key, required this.user, required this.updateCount})
      : super(key: key);

  @override
  _TruuBoosterScreenState createState() => _TruuBoosterScreenState();
}

class _TruuBoosterScreenState extends State<TruuBoosterScreen> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  late User user;
  double? bottom1;
  Size? size;
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  int predefineCount = 0;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    user = widget.user;
    SchedulerBinding.instance?.addPostFrameCallback((timeStamp) async {
      predefineCount = int.parse(await FireStoreUtils.getBoostLikeCount());
      print("count:" + predefineCount.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    // size = MediaQuery.of(context).size;
    // var scrWidth = MediaQuery.of(context).size.width;
    // var scrHeight = MediaQuery.of(context).size.height;
    // _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    // _large = ResponsiveWidget.isScreenLarge(scrWidth, _pixelRatio!);
    // _medium = ResponsiveWidget.isScreenMedium(scrWidth, _pixelRatio!);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  right: 20, left: 20, bottom: 20, top: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    constraints:
                        const BoxConstraints(minWidth: double.minPositive),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 5.0, left: 10, right: 10),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Center(
                                    child: displayCircleImage(
                                        user.profilePictureURL, 90, false)),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 16, top: 0, right: 16, bottom: 5),
                            child: Text(
                              "Try a TruuBoost!".tr(),
                              textAlign: TextAlign.center,
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                color: Color(0xff000000),
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            )),
                        _checkList(),
                        _pricing(),
                        Row(children: <Widget>[
                          Expanded(
                              child: Divider(
                            color: Color(0xff000000),
                          )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "OR",
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                color: Color(0xff000000),
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                          ),
                          Expanded(
                              child: Divider(
                            color: Color(0xff000000),
                          )),
                        ]),
                        Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  right: 13, left: 13, top: 5, bottom: 0),
                              decoration: BoxDecoration(
                                color: Color(0xFF70573ac),
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                  color: Color(0xFF0573ac),
                                ),
                              ),
                              child: IntrinsicHeight(
                                child: Column(
                                  children: [
                                    Text(
                                      'Go Deep Blue'.tr(),
                                      textScaleFactor: 1.0,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Unlock al l the features of TruuBlue to expand your  Are and improve your dating experience "
                                          .tr(),
                                      textScaleFactor: 1.0,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 65.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF68ce09),
                                    textStyle: TextStyle(color: Colors.white),
                                    padding: EdgeInsets.only(
                                        right: 16,
                                        left: 16,
                                        top: 10,
                                        bottom: 5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        side: BorderSide(
                                            color: Color(0xFF68ce09))),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, right: 20),
                                    child: IntrinsicHeight(
                                      child: Column(
                                        children: [
                                          // Text(
                                          //   'Upgrade From '.tr(),
                                          //   textScaleFactor: 1.0,
                                          //   textAlign: TextAlign.center,
                                          //   style: TextStyle(
                                          //       fontSize: 15,
                                          //       fontWeight: FontWeight.bold),
                                          // ),
                                          Text(
                                            "Click to Upgrade".tr(),
                                            textScaleFactor: 1.0,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    /*push(
                                      context,
                                      SubscriptionPaymentScreen(price: 18),
                                    );*/
                                    /* push(
                                      context,
                                      UpgradeAccount(package: MONTHLY_SUBSCRIPTION,),
                                    );*/
                                    initStoreInfo(UNLIMITED_ULTRALIKES, "All");
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (isLoading)
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  alignment: Alignment.center,
                  child: CupertinoActivityIndicator(),
                ),
              ),
          ],
        ),
      ],
    );
  }

  _checkList() {
    var termData =
        """<ul><article><li><strong>We select a group of top-rated potential matches for you</strong></li></article><article><li><strong>You select the cream of the crop from that group</strong></li></article><article><li><strong>We instantly Boost your profile to the top of the list for those potential matches</strong></li></article></ul>""";
    return Container(
      height: 130,
      padding: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 8),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Html(
            data: termData,
            tagsList: Html.tags..addAll(["bird", "flutter"]),
            style: {
              "table": Style(
                backgroundColor: Color.fromARGB(0x50, 0xee, 0xee, 0xee),
              ),
              "tr": Style(
                border: Border(bottom: BorderSide(color: Colors.grey)),
              ),
              "th": Style(
                padding: EdgeInsets.all(6),
                backgroundColor: Colors.grey,
              ),
              "td": Style(
                padding: EdgeInsets.all(6),
                alignment: Alignment.topLeft,
              ),
              'h5': Style(maxLines: 2, textOverflow: TextOverflow.ellipsis),
            },
            onLinkTap: (url, _, __, ___) {
              print("Opening $url...");
            },
            onImageTap: (src, _, __, ___) {
              print(src);
            },
            onImageError: (exception, stackTrace) {
              print(exception);
            },
            onCssParseError: (css, messages) {
              print("css that errored: $css");
              print("error messages:");
              messages.forEach((element) {
                print(element);
              });
            },
          ),
        ),
      ),
    );
  }

  _pricing() {
    return Padding(
      padding: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 4.0, right: 4.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF70573ac),
                  textStyle: TextStyle(color: Colors.white),
                  padding: EdgeInsets.all(5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Color(0xFF0573ac))),
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '5 '.tr(),
                            textScaleFactor: 1.0,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'TruuBoosts'.tr(),
                            textScaleFactor: 1.0,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text(
                        "from".tr(),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Text(
                            '50 '.tr(),
                            textScaleFactor: 1.0,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Top Pick'.tr(),
                            textScaleFactor: 1.0,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text(
                        "-------------".tr(),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Save 30%'.tr(),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "\$42".tr(),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                onPressed: () {
                  /* push(
                    context,
                    SubscriptionPaymentScreen(price: 42),
                  );*/
                  /* push(
                    context,
                    UpgradeAccount(package: MONTHLY_SUBSCRIPTION,),
                  );*/
                  // initStoreInfo(UNLIMITED_ULTRALIKES, "5");
                  initStoreInfo(TEN_BOOSTS, "10");
                },
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 4.0, right: 4.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF68ce09),
                  textStyle: TextStyle(color: Colors.white),
                  padding: EdgeInsets.all(5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Color(0xFF68ce09))),
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '10 '.tr(),
                            textScaleFactor: 1.0,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'TruuBoosts'.tr(),
                            textScaleFactor: 1.0,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text(
                        "from".tr(),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "100 ".tr(),
                            textScaleFactor: 1.0,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Top Picks".tr(),
                            textScaleFactor: 1.0,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text(
                        "-------------".tr(),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Save 35%'.tr(),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "\$80".tr(),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                onPressed: () {
                  /*push(
                    context,
                    SubscriptionPaymentScreen(price: 78),
                  );*/
                  /*  push(
                    context,
                    UpgradeAccount(package: MONTHLY_SUBSCRIPTION,),
                  );*/
                  // initStoreInfo(UNLIMITED_ULTRALIKES, "10");
                  initStoreInfo(THERTY_BOOSTS, "30");
                },
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 4.0, right: 4.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF70573ac),
                  textStyle: TextStyle(color: Colors.white),
                  padding: EdgeInsets.all(5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Color(0xFF0573ac))),
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '2 '.tr(),
                            textScaleFactor: 1.0,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'TruuBoosts'.tr(),
                            textScaleFactor: 1.0,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text(
                        "from".tr(),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '20 '.tr(),
                            textScaleFactor: 1.0,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Top Pick'.tr(),
                            textScaleFactor: 1.0,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text(
                        "-------------".tr(),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Only'.tr(),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "\$24".tr(),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                onPressed: () {
                  /*push(
                    context,
                    SubscriptionPaymentScreen(price: 24),
                  );*/
                  /* push(
                    context,
                    UpgradeAccount(package: MONTHLY_SUBSCRIPTION,),
                  );*/
                  // initStoreInfo(UNLIMITED_ULTRALIKES, "2");
                  initStoreInfo(TWO_BOOSTS, "2");
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> initStoreInfo(String package, String count) async {
    setState(() {
      isLoading = true;
    });
    final bool isAvailable = await _inAppPurchase.isAvailable();
    print('_UpgradeAccountState.initStoreInfo $isAvailable');
    if (!isAvailable) {
      setState(() {
        _products = [];
        _purchases = [];
      });
      return;
    }
    List<String> _kProductIds = <String>[package];

    ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(_kProductIds.toSet());

    if (productDetailResponse.error != null) {
      print('productserror ${productDetailResponse.error}');
      setState(() {
        _products = productDetailResponse.productDetails;
        _purchases = [];
      });
      return;
    }

    //getting empty product list here
    print('products ${productDetailResponse.productDetails.length}');

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _products = productDetailResponse.productDetails;
        _purchases = [];
      });
      print('productsnotFoundIDs ${productDetailResponse.notFoundIDs.toSet()}');
      return;
    }

    await _inAppPurchase.restorePurchases();

    final List<PurchaseDetails> verifiedPurchases = [];
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;

    purchaseUpdated.listen(
        (purchaseDetails) async {
          // for (PurchaseDetails purchase in event) {
          if (await verifyPurchase(purchaseDetails.first)) {
            await _handlePurchase(purchaseDetails.first, count);
            verifiedPurchases.add(purchaseDetails.first);
          }

          if (purchaseDetails.first.status == PurchaseStatus.canceled) {
            await _inAppPurchase.completePurchase(purchaseDetails.first);
          }
        },
        onDone: () {
          print('++++++');
        },
        cancelOnError: true,
        onError: (error) {
          print('++++++++++++$error + + +');
        });

    setState(() {
      _products = productDetailResponse.productDetails;
      _purchases = verifiedPurchases;
    });
    await Future.delayed(Duration(seconds: 1), () {
      if (mounted)
        setState(() {
          isLoading = false;
        });
    });

    PurchaseParam purchaseParam = PurchaseParam(
        productDetails: _products.first, applicationUserName: null);

    try {
      await _inAppPurchase.buyConsumable(
        purchaseParam: purchaseParam,
        autoConsume: true,
      );
    } catch (e) {
      if (e.toString().contains('storekit_duplicate_product_object')) {
        if (_purchases.isNotEmpty) {
          await _inAppPurchase.completePurchase(_purchases.first);
          initStoreInfo(package, count);
        }
      }
    }
  }

  _handlePurchase(PurchaseDetails purchase, String count) async {
    if (purchase.status == PurchaseStatus.purchased) {
      await showProgress(context, 'Processing purchase...'.tr(), false);
      int totalCount = (predefineCount + int.parse(count));
      await FireStoreUtils.recordBoostPurchase(purchase, totalCount.toString());
      boostCount = totalCount;
      await widget.updateCount(totalCount);
      await hideProgress();
      Navigator.pop(context);
      await _inAppPurchase.completePurchase(purchase);
      showDialog<AlertDialog>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext ctx) {
            Future.delayed(Duration(seconds: 2), () {
              Navigator.pop(ctx);
            });
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              insetPadding: EdgeInsets.symmetric(horizontal: 20),
              content: Container(
                height: 300,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/app_logo__.png",
                      height: 100,
                      width: 200,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Payment sucessfully",
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.green.shade900,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Thank you, For your purchase",
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ),
              ),
            );
          });
    }
  }
}
