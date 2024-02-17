import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/constants.dart';
import 'package:dating/main.dart';
import 'package:dating/model/ConversationModel.dart';
import 'package:dating/model/MessageData.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/ui/AppEntryOffers/boost_purchase_screen.dart';
import 'package:dating/ui/SwipeScreen/question_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:dating/model/User.dart';
import 'package:dating/CustomFlutterTinderCard.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:dating/ui/SwipeScreen/user_page_view.dart';
import 'package:dating/ui/SwipeScreen/image_details_screen.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SwipeScreen extends StatefulWidget {
  @override
  SwipeScreenState createState() => SwipeScreenState();
}

FireStoreUtils _fireStoreUtils = FireStoreUtils();
List<User> tinderUsers = <User>[];
List<User> swipedUsers = [];
ConversationModel? conversationModel;
CardController controller = CardController();
PageController pageController = PageController();
int currentPage = 0;
double containerHeight = 0.0;
double likeContainerHeight = 0.0;
bool isLikedTap = false;
bool isQuestionTap = false;
String? imageUrl;
User? currentuser;
late SharedPreferences prefs;
RxBool isLoading = true.obs;
int indexCount = 0;
int boostCount = 0;
int ultraLikeCount = 0;
bool isAlreadyWidget = true;

class SwipeScreenState extends State<SwipeScreen> {
  // @override
  // void initState() {
  //   super.initState();
  //   print("SWIPE SCREEN");
  //   if (isAlreadyWidget) {
  //     getcurrentUser(context);
  //   } else {}
  // }

  getcurrentUser(BuildContext context) async {
    FlutterAppBadger.removeBadge();
    prefs = await SharedPreferences.getInstance();
    currentuser =
        (await FireStoreUtils.getCurrentUser(MyAppState.currentUser!.userID))!;
    boostCount = int.parse(await FireStoreUtils.getBoostLikeCount());
    ultraLikeCount = int.parse(await FireStoreUtils.getUltraLikeCount());
    await updateFeedData(context);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => isLoading.value
          ? Center(
              child: CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation<Color>(Color(COLOR_ACCENT)),
              ),
            )
          : _asyncCards(context, tinderUsers),
    );
  }

  Widget _asyncCards(BuildContext context, List<User> data) {
    if (data.length != 0) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.9,
        width: MediaQuery.of(context).size.width,
        color: Colors.grey.withOpacity(0.2),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            _buildPageView(data),
            _buildMoveNextUser(data),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: MediaQuery.of(context).size.width,
              height: containerHeight,
              color: Colors.white,
              child: Image.asset(
                'assets/images/ic_close.png',
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: MediaQuery.of(context).size.width,
              height: likeContainerHeight,
              color: Colors.white,
              child: SizedBox(
                height: 100,
                width: 100,
                child: Center(
                  child: FittedBox(
                    child: Image.asset(
                      'assets/images/ic_heart.png',
                      height: 100,
                      width: 100,
                    ),
                  ),
                ),
              ),
            ),
            if (isLikedTap)
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 30.0,
                    sigmaY: 30.0,
                  ),
                  child: Scaffold(
                    backgroundColor: Colors.white30,
                    body: ImageDetailsScreen(
                      imageUrl: imageUrl!,
                      name: data[currentPage].firstName,
                      ultraLikeCount: ultraLikeCount,
                      sendLike: (String? message, bool isUltraLike) async {
                        await showProgress(context, 'Sending like..', false);
                        await _fireStoreUtils.onSwipeRight(
                            data[currentPage], 'photo');
                        setState(() {
                          isLikedTap = false;
                          likeContainerHeight =
                              MediaQuery.of(context).size.height;
                        });
                        Future.delayed(Duration(milliseconds: 1000), () async {
                          likeContainerHeight = 0;
                          data.removeAt(currentPage);
                          List<String> usersIDs = [];
                          for (int i = 0; i < data.length; i++) {
                            usersIDs.add(data[i].userID);
                          }
                          final String encodedData = jsonEncode(usersIDs);
                          await prefs.setString('storeUsers', encodedData);
                          tinderUsers = data;
                          setState(() {});
                        });
                        if (message != '') {
                          _sendMessage(message!, Url(mime: '', url: ''), '',
                              data[currentPage]);
                        }
                        if (isUltraLike) {
                          await FireStoreUtils().ultraLikeYouLike(
                              MyAppState.currentUser!.userID,
                              data[currentPage].userID,
                              ultraLikeCount);
                          ultraLikeCount = int.parse(
                            await FireStoreUtils.getUltraLikeCount(),
                          );
                          if (mounted) setState(() {});
                        }
                        hideProgress();
                      },
                      cancel: () {
                        setState(() {
                          isLikedTap = false;
                        });
                      },
                    ),
                  ),
                ),
              ),
            if (isQuestionTap)
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 30.0,
                    sigmaY: 30.0,
                  ),
                  child: Scaffold(
                    backgroundColor: Colors.white30,
                    body: QuestionDetailsScreen(
                      user: data[currentPage],
                      ultraLikeCount: ultraLikeCount,
                      sendLike: (String? message, bool isUltraLike) async {
                        if (isLike.isEmpty &&
                            data[currentPage].answeredQuestion.isNotEmpty) {
                          await FirebaseFirestore.instance
                              .collection('question_like')
                              .doc()
                              .set({
                            "id": data[currentPage].answeredQuestion[0]['id'],
                            "category_question_id": data[currentPage]
                                .answeredQuestion[0]['category_question_id'],
                            "user_id": MyAppState.currentUser!.userID,
                            "other_user_id": data[currentPage].userID
                          });
                        } else {
                          if (data[currentPage].answeredQuestion.isNotEmpty) {
                            var snapshot = await FirebaseFirestore.instance
                                .collection('question_like')
                                .where("other_user_id",
                                    isEqualTo: data[currentPage].userID)
                                .where('id',
                                    isEqualTo: data[currentPage]
                                        .answeredQuestion[0]['id'])
                                .get();
                            for (var doc in snapshot.docs) {
                              await doc.reference.delete();
                            }
                            isLike.clear();
                          }
                        }
                        if (data[currentPage].answeredQuestion.isNotEmpty) {
                          likeflag(data[currentPage]);
                        }
                        await showProgress(context, 'Sending like..', false);
                        await _fireStoreUtils.onSwipeRight(
                            data[currentPage], 'Ice Breaker');
                        setState(() {
                          isLikedTap = false;
                          isQuestionTap = false;
                          likeContainerHeight =
                              MediaQuery.of(context).size.height;
                        });
                        Future.delayed(Duration(milliseconds: 1000), () async {
                          likeContainerHeight = 0;
                          data.removeAt(currentPage);
                          List<String> usersIDs = [];
                          for (int i = 0; i < data.length; i++) {
                            usersIDs.add(data[i].userID);
                          }
                          final String encodedData = jsonEncode(usersIDs);
                          await prefs.setString('storeUsers', encodedData);
                          tinderUsers = data;
                          setState(() {});
                        });
                        setState(() {
                          likeContainerHeight =
                              MediaQuery.of(context).size.height;
                        });
                        Future.delayed(Duration(milliseconds: 1000), () {
                          likeContainerHeight = 0;
                          setState(() {});
                        });
                        if (message != '') {
                          _sendMessage(message!, Url(mime: '', url: ''), '',
                              data[currentPage]);
                        }
                        if (isUltraLike) {
                          await FireStoreUtils().ultraLikeYouLike(
                              MyAppState.currentUser!.userID,
                              data[currentPage].userID,
                              ultraLikeCount);
                          ultraLikeCount = int.parse(
                              await FireStoreUtils.getUltraLikeCount());
                          if (mounted) setState(() {});
                        }
                        hideProgress();
                      },
                      cancel: () {
                        setState(() {
                          isQuestionTap = false;
                        });
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    } else {
      return boostCount <= 0
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'For More feed you need to purchase some Truuboosts.',
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF70573ac),
                    textStyle: TextStyle(color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: BorderSide(
                        color: Color(0xFF0573ac),
                      ),
                    ),
                  ),
                  child: Text(
                    'Purchase a Truuboosts',
                    textScaleFactor: 1.0,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BoosrPurchaseScreen(
                          user: MyAppState.currentUser!,
                        ),
                      ),
                    ).then((value) async {
                      if (value != null) {
                        if (value > 0) {
                          isLoading.value = true;

                          tinderUsers = await _fireStoreUtils.getTinderUsers();
                          List<String> usersIDs = [];
                          for (int i = 0; i < tinderUsers.length; i++) {
                            usersIDs.add(tinderUsers[i].userID);
                          }
                          final String encodedData = jsonEncode(usersIDs);
                          await prefs.setString('storeUsers', encodedData);
                          prefs.setInt('lastDay', DateTime.now().day);
                        }
                        isLoading.value = false;
                        setState(() {});
                      }
                    });
                  },
                ),
              ],
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'There’s no one around you. Try increasing the distance radius to get more recommendations.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
    }
  }

  _sendMessage(
      String content, Url? url, String videoThumbnail, User user) async {
    String channelID;
    if (user.userID.compareTo(MyAppState.currentUser!.userID) < 0) {
      channelID = user.userID + MyAppState.currentUser!.userID;
    } else {
      channelID = MyAppState.currentUser!.userID + user.userID;
    }
    conversationModel = await FireStoreUtils().getChannelByIdOrNull(channelID);
    MessageData message;

    message = MessageData(
        content: content,
        created: Timestamp.now(),
        recipientFirstName: user.firstName,
        recipientID: user.userID,
        recipientLastName: user.lastName,
        recipientProfilePictureURL: user.profilePictureURL,
        senderFirstName: MyAppState.currentUser!.firstName,
        senderID: MyAppState.currentUser!.userID,
        senderLastName: MyAppState.currentUser!.lastName,
        senderProfilePictureURL: MyAppState.currentUser!.profilePictureURL,
        url: url,
        videoThumbnail: videoThumbnail);

    if (await _checkChannelNullability(conversationModel, user)) {
      conversationModel?.lastMessageDate = Timestamp.now();
      conversationModel?.lastMessage = message.content;
      conversationModel?.name = MyAppState.currentUser!.firstName;
      await FireStoreUtils()
          .sendMessage([user], false, message, conversationModel!);
      await FireStoreUtils().updateChannel(conversationModel!);
    } else {
      showAlertDialog(context, 'An Error Occurred',
          'Couldn\'t send Message, please try again later');
    }
  }

  Future<bool> _checkChannelNullability(
      ConversationModel? model, User user) async {
    if (model != null) {
      return true;
    } else {
      String channelID;
      User friend = user;
      User currentUser = MyAppState.currentUser!;
      if (friend.userID.compareTo(currentUser.userID) < 0) {
        channelID = friend.userID + currentUser.userID;
      } else {
        channelID = currentUser.userID + friend.userID;
      }

      ConversationModel conversation = ConversationModel(
        creatorId: currentUser.userID,
        id: channelID,
        lastMessageDate: Timestamp.now(),
        name: MyAppState.currentUser!.firstName,
        lastMessage: '${currentUser.fullName()} sent a message',
      );
      bool isSuccessful =
          await FireStoreUtils().createConversation(conversation);
      if (isSuccessful) {
        setState(() {
          conversationModel = conversation;
        });
      }
      return isSuccessful;
    }
  }

  Future<void> updateFeedData(BuildContext context) async {
    try {
      if (boostCount <= 0) {
        int? lastDay = prefs.getInt('lastDay');
        int today = DateTime.now().day;

        if (lastDay == null || lastDay != today) {
          tinderUsers = await _fireStoreUtils.getTinderUsers();
          prefs.setInt('lastDay', today);
        } else {
          final String? getStoreUsers = prefs.getString('storeUsers');
          if (getStoreUsers != null) {
            tinderUsers = await _fireStoreUtils.getTinderUsers(
              getStoredUser: jsonDecode(getStoreUsers),
            );
          } else {
            tinderUsers = await _fireStoreUtils.getTinderUsers();
            prefs.setInt('lastDay', today);
          }
        }
        List<String> usersIDs = [];
        for (int i = 0; i < tinderUsers.length; i++) {
          usersIDs.add(tinderUsers[i].userID);
        }
        final String encodedData = jsonEncode(usersIDs);
        await prefs.setString('storeUsers', encodedData);
      } else {
        tinderUsers = await _fireStoreUtils.getTinderUsers();
        await _fireStoreUtils.matchChecker();
      }
    } catch (e) {
      log(e.toString());
    }
    isLoading.value = false;
  }

  void likeflag(User user) async {
    await FirebaseFirestore.instance
        .collection('question_like')
        .doc(MyAppState.currentUser!.userID)
        .collection("question_like")
        .where("other_user_id", isEqualTo: user.userID)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        isLike.addAll(value.docs);
      }
      setState(() {});
    });
  }

  Widget _buildPageView(List<User> userList) {
    return PageView.builder(
      itemCount: userList.length,
      physics: NeverScrollableScrollPhysics(),
      onPageChanged: (int index) {
        currentPage = index;
        isLike.clear();
        likeflag(userList[index]);
        setState(() {});
      },
      itemBuilder: (BuildContext context, int index) {
        indexCount = index;
        return UserPageView(
          user: userList[index],
          questionTap: () {
            setState(() {
              isQuestionTap = true;
            });
          },
          likeTap: (String url) {
            setState(() {
              isLikedTap = true;
              imageUrl = url;
            });
          },
          questionLikeTap: () async {
            await showProgress(context, 'Sending like..', false);
            await _fireStoreUtils.onSwipeRight(
                userList[currentPage], 'Ice Breaker');
            setState(() {
              isLikedTap = false;
              isQuestionTap = false;
              likeContainerHeight = MediaQuery.of(context).size.height;
            });
            Future.delayed(Duration(milliseconds: 1000), () async {
              likeContainerHeight = 0;
              userList.removeAt(currentPage);
              List<String> usersIDs = [];
              for (int i = 0; i < userList.length; i++) {
                usersIDs.add(userList[i].userID);
              }
              final String encodedData = jsonEncode(usersIDs);
              await prefs.setString('storeUsers', encodedData);
              tinderUsers = userList;
              setState(() {});
            });
            setState(() {
              likeContainerHeight = MediaQuery.of(context).size.height;
            });
            Future.delayed(Duration(milliseconds: 1000), () {
              likeContainerHeight = 0;
              setState(() {});
            });
            hideProgress();
          },
          onBlockOrReport: () async {
            DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
                .instance
                .collection(USERDISPLAYED)
                .doc(MyAppState.currentUser!.userID)
                .get();
            if (doc.exists) {
              await FirebaseFirestore.instance
                  .collection(USERDISPLAYED)
                  .doc(MyAppState.currentUser!.userID)
                  .update({
                "users_displayed":
                    FieldValue.arrayUnion([userList[currentPage].userID]),
              });
            } else {
              await FirebaseFirestore.instance
                  .collection(USERDISPLAYED)
                  .doc(MyAppState.currentUser!.userID)
                  .set({
                "users_displayed":
                    FieldValue.arrayUnion([userList[currentPage].userID]),
              });
            }
            userList.removeAt(currentPage);
            List<String> usersIDs = [];
            for (int i = 0; i < userList.length; i++) {
              usersIDs.add(userList[i].userID);
            }
            final String encodedData = jsonEncode(usersIDs);
            await prefs.setString('storeUsers', encodedData);
            tinderUsers = userList;

            setState(() {});
          },
        );
      },
    );
  }

  Widget _buildMoveNextUser(List<User> userList) {
    return GestureDetector(
      onTap: () {
        setState(() {
          containerHeight = MediaQuery.of(context).size.height;
        });
        Future.delayed(Duration(milliseconds: 1000), () async {
          containerHeight = 0;
          DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
              .instance
              .collection(USERDISPLAYED)
              .doc(MyAppState.currentUser!.userID)
              .get();
          if (doc.exists) {
            await FirebaseFirestore.instance
                .collection(USERDISPLAYED)
                .doc(MyAppState.currentUser!.userID)
                .update({
              "users_displayed":
                  FieldValue.arrayUnion([userList[currentPage].userID]),
            });
          } else {
            await FirebaseFirestore.instance
                .collection(USERDISPLAYED)
                .doc(MyAppState.currentUser!.userID)
                .set({
              "users_displayed":
                  FieldValue.arrayUnion([userList[currentPage].userID]),
            });
          }
          userList.removeAt(currentPage);
          List<String> usersIDs = [];
          for (int i = 0; i < userList.length; i++) {
            usersIDs.add(userList[i].userID);
          }
          final String encodedData = jsonEncode(usersIDs);
          await prefs.setString('storeUsers', encodedData);
          tinderUsers = userList;
          setState(() {});
        });
      },
      child: Container(
        height: 50,
        width: 50,
        padding: EdgeInsets.all(13),
        margin: EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              spreadRadius: 5,
              blurRadius: 10,
              offset: Offset(0.2, 0.2),
              color: Colors.black.withOpacity(0.18),
            ),
          ],
        ),
        child: Image.asset(
          'assets/images/ic_close.png',
        ),
      ),
    );
  }
}
