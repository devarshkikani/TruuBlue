import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating/common/colors.dart';
import 'package:dating/main.dart';
import 'package:dating/model/User.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/theme/textstyle.dart';
import 'package:dating/ui/AppEntryOffers/Deepblue_purchase_screen.dart';
import 'package:dating/ui/AppEntryOffers/boost_purchase_screen.dart';
import 'package:dating/ui/home/HomeScreen.dart';
import 'package:dating/ui/likes/like_details_screen.dart';
import 'package:dating/ui/userDetailsScreen/UserDetailsScreen.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

// class LikesScreen extends StatefulWidget {
//   const LikesScreen({Key? key}) : super(key: key);

//   @override
//   _LikesScreenState createState() => _LikesScreenState();
// }

// class _LikesScreenState extends State<LikesScreen> {
//   late User user;
//   var select = 1;
//   late Widget _currentWidget;
//   bool isBoostLoading = false;
//   @override
//   void initState() {
//     super.initState();
//     FlutterAppBadger.removeBadge();
//     user = MyAppState.currentUser!;
//     _currentWidget = LikesYou(
//       user: user,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
// Row(
//   mainAxisAlignment: MainAxisAlignment.center,
//   children: [
//     GestureDetector(
//       onTap: () {
//         setState(() {
//           select = 1;
//           _currentWidget = LikesYou(
//             user: user,
//           );
//         });
//       },
//       child: Text(
//         'Liked You'.tr(),
//         textScaleFactor: 1.0,
//         style: TextStyle(
//             fontSize: 18,
//             color: select == 1
//                 ? Color(COLOR_BLUE_BUTTON)
//                 : Color(0xFF949494),
//             decoration: TextDecoration.underline),
//       ),
//     ),
//     Padding(
//       padding: const EdgeInsets.only(right: 8.0, left: 8.0),
//       child: Container(
//         height: 15,
//         width: 1,
//         color: Color(COLOR_BLUE_BUTTON),
//       ),
//     ),
//     GestureDetector(
//       onTap: () {
//         setState(() {
//           select = 2;
//           _currentWidget = YouLiked(
//             user: user,
//           );
//         });
//       },
//       child: Text(
//         'You Liked'.tr(),
//         textScaleFactor: 1.0,
//         style: TextStyle(
//             fontSize: 18,
//             color: select == 2
//                 ? Color(COLOR_BLUE_BUTTON)
//                 : Color(0xFF949494),
//             decoration: TextDecoration.underline),
//       ),
//     ),
//   ],
// ),
// Padding(
//   padding: const EdgeInsets.only(left: 16.0, right: 16.0),
//   child: Row(
//     children: [
//       Text(
//         'Likes You',
//         style: TextStyle(
//           fontSize: 24,
//           fontWeight: FontWeight.w700,
//         ),
//       ),
//     ],
//   ),
// ),
//           SafeArea(
//             child: Container(
//               height: MediaQuery.of(context).size.height - 200,
//               child: LikesYou(
//                 user: user,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class LikesYou extends StatefulWidget {
  const LikesYou({Key? key}) : super(key: key);

  @override
  _ActiveLikesState createState() => _ActiveLikesState();
}

class _ActiveLikesState extends State<LikesYou> {
  late User user;
  final fireStoreUtils = FireStoreUtils();
  late Future<List<User>> _matchesFuture;
  bool isBoostLoading = false;
  int predefineBoostCount = 0;
  bool isUserDetailsShow = false;
  int selectedUser = 0;
  List<User> friendsList = [];

  @override
  void initState() {
    super.initState();
    print('LIKES SCREEN');
    FlutterAppBadger.removeBadge();
    user = MyAppState.currentUser!;
    getBoostCount();
    fireStoreUtils.getBlocks().listen((shouldRefresh) {
      if (shouldRefresh) {
        setState(() {});
      }
    });
    _matchesFuture = fireStoreUtils.getOtherYouLikedObject(user.userID);
  }

  getBoostCount() async {
    predefineBoostCount = int.parse(await FireStoreUtils.getBoostLikeCount());
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var scrWidth = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;
    return Stack(
      children: [
        FutureBuilder<List<User>>(
          future: _matchesFuture,
          initialData: [],
          builder: (context, snap) {
            friendsList = [];
            if (snap.connectionState == ConnectionState.waiting)
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 205,
                child: Center(
                  child: CircularProgressIndicator.adaptive(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(COLOR_ACCENT)),
                  ),
                ),
              );
            if (!snap.hasData ||
                snap.data == null ||
                (snap.data?.isEmpty == true)) {
              return noDataWidget();
            } else if (snap.data != null && snap.hasData) {
              snap.data!.forEach((element) {
                if (element.otherLike == false) {
                  friendsList.add(element);
                }
              });
              return friendsList.isEmpty
                  ? noDataWidget()
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              Text(
                                'Likes You',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: GridView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(bottom: 10),
                              itemCount: friendsList.length,
                              itemBuilder: (BuildContext context, int index) {
                                User? friend = friendsList[index];
                                final birthday = friend.birthdate.toString();
                                var birthyear = birthday.split("/").toList();
                                var diffrtence = DateTime.now().year.toInt() -
                                    int.parse(birthyear[2]);
                                return fireStoreUtils
                                        .validateIfUserBlocked(friend.userID)
                                    ? SizedBox()
                                    : Stack(
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              if (user.isVip == true ||
                                                  index == 0) {
                                                setState(() {
                                                  isUserDetailsShow = true;
                                                  selectedUser = index;
                                                });
                                                // push(
                                                //   context,
                                                //   UserDetailsScreen(
                                                //     user: friend,
                                                //     isMatch: true,
                                                //     isMenuVisible: false,
                                                //     likedYou: true,
                                                //   ),
                                                // );
                                              } else {
                                                push(
                                                    context,
                                                    DeepBluePurchaseScreen(
                                                        user: user));
                                              }
                                            },
                                            child: CachedNetworkImage(
                                              width: scrWidth / 2,
                                              height: 300,
                                              fit: BoxFit.cover,
                                              imageUrl: friend
                                                          .profilePictureURL ==
                                                      DEFAULT_AVATAR_URL
                                                  ? DEFAULT_AVATAR_URL
                                                  : friend.profilePictureURL,
                                              placeholder: (context, imageUrl) {
                                                return Icon(
                                                  Icons.account_circle,
                                                  size: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .4,
                                                  color: isDarkMode(context)
                                                      ? Colors.black
                                                      : Colors.white,
                                                );
                                              },
                                              errorWidget:
                                                  (context, imageUrl, error) {
                                                return Icon(
                                                  Icons.account_circle,
                                                  size: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .4,
                                                  color: isDarkMode(context)
                                                      ? Colors.black
                                                      : Colors.white,
                                                );
                                              },
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.topCenter,
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                  bottom: Radius.circular(0),
                                                ),
                                                gradient: const LinearGradient(
                                                  begin: Alignment.bottomCenter,
                                                  end: Alignment.topCenter,
                                                  colors: [
                                                    Colors.black54,
                                                    Colors.black26
                                                  ],
                                                ),
                                              ),
                                              child: Row(
                                                children: <Widget>[
                                                  Text(
                                                    friend.fullName() + ', ',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap: true,
                                                    textScaleFactor: 1.0,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Text(
                                                    diffrtence.toString(),
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  InkWell(
                                                    onTap: () async {
                                                      await closeTap(user);
                                                      snap.data
                                                          ?.removeAt(index);
                                                      setState(() {});
                                                    },
                                                    child: Icon(
                                                      Icons.close,
                                                      color: Colors.white,
                                                      size: 24,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          // Align(
                                          //   alignment: Alignment.bottomCenter,
                                          //   child: Container(
                                          //     padding: EdgeInsets.all(8),
                                          //     decoration: BoxDecoration(
                                          //       borderRadius: BorderRadius.vertical(
                                          //         bottom: Radius.circular(0),
                                          //       ),
                                          //       gradient: const LinearGradient(
                                          //         begin: Alignment.bottomCenter,
                                          //         end: Alignment.topCenter,
                                          //         colors: [
                                          //           Colors.black54,
                                          //           Colors.black26
                                          //         ],
                                          //       ),
                                          //     ),
                                          //     child: Row(
                                          //       crossAxisAlignment:
                                          //           CrossAxisAlignment.center,
                                          //       mainAxisSize: MainAxisSize.max,
                                          //       mainAxisAlignment:
                                          //           MainAxisAlignment.spaceBetween,
                                          //       children: <Widget>[
                                          //         InkWell(
                                          //           onTap: () {
                                          //             if (user.isVip || index == 0) {
                                          //               if (!friend.otherLike) {
                                          //                 setState(() {
                                          //                   fireStoreUtils
                                          //                       .otherLikeYouLike(
                                          //                           user.userID,
                                          //                           friend.userID,
                                          //                           'Like');
                                          //                   friend.otherLike = true;
                                          //                 });
                                          //               }
                                          //             } else {
                                          //               push(
                                          //                   context,
                                          //                   DeepBluePurchaseScreen(
                                          //                       user: user));
                                          //             }
                                          //           },
                                          //           child: friend.otherLike
                                          //               ? Icon(
                                          //                   Icons.favorite_rounded,
                                          //                   color: Colors.green,
                                          //                   size: 24,
                                          //                 )
                                          //               : Icon(
                                          //                   Icons.favorite_border,
                                          //                   color: Colors.white,
                                          //                   size: 24,
                                          //                 ),
                                          //         ),
                                          //         InkWell(
                                          //           onTap: () {
                                          //             setState(
                                          //               () {
                                          //                 fireStoreUtils
                                          //                     .removeLikeYou(
                                          //                         user.userID,
                                          //                         friend.userID);
                                          //                 snap.data?.removeAt(index);
                                          //               },
                                          //             );
                                          //           },
                                          //           child: Icon(
                                          //             Icons.close,
                                          //             color: Colors.white,
                                          //             size: 24,
                                          //           ),
                                          //         ),
                                          //       ],
                                          //     ),
                                          //   ),
                                          // ),
                                          if (user.isVip == false && index != 0)
                                            GestureDetector(
                                              onTap: () {
                                                push(
                                                  context,
                                                  DeepBluePurchaseScreen(
                                                      user: user),
                                                );
                                              },
                                              child: BlurryEffect(4.0),
                                            ),
                                        ],
                                      );
                              },
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 0.7,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16,
                                      crossAxisCount:
                                          (orientation == Orientation.portrait)
                                              ? 2
                                              : 3),
                            ),
                          ),
                        ),
                      ],
                    );
            } else {
              return SizedBox(
                child: Center(
                  child: Text(
                    'error while fetching data',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
              );
            }
          },
        ),
        if (!user.isVip)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: InkWell(
                onTap: () {
                  push(context, DeepBluePurchaseScreen(user: user));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 50,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade300),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(30)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Text(
                          'Upgrade',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          'Upgrade to see all your Likes at once',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        if (isUserDetailsShow)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 30.0,
                sigmaY: 30.0,
              ),
              child: LikeDetailsScreen(
                friend: friendsList[selectedUser],
                cancel: (bool like) {
                  isUserDetailsShow = false;
                  friendsList[selectedUser].otherLike = like;
                  setState(() {});
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget noDataWidget() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Text(
                'Likes You',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 205,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'You have no new likes',
                      style: boldText20,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      "But don't panic... TruuBlue is a serious dating app and people are more selective with their likes.",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: greyColor,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Try the following:',
                        style: mediumText14,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          '•',
                          style: mediumText14,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        RichText(
                          text: new TextSpan(
                            text: 'Widen your ',
                            style: mediumText14,
                            children: <TextSpan>[
                              new TextSpan(
                                text: 'Distance',
                                style: boldText14,
                              ),
                              new TextSpan(
                                text: ' setting',
                                style: mediumText14,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          '•',
                          style: mediumText14,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        RichText(
                          text: new TextSpan(
                            text: 'Expand your ',
                            style: mediumText14,
                            children: <TextSpan>[
                              new TextSpan(
                                text: 'Age',
                                style: boldText14,
                              ),
                              new TextSpan(
                                text: ' preference',
                                style: mediumText14,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    InkWell(
                      onTap: () async {
                        if (user.isUserBoost <= 0) {
                          int predefineBoostCount = int.parse(
                              await FireStoreUtils.getBoostLikeCount());
                          int usedpredefineBoostCount = int.parse(
                              await FireStoreUtils.getusedBoostLikeCount());

                          if (predefineBoostCount > 0) {
                            String getNewCount =
                                (predefineBoostCount - 1).toString();
                            String getNewUsedCount =
                                (usedpredefineBoostCount + 1).toString();
                            await FireStoreUtils().boostCountUpdate(
                              count: getNewCount.toString(),
                              // getNewUsedCount: getNewUsedCount.toString(),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(new SnackBar(
                              content: Text(
                                  'Successfully, Your Profile Boost For 12 Hours'),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ));
                            user.isUserBoost = 1;
                            user.profileBoostAt = DateTime.now();
                            push(
                              context,
                              HomeScreen(
                                user: user,
                                index: 0,
                              ),
                            );
                          } else {
                            push(
                              context,
                              BoosrPurchaseScreen(
                                user: user,
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            new SnackBar(
                              content: Text('Your profile Already Boost'),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(30)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Text(
                          'Try Boosting Your Profile',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> closeTap(User friend) async {
    await fireStoreUtils.removeLikeYou(user.userID, friend.userID);
    SharedPreferences pref = await SharedPreferences.getInstance();
    int likeCount = pref.getInt('oldNewLikesCount') ?? 0;
    if (likeCount != 0) {
      pref.setInt('oldNewLikesCount', likeCount - 1);
    }
  }

  _onMatchLongPress(User friend) {
    final action = CupertinoActionSheet(
      message: Text(
        friend.fullName(),
        style: TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text('View Profile'.tr()),
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);
            push(
              context,
              UserDetailsScreen(
                user: friend,
                isMatch: true,
                isMenuVisible: false,
              ),
            );
          },
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text(
          'Cancel'.tr(),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }
}

// class YouLiked extends StatefulWidget {
//   final User user;
//   const YouLiked({Key? key, required this.user}) : super(key: key);

//   @override
//   _YouLikedState createState() => _YouLikedState();
// }

// class _YouLikedState extends State<YouLiked> {
//   late User user;
//   final fireStoreUtils = FireStoreUtils();
//   late Future<List<User>> _matchesFuture;
//   int predefineCount = 0;

//   @override
//   void initState() {
//     super.initState();
//     user = widget.user;
//     SchedulerBinding.instance?.addPostFrameCallback((timeStamp) async {
//       predefineCount = int.parse(await FireStoreUtils.getUltraLikeCount());
//       print("count:" + predefineCount.toString());
//     });
//     fireStoreUtils.getBlocks().listen((shouldRefresh) {
//       if (shouldRefresh) {
//         setState(() {});
//       }
//     });
//     _matchesFuture = fireStoreUtils.getYouLikedObject(user.userID);
//   }

//   @override
//   Widget build(BuildContext context) {
//     var scrWidth = MediaQuery.of(context).size.width;
//     var scrHeight = MediaQuery.of(context).size.height;
//     final orientation = MediaQuery.of(context).orientation;
//     return FutureBuilder<List<User>>(
//       future: _matchesFuture,
//       initialData: [],
//       builder: (context, snap) {
//         if (snap.connectionState == ConnectionState.waiting)
//           return Container(
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height - 205,
//             child: Center(
//               child: CircularProgressIndicator.adaptive(
//                 valueColor: AlwaysStoppedAnimation<Color>(Color(COLOR_ACCENT)),
//               ),
//             ),
//           );
//         if (!snap.hasData || (snap.data?.isEmpty ?? true)) {
//           return SizedBox(
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height - 205,
//             child: Center(
//               child: Text(
//                 'No Likes found.'.tr(),
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//           );
//         } else {
//           return Padding(
//             padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
//             child: GridView.builder(
//               shrinkWrap: true,
//               padding: const EdgeInsets.only(bottom: 40),
//               itemCount: snap.data!.length,
//               itemBuilder: (BuildContext context, int index) {
//                 User friend = snap.data![index];
//                 final birthday = friend.birthdate.toString();
//                 var birthyear = birthday.split("/").toList();
//                 var diffrtence =
//                     DateTime.now().year.toInt() - int.parse(birthyear[2]);
//                 return fireStoreUtils.validateIfUserBlocked(friend.userID)
//                     ? Container(
//                         width: 0,
//                         height: 0,
//                       )
//                     : Stack(
//                         children: <Widget>[
//                           GestureDetector(
//                             onTap: () {
//                               if (user.isVip == true || index == 0) {
//                                 push(
//                                     context,
//                                     UserDetailsScreen(
//                                       user: friend,
//                                       isMatch: true,
//                                       isMenuVisible: false,
//                                       likedYou: false,
//                                     ));
//                               } else {
//                                 push(context,
//                                     DeepBluePurchaseScreen(user: user));
//                               }
//                             },
//                             child: CachedNetworkImage(
//                               width: scrWidth / 2,
//                               height: 300,
//                               fit: BoxFit.cover,
//                               imageUrl:
//                                   friend.profilePictureURL == DEFAULT_AVATAR_URL
//                                       ? ''
//                                       : friend.profilePictureURL,
//                               placeholder: (context, imageUrl) {
//                                 return Icon(
//                                   Icons.account_circle,
//                                   size: MediaQuery.of(context).size.height * .4,
//                                   color: isDarkMode(context)
//                                       ? Colors.black
//                                       : Colors.white,
//                                 );
//                               },
//                               errorWidget: (context, imageUrl, error) {
//                                 return Icon(
//                                   Icons.account_circle,
//                                   size: MediaQuery.of(context).size.height * .4,
//                                   color: isDarkMode(context)
//                                       ? Colors.black
//                                       : Colors.white,
//                                 );
//                               },
//                             ),
//                           ),
//                           Align(
//                             alignment: Alignment.topCenter,
//                             child: Container(
//                               padding: const EdgeInsets.all(10),
//                               width: MediaQuery.of(context).size.width,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.vertical(
//                                   bottom: Radius.circular(0),
//                                 ),
//                                 gradient: const LinearGradient(
//                                   begin: Alignment.bottomCenter,
//                                   end: Alignment.topCenter,
//                                   colors: [Colors.black54, Colors.black26],
//                                 ),
//                               ),
//                               child: Row(
//                                 children: [
//                                   Text(
//                                     friend.fullName().trim() + ', ',
//                                     overflow: TextOverflow.ellipsis,
//                                     softWrap: true,
//                                     textScaleFactor: 1.0,
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 16,
//                                     ),
//                                   ),
//                                   Text(
//                                     diffrtence.toString(),
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Align(
//                             alignment: Alignment.bottomCenter,
//                             child: Container(
//                               padding: const EdgeInsets.all(8),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.vertical(
//                                   bottom: Radius.circular(0),
//                                 ),
//                                 gradient: const LinearGradient(
//                                   begin: Alignment.bottomCenter,
//                                   end: Alignment.topCenter,
//                                   colors: [Colors.black54, Colors.black26],
//                                 ),
//                               ),
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 mainAxisSize: MainAxisSize.max,
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: <Widget>[
//                                   InkWell(
//                                     onTap: () async {
//                                       if (user.isVip == true || index == 0) {
//                                         if (friend.ultraLike == false) {
//                                           await fireStoreUtils.ultraLikeYouLike(
//                                               user.userID,
//                                               friend.userID,
//                                               predefineCount);
//                                         }
//                                         setState(() {});
//                                       } else {
//                                         push(
//                                           context,
//                                           DeepBluePurchaseScreen(user: user),
//                                         );
//                                       }
//                                     },
//                                     child: friend.ultraLike
//                                         ? ImageIcon(
//                                             AssetImage(
//                                                 'assets/images/thunder_green.png'),
//                                             color: Colors.green,
//                                           )
//                                         : ImageIcon(
//                                             AssetImage(
//                                                 'assets/images/thunder.png'),
//                                             color: Colors.white,
//                                           ),
//                                   ),
//                                   InkWell(
//                                     onTap: () {
//                                       setState(() {
//                                         fireStoreUtils.removeYouLike(
//                                             user.userID, friend.userID);
//                                         snap.data?.removeAt(index);
//                                       });
//                                     },
//                                     child: Icon(
//                                       Icons.close,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           if (user.isVip == false && index != 0)
//                             GestureDetector(
//                               onTap: () {
//                                 push(
//                                   context,
//                                   DeepBluePurchaseScreen(user: user),
//                                 );
//                               },
//                               child: BlurryEffect(4.0),
//                             ),
//                         ],
//                       );
//               },
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   childAspectRatio: 0.7,
//                   crossAxisSpacing: 16,
//                   mainAxisSpacing: 16,
//                   crossAxisCount:
//                       (orientation == Orientation.portrait) ? 2 : 3),
//             ),
//           );
//         }
//       },
//     );
//   }

//   _onMatchLongPress(User friend) {
//     final action = CupertinoActionSheet(
//       message: Text(
//         friend.fullName(),
//         style: TextStyle(fontSize: 15.0),
//       ),
//       actions: <Widget>[
//         CupertinoActionSheetAction(
//           child: Text('View Profile'.tr()),
//           isDefaultAction: true,
//           onPressed: () async {
//             Navigator.pop(context);
//             push(
//               context,
//               UserDetailsScreen(
//                 user: friend,
//                 isMatch: true,
//                 isMenuVisible: false,
//               ),
//             );
//           },
//         ),
//       ],
//       cancelButton: CupertinoActionSheetAction(
//         child: Text(
//           'Cancel'.tr(),
//         ),
//         onPressed: () {
//           Navigator.pop(context);
//         },
//       ),
//     );
//     showCupertinoModalPopup(context: context, builder: (context) => action);
//   }
// }

class BlurryEffect extends StatelessWidget {
  final double blurry;

  BlurryEffect(this.blurry);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurry, sigmaY: blurry),
          child: Container(
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}
