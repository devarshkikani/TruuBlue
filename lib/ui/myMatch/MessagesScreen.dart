import 'package:dating/main.dart';
import 'package:dating/constants.dart';
import 'package:flutter/material.dart';
import 'package:dating/model/User.dart';
import 'package:dating/model/Swipe.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/ui/chat/ChatScreen.dart';
import 'package:dating/model/PurchaseModel.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:dating/model/HomeConversationModel.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  late User user;
  final fireStoreUtils = FireStoreUtils();
  late Stream<List<HomeConversationModel>> _conversationsStream;
  late Future<List<User>> _matchesFuture;
  late List<User> youLikedObjectFuture;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Swipe> matchList = <Swipe>[];
  List<Swipe> afterfotryeight = <Swipe>[];
  List<User> _Sort = [];
  bool isLoaging = true;

  @override
  void initState() {
    super.initState();
    FlutterAppBadger.removeBadge();
    user = MyAppState.currentUser!;
    fireStoreUtils.getBlocks().listen((shouldRefresh) {
      if (shouldRefresh) {
        setState(() {});
      }
    });
    _matchesFuture = fireStoreUtils.getMatchedUserObject(user.userID);
    _conversationsStream = fireStoreUtils.getConversations(user.userID);
    _swipeuser();
  }

  _swipeuser() async {
    matchList = <Swipe>[];
    afterfotryeight = [];
    youLikedObjectFuture = await fireStoreUtils.getYouLikedObject(user.userID);
    await firestore
        .collection(SWIPES)
        .where('user1', isEqualTo: user.userID)
        .where('hasBeenSeen', isEqualTo: true)
        .get()
        .then((querySnapShot) {
      querySnapShot.docs.forEach((doc) async {
        Swipe match = Swipe.fromJson(doc.data());
        if (match.id.isEmpty) {
          match.id = doc.id;
        }
        _isSubscribeUser(match);
      });
    });
  }

  _isSubscribeUser(Swipe match) async {
    await firestore
        .collection(SUBSCRIPTIONS)
        .where('userID', isEqualTo: user.userID)
        .get()
        .then((querySnapShot) {
      if (querySnapShot.docs.isNotEmpty) {
        querySnapShot.docs.forEach((doc) {
          PurchaseModel model = PurchaseModel.fromJson(doc.data());
          DateTime purchaseDate =
              DateTime.fromMillisecondsSinceEpoch(model.transactionDate);
          DateTime endOfSubscription = DateTime.now();
          if (model.productId == MONTHLY_SUBSCRIPTION) {
            endOfSubscription = purchaseDate.add(Duration(days: 30));
          } else if (model.productId == YEARLY_SUBSCRIPTION) {
            endOfSubscription = purchaseDate.add(Duration(days: 365));
          }
          if (DateTime.now().isBefore(endOfSubscription)) {
            matchList.add(match);
          } else {
            if (Timestamp.now()
                    .toDate()
                    .difference(match.createdAt.toDate())
                    .inDays <
                7) {
              matchList.add(match);
              afterfotryeight.add(match);
            }
          }
        });
      } else {
        if (Timestamp.now()
                .toDate()
                .difference(match.createdAt.toDate())
                .inDays <
            7) {
          matchList.add(match);
          afterfotryeight.add(match);
        }
      }
    });
    _activesort();
  }

  _activesort() {
    _Sort = [];

    _matchesFuture.then((value) {
      value.forEach((elem) {
        matchList.forEach((element) {
          if (elem.userID == element.user2) {
            if (mounted)
              setState(() {
                _Sort.add(elem);
              });
          }
        });
      });
    });
    setState(() {
      isLoaging = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
          child: Row(
            children: [
              Text(
                'Matches',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<List<HomeConversationModel>>(
            stream: _conversationsStream,
            initialData: [],
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  isLoaging) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 200,
                  child: Center(
                    child: CircularProgressIndicator.adaptive(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(COLOR_ACCENT)),
                    ),
                  ),
                );
              } else if (!snapshot.hasData ||
                  (snapshot.data?.isEmpty ?? true)) {
                return Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'No conversations found.',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              } else {
                List<HomeConversationModel> activeChatList = [];
                List<HomeConversationModel> expireChatList = [];
                snapshot.data?.forEach((e) {
                  _Sort.forEach((element) {
                    if (element.userID == e.members.first.userID) {
                      if (Timestamp.now()
                              .toDate()
                              .difference(
                                  e.conversationModel!.lastMessageDate.toDate())
                              .inDays <
                          7) {
                        e.isExpireChat = true;
                        activeChatList.add(e);
                      } else {
                        e.isExpireChat = false;
                        expireChatList.add(e);
                      }
                    }
                  });
                });
                return expireChatList.isEmpty && activeChatList.isEmpty
                    ? Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            'No conversations found.',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height - 200,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: activeChatList.length,
                                  itemBuilder: (context, index) {
                                    final homeConversationModel =
                                        activeChatList[index];
                                    if (homeConversationModel.isGroupChat) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16.0,
                                            right: 16,
                                            top: 8,
                                            bottom: 8),
                                        child: _buildConversationRow(
                                          homeConversationModel,
                                        ),
                                      );
                                    } else {
                                      return fireStoreUtils
                                              .validateIfUserBlocked(
                                                  homeConversationModel
                                                      .members.first.userID)
                                          ? Container(
                                              width: 0,
                                              height: 0,
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16.0,
                                                  right: 16,
                                                  top: 8,
                                                  bottom: 8),
                                              child: _buildConversationRow(
                                                homeConversationModel,
                                              ),
                                            );
                                    }
                                  }),
                              Theme(
                                data: ThemeData()
                                    .copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  title: Text(
                                    'Expired (${expireChatList.length})',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  children: List.generate(expireChatList.length,
                                      (index) {
                                    final homeConversationModel =
                                        expireChatList[index];
                                    if (homeConversationModel.isGroupChat) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16.0,
                                            right: 16,
                                            top: 8,
                                            bottom: 8),
                                        child: _buildConversationRow(
                                          homeConversationModel,
                                        ),
                                      );
                                    } else {
                                      return fireStoreUtils
                                              .validateIfUserBlocked(
                                                  homeConversationModel
                                                      .members.first.userID)
                                          ? Container(
                                              width: 0,
                                              height: 0,
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16.0,
                                                  right: 16,
                                                  top: 8,
                                                  bottom: 8),
                                              child: _buildConversationRow(
                                                homeConversationModel,
                                              ),
                                            );
                                    }
                                  }),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildConversationRow(HomeConversationModel homeConversationModel) {
    String user1Image = '';
    String user2Image = '';
    if (homeConversationModel.members.length >= 2) {
      user1Image = homeConversationModel.members.first.profilePictureURL;
      user2Image = homeConversationModel.members.elementAt(1).profilePictureURL;
    }

    return Slidable(
      key: Key(homeConversationModel.conversationModel!.id),
      direction: Axis.horizontal,
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        extentRatio: 0.2,
        children: [
          SlidableAction(
            onPressed: (value) async {
              showProgress(context, 'Loading...', false);
              await fireStoreUtils.removeYouLike(
                MyAppState.currentUser!.userID,
                homeConversationModel.members.first.userID,
              );
              await fireStoreUtils
                  .removeChat(homeConversationModel.conversationModel!.id);
              await fireStoreUtils.removeMatch(
                user.userID,
              );
              hideProgress();
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.close,
            label: 'Unmatch',
            padding: EdgeInsets.zero,
          ),
        ],
      ),

      // onDismissed: (direction) {
      //   setState(() {
      //     fireStoreUtils
      //         .removeChat(homeConversationModel.conversationModel!.id)
      //         .then((value) {
      //       print(value);
      //       if (value) {
      //         setState(() {
      //           list?.removeAt(index);
      //           if (list!.length == 0) {
      //             fireStoreUtils.getBlocks().listen((shouldRefresh) {
      //               if (shouldRefresh) {
      //                 setState(() {});
      //               }
      //             });
      //             _matchesFuture =
      //                 fireStoreUtils.getMatchedUserObject(user.userID);
      //             _conversationsStream =
      //                 fireStoreUtils.getConversations(user.userID);
      //             _swipeuser();
      //           }
      //         });
      //       }
      //     });
      //   });
      // },
      // Show a red background as the item is swiped away.
      // background: Container(color: Colors.red),
      child: homeConversationModel.isGroupChat
          ? Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 12.8),
              child: InkWell(
                onTap: () {
                  push(context,
                      ChatScreen(homeConversationModel: homeConversationModel));
                },
                /*onLongPress: (){
            _onMatchLongPress(homeConversationModel.conversationModel!.id);
          },*/
                child: Column(
                  children: [
                    Row(
                      children: <Widget>[
                        Stack(
                          clipBehavior: Clip.none,
                          children: <Widget>[
                            displayCircleImage(user1Image, 44, false),
                            Positioned(
                                left: -16,
                                bottom: -12.8,
                                child: displayCircleImage(user2Image, 44, true))
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 8, right: 8, left: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${homeConversationModel.conversationModel!.name}',
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: isDarkMode(context)
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (homeConversationModel
                                            .conversationModel!.lastMessage
                                            .contains('sent a message') ||
                                        homeConversationModel
                                                .conversationModel?.name !=
                                            MyAppState.currentUser?.firstName)
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                            color: homeConversationModel
                                                        .conversationModel
                                                        ?.name ==
                                                    MyAppState
                                                        .currentUser?.firstName
                                                ? Colors.green.shade900
                                                : Colors.purple,
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: Text(
                                          homeConversationModel
                                                      .conversationModel
                                                      ?.name ==
                                                  MyAppState
                                                      .currentUser?.firstName
                                              ? 'New'
                                              : 'Your Turn',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        '${homeConversationModel.conversationModel!.lastMessage}}',
                                        maxLines: 1,
                                        textScaleFactor: 1.0,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xff000000)),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        '${formatTimestamp(homeConversationModel.conversationModel!.lastMessageDate.seconds)}',
                                        maxLines: 1,
                                        textScaleFactor: 1.0,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xff000000)),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Divider(
                        color: Color(0xff000000),
                        height: 1,
                      ),
                    )
                  ],
                ),
              ),
            )
          : homeConversationModel.isExpireChat
              ? InkWell(
                  onTap: () {
                    push(
                        context,
                        ChatScreen(
                            homeConversationModel: homeConversationModel));
                  },
                  /*onLongPress: (){
          _onMatchLongPress(homeConversationModel.conversationModel!.id);
        },*/
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: <Widget>[
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: <Widget>[
                                displayCircleImage(
                                    homeConversationModel
                                        .members.first.profilePictureURL,
                                    50,
                                    false),
                                Positioned(
                                    right: 2.4,
                                    bottom: 2.4,
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                          color: homeConversationModel
                                                  .members.first.active
                                              ? Colors.green
                                              : Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          border: Border.all(
                                              color: isDarkMode(context)
                                                  ? Color(0xFF303030)
                                                  : Colors.white,
                                              width: 1.6)),
                                    ))
                              ],
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 8, right: 8, left: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            '${homeConversationModel.members.first.fullName()}',
                                            textScaleFactor: 1.0,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: isDarkMode(context)
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        if (homeConversationModel
                                                .conversationModel!.lastMessage
                                                .contains('sent a message') ||
                                            homeConversationModel
                                                    .conversationModel?.name !=
                                                MyAppState
                                                    .currentUser?.firstName)
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            decoration: BoxDecoration(
                                                color: homeConversationModel
                                                            .conversationModel
                                                            ?.name ==
                                                        MyAppState.currentUser
                                                            ?.firstName
                                                    ? Colors.green.shade900
                                                    : Colors.purple,
                                                borderRadius:
                                                    BorderRadius.circular(30)),
                                            child: Text(
                                              homeConversationModel
                                                          .conversationModel
                                                          ?.name ==
                                                      MyAppState.currentUser
                                                          ?.firstName
                                                  ? 'New'
                                                  : 'Your Turn',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5.0),
                                            child: Text(
                                              '${homeConversationModel.conversationModel?.lastMessage} ',
                                              textScaleFactor: 1.0,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xff000000)),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
                                          child: Text(
                                            '${formatTimestamp(homeConversationModel.conversationModel?.lastMessageDate.seconds ?? 0)}',
                                            maxLines: 1,
                                            textScaleFactor: 1.0,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Color(0xff000000)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Divider(
                          color: Color(0xff000000),
                          height: 1,
                        ),
                      )
                    ],
                  ),
                )
              : InkWell(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: <Widget>[
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: <Widget>[
                                Container(
                                  foregroundDecoration: BoxDecoration(
                                    color: Colors.grey,
                                    backgroundBlendMode: BlendMode.saturation,
                                    shape: BoxShape.circle,
                                  ),
                                  child: displayCircleImage(
                                      homeConversationModel
                                          .members.first.profilePictureURL,
                                      50,
                                      false),
                                ),
                                Positioned(
                                    right: 2.4,
                                    bottom: 2.4,
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                          color: homeConversationModel
                                                  .members.first.active
                                              ? Colors.green
                                              : Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          border: Border.all(
                                              color: isDarkMode(context)
                                                  ? Color(0xFF303030)
                                                  : Colors.white,
                                              width: 1.6)),
                                    ))
                              ],
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 8, right: 8, left: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            '${homeConversationModel.members.first.fullName()}',
                                            textScaleFactor: 1.0,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: isDarkMode(context)
                                                  ? Colors.white
                                                  : Colors.grey,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        if (homeConversationModel
                                                .conversationModel!.lastMessage
                                                .contains('sent a message') ||
                                            homeConversationModel
                                                    .conversationModel?.name !=
                                                MyAppState
                                                    .currentUser?.firstName)
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            decoration: BoxDecoration(
                                                color: homeConversationModel
                                                            .conversationModel
                                                            ?.name ==
                                                        MyAppState.currentUser
                                                            ?.firstName
                                                    ? Colors.green.shade900
                                                    : Colors.purple,
                                                borderRadius:
                                                    BorderRadius.circular(30)),
                                            child: Text(
                                              homeConversationModel
                                                          .conversationModel
                                                          ?.name ==
                                                      MyAppState.currentUser
                                                          ?.firstName
                                                  ? 'New'
                                                  : 'Your Turn',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5.0),
                                            child: Text(
                                              '${homeConversationModel.conversationModel?.lastMessage} ',
                                              textScaleFactor: 1.0,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
                                          child: Text(
                                            '${formatTimestamp(homeConversationModel.conversationModel?.lastMessageDate.seconds ?? 0)}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textScaleFactor: 1.0,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Color(0xff000000)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Divider(
                          color: Color(0xff000000),
                          height: 1,
                        ),
                      )
                    ],
                  ),
                ),
    );
  }

  // onMatchLongPress(String channelID) {
  //   final action = CupertinoActionSheet(
  //     message: Text(
  //       'Delete Chat',
  //       style: TextStyle(fontSize: 15.0),
  //     ),
  //     actions: <Widget>[
  //       CupertinoActionSheetAction(
  //         child: Text('Delete Chat'),
  //         isDefaultAction: true,
  //         onPressed: () async {
  //           Navigator.pop(context);
  //           fireStoreUtils.removeChat(channelID).then((value) {
  //             if (value) {
  //               setState(() {
  //                 fireStoreUtils.getBlocks().listen((shouldRefresh) {
  //                   if (shouldRefresh) {
  //                     setState(() {});
  //                   }
  //                 });
  //                 _matchesFuture =
  //                     fireStoreUtils.getMatchedUserObject(user.userID);
  //                 _conversationsStream =
  //                     fireStoreUtils.getConversations(user.userID);
  //                 _swipeuser();
  //               });
  //             }
  //           });
  //         },
  //       ),
  //     ],
  //     cancelButton: CupertinoActionSheetAction(
  //       child: Text(
  //         'Cancel',
  //       ),
  //       onPressed: () {
  //         Navigator.pop(context);
  //       },
  //     ),
  //   );
  //   showCupertinoModalPopup(context: context, builder: (context) => action);
  // }
}

// sendNotification(String token, String title, String body,
//     Map<String, dynamic>? payload) async {
//   await http.post(
//     Uri.parse('https://fcm.googleapis.com/fcm/send'),
//     headers: <String, String>{
//       'Content-Type': 'application/json',
//       'Authorization': 'key=$SERVER_KEY',
//     },
//     body: jsonEncode(
//       <String, dynamic>{
//         'notification': <String, dynamic>{'body': body, 'title': title},
//         'priority': 'high',
//         'data': payload ?? <String, dynamic>{},
//         'to': token
//       },
//     ),
//   );
// }

// Future<bool> sendFcmMessage(
//     String title, String message, String Token, String reqType) async {
//   try {
//     var url = 'https://fcm.googleapis.com/fcm/send';
//     var header = {
//       "Content-Type": "application/json",
//       "Authorization": "key=$SERVER_KEY",
//     };
//     var request = {
//       "notification": {
//         "title": title,
//         "body": message,
//         "sound": "default",
//         // "color": COLOR_PRIMARY,
//       },
//       "priority": "high",
//       'data': <String, dynamic>{
//         'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//         'id': '1',
//         'status': 'done',
//         'reqtype': '$reqType'
//       },
//       "to": Token
//     };

//     var client = new http.Client();
//     var response = await client.post(Uri.parse(url),
//         headers: header, body: json.encode(request));
//     log(response.headers.toString());
//     log(response.statusCode.toString());
//     log(response.body.toString());
//     log(response.contentLength.toString());
//     print('done........ ');
//     return true;
//   } catch (e, s) {
//     print(e);
//     return false;
//   }
// }
