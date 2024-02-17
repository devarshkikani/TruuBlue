// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dating/main.dart';
// import 'package:dating/model/PurchaseModel.dart';
// import 'package:dating/services/FirebaseHelper.dart';
// import 'package:dating/services/helper.dart';
// import 'package:dating/ui/payment/PaymentScreen.dart';
// import 'package:dating/ui/upgradeAccount/UpgradeAccount.dart';
// import 'package:flutter/material.dart';

// import '../constants.dart';

// class CustomAlertDialog extends StatefulWidget {
//   const CustomAlertDialog(
//       {Key? key,
//       required this.title,
//       required this.description,
//       required this.stream,
//       required this.userID2})
//       : super(key: key);

//   final String title, description, userID2;
//   final StreamController<int> stream;

//   @override
//   _CustomAlertDialogState createState() => _CustomAlertDialogState();
// }

// class _CustomAlertDialogState extends State<CustomAlertDialog> {
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       elevation: 0,
//       backgroundColor: Color(0xffffffff),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15.0),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           SizedBox(height: 15),
//           Text(
//             "${widget.title}",
//             style: TextStyle(
//               fontSize: 18.0,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 15),
//           Padding(
//             padding: const EdgeInsets.only(
//                 right: 20.0, left: 20.0, top: 10.0, bottom: 20.0),
//             child: Text(
//               "${widget.description}",
//               textAlign: TextAlign.center,
//             ),
//           ),
//           SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Container(
//                 height: 50,
//                 child: InkWell(
//                   highlightColor: Colors.blue[600],
//                   onTap: () {
//                     // checkSubscription();
//                     /*push(
//                       context,
//                       PaymentScreen(title: widget.title,description: widget.description,userID2: widget.userID2,stream: widget.stream,),
//                     );*/
//                     /*push(
//                       context,
//                       UpgradeAccount(),
//                     );*/
//                   },
//                   child: Center(
//                     child: Text(
//                       "Yes",
//                       style: TextStyle(
//                         fontSize: 18.0,
//                         color: Theme.of(context).primaryColor,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Container(
//                 height: 50,
//                 child: InkWell(
//                   highlightColor: Colors.blue[600],
//                   onTap: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: Center(
//                     child: Text(
//                       "No",
//                       style: TextStyle(
//                         fontSize: 16.0,
//                         color: Theme.of(context).primaryColor,
//                         fontWeight: FontWeight.normal,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // void checkSubscription() async {
//   //   await showProgress(context, 'Loading...', false);
//   //   PurchaseModel purchaseModel = PurchaseModel(
//   //       active: true,
//   //       productId: MONTHLY_SUBSCRIPTION,
//   //       receipt: MONTHLY_SUBSCRIPTION,
//   //       serverVerificationData: DateTime.now().toString(),
//   //       source: "",
//   //       subscriptionPeriod: "",
//   //       transactionDate: DateTime.now().millisecondsSinceEpoch,
//   //       userID: MyAppState.currentUser!.userID,
//   //       userID2: widget.userID2);
//   //   await FireStoreUtils.activeMatch(purchaseModel);

//   //   await hideProgress();
//   //   Navigator.of(context).pop();
//   //   widget.stream.add(1);
//   // }
// }
