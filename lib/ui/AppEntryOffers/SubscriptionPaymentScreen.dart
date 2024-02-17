import 'package:dating/model/PurchaseModel.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';

import '../../constants.dart';
import '../../main.dart';

class SubscriptionPaymentScreen extends StatefulWidget {
  SubscriptionPaymentScreen({Key? key, required this.price}) : super(key: key);
  double price;
  @override
  _SubscriptionPaymentScreenState createState() =>
      _SubscriptionPaymentScreenState();
}

class _SubscriptionPaymentScreenState extends State<SubscriptionPaymentScreen> {
  @override
  Widget build(BuildContext context) {
    var _paymentItems = [
      PaymentItem(
        label: 'Total',
        amount: widget.price.toString(),
        status: PaymentItemStatus.final_price,
      )
    ];
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
                Text(
                  '\$${widget.price}',
                  maxLines: 1,
                  textScaleFactor: 1.0,
                  style: TextStyle(fontSize: 16, color: Color(0xff000000)),
                ),
                GooglePayButton(
                  paymentConfigurationAsset: 'gpay.json',
                  paymentItems: _paymentItems,
                  // style: GooglePayButtonStyle.white,
                  type: GooglePayButtonType.subscribe,
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
                  onError: (error) {
                    print(error);
                  },
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
    // checkSubscription();
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
        userID2: "widget.userID2");
    await FireStoreUtils.subscribePurchase(purchaseModel);
    Navigator.of(context).pop();
    await hideProgress();
  }
}
