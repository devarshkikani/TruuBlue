import 'dart:ui';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:dating/model/User.dart';
import 'package:flutter/scheduler.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/help/responsive_ui.dart';
import 'package:dating/html_text/flutter_html.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:dating/ui/upgradeAccount/UpgradeAccount.dart';

import '../../constants.dart';

class UltralikeSubscribtionScreen extends StatefulWidget {
  final User user;
  final Function(int count) updateCount;
  const UltralikeSubscribtionScreen(
      {Key? key, required this.user, required this.updateCount})
      : super(key: key);

  @override
  _UltralikeSubscribtionScreenState createState() =>
      _UltralikeSubscribtionScreenState();
}

class _UltralikeSubscribtionScreenState
    extends State<UltralikeSubscribtionScreen> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  late User user;
  bool? _isLoading, _large, _medium;
  double? _pixelRatio, bottom1;
  Size? size;
  List<String> _notFoundIds = [];
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;
  int predefineCount = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    SchedulerBinding.instance?.addPostFrameCallback((timeStamp) async {
      predefineCount = int.parse(await FireStoreUtils.getUltraLikeCount());
      print("count:" + predefineCount.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    var scrWidth = MediaQuery.of(context).size.width;
    var scrHeight = MediaQuery.of(context).size.height;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(scrWidth, _pixelRatio!);
    _medium = ResponsiveWidget.isScreenMedium(scrWidth, _pixelRatio!);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      constraints:
                          const BoxConstraints(minWidth: double.minPositive),
                      child: Column(children: [
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
                              "Get More Ultra Likes".tr(),
                              textAlign: TextAlign.center,
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                color: Color(0xff000000),
                                fontWeight: FontWeight.bold,
                                fontSize: _large! ? 22 : (_medium! ? 20 : 20),
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
                                fontSize: _large! ? 22 : (_medium! ? 20 : 20),
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
                                border: Border.all(
                                  color: Color(0xFF0573ac),
                                ),
                                borderRadius: BorderRadius.circular(10.0),
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
                                      "Unlock all the features of TruuBlue to expand your  Are and improve your dating experience "
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
                                padding: const EdgeInsets.only(top: 55.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xFF68ce09),
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
                                          Text(
                                            'Upgrade From '.tr(),
                                            textScaleFactor: 1.0,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "Click to Upgrade".tr(),
                                            textScaleFactor: 1.0,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 12,
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
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 16, top: 10, right: 16, bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.check,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 0, bottom: 0),
                                      child: DefaultTextStyle(
                                        style: TextStyle(
                                          color: Color(0xff9c9c9c),
                                          fontWeight: FontWeight.bold,
                                          fontSize: _large!
                                              ? 16
                                              : (_medium! ? 14 : 14),
                                        ),
                                        child: Text(
                                          "Unlimited likes".tr(),
                                          textAlign: TextAlign.center,
                                          textScaleFactor: 1.0,
                                          style: TextStyle(
                                            color: Color(0xff9c9c9c),
                                            fontSize: _large!
                                                ? 14
                                                : (_medium! ? 12 : 12),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.check,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 0, bottom: 0),
                                      child: DefaultTextStyle(
                                        style: TextStyle(
                                          color: Color(0xff9c9c9c),
                                          fontWeight: FontWeight.bold,
                                          fontSize: _large!
                                              ? 16
                                              : (_medium! ? 14 : 14),
                                        ),
                                        child: Text(
                                          "See Who Likes You".tr(),
                                          textAlign: TextAlign.center,
                                          textScaleFactor: 1.0,
                                          style: TextStyle(
                                            color: Color(0xff9c9c9c),
                                            fontSize: _large!
                                                ? 14
                                                : (_medium! ? 12 : 12),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.check,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 0, bottom: 0),
                                      child: DefaultTextStyle(
                                        style: TextStyle(
                                          color: Color(0xff9c9c9c),
                                          fontWeight: FontWeight.bold,
                                          fontSize: _large!
                                              ? 16
                                              : (_medium! ? 14 : 14),
                                        ),
                                        child: Text(
                                          "1 FREE TruuBoost/Month".tr(),
                                          textAlign: TextAlign.center,
                                          textScaleFactor: 1.0,
                                          style: TextStyle(
                                            color: Color(0xff9c9c9c),
                                            fontSize: _large!
                                                ? 14
                                                : (_medium! ? 12 : 12),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ))
                      ])),
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
        """<ul><article><li><strong>Get up to lox more Matches by letting them know you really Like them</strong></li></article><article><li><strong>Automatically extends your Ultra Likes for as long as it takes them to see you</strong></li></article><article><li><strong>Ultra Likes never expire</strong></li></article></ul>""";
    return Container(
      height: 120,
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
          return null;
        },
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
                  primary: Color(0xFF70573ac),
                  textStyle: TextStyle(color: Colors.white),
                  padding:
                      EdgeInsets.only(right: 10, left: 10, top: 0, bottom: 5),
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
                            '12'.tr(),
                            textScaleFactor: 1.0,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ''.tr(),
                            textScaleFactor: 1.0,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Ultra Likes'.tr(),
                            textScaleFactor: 1.0,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ''.tr(),
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
                        'Save 16%'.tr(),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "\$2.50 ea".tr(),
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
                    SubscriptionPaymentScreen(price: 2.50),
                  );*/
                  /*  push(
                    context,
                    UpgradeAccount(package: MONTHLY_SUBSCRIPTION,),
                  );*/
                  initStoreInfo(TEWELVE_UTRALIKES, "12");
                },
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 5.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF68ce09),
                  textStyle: TextStyle(color: Colors.white),
                  padding:
                      EdgeInsets.only(right: 10, left: 10, top: 5, bottom: 5),
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
                            '30'.tr(),
                            textScaleFactor: 1.0,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ''.tr(),
                            textScaleFactor: 1.0,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Ultra Likes".tr(),
                            textScaleFactor: 1.0,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "".tr(),
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
                        'Save 33%'.tr(),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "\$2.00 ea".tr(),
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
                    SubscriptionPaymentScreen(price: 2.00),
                  );*/
                  /* push(
                    context,
                    UpgradeAccount(package: MONTHLY_SUBSCRIPTION,),
                  );*/
                  initStoreInfo(THERTY_ULTRALIKES, "30");
                },
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 5.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF70573ac),
                  textStyle: TextStyle(color: Colors.white),
                  padding:
                      EdgeInsets.only(right: 10, left: 10, top: 5, bottom: 5),
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
                            '4'.tr(),
                            textScaleFactor: 1.0,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ''.tr(),
                            textScaleFactor: 1.0,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Ultra Likes'.tr(),
                            textScaleFactor: 1.0,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ''.tr(),
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
                        "\$3 ea".tr(),
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
                    SubscriptionPaymentScreen(price: 3.00),
                  );*/
                  /*push(
                    context,
                    UpgradeAccount(package: MONTHLY_SUBSCRIPTION,),
                  );*/
                  initStoreInfo(FOUR_ULTRALIKES, "4");
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
        _isAvailable = isAvailable;
        _products = [];
        _purchases = [];
        _notFoundIds = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }
    List<String> _kProductIds = <String>[package];

    ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      print('productserror ${productDetailResponse.error}');
      setState(() {
        _queryProductError = productDetailResponse.error!.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    //getting empty product list here
    print('products ${productDetailResponse.productDetails.length}');

    if (productDetailResponse.productDetails.isEmpty) {
      print("Empty");
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _purchasePending = false;
        _loading = false;
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
        },
        onDone: () {
          print('++++++');
        },
        cancelOnError: true,
        onError: (error) {
          print('-------$error');
        });

    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _purchases = verifiedPurchases;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _purchasePending = false;
      _loading = false;
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
      await FireStoreUtils.recordUltraLikePurchase(
          purchase, totalCount.toString());
      await widget.updateCount(totalCount);
      await hideProgress();

      // pushAndRemoveUntil(context, AppEntryOffersScreen(user: user), false);
      Navigator.pop(context);
      await _inAppPurchase.completePurchase(purchase);
      showDialog<AlertDialog>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          Future.delayed(Duration(seconds: 2), () async {
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
        },
      );
    }
  }
}
