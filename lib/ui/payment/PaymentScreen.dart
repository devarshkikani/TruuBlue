import 'dart:async';

import 'package:dating/model/PurchaseModel.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';

import '../../constants.dart';
import '../../main.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen(
      {Key? key,
      required this.title,
      required this.description,
      required this.stream,
      required this.userID2})
      : super(key: key);
  final String title, description, userID2;
  final StreamController<int> stream;
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  var _paymentItems = [
    PaymentItem(
      label: 'Total',
      amount: '25.00',
      status: PaymentItemStatus.final_price,
    )
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50.0, left: 20),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 30,
                    color: Color(0xFF0573ac),
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GooglePayButton(
                  paymentConfigurationAsset: 'gpay.json',
                  paymentItems: _paymentItems,
                  // style: GooglePayButtonStyle.black,
                  type: GooglePayButtonType.pay,
                  margin: const EdgeInsets.only(top: 15.0),
                  onPaymentResult: onGooglePayResult,
                  loadingIndicator: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                ApplePayButton(
                  paymentConfigurationAsset: 'applepay.json',
                  paymentItems: _paymentItems,
                  style: ApplePayButtonStyle.black,
                  type: ApplePayButtonType.buy,
                  margin: const EdgeInsets.only(top: 15.0),
                  onPaymentResult: onApplePayResult,
                  loadingIndicator: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onGooglePayResult(paymentResult) {
    debugPrint(paymentResult.toString());
  }

  void onApplePayResult(paymentResult) {
    debugPrint(paymentResult.toString());
    checkSubscription();
  }

  void checkSubscription() async {
    await showProgress(context, 'Loading...', false);
    PurchaseModel purchaseModel = PurchaseModel(
        active: true,
        productId: MONTHLY_SUBSCRIPTION,
        receipt: MONTHLY_SUBSCRIPTION,
        serverVerificationData: DateTime.now().toString(),
        source: "",
        subscriptionPeriod: "",
        transactionDate: DateTime.now().millisecondsSinceEpoch,
        userID: MyAppState.currentUser!.userID,
        userID2: widget.userID2);
    await FireStoreUtils.subscribePurchase(purchaseModel);
    Navigator.of(context).pop();
    await hideProgress();
    widget.stream.add(1);
  }
}
