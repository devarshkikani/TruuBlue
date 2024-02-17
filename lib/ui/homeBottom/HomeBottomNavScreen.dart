import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/common/common_appbar_widget.dart';
import 'package:dating/main.dart';
import 'package:dating/model/PurchaseModel.dart';
import 'package:dating/model/Swipe.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/ui/AppEntryOffers/AppEntryOffersScreen.dart';
import 'package:dating/ui/AppEntryOffers/SummaryScreen.dart';
import 'package:dating/ui/SwipeScreen/SwipeScreen.dart';
import 'package:dating/ui/likes/LikesScreen.dart';
import 'package:dating/ui/myMatch/MessagesScreen.dart';
import 'package:dating/ui/truuboost/truuboost_screen.dart';
import 'package:flutter/material.dart';
import 'package:dating/model/User.dart';
import 'package:get/get.dart';

import '../../constants.dart';

class HomeBottomNavScreen extends StatefulWidget {
  final User user;
  final int index;
  HomeBottomNavScreen({Key? key, required this.user, required this.index})
      : super(key: key);

  @override
  _HomeBottomNavScreenState createState() => _HomeBottomNavScreenState();
}

class _HomeBottomNavScreenState extends State<HomeBottomNavScreen> {
  int _selectedIndex = 0;
  late User user;
  late int tabIndex;
  final fireStoreUtils = FireStoreUtils();
  int messageCount = 0;
  int matchesCount = 0;
  late Future<List<User>> _matchesUserFuture;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Swipe> matchList = <Swipe>[];
  List<User> _Sort = [];
  void onItemTapped(int index) {
    if (index == 2) {
      newLikesCount = 0;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    user = widget.user;
    tabIndex = widget.index;
    onItemTapped(tabIndex);
    _matchesUserFuture = fireStoreUtils.getMatchedUserObject(user.userID);
    _swipeuser();
  }

  getdata() async {
    fireStoreUtils.getConversations(user.userID).forEach((e) {
      messageCount = messageCount + 1;
      matchesCount = 0;
      _Sort.forEach((element) {
        if (e.isNotEmpty) {
          if (element.userID == e.first.members.first.userID) {
            if (Timestamp.now()
                    .toDate()
                    .difference(
                        e.first.conversationModel!.lastMessageDate.toDate())
                    .inDays <
                7) {
              e.first.isExpireChat = true;
            } else {
              e.first.isExpireChat = false;
            }
          }
        }
      });

      matchesCount = e
          .where(
            (element) =>
                element.isExpireChat &&
                element.conversationModel?.name !=
                    MyAppState.currentUser?.firstName,
          )
          .length;
      if (mounted) setState(() {});
    });
    // hideProgress();
  }

  _activesort() async {
    _Sort = [];
    List data = await _matchesUserFuture;
    data.forEach((elem) {
      matchList.forEach((element) {
        if (elem.userID == element.user2) {
          setState(() {
            _Sort.add(elem);
          });
        }
      });
    });
    getdata();
  }

  _swipeuser() async {
    matchList = <Swipe>[];
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
        setState(() {});
        _isSubscribeUser(match);
      });
    });
    setState(() {});
  }

  _isSubscribeUser(Swipe match) async {
    await firestore
        .collection(SUBSCRIPTIONS)
        .where('userID', isEqualTo: user.userID)
        // .where('userID2', isEqualTo: match.user2)
        .get()
        .then((querySnapShot) {
      if (querySnapShot.docs.isNotEmpty) {
        querySnapShot.docs.forEach((doc) async {
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
            user.isVip = false;
            MyAppState.currentUser!.isVip = false;
            await FireStoreUtils.updateCurrentUser(MyAppState.currentUser!);
            await firestore
                .collection(SUBSCRIPTIONS)
                .doc(MyAppState.currentUser!.userID)
                .set({'active': false});
            if (Timestamp.now()
                    .toDate()
                    .difference(match.createdAt.toDate())
                    .inDays <
                10) {
              matchList.add(match);
            }
          }
        });
      } else {
        if (Timestamp.now()
                .toDate()
                .difference(match.createdAt.toDate())
                .inDays <
            10) {
          matchList.add(match);
        }
      }
    });
    setState(() {});
    _activesort();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(user: user, context: context),
      body: [
        SwipeScreen(),
        SummaryScreen(
          onPressed: onItemTapped,
        ),
        LikesYou(),
        MessagesScreen(),
        TruuBoostScreen(),
      ].elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                label: "Feed",
                icon: ImageIcon(
                    AssetImage("assets/images/app_circle_icon_one.png")),
              ),
              BottomNavigationBarItem(
                label: "Summary",
                icon: ImageIcon(AssetImage("assets/images/summary.png")),
              ),
              BottomNavigationBarItem(
                label: "Likes",
                icon: Badge(
                  showBadge: newLikesCount != 0,
                  badgeColor: Colors.purple,
                  badgeContent: Text(
                    newLikesCount.toString(),
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  child: Icon(Icons.star_outline_rounded),
                ),
              ),
              BottomNavigationBarItem(
                label: "Matches",
                icon: Badge(
                  badgeColor: Colors.purple,
                  showBadge: matchesCount != 0,
                  badgeContent: Text(
                    matchesCount.toString(),
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  child: ImageIcon(
                    AssetImage("assets/images/match_icon.png"),
                  ),
                ),
              ),
              BottomNavigationBarItem(
                label: "TruuBoost",
                icon: Obx(() => Badge(
                      padding: EdgeInsets.only(
                        top: 5,
                        bottom: 5,
                      ),
                      showBadge: isBossted.value || user.isUserBoost > 0,
                      badgeColor: Colors.purple,
                      badgeContent: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Image.asset(
                          'assets/images/thunder.png',
                          color: Colors.white,
                          height: 12,
                        ),
                      ),
                      child: Icon(
                        Icons.rocket,
                      ),
                    )),
              ),
            ],
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.green,
            unselectedItemColor: Color(0XFF6f6f6f),
            iconSize: 40,
            onTap: onItemTapped,
            elevation: 0),
      ),
    );
  }
}
