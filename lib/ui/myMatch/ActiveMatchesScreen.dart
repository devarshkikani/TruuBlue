// import 'dart:async';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dating/constants.dart';
// import 'package:dating/help/CustomAlertDialog.dart';
// import 'package:dating/model/ConversationModel.dart';
// import 'package:dating/model/HomeConversationModel.dart';
// import 'package:dating/model/PurchaseModel.dart';
// import 'package:dating/model/Swipe.dart';
// import 'package:dating/model/User.dart';
// import 'package:dating/services/FirebaseHelper.dart';
// import 'package:dating/services/helper.dart';
// import 'package:dating/ui/chat/ChatScreen.dart';
// import 'package:dating/ui/payment/PaymentScreen.dart';
// import 'package:dating/ui/userDetailsScreen/UserDetailsScreen.dart';
// import 'package:easy_localization/src/public_ext.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// import '../../main.dart';

// StreamController<int> _streamController = StreamController.broadcast();

// class ActiveMatchesScreen extends StatefulWidget {
//   final User user;

//   const ActiveMatchesScreen({Key? key, required this.user}) : super(key: key);

//   @override
//   _ActiveMatchesScreenState createState() => _ActiveMatchesScreenState();
// }

// class _ActiveMatchesScreenState extends State<ActiveMatchesScreen> {
//   late User user;
//   final fireStoreUtils = FireStoreUtils();
//   late Future<List<User>> _matchesFuture;
//   late Future<List<User>> _expireMatchesFuture;
//   late Future<List<User>> _matchesFutureSort;
//   late Future<List<User>> _expireMatchesFutureSort;
//   static FirebaseFirestore firestore = FirebaseFirestore.instance;
//   List<Swipe> matchList = <Swipe>[];
//   List<Swipe> expireMatchList = <Swipe>[];
//   List<Swipe> afterfotryeight = <Swipe>[];
//   @override
//   void initState() {
//     super.initState();
//     user = widget.user;
//     _swipeuser();
//     _streamController.stream.asBroadcastStream().listen((event) {
//       _swipeuser();
//       if (event == 1) {
//         setState(() {
//           fireStoreUtils.getBlocks().listen((shouldRefresh) {
//             if (shouldRefresh) {
//               setState(() {});
//             }
//           });
//           _matchesFuture = fireStoreUtils.getMatchedUserObject(user.userID);
//           //_expireMatchesFuture=fireStoreUtils.getExpireMatchedUserObject(user.userID);
//         });
//       }
//       _activesort();
//     });
//     fireStoreUtils.getBlocks().listen((shouldRefresh) {
//       if (shouldRefresh) {
//         setState(() {});
//       }
//     });

//     _matchesFuture = fireStoreUtils.getMatchedUserObject(user.userID);
//     // _expireMatchesFuture=fireStoreUtils.getExpireMatchedUserObject(user.userID);
//     _activesort();
//   }

//   _activesort() {
//     List<User> _Sort = [];
//     List<User> _ExpireSort = [];
//     _matchesFuture.then((value) {
//       value.forEach((elem) {
//         matchList.forEach((element) {
//           if (elem.userID == element.user2) {
//             setState(() {
//               _Sort.add(elem);
//             });
//           }
//         });
//         expireMatchList.forEach((element) {
//           if (elem.userID == element.user2) {
//             setState(() {
//               _ExpireSort.add(elem);
//             });
//           }
//         });
//       });
//     });
//     print(_Sort);
//     print(_ExpireSort);
//     setState(() {
//       _matchesFutureSort = Future.value(_Sort);
//       _expireMatchesFutureSort = Future.value(_ExpireSort);
//     });
//   }

//   _swipeuser() async {
//     matchList = <Swipe>[];
//     expireMatchList = [];
//     afterfotryeight = [];
//     await firestore
//         .collection(SWIPES)
//         .where('user1', isEqualTo: user.userID)
//         .where('hasBeenSeen', isEqualTo: true)
//         .get()
//         .then((querySnapShot) {
//       querySnapShot.docs.forEach((doc) async {
//         Swipe match = Swipe.fromJson(doc.data());
//         if (match.id.isEmpty) {
//           match.id = doc.id;
//         }
//         _isSubscribeUser(match);
//         _isExpireSubscribeUser(match);
//       });
//     });
//   }

//   _isExpireSubscribeUser(Swipe match) async {
//     await firestore
//         .collection(ACTIVE_MATCH)
//         .where('userID', isEqualTo: user.userID)
//         .where('userID2', isEqualTo: match.user2)
//         .get()
//         .then((querySnapShot) {
//       if (querySnapShot.docs.isNotEmpty) {
//         querySnapShot.docs.forEach((doc) {
//           PurchaseModel model = PurchaseModel.fromJson(doc.data());
//           DateTime purchaseDate =
//               DateTime.fromMillisecondsSinceEpoch(model.transactionDate);
//           DateTime endOfSubscription = DateTime.now();
//           if (model.productId == MONTHLY_SUBSCRIPTION) {
//             endOfSubscription = purchaseDate.add(Duration(days: 30));
//           } else if (model.productId == YEARLY_SUBSCRIPTION) {
//             endOfSubscription = purchaseDate.add(Duration(days: 365));
//           }
//           if (DateTime.now().isAfter(endOfSubscription)) {
//             expireMatchList.add(match);
//           } else if (DateTime.now().isBefore(endOfSubscription)) {
//           } else {
//             if (Timestamp.now()
//                     .toDate()
//                     .difference(match.createdAt.toDate())
//                     .inDays >
//                 10) {
//               expireMatchList.add(match);
//             }
//           }
//         });
//       } else {
//         if (Timestamp.now()
//                 .toDate()
//                 .difference(match.createdAt.toDate())
//                 .inDays >
//             10 {
//           expireMatchList.add(match);
//         }
//       }
//     });
//     _activesort();
//   }

//   _isSubscribeUser(Swipe match) async {
//     await firestore
//         .collection(ACTIVE_MATCH)
//         .where('userID', isEqualTo: user.userID)
//         .where('userID2', isEqualTo: match.user2)
//         .get()
//         .then((querySnapShot) {
//       if (querySnapShot.docs.isNotEmpty) {
//         querySnapShot.docs.forEach((doc) {
//           PurchaseModel model = PurchaseModel.fromJson(doc.data());
//           DateTime purchaseDate =
//               DateTime.fromMillisecondsSinceEpoch(model.transactionDate);
//           DateTime endOfSubscription = DateTime.now();
//           if (model.productId == MONTHLY_SUBSCRIPTION) {
//             endOfSubscription = purchaseDate.add(Duration(days: 30));
//           } else if (model.productId == YEARLY_SUBSCRIPTION) {
//             endOfSubscription = purchaseDate.add(Duration(days: 365));
//           }
//           if (DateTime.now().isBefore(endOfSubscription)) {
//             matchList.add(match);
//           } else {
//             if (Timestamp.now()
//                     .toDate()
//                     .difference(match.createdAt.toDate())
//                     .inDays <
//               10) {
//               matchList.add(match);
//               afterfotryeight.add(match);
//             }
//           }
//         });
//       } else {
//         if (Timestamp.now()
//                 .toDate()
//                 .difference(match.createdAt.toDate())
//                 .inDays <
//             10) {
//           matchList.add(match);
//           afterfotryeight.add(match);
//         }
//       }
//     });
//     _activesort();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var scrWidth = MediaQuery.of(context).size.width;
//     var scrHeight = MediaQuery.of(context).size.height;
//     final orientation = MediaQuery.of(context).orientation;
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 20.0, top: 10),
//             child: Align(
//                 alignment: Directionality.of(context) == TextDirection.ltr
//                     ? Alignment.topLeft
//                     : Alignment.topLeft,
//                 child: Text(
//                   'Active Matches'.tr(),
//                   textScaleFactor: 1.0,
//                   style: TextStyle(
//                       color: Color(0xFF0573ac),
//                       fontWeight: FontWeight.bold,
//                       fontSize: 20),
//                   textAlign: TextAlign.start,
//                 )),
//           ),
//           FutureBuilder<List<User>>(
//             future: _matchesFutureSort,
//             initialData: [],
//             builder: (context, snap) {
//               if (snap.connectionState == ConnectionState.waiting)
//                 return Container(
//                   width: MediaQuery.of(context).size.width,
//                   height: (MediaQuery.of(context).size.height / 2) - 123,
//                   child: Center(
//                     child: CircularProgressIndicator.adaptive(
//                       valueColor:
//                           AlwaysStoppedAnimation<Color>(Color(COLOR_ACCENT)),
//                     ),
//                   ),
//                 );
//               if (!snap.hasData || (snap.data?.isEmpty ?? true)) {
//                 return SizedBox(
//                   width: MediaQuery.of(context).size.width,
//                   height: (MediaQuery.of(context).size.height / 2) - 123,
//                   child: Center(
//                     child: Text(
//                       'No Matches found.'.tr(),
//                       style: TextStyle(fontSize: 18),
//                     ),
//                   ),
//                 );
//               } else {
//                 return Container(
//                   width: MediaQuery.of(context).size.width,
//                   height: (MediaQuery.of(context).size.height / 2) - 123,
//                   child: ListView.builder(
//                       physics: NeverScrollableScrollPhysics(),
//                       shrinkWrap: true,
//                       itemCount: snap.data!.length,
//                       itemBuilder: (context, index) {
//                         final homeConversationModel = snap.data![index];

//                         return fireStoreUtils.validateIfUserBlocked(
//                                 homeConversationModel.userID)
//                             ? Container(
//                                 width: 0,
//                                 height: 0,
//                               )
//                             : Padding(
//                                 padding: const EdgeInsets.only(
//                                     left: 16.0, right: 16, top: 8, bottom: 8),
//                                 child: Column(
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.only(top: 8.0),
//                                       child: Row(
//                                         children: <Widget>[
//                                           Stack(
//                                             alignment: Alignment.bottomRight,
//                                             children: <Widget>[
//                                               InkWell(
//                                                 onTap: () {
//                                                   push(
//                                                     context,
//                                                     UserDetailsScreen(
//                                                       user:
//                                                           homeConversationModel,
//                                                       isMatch: true,
//                                                       isMenuVisible: false,
//                                                     ),
//                                                   );
//                                                 },
//                                                 child: displayCircleImage(
//                                                     homeConversationModel
//                                                         .profilePictureURL,
//                                                     50,
//                                                     false),
//                                               ),
//                                               Positioned(
//                                                   right: 2.4,
//                                                   bottom: 2.4,
//                                                   child: Container(
//                                                     width: 12,
//                                                     height: 12,
//                                                     decoration: BoxDecoration(
//                                                         color:
//                                                             homeConversationModel
//                                                                     .active
//                                                                 ? Colors.green
//                                                                 : Colors.grey,
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(100),
//                                                         border: Border.all(
//                                                             color: isDarkMode(
//                                                                     context)
//                                                                 ? Color(
//                                                                     0xFF303030)
//                                                                 : Colors.white,
//                                                             width: 1.6)),
//                                                   ))
//                                             ],
//                                           ),
//                                           Expanded(
//                                             child: Padding(
//                                               padding: const EdgeInsets.only(
//                                                   top: 8, right: 8, left: 15),
//                                               child: Column(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.start,
//                                                 children: <Widget>[
//                                                   Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .spaceBetween,
//                                                     children: [
//                                                       InkWell(
//                                                         onTap: () {
//                                                           push(
//                                                               context,
//                                                               UserDetailsScreen(
//                                                                 user:
//                                                                     homeConversationModel,
//                                                                 isMatch: true,
//                                                                 isMenuVisible:
//                                                                     false,
//                                                               ));
//                                                         },
//                                                         child: Text(
//                                                           '${homeConversationModel.fullName()},${homeConversationModel.calculateAge()}',
//                                                           textScaleFactor: 1.0,
//                                                           style: TextStyle(
//                                                               fontSize: 20,
//                                                               color: isDarkMode(
//                                                                       context)
//                                                                   ? Colors.white
//                                                                   : Color(
//                                                                       0xff000000),
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .bold),
//                                                         ),
//                                                       ),
//                                                       Text(
//                                                         '',
//                                                         maxLines: 1,
//                                                         textScaleFactor: 1.0,
//                                                         style: TextStyle(
//                                                             fontSize: 16,
//                                                             color: Color(
//                                                                 0xff000000)),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                   Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .spaceBetween,
//                                                     children: [
//                                                       SizedBox(
//                                                         child: Padding(
//                                                           padding:
//                                                               const EdgeInsets
//                                                                       .only(
//                                                                   top: 5.0),
//                                                           child: Text(
//                                                             homeConversationModel
//                                                                 .bio,
//                                                             overflow:
//                                                                 TextOverflow
//                                                                     .ellipsis,
//                                                             //'${homeConversationModel.bio} ',
//                                                             textScaleFactor:
//                                                                 1.0,
//                                                             maxLines: 1,
//                                                             style: TextStyle(
//                                                                 fontSize: 16,
//                                                                 color: Color(
//                                                                     0xff8d8d8d)),
//                                                           ),
//                                                         ),
//                                                         width: 200,
//                                                       ),
//                                                       Row(
//                                                         children: [
//                                                           InkWell(
//                                                               onTap: () {
//                                                                 setState(
//                                                                     () async {
//                                                                   var flag =
//                                                                       false;
//                                                                   afterfotryeight
//                                                                       .forEach(
//                                                                           (element) {
//                                                                     if (element
//                                                                             .user2 ==
//                                                                         homeConversationModel
//                                                                             .userID) {
//                                                                       flag =
//                                                                           true;
//                                                                     }
//                                                                   });
//                                                                   if (flag) {
//                                                                     showDialog(
//                                                                       barrierColor:
//                                                                           Colors
//                                                                               .black26,
//                                                                       context:
//                                                                           context,
//                                                                       builder:
//                                                                           (context) {
//                                                                         return CustomAlertDialog(
//                                                                           title:
//                                                                               "Rekindle?",
//                                                                           description:
//                                                                               "Would You Like To Renew Your Match With This Person?",
//                                                                           stream:
//                                                                               _streamController,
//                                                                           userID2:
//                                                                               homeConversationModel.userID,
//                                                                         );
//                                                                       },
//                                                                     );
//                                                                   } else {
//                                                                     String
//                                                                         channelID;
//                                                                     if (homeConversationModel
//                                                                             .userID
//                                                                             .compareTo(MyAppState.currentUser!.userID) <
//                                                                         0) {
//                                                                       channelID = homeConversationModel
//                                                                               .userID +
//                                                                           MyAppState
//                                                                               .currentUser!
//                                                                               .userID;
//                                                                     } else {
//                                                                       channelID = MyAppState
//                                                                               .currentUser!
//                                                                               .userID +
//                                                                           homeConversationModel
//                                                                               .userID;
//                                                                     }
//                                                                     ConversationModel?
//                                                                         conversationModel =
//                                                                         await fireStoreUtils
//                                                                             .getChannelByIdOrNull(channelID);
//                                                                     Navigator.push(
//                                                                         context,
//                                                                         MaterialPageRoute(
//                                                                             builder: (context) => ChatScreen(
//                                                                                   activeMatch: (bool isActive) {
//                                                                                     homeConversationModel.active = isActive;
//                                                                                   },
//                                                                                   homeConversationModel: HomeConversationModel(
//                                                                                     isGroupChat: false,
//                                                                                     members: [
//                                                                                       homeConversationModel
//                                                                                     ],
//                                                                                     conversationModel: conversationModel,
//                                                                                   ),
//                                                                                 ))).then((value) {
//                                                                       setState(
//                                                                           () {});
//                                                                     });
//                                                                   }
//                                                                 });
//                                                               },
//                                                               child: Icon(
//                                                                 Icons
//                                                                     .mail_outlined,
//                                                                 color: Color(
//                                                                     0xff8d8d8d),
//                                                                 size: 30,
//                                                               )),
//                                                           SizedBox(
//                                                             width: 10,
//                                                           ),
//                                                           InkWell(
//                                                               onTap: () {
//                                                                 setState(() {
//                                                                   fireStoreUtils.removeLikeYou(
//                                                                       user
//                                                                           .userID,
//                                                                       homeConversationModel
//                                                                           .userID);
//                                                                   snap.data
//                                                                       ?.removeAt(
//                                                                           index);
//                                                                 });
//                                                               },
//                                                               child: Icon(
//                                                                 Icons.close,
//                                                                 color: Color(
//                                                                     0xff8d8d8d),
//                                                                 size: 30,
//                                                               ))
//                                                         ],
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.only(top: 10.0),
//                                       child: Divider(
//                                         color: Color(0xff000000),
//                                         height: 1,
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               );
//                       }),
//                 );
//               }
//             },
//           ),
//           Padding(
//             padding: const EdgeInsets.only(
//               left: 20.0,
//             ),
//             child: Align(
//                 alignment: Directionality.of(context) == TextDirection.ltr
//                     ? Alignment.topLeft
//                     : Alignment.topLeft,
//                 child: Text(
//                   'Expire Matches'.tr(),
//                   textScaleFactor: 1.0,
//                   style: TextStyle(
//                       color: Color(0xFF0573ac),
//                       fontWeight: FontWeight.bold,
//                       fontSize: 20),
//                   textAlign: TextAlign.start,
//                 )),
//           ),
//           FutureBuilder<List<User>>(
//             future: _expireMatchesFutureSort,
//             initialData: [],
//             builder: (context, snap) {
//               if (snap.connectionState == ConnectionState.waiting)
//                 return Container(
//                   width: MediaQuery.of(context).size.width,
//                   height: (MediaQuery.of(context).size.height / 2) - 133,
//                   child: Center(
//                     child: CircularProgressIndicator.adaptive(
//                       valueColor:
//                           AlwaysStoppedAnimation<Color>(Color(COLOR_ACCENT)),
//                     ),
//                   ),
//                 );
//               if (!snap.hasData || (snap.data?.isEmpty ?? true)) {
//                 return SizedBox(
//                   width: MediaQuery.of(context).size.width,
//                   height: (MediaQuery.of(context).size.height / 2) - 133,
//                   child: Center(
//                     child: Text(
//                       'No Matches found.'.tr(),
//                       style: TextStyle(fontSize: 18),
//                     ),
//                   ),
//                 );
//               } else {
//                 return Container(
//                   width: MediaQuery.of(context).size.width,
//                   height: (MediaQuery.of(context).size.height / 2) - 133,
//                   child: ListView.builder(
//                       physics: NeverScrollableScrollPhysics(),
//                       shrinkWrap: true,
//                       itemCount: snap.data!.length,
//                       itemBuilder: (context, index) {
//                         final homeConversationModel = snap.data![index];

//                         return fireStoreUtils.validateIfUserBlocked(
//                                 homeConversationModel.userID)
//                             ? Container(
//                                 width: 0,
//                                 height: 0,
//                               )
//                             : Padding(
//                                 padding: const EdgeInsets.only(
//                                     left: 16.0, right: 16, top: 8, bottom: 8),
//                                 child: _buildConversationRowExpire(
//                                     homeConversationModel),
//                               );
//                       }),
//                 );
//               }
//             },
//           )
//         ],
//       ),
//     );
//   }

//   Widget _buildConversationRowExpire(User homeConversationModel) {
//     String user1Image = '';
//     String user2Image = '';
//     if (homeConversationModel != null) {
//       user1Image = homeConversationModel.profilePictureURL;
//       user2Image = homeConversationModel.profilePictureURL;
//     }
//     return InkWell(
//       onTap: () {
//         showDialog(
//           barrierColor: Colors.black26,
//           context: context,
//           builder: (context) {
//             return CustomAlertDialog(
//               title: "Rekindle?",
//               description:
//                   "Would You Like To Renew Your Match With This Person?",
//               stream: _streamController,
//               userID2: homeConversationModel.userID,
//             );
//           },
//         );
//       },
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 8.0),
//             child: Row(
//               children: <Widget>[
//                 Stack(
//                   alignment: Alignment.bottomRight,
//                   children: <Widget>[
//                     Container(
//                       foregroundDecoration: BoxDecoration(
//                         color: Colors.grey,
//                         backgroundBlendMode: BlendMode.saturation,
//                         shape: BoxShape.circle,
//                       ),
//                       child: displayCircleImage(
//                           homeConversationModel.profilePictureURL, 50, false),
//                     ),
//                     Positioned(
//                         right: 2.4,
//                         bottom: 2.4,
//                         child: Container(
//                           width: 12,
//                           height: 12,
//                           decoration: BoxDecoration(
//                               color: homeConversationModel.active
//                                   ? Colors.green
//                                   : Colors.grey,
//                               borderRadius: BorderRadius.circular(100),
//                               border: Border.all(
//                                   color: isDarkMode(context)
//                                       ? Color(0xFF303030).withOpacity(0.5)
//                                       : Colors.white.withOpacity(0.5),
//                                   width: 1.6)),
//                         ))
//                   ],
//                 ),
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 8, right: 8, left: 15),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: <Widget>[
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               '${homeConversationModel.fullName()},${homeConversationModel.calculateAge()}',
//                               textScaleFactor: 1.0,
//                               style: TextStyle(
//                                   fontSize: 20,
//                                   color: isDarkMode(context)
//                                       ? Colors.white
//                                       : Color(0xffd7d7d7),
//                                   fontWeight: FontWeight.bold),
//                             ),
//                             Text(
//                               '',
//                               maxLines: 1,
//                               textScaleFactor: 1.0,
//                               style: TextStyle(
//                                   fontSize: 16, color: Color(0xff000000)),
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           child: Padding(
//                             padding: const EdgeInsets.only(top: 5.0),
//                             child: Text(
//                               homeConversationModel.bio,
//                               overflow: TextOverflow.ellipsis,
//                               //'${homeConversationModel.bio} ',
//                               textScaleFactor: 1.0,
//                               maxLines: 1,
//                               style: TextStyle(
//                                   fontSize: 16, color: Color(0xff8d8d8d)),
//                             ),
//                           ),
//                           width: 200,
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 10.0),
//             child: Divider(
//               color: Color(0xff000000),
//               height: 1,
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _buildConversationRow(User homeConversationModel, int index) {
//     String user1Image = '';
//     String user2Image = '';
//     if (homeConversationModel != null) {
//       user1Image = homeConversationModel.profilePictureURL;
//       user2Image = homeConversationModel.profilePictureURL;
//     }
//     return InkWell(
//       onTap: () async {
//         String channelID;
//         if (homeConversationModel.userID
//                 .compareTo(MyAppState.currentUser!.userID) <
//             0) {
//           channelID =
//               homeConversationModel.userID + MyAppState.currentUser!.userID;
//         } else {
//           channelID =
//               MyAppState.currentUser!.userID + homeConversationModel.userID;
//         }
//         ConversationModel? conversationModel =
//             await fireStoreUtils.getChannelByIdOrNull(channelID);
//         push(
//             context,
//             ChatScreen(
//                 homeConversationModel: HomeConversationModel(
//                     isGroupChat: false,
//                     members: [homeConversationModel],
//                     conversationModel: conversationModel)));
//       },
//       /* child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 8.0),
//             child: Row(
//               children: <Widget>[
//                 Stack(
//                   alignment: Alignment.bottomRight,
//                   children: <Widget>[
//                     displayCircleImage(
//                         homeConversationModel.profilePictureURL,
//                         50,
//                         false),
//                     Positioned(
//                         right: 2.4,
//                         bottom: 2.4,
//                         child: Container(
//                           width: 12,
//                           height: 12,
//                           decoration: BoxDecoration(
//                               color: homeConversationModel.active
//                                   ? Colors.green
//                                   : Colors.grey,
//                               borderRadius: BorderRadius.circular(100),
//                               border: Border.all(
//                                   color: isDarkMode(context)
//                                       ? Color(0xFF303030)
//                                       : Colors.white,
//                                   width: 1.6)),
//                         ))
//                   ],
//                 ),
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 8, right: 8, left: 15),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: <Widget>[
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               '${homeConversationModel.fullName()}',
//                               textScaleFactor: 1.0,
//                               style: TextStyle(
//                                   fontSize: 20,
//                                   color: isDarkMode(context)
//                                       ? Colors.white
//                                       : Color(0xff176d00),fontWeight: FontWeight.bold),
//                             ),Text(
//                               '',
//                               maxLines: 1,
//                               textScaleFactor: 1.0,
//                               style: TextStyle(
//                                   fontSize: 16, color: Color(0xff000000)),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(top: 5.0),
//                               child: Text(
//                                 'Nice to meet you!',//'${homeConversationModel.bio} ',
//                                 textScaleFactor: 1.0,
//                                 maxLines: 1,
//                                 style: TextStyle(
//                                     fontSize: 16, color: Color(0xff176d00)),
//                               ),
//                             ),
//                     InkWell(
//                         onTap: () {
//                           setState(() async {
//                             String channelID;
//                             if (homeConversationModel.userID
//                                 .compareTo(MyAppState.currentUser!.userID) <
//                                 0) {
//                               channelID = homeConversationModel.userID +
//                                   MyAppState.currentUser!.userID;
//                             } else {
//                               channelID = MyAppState.currentUser!.userID +
//                                   homeConversationModel.userID;
//                             }
//                             ConversationModel? conversationModel =
//                                 await fireStoreUtils
//                                 .getChannelByIdOrNull(channelID);
//                             pushReplacement(
//                               context,
//                               ChatScreen(
//                                 homeConversationModel: HomeConversationModel(
//                                     isGroupChat: false,
//                                     members: [homeConversationModel],
//                                     conversationModel: conversationModel),
//                               ),
//                             );
//                           });
//                         },
//                         child: Icon(
//                           Icons.mail_outlined,
//                           color: Colors.white,
//                           size: 30,
//                         )),
//                             InkWell(
//                               onTap: () {
//                                 setState(() {
//                                   fireStoreUtils.removeLikeYou(user.userID,homeConversationModel.userID);
//                                   snap.data?.removeAt(index);
//                                 });
//                               },
//                               child: Icon(
//                                 Icons.close,
//                                 color: Colors.white,
//                                 size: 30,
//                               ))
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),Padding(
//             padding: const EdgeInsets.only(top: 10.0),
//             child: Divider(color: Color(0xff000000) ,height: 1,),
//           )
//         ],
//       ),*/
//     );
//   }
// }
