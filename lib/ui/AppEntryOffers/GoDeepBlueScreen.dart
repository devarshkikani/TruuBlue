import 'dart:ui';

import 'package:dating/help/responsive_ui.dart';
import 'package:dating/model/User.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/ui/upgradeAccount/UpgradeAccount.dart';
// ignore: implementation_imports
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../constants.dart';

class GoDeepBlueScreen extends StatefulWidget {
  final User user;
  const GoDeepBlueScreen({Key? key, required this.user}) : super(key: key);

  @override
  _GoDeepBlueScreenState createState() => _GoDeepBlueScreenState();
}

class _GoDeepBlueScreenState extends State<GoDeepBlueScreen> {
  late User user;
  bool? _large, _medium;
  double? _pixelRatio, bottom1;
  Size? size;
  List<ProductDetails> _products = [];
  bool isLoading = false;
  final InAppPurchase _connection = InAppPurchase.instance;

  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    var scrWidth = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(scrWidth, _pixelRatio!);
    _medium = ResponsiveWidget.isScreenMedium(scrWidth, _pixelRatio!);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    right: 20, left: 20, bottom: 20, top: 0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16, top: 00, right: 16, bottom: 5),
                      child: DefaultTextStyle(
                        style: TextStyle(
                          color: Color(0xffffffff),
                          fontWeight: FontWeight.bold,
                          fontSize: _large! ? 14 : (_medium! ? 12 : 12),
                        ),
                        child: Text(
                          "Recurring billing, cancel anytime.".tr(),
                          textAlign: TextAlign.center,
                          textScaleFactor: 1.0,
                          style: TextStyle(
                            color: Color(0xffffffff),
                            fontWeight: FontWeight.bold,
                            fontSize: _large! ? 14 : (_medium! ? 12 : 12),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 16, top: 0, right: 16, bottom: 8),
                        child: DefaultTextStyle(
                          style: TextStyle(
                            color: Color(0xff9c9c9c),
                            fontWeight: FontWeight.bold,
                            fontSize: _large! ? 12 : (_medium! ? 10 : 10),
                          ),
                          child: Text(
                            "By tapping Continue, your payment will be charged to your nuns account and your subscription will automatically renew for the same package length at the same price until you cancel in settings in the 'Tunes store at least 24 hours prior to the end of the current period. By tapping Continue, you agree to our Privacy Policy and Terms."
                                .tr(),
                            textAlign: TextAlign.center,
                            textScaleFactor: 1.0,
                            style: TextStyle(
                              color: Color(0xff9c9c9c),
                              fontSize: _large! ? 12 : (_medium! ? 10 : 10),
                            ),
                          ),
                        )),
                    Container(
                        constraints:
                            const BoxConstraints(minWidth: double.minPositive),
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 5.0, left: 10, right: 10),
                            child: InkWell(
                              onTap: () {
                                setState(() {});
                              },
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: Center(
                                        child: displayCircleImage(
                                            user.profilePictureURL, 90, false)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, top: 0, right: 16, bottom: 8),
                            child: Text(
                              "Go DeepBlue!".tr(),
                              textAlign: TextAlign.center,
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                color: Color(0xff000000),
                                fontWeight: FontWeight.bold,
                                fontSize: _large! ? 22 : (_medium! ? 20 : 20),
                              ),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, top: 0, right: 20, bottom: 8),
                              child: Text(
                                "Unlock your full potential with all of the features of TruuBlue"
                                    .tr(),
                                textAlign: TextAlign.center,
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                  color: Color(0xff000000),
                                  fontSize: _large! ? 16 : (_medium! ? 14 : 14),
                                ),
                              )),
                          SizedBox(
                            height: 5,
                          ),
                          _checkList(),
                          _pricing(),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF68ce09),
                              textStyle: TextStyle(color: Colors.white),
                              padding: EdgeInsets.only(
                                  right: 16, left: 16, top: 5, bottom: 5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  side: BorderSide(color: Color(0xFF68ce09))),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, right: 20),
                              child: IntrinsicHeight(
                                child: Column(
                                  children: [
                                    Text(
                                      'CONTINUE'.tr(),
                                      textScaleFactor: 1.0,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onPressed: () {
                              /*  push(
                                  context,
                                  SubscriptionPaymentScreen(price: 216),
                                );*/
                              /* push(
                                  context,
                                  UpgradeAccount(package: MONTHLY_SUBSCRIPTION),
                                );*/
                              initStoreInfo(MONTHLY_SUBSCRIPTION);
                            },
                          ),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, top: 0, right: 16, bottom: 8),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: DefaultTextStyle(
                                  style: TextStyle(
                                    color: Color(0xff9c9c9c),
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        _large! ? 16 : (_medium! ? 14 : 14),
                                  ),
                                  child: Text(
                                    "NO THANKS".tr(),
                                    textAlign: TextAlign.center,
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                      color: Color(0xff9c9c9c),
                                      fontSize:
                                          _large! ? 16 : (_medium! ? 14 : 14),
                                    ),
                                  ),
                                ),
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
      ),
    );
  }

  final List<String> _sexualityList = [
    'Unlimited likes'.tr(),
    'See Who Likes You'.tr(),
    '1 FREE TruuBoost per month'.tr(),
    '5 FREE Ultra Likes per week'.tr(),
    'Unlimited Backtracks'.tr(),
    'Unlimited Extends'.tr(),
    'Unlimited Rematches'.tr(),
    'Advanced Filters'.tr(),
    'Travel mode'.tr(),
    'Remove ads'.tr(),
  ];
  _checkList() {
    return Container(
      padding: const EdgeInsets.only(left: 0, top: 8, right: 0, bottom: 8),
      height: 130,
      width: 300,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
        ),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: _sexualityList.length,
        itemBuilder: (BuildContext context, int index) {
          return _preferPronounItem(_sexualityList[index], index);
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 7, crossAxisCount: 2),
      ),
    );
  }

  _preferPronounItem(String _list, int index) {
    return Container(
      color: Colors.white,
      child: Padding(
          padding: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
          child: Column(
            children: [
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 3, top: 0, right: 3, bottom: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check,
                        color: Colors.black,
                        size: 20,
                      ),
                      Expanded(
                        child: Text(
                          _list.tr(),
                          textScaleFactor: 1.0,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 10, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  setState(() {});
                },
              ),
              //Divider(color: Colors.grey,height: 1,)
            ],
          )),
    );
  }

  _pricing() {
    return Padding(
      padding: const EdgeInsets.only(left: 0, top: 8, right: 0, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 5.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF70573ac),
                  textStyle: TextStyle(color: Colors.white),
                  padding:
                      EdgeInsets.only(right: 13, left: 13, top: 5, bottom: 5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Color(0xFF0573ac))),
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Text(
                        '6\nMonths'.tr(),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "\$25/mo".tr(),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "-------------".tr(),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Save 36%'.tr(),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "\$125".tr(),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                onPressed: () {
                  /*  push(
                      context,
                      SubscriptionPaymentScreen(price: 125),
                    );*/
                  /* push(
                    context,
                    UpgradeAccount(package: SIX_MONTH_SUBSCRIPTION),
                  );*/
                  initStoreInfo(SIX_MONTH_SUBSCRIPTION);
                },
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 5.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF68ce09),
                  textStyle: TextStyle(color: Colors.white),
                  padding:
                      EdgeInsets.only(right: 16, left: 16, top: 5, bottom: 5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Color(0xFF68ce09))),
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Text(
                        '12\nMonths'.tr(),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "\$18/mo".tr(),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "-------------".tr(),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Save 54%'.tr(),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "\$216".tr(),
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
                      SubscriptionPaymentScreen(price: 216),
                    );*/
                  /* push(
                    context,
                    UpgradeAccount(package:YEARLY_SUBSCRIPTION ,),
                  );*/
                  initStoreInfo(YEARLY_SUBSCRIPTION);
                },
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 5.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF70573ac),
                  textStyle: TextStyle(color: Colors.white),
                  padding:
                      EdgeInsets.only(right: 13, left: 13, top: 5, bottom: 5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Color(0xFF0573ac))),
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Text(
                        '1\nMonths'.tr(),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "\$39/mo".tr(),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "-------------".tr(),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Only'.tr(),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "\$39".tr(),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                onPressed: () {
                  /*push(
                      context,
                      SubscriptionPaymentScreen(price: 39),
                    );*/
                  /*push(
                    context,
                    UpgradeAccount(package: MONTHLY_SUBSCRIPTION,),
                  );*/
                  initStoreInfo(MONTHLY_SUBSCRIPTION);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> initStoreInfo(String package) async {
    setState(() {
      isLoading = true;
    });
    final bool isAvailable = await _connection.isAvailable();
    print('_UpgradeAccountState.initStoreInfo $isAvailable');
    if (!isAvailable) {
      setState(() {
        _products = [];
      });
      return;
    }
    List<String> _kProductIds = <String>[package];

    ProductDetailsResponse productDetailResponse =
        await _connection.queryProductDetails(_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      print('productserror ${productDetailResponse.error}');
      setState(() {
        _products = productDetailResponse.productDetails;
      });
      return;
    }
    await Future.delayed(Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });

    //getting empty product list here
    print('products ${productDetailResponse.productDetails.length}');

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _products = productDetailResponse.productDetails;
      });
      print('productsnotFoundIDs ${productDetailResponse.notFoundIDs.toSet()}');
      return;
    }

    await _connection.restorePurchases();
    final List<PurchaseDetails> verifiedPurchases = [];
    _connection.purchaseStream.listen((event) async {
      for (PurchaseDetails purchase in event) {
        if (await verifyPurchase(purchase)) {
          await _handlePurchase(purchase);
          verifiedPurchases.add(purchase);
        }
      }
    });

    setState(() {
      _products = productDetailResponse.productDetails;
    });

    PurchaseParam purchaseParam = PurchaseParam(
        productDetails: _products.first, applicationUserName: null);
    await _connection.buyNonConsumable(purchaseParam: purchaseParam);
  }

  _handlePurchase(PurchaseDetails purchase) async {
    if (purchase.status == PurchaseStatus.purchased) {
      await showProgress(context, 'Processing purchase...'.tr(), false);
      await FireStoreUtils.recordPurchase(purchase);
      await hideProgress();
      Navigator.pop(context);
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
        },
      );
    }
  }
}
