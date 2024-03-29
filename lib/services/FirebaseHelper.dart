import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/constants.dart';
import 'package:dating/main.dart';
import 'package:dating/model/BlockUserModel.dart';
import 'package:dating/model/ChannelParticipation.dart';
import 'package:dating/model/ChatModel.dart';
import 'package:dating/model/ChatVideoContainer.dart';
import 'package:dating/model/ConversationModel.dart';
import 'package:dating/model/HomeConversationModel.dart';
import 'package:dating/model/MessageData.dart';
import 'package:dating/model/PurchaseModel.dart';
import 'package:dating/model/Swipe.dart';
import 'package:dating/model/SwipeCounterModel.dart';
import 'package:dating/model/User.dart';
import 'package:dating/model/User.dart' as location;
import 'package:dating/services/helper.dart';
import 'package:dating/ui/matchScreen/MatchScreen.dart';
import 'package:dating/ui/onBoarding/OnBoardingOtpVerficationScreen.dart';
import 'package:dating/ui/onBoarding/onBoarding_hobby_question.dart';
import 'package:dating/ui/reauthScreen/reauth_user_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart' as apple;
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class FireStoreUtils {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static Reference storage = FirebaseStorage.instance.ref();
  List<Swipe> matchedUsersList = [];
  late StreamController<List<HomeConversationModel>> conversationsStream;
  List<HomeConversationModel> homeConversations = [];
  List<BlockUserModel> blockedList = [];
  List<User> matches = [];
  // late StreamController<List<User>> tinderCardsStreamController;

  static Future<User?> getCurrentUser(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> userDocument =
        await firestore.collection(USERS).doc(uid).get();
    if (userDocument.exists) {
      return User.fromJson(userDocument.data() ?? {});
    } else {
      return null;
    }
  }

  static Future<User?> getCurrentUserMobile(String uid) async {
    QuerySnapshot<Map<String, dynamic>> userDocument = await firestore
        .collection(USERS)
        .where('phoneNumber', isEqualTo: uid)
        .get();
    User? users;
    userDocument.docs.forEach((element) {
      users = User.fromJson(element.data());
    });
    if (userDocument.docs.isNotEmpty) {
      return users;
    } else {
      return null;
    }
  }

  static Future<bool?> getCellNumber(String uid) async {
    QuerySnapshot<Map<String, dynamic>> userDocument = await firestore
        .collection(USERS)
        .where('phoneNumber', isEqualTo: uid)
        .get();
    if (userDocument.docs.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool?> getEmail(String uid) async {
    QuerySnapshot<Map<String, dynamic>> userDocument =
        await firestore.collection(USERS).where('email', isEqualTo: uid).get();
    if (userDocument.docs.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  static Future<User?> updateCurrentUser(User user) async {
    return await firestore
        .collection(USERS)
        .doc(user.userID)
        .set(user.toJson(null))
        .then((document) {
      return user;
    }, onError: (e) {
      return null;
    });
  }

  Future<Url> uploadChatImageToFireStorage(
      File image, BuildContext context) async {
    showProgress(context, 'Uploading image...'.tr(), false);
    var uniqueID = Uuid().v4();
    File compressedImage = await compressImage(image);
    Reference upload = storage.child('images/$uniqueID.png');
    UploadTask uploadTask = upload.putFile(compressedImage);
    uploadTask.snapshotEvents.listen((event) {
      updateProgress(
          'Uploading image ${(event.bytesTransferred.toDouble() / 1000).toStringAsFixed(2)} /'
                  '${(event.totalBytes.toDouble() / 1000).toStringAsFixed(2)} '
                  'KB'
              .tr());
    });
    uploadTask.whenComplete(() {}).catchError((onError) {
      print((onError as PlatformException).message);
    });
    var storageRef = (await uploadTask.whenComplete(() {})).ref;
    var downloadUrl = await storageRef.getDownloadURL();
    var metaData = await storageRef.getMetadata();
    hideProgress();
    return Url(
        mime: metaData.contentType ?? 'image', url: downloadUrl.toString());
  }

  Future<ChatVideoContainer> uploadChatVideoToFireStorage(
      File video, BuildContext context) async {
    showProgress(context, 'Uploading video...'.tr(), false);
    var uniqueID = Uuid().v4();
    File compressedVideo = await _compressVideo(video);
    Reference upload = storage.child('videos/$uniqueID.mp4');
    SettableMetadata metadata = SettableMetadata(contentType: 'video');
    UploadTask uploadTask = upload.putFile(compressedVideo, metadata);
    uploadTask.snapshotEvents.listen((event) {
      updateProgress(
          'Uploading video ${(event.bytesTransferred.toDouble() / 1000).toStringAsFixed(2)} /'
                  '${(event.totalBytes.toDouble() / 1000).toStringAsFixed(2)} '
                  'KB'
              .tr());
    });
    var storageRef = (await uploadTask.whenComplete(() {})).ref;
    var downloadUrl = await storageRef.getDownloadURL();
    var metaData = await storageRef.getMetadata();
    final uint8list = await VideoThumbnail.thumbnailFile(
        video: downloadUrl,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.PNG);
    final file = File(uint8list!);
    String thumbnailDownloadUrl = await uploadVideoThumbnailToFireStorage(file);
    hideProgress();
    return ChatVideoContainer(
        videoUrl: Url(
            url: downloadUrl.toString(), mime: metaData.contentType ?? 'video'),
        thumbnailUrl: thumbnailDownloadUrl);
  }

  Future<String> uploadVideoThumbnailToFireStorage(File file) async {
    var uniqueID = Uuid().v4();
    File compressedImage = await compressImage(file);
    Reference upload = storage.child('thumbnails/$uniqueID.png');
    UploadTask uploadTask = upload.putFile(compressedImage);
    var downloadUrl =
        await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    return downloadUrl.toString();
  }

  Future<List<Swipe>> getMatches(String userID) async {
    List<Swipe> matchList = <Swipe>[];
    await firestore
        .collection(SWIPES)
        .where('user1', isEqualTo: userID)
        .where('hasBeenSeen', isEqualTo: true)
        .get()
        .then((querySnapShot) {
      querySnapShot.docs.forEach((doc) {
        Swipe match = Swipe.fromJson(doc.data());
        if (match.id.isEmpty) {
          match.id = doc.id;
        }

        matchList.add(match);
      });
    });
    return matchList.toSet().toList();
  }

  getActiveMatches(String userID) async {
    List<Swipe> matchList = <Swipe>[];
    await firestore
        .collection(SWIPES)
        .where('user1', isEqualTo: userID)
        .where('hasBeenSeen', isEqualTo: true)
        .get()
        .then((querySnapShot) {
      querySnapShot.docs.forEach((doc) async {
        Swipe match = Swipe.fromJson(doc.data());
        if (match.id.isEmpty) {
          match.id = doc.id;
        }
        await firestore
            .collection(SUBSCRIPTIONS)
            .where('userID', isEqualTo: userID)
            // .where('userID2', isEqualTo: match.user2)
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
                return matchList.add(match);
              } else {
                MyAppState.currentUser!.isVip = false;
                if (Timestamp.now()
                        .toDate()
                        .difference(match.createdAt.toDate())
                        .inDays <
                    10) {
                  return matchList.add(match);
                }
              }
            });
          } else {
            if (Timestamp.now()
                    .toDate()
                    .difference(match.createdAt.toDate())
                    .inDays <
                10) {
              return matchList.add(match);
            }
          }
        });
      });
    });

    return matchList.toSet().toList();
  }

  Future<List<Swipe>> getExpireMatches(String userID) async {
    List<Swipe> matchList = <Swipe>[];
    await firestore
        .collection(SWIPES)
        .where('user1', isEqualTo: userID)
        .where('hasBeenSeen', isEqualTo: true)
        .get()
        .then((querySnapShot) {
      querySnapShot.docs.forEach((doc) {
        Swipe match = Swipe.fromJson(doc.data());
        if (match.id.isEmpty) {
          match.id = doc.id;
        }
        // print(match.createdAt.toDate());
        //print(  Timestamp.now().toDate().difference(match.createdAt.toDate()).inHours);
        if (MyAppState.currentUser?.isVip ?? false) {
          //matchList.add(match);
        } else {
          if (Timestamp.now()
                  .toDate()
                  .difference(match.createdAt.toDate())
                  .inDays >
              10) {
            matchList.add(match);
          }
        }
      });
    });
    return matchList.toSet().toList();
  }

  Future<List<Swipe>> getOtherLikedNotMatch(String userID) async {
    List<Swipe> matchList = <Swipe>[];
    await firestore
        .collection(SWIPES)
        .where('user2', isEqualTo: userID)
        .where('type', isEqualTo: "like")
        // .where('removeuser', isEqualTo: false)
        //.where('hasBeenSeen', isEqualTo: false)
        .get()
        .then((querySnapShot) {
      querySnapShot.docs.forEach((doc) {
        Swipe match = Swipe.fromJson(doc.data());
        if (match.id.isEmpty) {
          match.id = doc.id;
        }
        //if (match.removeuser == false) {
        matchList.add(match);
        //}
      });
    });
    return matchList.toSet().toList();
  }

  Future<List<Swipe>> getLikedNotMatch(String userID) async {
    List<Swipe> matchList = <Swipe>[];
    await firestore
        .collection(SWIPES)
        .where('user1', isEqualTo: userID)
        .where('type', isEqualTo: "like")
        //.where('hasBeenSeen', isEqualTo: false)
        .get()
        .then((querySnapShot) {
      querySnapShot.docs.forEach((doc) {
        Swipe match = Swipe.fromJson(doc.data());
        if (match.id.isEmpty) {
          match.id = doc.id;
        }
        // if(match.removeuser==false){
        matchList.add(match);
        //}
      });
    });
    return matchList.toSet().toList();
  }

  Future<bool> removeYouLike(String user1, String user2) async {
    bool isSuccessful = false;
    // removeUsers(
    //   user1,
    //   user2,
    //   'Remove You Like',
    //   false,
    // );
    await firestore
        .collection(SWIPES)
        .where('user1', isEqualTo: user1)
        .where('user2', isEqualTo: user2)
        .get()
        .then((onValue) {
      onValue.docs.forEach((doc) {
        Swipe match = Swipe.fromJson(doc.data());
        // match.type = "dislike";
        // match.removeuser=true;
        match.hasBeenSeen = false;
        firestore
            .collection(SWIPES)
            .doc(match.id)
            .update(match.toJson())
            .then((value) => isSuccessful = true);
      });
    }, onError: (e) {
      print('${e.toString()}');
      isSuccessful = false;
    });

    await firestore
        .collection(SWIPES)
        .where('user2', isEqualTo: user1)
        .where('user1', isEqualTo: user2)
        .get()
        .then((onValue) {
      onValue.docs.forEach((doc) {
        Swipe match = Swipe.fromJson(doc.data());
        //  match.removeuser=true;
        match.hasBeenSeen = false;
        firestore
            .collection(SWIPES)
            .doc(match.id)
            .update(match.toJson())
            .then((value) => isSuccessful = true);
      });
    }, onError: (e) {
      print('${e.toString()}');
      isSuccessful = false;
    });
    return isSuccessful;

    DocumentReference documentReference = firestore.collection(SWIPES).doc();
    Swipe leftSwipe = Swipe(
        id: documentReference.id,
        type: 'dislike',
        user1: user1,
        user2: user2,
        createdAt: Timestamp.now(),
        hasBeenSeen: false);
    await documentReference.set(leftSwipe.toJson());
    return true;
  }

  Future<bool> ultraLikeYouLike(String user1, String user2, int count) async {
    bool isSuccessful = false;
    await firestore
        .collection(SWIPES)
        .where('user1', isEqualTo: user1)
        .where('user2', isEqualTo: user2)
        .get()
        .then((onValue) {
      onValue.docs.forEach((doc) {
        Swipe match = Swipe.fromJson(doc.data());
        HashMap<String, bool> mapParam = HashMap<String, bool>();
        mapParam["ultraLike"] = true;
        firestore
            .collection(SWIPES)
            .doc(match.id)
            .update(mapParam)
            .then((value) => isSuccessful = true);
        removeUltraLikes(count);
      });
    }, onError: (e) {
      print('${e.toString()}');
      isSuccessful = false;
    });
    return isSuccessful;
  }

  Future<bool> removeUltraLikes(int count) async {
    bool isSuccessful = false;
    await firestore.collection(ULTRALIKECOUNT).get().then((onValue) {
      onValue.docs.forEach((doc) {
        HashMap<String, dynamic> mapParam = HashMap<String, dynamic>();
        HashMap<String, dynamic> ultraLikeParam = HashMap<String, dynamic>();
        var decreaseCount = count - 1;
        print(decreaseCount);
        mapParam["count"] = decreaseCount.toString();
        ultraLikeParam["ultralikeCount"] = decreaseCount.toString();
        firestore
            .collection(ULTRALIKECOUNT)
            .doc(MyAppState.currentUser!.userID)
            .update(mapParam)
            .then((value) => isSuccessful = true);

        firestore
            .collection(ULTRALIKE)
            .doc(MyAppState.currentUser!.userID)
            .update(ultraLikeParam)
            .then((value) => isSuccessful = true);
      });
    }, onError: (e) {
      print('${e.toString()}');
      isSuccessful = false;
    });
    return isSuccessful;
  }

  Future<bool> otherLikeYouLike(
      String user1, String user2, String whatLiked) async {
    bool isSuccessful = false;
    await firestore
        .collection(SWIPES)
        .where('user2', isEqualTo: user1)
        .where('user1', isEqualTo: user2)
        .get()
        .then((onValue) async {
      onValue.docs.forEach((doc) {
        Swipe match = Swipe.fromJson(doc.data());
        HashMap<String, dynamic> mapParam = HashMap<String, dynamic>();
        mapParam["otherLike"] = true;
        mapParam["hasBeenSeen"] = true;
        mapParam["createdAt"] = Timestamp.now();
        firestore
            .collection(SWIPES)
            .doc(match.id)
            .update(mapParam)
            .then((value) => isSuccessful = true);
      });
      User? user = await getCurrentUser(user2);
      QuerySnapshot querySnapshot = await firestore
          .collection(SWIPES)
          .where('user1', isEqualTo: user1)
          .where('user2', isEqualTo: user2)
          .where('type', isEqualTo: 'like')
          .get();

      if (querySnapshot.docs.isEmpty) {
        User? users = await getCurrentUser(user1);
        MyAppState.currentUser = users;
        DocumentReference document = firestore.collection(SWIPES).doc();
        var swipe = Swipe(
          id: document.id,
          type: 'like',
          hasBeenSeen: true,
          otherLike: true,
          createdAt: Timestamp.now(),
          user1: user1,
          user2: user2,
          whatLiked: whatLiked,
        );
        await document.set(swipe.toJson());
        if (user!.settings.pushNewMatchesEnabled) {
          await sendNotification(
              user.fcmToken,
              'New match',
              'You have got a new '
                  'match: ${MyAppState.currentUser!.fullName()}.',
              null);
        }
      }
    }, onError: (e) {
      print('${e.toString()}');
      isSuccessful = false;
    });
    return isSuccessful;
  }

  Future<bool> removeLikeYou(String user1, String user2) async {
    bool isSuccessful = false;
    removeUsers(user1, user2, 'Remove Like You', false);
    await firestore
        .collection(SWIPES)
        .where('user2', isEqualTo: user1)
        .where('user1', isEqualTo: user2)
        .get()
        .then((onValue) {
      onValue.docs.forEach((doc) {
        Swipe match = Swipe.fromJson(doc.data());
        //  match.removeuser=true;
        match.hasBeenSeen = false;
        firestore
            .collection(SWIPES)
            .doc(match.id)
            .update(match.toJson())
            .then((value) => isSuccessful = true);
      });
    }, onError: (e) {
      print('${e.toString()}');
      isSuccessful = false;
    });

    await firestore
        .collection(SWIPES)
        .where('user1', isEqualTo: user1)
        .where('user2', isEqualTo: user2)
        .get()
        .then((onValue) {
      onValue.docs.forEach((doc) {
        Swipe match = Swipe.fromJson(doc.data());
        match.type = "dislike";
        //  match.removeuser=true;
        match.hasBeenSeen = false;
        firestore
            .collection(SWIPES)
            .doc(match.id)
            .update(match.toJson())
            .then((value) => isSuccessful = true);
      });
    }, onError: (e) {
      print('${e.toString()}');
      isSuccessful = false;
    });
    return isSuccessful;

    DocumentReference documentReference = firestore.collection(SWIPES).doc();
    Swipe leftSwipe = Swipe(
        id: documentReference.id,
        //  removeuser: true,
        user1: MyAppState.currentUser!.userID,
        user2: user2,
        createdAt: Timestamp.now(),
        hasBeenSeen: false);
    await documentReference.set(leftSwipe.toJson());
    return true;
  }

  Future<bool> removeUsers(
      String user1, String user2, String? reason, bool isReport) async {
    HashMap<String, dynamic> hashMap = HashMap();
    hashMap["user1"] = user1;
    hashMap["user2"] = user2;
    hashMap["isRemove"] = true;
    hashMap["reason"] = reason;
    hashMap["isReport"] = isReport;

    await firestore.collection(REMOVE).add(hashMap).then((value) {});
    return true;
  }

  Future<bool> removeMatch(String id) async {
    bool isSuccessful = false;
    await firestore.collection(SWIPES).doc(id).delete().then((onValue) {
      isSuccessful = true;
    }, onError: (e) {
      print('${e.toString()}');
      isSuccessful = false;
    });
    return isSuccessful;
  }

  Future<List<User>> getMatchedUserObject(String userID) async {
    List<String> friendIDs = [];
    // matchedUsersList.clear();
    //var matchedUsersList = await getActiveMatches(userID);

    /* await firestore
        .collection(SUBSCRIPTIONS)
        .where('userID', isEqualTo: userID)
        .where('userID2', isEqualTo: match.user2)
        .get()
        .then((querySnapShot) {
      if(querySnapShot.docs.isNotEmpty) {
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
            if (Timestamp
                .now()
                .toDate()
                .difference(match.createdAt.toDate())
                .inHours < 48) {
              matchList.add(match);
            }
          }
        });
      }else{
        if (Timestamp
            .now()
            .toDate()
            .difference(match.createdAt.toDate())
            .inHours < 48) {
          matchList.add(match);
        }
      }
    });*/

    List<Swipe> matchList = <Swipe>[];
    await firestore
        .collection(SWIPES)
        .where('user1', isEqualTo: userID)
        .where('hasBeenSeen', isEqualTo: true)
        .get()
        .then((querySnapShot) {
      querySnapShot.docs.forEach((doc) async {
        Swipe match = Swipe.fromJson(doc.data());
        if (match.id.isEmpty) {
          match.id = doc.id;
        }
        matchList.add(match);
      });
    });
    matchList.forEach((matchedUser) {
      friendIDs.add(matchedUser.user2);
    });
    List<User> matches = [];
    for (String id in friendIDs) {
      await firestore.collection(USERS).doc(id).get().then((user) {
        matches.add(User.fromJson(user.data() ?? {}));
      });
    }
    return matches;
  }

  Future<List<User>> getExpireMatchedUserObject(String userID) async {
    List<String> friendIDs = [];
    // matchedUsersList.clear();
    var matchedUsersList = await getExpireMatches(userID);
    matchedUsersList.forEach((matchedUser) {
      friendIDs.add(matchedUser.user2);
    });
    List<User> matches = [];
    for (String id in friendIDs) {
      await firestore.collection(USERS).doc(id).get().then((user) {
        matches.add(User.fromJson(user.data() ?? {}));
      });
    }
    return matches;
  }

  Future<List<User>> getOtherYouLikedObject(String userID) async {
    List<String> friendIDs = [];
    matchedUsersList.clear();
    matchedUsersList = await getOtherLikedNotMatch(userID);
    matchedUsersList.forEach((matchedUser) {
      friendIDs.add(matchedUser.user1);
    });
    matches.clear();
    for (String id in friendIDs) {
      await firestore.collection(USERS).doc(id).get().then((user) async {
        var data = User.fromJson(user.data() ?? {});
        matchedUsersList.forEach((matchedUser) {
          if (matchedUser.user1 == data.userID) {
            if (matchedUser.ultraLike) {
              data.ultraLike = matchedUser.ultraLike;
            }
            if (matchedUser.otherLike) {
              data.otherLike = matchedUser.otherLike;
            }
          }
        });
        if (data.userID.isNotEmpty) {
          if (await _isUserRemoved(data.userID)) {
            matches.add(data);
          }
        }
      });
    }
    return matches;
  }

  Future<List<User>> getYouLikedObject(String userID) async {
    List<String> friendIDs = [];
    matchedUsersList.clear();
    matchedUsersList = await getLikedNotMatch(userID);
    matchedUsersList.forEach((matchedUser) {
      friendIDs.add(matchedUser.user2);
    });
    matches.clear();
    for (String id in friendIDs) {
      await firestore.collection(USERS).doc(id).get().then((user) async {
        var data = User.fromJson(user.data() ?? {});

        matchedUsersList.forEach((matchedUser) {
          if (matchedUser.user2 == data.userID) {
            if (matchedUser.ultraLike) {
              data.ultraLike = matchedUser.ultraLike;
            }
            if (matchedUser.otherLike) {
              data.otherLike = matchedUser.otherLike;
            }
          }
        });
        if (data.userID.isNotEmpty) {
          if (await _isUserRemoved(data.userID)) {
            matches.add(data);
          }
        }
      });
    }

    return matches;
  }

  Stream<List<HomeConversationModel>> getConversations(String userID) async* {
    conversationsStream = StreamController<List<HomeConversationModel>>();
    HomeConversationModel newHomeConversation;

    firestore
        .collection(CHANNEL_PARTICIPATION)
        .where('user', isEqualTo: userID)
        .snapshots()
        .listen((querySnapshot) {
      if (querySnapshot.docs.isEmpty) {
        conversationsStream.sink.add(homeConversations);
      } else {
        homeConversations.clear();
        Future.forEach(querySnapshot.docs,
            (DocumentSnapshot<Map<String, dynamic>> document) {
          if (document.exists) {
            ChannelParticipation participation =
                ChannelParticipation.fromJson(document.data() ?? {});
            firestore
                .collection(CHANNELS)
                .doc(participation.channel)
                .snapshots()
                .listen((channel) async {
              if (channel.exists) {
                bool isGroupChat = !channel.id.contains(userID);
                List<User> users = [];
                if (isGroupChat) {
                  getGroupMembers(channel.id).listen((listOfUsers) {
                    if (listOfUsers.isNotEmpty) {
                      users = listOfUsers;
                      newHomeConversation = HomeConversationModel(
                          conversationModel:
                              ConversationModel.fromJson(channel.data() ?? {}),
                          isGroupChat: isGroupChat,
                          members: users);

                      if (newHomeConversation.conversationModel!.id.isEmpty)
                        newHomeConversation.conversationModel!.id = channel.id;

                      homeConversations
                          .removeWhere((conversationModelToDelete) {
                        return newHomeConversation.conversationModel!.id ==
                            conversationModelToDelete.conversationModel!.id;
                      });
                      homeConversations.add(newHomeConversation);
                      homeConversations.sort((a, b) => a
                          .conversationModel!.lastMessageDate
                          .compareTo(b.conversationModel!.lastMessageDate));
                      conversationsStream.sink
                          .add(homeConversations.reversed.toList());
                    }
                  });
                } else {
                  getUserByID(channel.id.replaceAll(userID, '')).listen((user) {
                    users.clear();
                    users.add(user);
                    newHomeConversation = HomeConversationModel(
                        conversationModel:
                            ConversationModel.fromJson(channel.data() ?? {}),
                        isGroupChat: isGroupChat,
                        members: users);

                    if (newHomeConversation.conversationModel!.id.isEmpty)
                      newHomeConversation.conversationModel!.id = channel.id;

                    homeConversations.removeWhere((conversationModelToDelete) {
                      return newHomeConversation.conversationModel!.id ==
                          conversationModelToDelete.conversationModel!.id;
                    });

                    homeConversations.add(newHomeConversation);
                    homeConversations.sort((a, b) => a
                        .conversationModel!.lastMessageDate
                        .compareTo(b.conversationModel!.lastMessageDate));
                    conversationsStream.sink
                        .add(homeConversations.reversed.toList());
                  });
                }
              }
            });
          }
        });
      }
    });
    yield* conversationsStream.stream;
  }

  Stream<List<User>> getGroupMembers(String channelID) async* {
    StreamController<List<User>> membersStreamController = StreamController();
    getGroupMembersIDs(channelID).listen((memberIDs) {
      if (memberIDs.isNotEmpty) {
        List<User> groupMembers = [];
        for (String id in memberIDs) {
          getUserByID(id).listen((user) {
            groupMembers.add(user);
            membersStreamController.sink.add(groupMembers);
          });
        }
      } else {
        membersStreamController.sink.add([]);
      }
    });
    yield* membersStreamController.stream;
  }

  Stream<List<String>> getGroupMembersIDs(String channelID) async* {
    StreamController<List<String>> membersIDsStreamController =
        StreamController();
    firestore
        .collection(CHANNEL_PARTICIPATION)
        .where('channel', isEqualTo: channelID)
        .snapshots()
        .listen((participations) {
      List<String> uids = [];
      for (DocumentSnapshot<Map<String, dynamic>> document
          in participations.docs) {
        uids.add(document.data()?['user'] ?? '');
      }
      if (uids.contains(MyAppState.currentUser!.userID)) {
        membersIDsStreamController.sink.add(uids);
      } else {
        membersIDsStreamController.sink.add([]);
      }
    });
    yield* membersIDsStreamController.stream;
  }

  Stream<User> getUserByID(String id) async* {
    StreamController<User> userStreamController = StreamController();
    firestore.collection(USERS).doc(id).snapshots().listen((user) {
      userStreamController.sink.add(User.fromJson(user.data() ?? {}));
    });
    yield* userStreamController.stream;
  }

  getUser(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> result =
        await firestore.collection(USERS).doc(userId).get();
    return User.fromJson(result.data()!);
  }

  Future<ConversationModel?> getChannelByIdOrNull(String channelID) async {
    ConversationModel? conversationModel;
    await firestore.collection(CHANNELS).doc(channelID).get().then((channel) {
      if (channel.exists) {
        conversationModel = ConversationModel.fromJson(channel.data() ?? {});
      }
    }, onError: (e) {
      print((e as PlatformException).message);
    });
    return conversationModel;
  }

  Stream<ChatModel> getChatMessages(
      HomeConversationModel homeConversationModel) async* {
    StreamController<ChatModel> chatModelStreamController = StreamController();
    ChatModel chatModel = ChatModel();
    List<MessageData> listOfMessages = [];
    List<User> listOfMembers = homeConversationModel.members;
    if (homeConversationModel.isGroupChat) {
      homeConversationModel.members.forEach((groupMember) {
        if (groupMember.userID != MyAppState.currentUser!.userID) {
          getUserByID(groupMember.userID).listen((updatedUser) {
            for (int i = 0; i < listOfMembers.length; i++) {
              if (listOfMembers[i].userID == updatedUser.userID) {
                listOfMembers[i] = updatedUser;
              }
            }
            chatModel.message = listOfMessages;
            chatModel.members = listOfMembers;
            chatModelStreamController.sink.add(chatModel);
          });
        }
      });
    } else {
      User friend = homeConversationModel.members.first;
      getUserByID(friend.userID).listen((user) {
        listOfMembers.clear();
        listOfMembers.add(user);
        chatModel.message = listOfMessages;
        chatModel.members = listOfMembers;
        chatModelStreamController.sink.add(chatModel);
      });
    }
    if (homeConversationModel.conversationModel != null) {
      firestore
          .collection(CHANNELS)
          .doc(homeConversationModel.conversationModel!.id)
          .collection(THREAD)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen((onData) {
        listOfMessages.clear();
        onData.docs.forEach((document) {
          listOfMessages.add(MessageData.fromJson(document.data()));
        });
        chatModel.message = listOfMessages;
        chatModel.members = listOfMembers;
        chatModelStreamController.sink.add(chatModel);
      });
    }
    yield* chatModelStreamController.stream;
  }

  Future<void> sendMessage(List<User> members, bool isGroup,
      MessageData message, ConversationModel conversationModel) async {
    var ref = firestore
        .collection(CHANNELS)
        .doc(conversationModel.id)
        .collection(THREAD)
        .doc();
    message.messageID = ref.id;
    await ref.set(message.toJson());
    List<User> payloadFriends;
    if (isGroup) {
      payloadFriends = [];
      payloadFriends.addAll(members);
    } else {
      payloadFriends = [MyAppState.currentUser!];
    }

    await Future.forEach(members, (User element) async {
      if (element.userID != MyAppState.currentUser!.userID) {
        if (element.settings.pushNewMessages) {
          User? friend;
          if (isGroup) {
            friend = payloadFriends
                .firstWhere((user) => user.fcmToken == element.fcmToken);
            payloadFriends.remove(friend);
            payloadFriends.add(MyAppState.currentUser!);
          }
          Map<String, dynamic> payload = <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
            'conversationModel': conversationModel.toPayload(),
            'isGroup': isGroup,
            'members': '${payloadFriends.first.userID}',
          };
          await sendNotification(
            element.fcmToken,
            isGroup
                ? conversationModel.name
                : MyAppState.currentUser!.fullName(),
            message.content,
            payload,
          );
          if (isGroup) {
            payloadFriends.remove(MyAppState.currentUser);
            payloadFriends.add(friend!);
          }
        }
      }
    });
  }

  Future<bool> createConversation(ConversationModel conversation) async {
    bool isSuccessful = false;
    await firestore
        .collection(CHANNELS)
        .doc(conversation.id)
        .set(conversation.toJson())
        .then((onValue) async {
      ChannelParticipation myChannelParticipation = ChannelParticipation(
          user: MyAppState.currentUser!.userID, channel: conversation.id);
      ChannelParticipation myFriendParticipation = ChannelParticipation(
          user: conversation.id.replaceAll(MyAppState.currentUser!.userID, ''),
          channel: conversation.id);
      await createChannelParticipation(myChannelParticipation);
      await createChannelParticipation(myFriendParticipation);
      isSuccessful = true;
    }, onError: (e) {
      print((e as PlatformException).message);
      isSuccessful = false;
    });
    return isSuccessful;
  }

  Future<void> updateChannel(ConversationModel conversationModel) async {
    await firestore
        .collection(CHANNELS)
        .doc(conversationModel.id)
        .update(conversationModel.toJson());
  }

  Future<void> createChannelParticipation(
      ChannelParticipation channelParticipation) async {
    await firestore
        .collection(CHANNEL_PARTICIPATION)
        .add(channelParticipation.toJson());
  }

  Future<HomeConversationModel> createGroupChat(
      List<User> selectedUsers, String groupName) async {
    late HomeConversationModel groupConversationModel;
    DocumentReference channelDoc = firestore.collection(CHANNELS).doc();
    ConversationModel conversationModel = ConversationModel();
    conversationModel.id = channelDoc.id;
    conversationModel.creatorId = MyAppState.currentUser!.userID;
    conversationModel.name = groupName;
    conversationModel.lastMessage =
        '${MyAppState.currentUser!.fullName()} created this group'.tr();
    conversationModel.lastMessageDate = Timestamp.now();
    await channelDoc.set(conversationModel.toJson()).then((onValue) async {
      selectedUsers.add(MyAppState.currentUser!);
      for (User user in selectedUsers) {
        ChannelParticipation channelParticipation = ChannelParticipation(
            channel: conversationModel.id, user: user.userID);
        await createChannelParticipation(channelParticipation);
      }
      groupConversationModel = HomeConversationModel(
          isGroupChat: true,
          members: selectedUsers,
          conversationModel: conversationModel);
    });
    return groupConversationModel;
  }

  Future<bool> leaveGroup(ConversationModel conversationModel) async {
    bool isSuccessful = false;
    conversationModel.lastMessage = '${MyAppState.currentUser!.fullName()} '
            'left'
        .tr();
    conversationModel.lastMessageDate = Timestamp.now();
    await updateChannel(conversationModel).then((_) async {
      await firestore
          .collection(CHANNEL_PARTICIPATION)
          .where('channel', isEqualTo: conversationModel.id)
          .where('user', isEqualTo: MyAppState.currentUser!.userID)
          .get()
          .then((onValue) async {
        await firestore
            .collection(CHANNEL_PARTICIPATION)
            .doc(onValue.docs.first.id)
            .delete()
            .then((onValue) {
          isSuccessful = true;
        });
      });
    });
    return isSuccessful;
  }

  Future<bool> blockUser(User blockedUser, String type, String reason) async {
    bool isSuccessful = false;
    BlockUserModel blockUserModel = BlockUserModel(
      type: type,
      source: MyAppState.currentUser!.userID,
      dest: blockedUser.userID,
      createdAt: Timestamp.now(),
      reason: reason,
    );
    await firestore
        .collection(REPORTS)
        .add(blockUserModel.toJson())
        .then((onValue) {
      isSuccessful = true;
    });
    return isSuccessful;
  }

  // reportUser({required String otherUid, required String reasone}) async {
  //   await firestore.collection(REPORTSUSER).doc().set({
  //     'uid': MyAppState.currentUser?.userID,
  //     'reportUserId': otherUid,
  //     'reasone': reasone
  //   });
  // }

  Stream<bool> getBlocks() async* {
    StreamController<bool> refreshStreamController = StreamController();
    firestore
        .collection(REPORTS)
        .where('source', isEqualTo: MyAppState.currentUser!.userID)
        .snapshots()
        .listen((onData) {
      List<BlockUserModel> list = [];
      for (DocumentSnapshot<Map<String, dynamic>> block in onData.docs) {
        list.add(BlockUserModel.fromJson(block.data() ?? {}));
      }
      blockedList = list;

      if (homeConversations.isNotEmpty || matches.isNotEmpty) {
        refreshStreamController.sink.add(true);
      }
    });
    yield* refreshStreamController.stream;
  }

  bool validateIfUserBlocked(String userID) {
    for (BlockUserModel blockedUser in blockedList) {
      if (userID == blockedUser.dest) {
        return true;
      }
    }
    return false;
  }

  Future<List<String>> getUserDisplayed() async {
    DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
        .instance
        .collection(USERDISPLAYED)
        .doc(MyAppState.currentUser!.userID)
        .get();
    if (doc.data() != null) {
      return await List<String>.from(doc.data()!['users_displayed']);
    } else {
      return [MyAppState.currentUser!.userID];
    }
  }

  List<User> truuBlueUsers = [];
  Future<List<User>> getTinderUsers({List? getStoredUser}) async {
    List<User> tinderUsers = [];
    Position? locationData = await getCurrentLocation();

    if (locationData != null) {
      MyAppState.currentUser!.location = location.UserLocation(
          latitude: locationData.latitude, longitude: locationData.longitude);
      QuerySnapshot<Map<String, dynamic>> value;
      List<String> displayedUser = await getUserDisplayed();
      int limit = 10;
      if (displayedUser.length >= 10) {
        limit = displayedUser.length;
        displayedUser.removeRange(10, displayedUser.length);
      }
      if (getStoredUser != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final String? getStoreUsers = prefs.getString('storeUsers');
        if (getStoreUsers != null && getStoreUsers != "[]") {
          value = await firestore
              .collection(USERS)
              .where('showMe', isEqualTo: true)
              .where('id', whereIn: jsonDecode(getStoreUsers))
              .orderBy('isUserBoost', descending: true)
              .limit(limit)
              .get();
        } else {
          value = await firestore
              .collection(USERS)
              .where('showMe', isEqualTo: true)
              .where('id', whereNotIn: displayedUser)
              .orderBy('id')
              .orderBy('isUserBoost', descending: true)
              .limit(limit)
              .get();
        }
      } else {
        value = await firestore
            .collection(USERS)
            .where('showMe', isEqualTo: true)
            .where('id', whereNotIn: displayedUser)
            .orderBy('id')
            .orderBy('isUserBoost', descending: true)
            .limit(limit)
            .get();
      }
      await Future.forEach(value.docs,
          (DocumentSnapshot<Map<String, dynamic>> tinderUser) async {
        try {
          if (tinderUser.id != MyAppState.currentUser!.userID) {
            User user = User.fromJson(tinderUser.data() ?? {});
            double distance =
                getDistance(user.location, MyAppState.currentUser!.location);

            if (await _isValidUserForTinderSwipe(user, distance)) {
              if (await _isUserRemoved(user.userID)) {
                user.milesAway = '$distance Miles Away'.tr();
                tinderUsers.add(user);
                truuBlueUsers = tinderUsers;
              }
            }
            if (tinderUsers.isEmpty) {
              truuBlueUsers = tinderUsers;
            }
          } else if (value.docs.length == 1) {
            truuBlueUsers = tinderUsers;
          }
        } catch (e) {
          print('FireStoreUtils.getTinderUsers failed to parse user object $e');
        }
      });
    }
    return truuBlueUsers;
  }

  Future<bool> _isValidUserForTinderSwipe(
      User tinderUser, double distance) async {
    //make sure that we haven't swiped this user before
    QuerySnapshot result1 = await firestore
        .collection(SWIPES)
        .where('user1', isEqualTo: MyAppState.currentUser!.userID)
        .where('user2', isEqualTo: tinderUser.userID)
        .get()
        .catchError((onError) {
      print('${(onError as PlatformException).message}');
    });
    return result1.docs.isEmpty &&
        // isPreferredGender(tinderUser.settings.gender) &&
        isInPreferredDistance(distance);
  }

  Future<bool> _isUserRemoved(String tinderUser) async {
    //make sure that we haven't swiped this user before
    QuerySnapshot result1 = await firestore
        .collection(REMOVE)
        .where('user1', isEqualTo: MyAppState.currentUser!.userID)
        .where('user2', isEqualTo: tinderUser)
        .get()
        .catchError((onError) {
      print('${(onError as PlatformException).message}');
    });
    return result1.docs.isEmpty;
  }

  matchChecker() async {
    String myID = MyAppState.currentUser!.userID;
    QuerySnapshot<Map<String, dynamic>> result = await firestore
        .collection(SWIPES)
        .where('user2', isEqualTo: myID)
        .where('type', isEqualTo: 'like')
        .get();
    if (result.docs.isNotEmpty) {
      await Future.forEach(result.docs,
          (DocumentSnapshot<Map<String, dynamic>> document) async {
        try {
          Swipe match = Swipe.fromJson(document.data() ?? {});
          QuerySnapshot<Map<String, dynamic>> unSeenMatches = await firestore
              .collection(SWIPES)
              .where('user1', isEqualTo: myID)
              .where('type', isEqualTo: 'like')
              .where('user2', isEqualTo: match.user1)
              .where('hasBeenSeen', isEqualTo: false)
              .get();
          if (unSeenMatches.docs.isNotEmpty) {
            unSeenMatches.docs.forEach(
                (DocumentSnapshot<Map<String, dynamic>> unSeenMatch) async {
              DocumentSnapshot<Map<String, dynamic>> matchedUserDocSnapshot =
                  await firestore.collection(USERS).doc(match.user1).get();
              User matchedUser =
                  User.fromJson(matchedUserDocSnapshot.data() ?? {});
              Get.to(() => MatchScreen(matchedUser: matchedUser));
              updateHasBeenSeen(unSeenMatch.data() ?? {});
            });
          }
        } catch (e) {
          print('FireStoreUtils.matchChecker failed to parse object ' '$e');
        }
      });
    }
  }

  onSwipeLeft(User dislikedUser) async {
    removeUsers(
      MyAppState.currentUser!.userID,
      dislikedUser.userID,
      'Remove',
      false,
    );
    DocumentReference documentReference = firestore.collection(SWIPES).doc();
    Swipe leftSwipe = Swipe(
        id: documentReference.id,
        type: 'dislike',
        user1: MyAppState.currentUser!.userID,
        user2: dislikedUser.userID,
        createdAt: Timestamp.now(),
        // removeuser: true,
        hasBeenSeen: false);
    await documentReference.set(leftSwipe.toJson());
  }

  Future<User?> onSwipeRight(User user, String whatLiked) async {
    // check if this user sent a match request before ? if yes, it's a match,
    // if not, send him match request
    QuerySnapshot querySnapshot = await firestore
        .collection(SWIPES)
        .where('user1', isEqualTo: user.userID)
        .where('user2', isEqualTo: MyAppState.currentUser!.userID)
        .where('type', isEqualTo: 'like')
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      //this user sent me a match request, let's talk
      // if(await checkLiked(user.userID)) {

      await firestore
          .collection(SWIPES)
          .where('user1', isEqualTo: user.userID)
          .where('user2', isEqualTo: MyAppState.currentUser!.userID)
          .get()
          .then((onValue) {
        onValue.docs.forEach((doc) {
          print("match.toJson()");
          print(doc.data());
          Swipe match = Swipe.fromJson(doc.data());
          match.otherLike = true;
          match.hasBeenSeen = true;
          match.whatLiked = whatLiked;
          match.createdAt = Timestamp.now();
          firestore
              .collection(SWIPES)
              .doc(match.id)
              .update(match.toJson())
              .then((value) {
            print("match.toJson(),value");
          }).onError((error, stackTrace) {
            print(error);
          });
          print("match.toJson()");
          print(match.toJson());
        });
      });

      //  }
      DocumentReference document = firestore.collection(SWIPES).doc();
      var swipe = Swipe(
        id: document.id,
        type: 'like',
        hasBeenSeen: true,
        otherLike: true,
        createdAt: Timestamp.now(),
        user1: MyAppState.currentUser!.userID,
        user2: user.userID,
        whatLiked: whatLiked,
      );
      await document.set(swipe.toJson());
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
          "users_displayed": FieldValue.arrayUnion([user.userID]),
        });
      } else {
        await FirebaseFirestore.instance
            .collection(USERDISPLAYED)
            .doc(MyAppState.currentUser!.userID)
            .set({
          "users_displayed": FieldValue.arrayUnion([user.userID]),
        });
      }

      if (user.settings.pushNewMatchesEnabled) {
        await sendNotification(
            user.fcmToken,
            'New match',
            'You have got a new '
                'match: ${MyAppState.currentUser!.fullName()}.',
            null);
      }

      return user;
    } else {
      //this user didn't send me a match request, let's send match request
      // and keep swiping
      await sendSwipeRequest(user, MyAppState.currentUser!.userID, whatLiked);
      return null;
    }
  }

  Future<bool> checkLiked(String user) async {
    bool isSuccessful = false;
    await firestore
        .collection(SWIPES)
        .where('user1', isEqualTo: user)
        .where('user2', isEqualTo: MyAppState.currentUser!.userID)
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        isSuccessful = true;
      }
    });
    return isSuccessful;
  }

  Future<bool> sendSwipeRequest(
      User user, String myID, String whatLiked) async {
    bool isSuccessful = false;
    DocumentReference documentReference = firestore.collection(SWIPES).doc();
    Swipe swipe = Swipe(
        id: documentReference.id,
        user1: myID,
        user2: user.userID,
        hasBeenSeen: false,
        createdAt: Timestamp.now(),
        whatLiked: whatLiked,
        type: 'like');
    await documentReference.set(swipe.toJson()).then((onValue) async {
      isSuccessful = true;
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
          "users_displayed": FieldValue.arrayUnion([user.userID]),
        });
      } else {
        await FirebaseFirestore.instance
            .collection(USERDISPLAYED)
            .doc(MyAppState.currentUser!.userID)
            .set({
          "users_displayed": FieldValue.arrayUnion([user.userID]),
        });
      }
      if (user.settings.pushSuperLikesEnabled) {
        await sendNotification(user.fcmToken, 'New Like',
            '${MyAppState.currentUser!.fullName()} like your profile', null);
      }
    }, onError: (e) {
      isSuccessful = false;
    });

    return isSuccessful;
  }

  updateHasBeenSeen(Map<String, dynamic> target) async {
    target['hasBeenSeen'] = true;
    await firestore.collection(SWIPES).doc(target['id'] ?? '').update(target);
  }

  Future<void> deleteImage(String imageFileUrl) async {
    var fileUrl = Uri.decodeFull(Path.basename(imageFileUrl))
        .replaceAll(RegExp(r'(\?alt).*'), '');

    final Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileUrl);
    await firebaseStorageRef.delete();
  }

  undo(User tinderUser) async {
    await firestore
        .collection(SWIPES)
        .where('user1', isEqualTo: MyAppState.currentUser!.userID)
        .where('user2', isEqualTo: tinderUser.userID)
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        await firestore.collection(SWIPES).doc(value.docs.first.id).delete();
      }
    });
  }

  Future<bool> incrementSwipe() async {
    DocumentReference<Map<String, dynamic>> documentReference =
        firestore.collection(SWIPE_COUNT).doc(MyAppState.currentUser!.userID);
    DocumentSnapshot<Map<String, dynamic>> validationDocumentSnapshot =
        await documentReference.get();
    if (validationDocumentSnapshot.exists) {
      if ((validationDocumentSnapshot['count'] ?? 1) < 10) {
        await firestore
            .doc(documentReference.path)
            .update({'count': validationDocumentSnapshot['count'] + 1});
        return true;
      } else {
        return _shouldResetCounter(validationDocumentSnapshot);
      }
    } else {
      await firestore.doc(documentReference.path).set(SwipeCounter(
              authorID: MyAppState.currentUser!.userID,
              createdAt: Timestamp.now(),
              count: 1)
          .toJson());
      return true;
    }
  }

  Future<Url> uploadAudioFile(File file, BuildContext context) async {
    showProgress(context, 'Uploading Audio...'.tr(), false);
    var uniqueID = Uuid().v4();
    Reference upload = storage.child('audio/$uniqueID.mp3');
    SettableMetadata metadata = SettableMetadata(contentType: 'audio');
    UploadTask uploadTask = upload.putFile(file, metadata);
    uploadTask.snapshotEvents.listen((event) {
      updateProgress(
          'Uploading Audio ${(event.bytesTransferred.toDouble() / 1000).toStringAsFixed(2)} /'
                  '${(event.totalBytes.toDouble() / 1000).toStringAsFixed(2)} '
                  'KB'
              .tr());
    });
    uploadTask.whenComplete(() {}).catchError((onError) {
      print((onError as PlatformException).message);
    });
    var storageRef = (await uploadTask.whenComplete(() {})).ref;
    var downloadUrl = await storageRef.getDownloadURL();
    var metaData = await storageRef.getMetadata();
    hideProgress();
    return Url(
        mime: metaData.contentType ?? 'audio', url: downloadUrl.toString());
  }

  Future<bool> _shouldResetCounter(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) async {
    SwipeCounter counter = SwipeCounter.fromJson(documentSnapshot.data() ?? {});
    DateTime now = DateTime.now();
    DateTime from = DateTime.fromMillisecondsSinceEpoch(
        counter.createdAt.millisecondsSinceEpoch);
    Duration diff = now.difference(from);
    if (diff.inDays > 0) {
      counter.count = 1;
      counter.createdAt = Timestamp.now();
      await firestore
          .collection(SWIPE_COUNT)
          .doc(counter.authorID)
          .update(counter.toJson());
      return true;
    } else {
      return false;
    }
  }

  /// compress video file to make it load faster but with lower quality,
  /// change the quality parameter to control the quality of the video after
  /// being compressed
  /// @param file the video file that will be compressed
  /// @return File a new compressed file with smaller size
  Future<File> _compressVideo(File file) async {
    MediaInfo? info = await VideoCompress.compressVideo(file.path,
        quality: VideoQuality.DefaultQuality,
        deleteOrigin: false,
        includeAudio: true,
        frameRate: 24);
    if (info != null) {
      File compressedVideo = File(info.path!);
      return compressedVideo;
    } else {
      return file;
    }
  }

  static loginWithFacebook() async {
    /// creates a user for this facebook login when this user first time login
    /// and save the new user object to firebase and firebase auth
    FacebookAuth facebookAuth = FacebookAuth.instance;
    bool isLogged = await facebookAuth.accessToken != null;
    if (!isLogged) {
      LoginResult result = await facebookAuth
          .login(); // by default we request the email and the public profile
      if (result.status == LoginStatus.success) {
        // you are logged
        AccessToken? token = await facebookAuth.accessToken;
        return await handleFacebookLogin(
            await facebookAuth.getUserData(), token!);
      }
    } else {
      AccessToken? token = await facebookAuth.accessToken;
      return await handleFacebookLogin(
          await facebookAuth.getUserData(), token!);
    }
  }

  static handleFacebookLogin(
      Map<String, dynamic> userData, AccessToken token) async {
    auth.UserCredential authResult = await auth.FirebaseAuth.instance
        .signInWithCredential(
            auth.FacebookAuthProvider.credential(token.token));
    User? user = await getCurrentUser(authResult.user?.uid ?? '');
    List<String> fullName = (userData['name'] as String).split(' ');
    String firstName = '';
    String lastName = '';
    if (fullName.isNotEmpty) {
      firstName = fullName.first;
      lastName = fullName.skip(1).join(' ');
    }
    if (user != null) {
      user.profilePictureURL = userData['picture']['data']['url'];
      user.firstName = firstName;
      user.lastName = lastName;
      user.email = userData['email'];
      user.active = true;
      user.fcmToken = await firebaseMessaging.getToken() ?? '';
      dynamic result = await updateCurrentUser(user);
      return result;
    } else {
      user = User(
          email: userData['email'] ?? '',
          firstName: firstName,
          profilePictureURL: userData['picture']['data']['url'] ?? '',
          userID: authResult.user?.uid ?? '',
          lastOnlineTimestamp: DateTime.now().toUtc().millisecondsSinceEpoch,
          lastName: lastName,
          active: true,
          // fcmToken: await firebaseMessaging.getToken() ?? '',
          phoneNumber: '',
          photos: [],
          settings: UserSettings());
      String? errorMessage = await firebaseCreateNewUser(user);
      if (errorMessage == null) {
        return user;
      } else {
        return errorMessage;
      }
    }
  }

  static loginWithApple() async {
    final appleCredential = await apple.TheAppleSignIn.performRequests([
      apple.AppleIdRequest(
          requestedScopes: [apple.Scope.email, apple.Scope.fullName])
    ]);
    if (appleCredential.error != null) {
      return 'Couldn\'t login with apple.';
    }

    if (appleCredential.status == apple.AuthorizationStatus.authorized) {
      final auth.AuthCredential credential =
          auth.OAuthProvider('apple.com').credential(
        accessToken: String.fromCharCodes(
            appleCredential.credential?.authorizationCode ?? []),
        idToken: String.fromCharCodes(
            appleCredential.credential?.identityToken ?? []),
      );
      return await handleAppleLogin(credential, appleCredential.credential!);
    } else {
      return 'Couldn\'t login with apple.';
    }
  }

  static handleAppleLogin(
    auth.AuthCredential credential,
    apple.AppleIdCredential appleIdCredential,
  ) async {
    auth.UserCredential authResult =
        await auth.FirebaseAuth.instance.signInWithCredential(credential);
    User? user = await getCurrentUser(authResult.user?.uid ?? '');
    if (user != null) {
      user.active = true;
      user.fcmToken = await firebaseMessaging.getToken() ?? '';
      dynamic result = await updateCurrentUser(user);
      return result;
    } else {
      user = User(
          email: appleIdCredential.email ?? '',
          firstName: appleIdCredential.fullName?.givenName ?? 'Deleted',
          profilePictureURL: '',
          userID: authResult.user?.uid ?? '',
          lastOnlineTimestamp: DateTime.now().toUtc().millisecondsSinceEpoch,
          lastName: appleIdCredential.fullName?.familyName ?? 'User',
          active: true,
          // fcmToken: await firebaseMessaging.getToken() ?? '',
          phoneNumber: '',
          photos: [],
          settings: UserSettings());
      String? errorMessage = await firebaseCreateNewUser(user);
      if (errorMessage == null) {
        return user;
      } else {
        return errorMessage;
      }
    }
  }

  /// save a new user document in the USERS table in firebase firestore
  /// returns an error message on failure or null on success
  static Future<String?> firebaseCreateNewUser(User user) async {
    try {
      await firestore.collection(USERS).doc(user.userID).set(user.toJson(null));
    } catch (e, s) {
      print('FireStoreUtils.firebaseCreateNewUser $e $s');
      return 'Couldn\'t sign up'.tr();
    }
    return null;
  }

  /// login with email and password with firebase
  /// @param email user email
  /// @param password user password
  static Future<dynamic> loginWithEmailAndPassword(
      String email, String password, Position currentLocation) async {
    try {
      auth.UserCredential result = await auth.FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await firestore.collection(USERS).doc(result.user?.uid ?? '').get();
      User? user;
      if (documentSnapshot.exists) {
        user = User.fromJson(documentSnapshot.data() ?? {});
        user.location = UserLocation(
            latitude: currentLocation.latitude,
            longitude: currentLocation.longitude);
        user.fcmToken = await firebaseMessaging.getToken() ?? '';
        await updateCurrentUser(user);
      }
      return user;
    } on auth.FirebaseAuthException catch (exception, s) {
      print(exception.toString() + '$s');
      switch ((exception).code) {
        case 'invalid-email':
          return 'Email address is malformed.'.tr();
        case 'wrong-password':
          return 'Wrong password.'.tr();
        case 'user-not-found':
          return 'No user corresponding to the given email address.'.tr();
        case 'user-disabled':
          return 'This user has been disabled.'.tr();
        case 'too-many-requests':
          return 'Too many attempts to sign in as this user.'.tr();
      }
      return 'Unexpected firebase error, Please try again.'.tr();
    } catch (e, s) {
      print(e.toString() + '$s');
      return 'Login failed, Please try again.'.tr();
    }
  }

  ///submit a phone number to firebase to receive a code verification, will
  ///be used later to login
  static firebaseSubmitPhoneNumber(
    String phoneNumber,
    auth.PhoneCodeAutoRetrievalTimeout? phoneCodeAutoRetrievalTimeout,
    auth.PhoneCodeSent? phoneCodeSent,
    auth.PhoneVerificationFailed? phoneVerificationFailed,
    auth.PhoneVerificationCompleted? phoneVerificationCompleted,
  ) {
    auth.FirebaseAuth.instance.verifyPhoneNumber(
      timeout: Duration(minutes: 2),
      phoneNumber: phoneNumber,
      verificationCompleted: phoneVerificationCompleted!,
      verificationFailed: phoneVerificationFailed!,
      codeSent: phoneCodeSent!,
      codeAutoRetrievalTimeout: phoneCodeAutoRetrievalTimeout!,
    );
  }

  /// submit the received code to firebase to complete the phone number
  /// verification process
  static Future<dynamic> firebaseSubmitPhoneNumberCode(String verificationID,
      String code, String phoneNumber, Position signUpLocation,
      {String firstName = 'Anonymous',
      String lastName = 'User',
      File? image}) async {
    auth.AuthCredential authCredential = auth.PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: code);
    auth.UserCredential userCredential =
        await auth.FirebaseAuth.instance.signInWithCredential(authCredential);
    User? user = await getCurrentUser(userCredential.user?.uid ?? '');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (user != null) {
      return user;
    } else {
      /// create a new user from phone login
      String profileImageUrl = '';
      if (image != null) {
        profileImageUrl = await uploadUserImageToFireStorage(
            image, userCredential.user?.uid ?? '');
      }
      User user = User(
        firstName: firstName,
        lastName: lastName,
        // fcmToken: await firebaseMessaging.getToken() ?? '',
        phoneNumber: phoneNumber,
        profilePictureURL: profileImageUrl,
        userID: userCredential.user?.uid ?? '',
        active: true,
        age: '',
        bio: '',
        isVip: false,
        lastOnlineTimestamp: DateTime.now().toUtc().millisecondsSinceEpoch,
        photos: [],
        school: prefs.getString("college").toString(),
        settings: UserSettings(),
        showMe: true,
        location: UserLocation(
            latitude: signUpLocation.latitude,
            longitude: signUpLocation.longitude),
        signUpLocation: UserLocation(
            latitude: signUpLocation.latitude,
            longitude: signUpLocation.longitude),
        email: '',
      );
      String? errorMessage = await firebaseCreateNewUser(user);
      if (errorMessage == null) {
        return user;
      } else {
        return 'Couldn\'t create new user with phone number.'.tr();
      }
    }
  }

  /// this method is used to upload the user image to firestore
  /// @param image file to be uploaded to firestore
  /// @param userID the userID used as part of the image name on firestore
  /// @return the full download url used to view the image
  static Future<String> uploadUserImageToFireStorage(
      File image, String userID) async {
    Reference storageReference = FirebaseStorage.instance
        .ref('Profileimage')
        .child(image.path.toString());
    await storageReference.putFile(File(image.path));

    String downloadUrl = await storageReference.getDownloadURL();
    return downloadUrl.toString();
  }

  /// compress image file to make it load faster but with lower quality,
  /// change the quality parameter to control the quality of the image after
  /// being compressed(100 = max quality - 0 = low quality)
  /// @param file the image file that will be compressed
  /// @return File a new compressed file with smaller size
  static Future<File> compressImage(File file) async {
    File compressedImage = await FlutterNativeImage.compressImage(
      file.path,
      quality: 25,
    );
    return compressedImage;
  }

  static firebaseSignUpWithEmailAndPassword(
    String emailAddress,
    String password,
    File? imageOne,
    File? imageTwo,
    File? imageThree,
    File? imageFour,
    File? imageFive,
    File? imageSix,
    String firstName,
    String lastName,
    Position locationData,
    String mobile,
    String preferPronoun,
    String q1,
    String q2,
    String q3,
    String q4,
    String q5,
    String q6,
    String q1_Deal_Breaker,
    String q2_Deal_Breaker,
    String q3_Deal_Breaker,
    String q4_Deal_Breaker,
    String q5_Deal_Breaker,
    String q6_Deal_Breaker,
    String birthdate,
    String prefrance_age_start,
    String prefrance_age_end,
    String yourGender,
    String genderWntToDate,
    String yourSexuality,
    String sexualityWantToDate,
    String your_Ethnicity,
    String ethnicityWantToDate,
    String userCount,
    List prompt,
    // String you_Drink,
    // String drinkWantToDate,
    // String your_Smoke,
    // String smokeWantToDate,
    // String haveChildren,
    // String ChildrenWantToDate,
  ) async {
    try {
      print(credential.user?.uid);
      // auth.UserCredential result =
      //     await auth.FirebaseAuth.instance.signInWithCredential(credential!);
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String profilePicUrl = '';
      List images = [];
      await updateProgress('Uploading images. Please wait...');
      if (imageOne != null) {
        String imageUrl = await uploadUserImageToFireStorage(
            imageOne, credential.user?.uid ?? '');
        profilePicUrl = imageUrl;
        images.add(imageUrl);
      }
      if (imageTwo != null) {
        String imageUrl = await uploadUserImageToFireStorage(
            imageTwo, credential.user?.uid ?? '');
        images.add(imageUrl);
      }
      if (imageThree != null) {
        String imageUrl = await uploadUserImageToFireStorage(
            imageThree, credential.user?.uid ?? '');
        images.add(imageUrl);
      }

      if (imageFour != null && imageFour.path != '') {
        String imageUrl = await uploadUserImageToFireStorage(
            imageFour, credential.user?.uid ?? '');
        images.add(imageUrl);
      }
      if (imageFive != null && imageFive.path != '') {
        String imageUrl = await uploadUserImageToFireStorage(
            imageFive, credential.user?.uid ?? '');
        images.add(imageUrl);
      }
      if (imageSix != null && imageSix.path != '') {
        String imageUrl = await uploadUserImageToFireStorage(
            imageSix, credential.user?.uid ?? '');
        images.add(imageUrl);
      }

      User user = User(
        email: emailAddress,
        signUpLocation: UserLocation(
            latitude: locationData.latitude, longitude: locationData.longitude),
        location: UserLocation(
            latitude: locationData.latitude, longitude: locationData.longitude),
        showMe: true,
        settings: UserSettings(),
        school: prefs.getString('college') ?? '',
        photos: images,
        lastOnlineTimestamp: DateTime.now().toUtc().millisecondsSinceEpoch,
        isVip: false,
        bio: '',
        age: '',
        active: true,
        phoneNumber: mobile,
        firstName: firstName,
        userID: credential.user?.uid ?? '',
        lastName: lastName,
        userCount: userCount,
        // fcmToken: await firebaseMessaging.getToken() ?? '',
        profilePictureURL: profilePicUrl,
        preferPronoun: preferPronoun,
        where_do_you_stand: Where_do_you_stand(
            woman_Right_to_Choose: q1,
            better_Climate_Legislation: q2,
            expanded_LGBTQ_Rights: q3,
            stronger_Gun_Controls: q4,
            softer_Immigration_Laws: q5,
            more_Religious_Freedoms: q6,
            woman_Right_to_Choose_Deal_Breaker: q1_Deal_Breaker,
            better_Climate_Legislation_Deal_Breaker: q2_Deal_Breaker,
            expanded_LGBTQ_Rights_Deal_Breaker: q3_Deal_Breaker,
            stronger_Gun_Controls_Deal_Breaker: q4_Deal_Breaker,
            softer_Immigration_Laws_Deal_Breaker: q5_Deal_Breaker,
            more_Religious_Freedoms_Deal_Breaker: q6_Deal_Breaker),
        birthdate: birthdate,
        prompt: prompt,
        prefreance_age_start: prefrance_age_start,
        prefreance_age_end: prefrance_age_end,
        your_gender: yourGender,
        genderWantToDate: genderWntToDate,
        your_Sexuality: yourSexuality,
        sexualityrWantToDate: sexualityWantToDate,
        your_Ethnicity: your_Ethnicity,
        ethnicityWantToDate: ethnicityWantToDate,
        // you_Drink: you_Drink,
        // drinkWantToDate: drinkWantToDate,
        // you_Smoke: your_Smoke,
        // smokeWantToDate: smokeWantToDate,
        // have_Children: haveChildren,
        // childrenWantToDate: ChildrenWantToDate,
        answeredQuestion: answeredQuestionList,
        your_details: YourDetails(
          univerties: prefs.getString('college') ?? '',
          religiose_belief: prefs.getString('religion') ?? '',
          home_town: prefs.getString('hometown') ?? '',
        ),
      );
      String? errorMessage = await firebaseCreateNewUser(user);
      if (errorMessage == null) {
        return user;
      } else {
        return 'Couldn\'t sign up for firebase, Please try again.'.tr();
      }
    } on auth.FirebaseAuthException catch (error) {
      print(error.toString() + '${error.stackTrace}');
      String message = 'Couldn\'t sign up'.tr();
      switch (error.code) {
        case 'email-already-in-use':
          message = 'Email already in use, Please pick another email!'.tr();
          break;
        case 'invalid-email':
          message = 'Enter valid e-mail'.tr();
          break;
        case 'operation-not-allowed':
          message = 'Email/password accounts are not enabled'.tr();
          break;
        case 'weak-password':
          message = 'Password must be more than 5 characters'.tr();
          break;
        case 'too-many-requests':
          message = 'Too many requests, Please try again later.'.tr();
          break;
      }
      return message;
    } catch (e) {
      return 'Couldn\'t sign up'.tr();
    }
  }

  static Future<auth.UserCredential?> reAuthUser(AuthProviders provider,
      {String? email,
      String? password,
      String? smsCode,
      String? verificationId,
      AccessToken? accessToken,
      apple.AuthorizationResult? appleCredential}) async {
    late auth.AuthCredential credential;
    switch (provider) {
      case AuthProviders.PASSWORD:
        credential = auth.EmailAuthProvider.credential(
            email: email!, password: password!);
        break;
      case AuthProviders.PHONE:
        credential = auth.PhoneAuthProvider.credential(
            smsCode: smsCode!, verificationId: verificationId!);
        break;
      case AuthProviders.FACEBOOK:
        credential = auth.FacebookAuthProvider.credential(accessToken!.token);
        break;
      case AuthProviders.APPLE:
        credential = auth.OAuthProvider('apple.com').credential(
          accessToken: String.fromCharCodes(
              appleCredential!.credential?.authorizationCode ?? []),
          idToken: String.fromCharCodes(
              appleCredential.credential?.identityToken ?? []),
        );
        break;
    }
    return await auth.FirebaseAuth.instance.currentUser!
        .reauthenticateWithCredential(credential);
  }

  static resetPassword(String emailAddress) async =>
      await auth.FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailAddress);

  static deleteUser() async {
    try {
      // delete user records from subscriptions table
      await firestore
          .collection(SUBSCRIPTIONS)
          .doc(MyAppState.currentUser!.userID)
          .delete();

      // delete user records from swipe_counts table
      await firestore
          .collection(SWIPE_COUNT)
          .doc(MyAppState.currentUser!.userID)
          .delete();

      // delete user records from swipes table
      await firestore
          .collection(SWIPES)
          .where('user1', isEqualTo: MyAppState.currentUser!.userID)
          .get()
          .then((value) async {
        for (var doc in value.docs) {
          await firestore.doc(doc.reference.path).delete();
        }
      });
      await firestore
          .collection(SWIPES)
          .where('user2', isEqualTo: MyAppState.currentUser!.userID)
          .get()
          .then((value) async {
        for (var doc in value.docs) {
          await firestore.doc(doc.reference.path).delete();
        }
      });

      // delete user records from CHANNEL_PARTICIPATION table
      await firestore
          .collection(CHANNEL_PARTICIPATION)
          .where('user', isEqualTo: MyAppState.currentUser!.userID)
          .get()
          .then((value) async {
        for (var doc in value.docs) {
          await firestore.doc(doc.reference.path).delete();
        }
      });

      // delete user records from REPORTS table
      await firestore
          .collection(REPORTS)
          .where('source', isEqualTo: MyAppState.currentUser!.userID)
          .get()
          .then((value) async {
        for (var doc in value.docs) {
          await firestore.doc(doc.reference.path).delete();
        }
      });

      // delete user records from REPORTS table
      await firestore
          .collection(REPORTS)
          .where('dest', isEqualTo: MyAppState.currentUser!.userID)
          .get()
          .then((value) async {
        for (var doc in value.docs) {
          await firestore.doc(doc.reference.path).delete();
        }
      });

      // delete user records from users table
      await firestore
          .collection(USERS)
          .doc(auth.FirebaseAuth.instance.currentUser!.uid)
          .delete();

      // delete user  from firebase auth
      await auth.FirebaseAuth.instance.currentUser!.delete();
    } catch (e, s) {
      print('FireStoreUtils.deleteUser $e $s');
    }
  }

  static recordPurchase(PurchaseDetails purchase) async {
    try {
      PurchaseModel purchaseModel = PurchaseModel(
        active: true,
        productId: purchase.productID,
        receipt: purchase.purchaseID ?? '',
        serverVerificationData:
            purchase.verificationData.serverVerificationData,
        source: purchase.verificationData.source,
        subscriptionPeriod:
            purchase.purchaseID == MONTHLY_SUBSCRIPTION ? 'monthly' : 'yearly',
        transactionDate: int.parse(purchase.transactionDate!),
        userID: MyAppState.currentUser!.userID,
      );
      await firestore
          .collection(SUBSCRIPTIONS)
          .doc(MyAppState.currentUser!.userID)
          .set(purchaseModel.toJson());
      MyAppState.currentUser!.isVip = true;
      await updateCurrentUser(MyAppState.currentUser!);
    } catch (e) {
      print(e.toString());
      await hideProgress();
    }
  }

  static recordUltraLikePurchase(PurchaseDetails purchase, String count) async {
    try {
      PurchaseModel purchaseModel = PurchaseModel(
          active: true,
          productId: purchase.productID,
          receipt: purchase.purchaseID ?? '',
          serverVerificationData:
              purchase.verificationData.serverVerificationData,
          source: purchase.verificationData.source,
          subscriptionPeriod: purchase.purchaseID == MONTHLY_SUBSCRIPTION
              ? 'monthly'
              : 'yearly',
          transactionDate: int.parse(purchase.transactionDate!),
          userID: MyAppState.currentUser!.userID,
          ultralikeCount: count);
      await firestore
          .collection(ULTRALIKE)
          .doc(MyAppState.currentUser!.userID)
          .set(purchaseModel.toJson());

      DocumentSnapshot<Map<String, dynamic>> userPurchase = await firestore
          .collection(ULTRALIKECOUNT)
          .doc(MyAppState.currentUser!.userID)
          .get();
      if (userPurchase.exists) {
        Map<String, dynamic> payload = <String, dynamic>{
          'userid': MyAppState.currentUser!.userID,
          'count': count,
        };
        await firestore
            .collection(ULTRALIKECOUNT)
            .doc(MyAppState.currentUser!.userID)
            .set(payload);
      } else {
        Map<String, dynamic> payload = <String, dynamic>{
          'userid': MyAppState.currentUser!.userID,
          'count': count,
        };
        await firestore
            .collection(ULTRALIKECOUNT)
            .doc(MyAppState.currentUser!.userID)
            .set(payload);
      }
    } catch (e) {
      print("Exceptonnnnn:" + e.toString());
      await hideProgress();
    }
  }

  static Future<String> getBoostLikeCount() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userPurchase = await firestore
          .collection(BOOSTCOUNT)
          .doc(MyAppState.currentUser!.userID)
          .get();
      return userPurchase.get("count") != null
          ? userPurchase.get("count")
          : '0';
    } catch (e) {
      return '0';
    }
  }

  static Future<String> getusedBoostLikeCount() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userPurchaseused = await firestore
          .collection(BOOSTCOUNT)
          .doc(MyAppState.currentUser!.userID)
          .get();
      return userPurchaseused.get("used_count") != null
          ? userPurchaseused.get("used_count")
          : '0';
    } catch (e) {
      return '0';
    }
  }

  Future<void> boostCountUpdate({
    required String count,
    // required String getNewUsedCount,
  }) async {
    await FirebaseFirestore.instance
        .collection(BOOSTCOUNT)
        .doc(MyAppState.currentUser!.userID)
        .update({
      "count": count,
      // 'used_count': getNewUsedCount,
    });
    await FirebaseFirestore.instance
        .collection(BOOST)
        .doc(MyAppState.currentUser!.userID)
        .update({
      "count": count,
      // 'used_count': getNewUsedCount,
    });
    await FirebaseFirestore.instance
        .collection(USERS)
        .doc(MyAppState.currentUser!.userID)
        .update({
      'isUserBoost': 1,
      'profileBoostAt': DateTime.now(),
    });
  }

  static Future<String> getUltraLikeCount() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userPurchase = await firestore
          .collection(ULTRALIKECOUNT)
          .doc(MyAppState.currentUser!.userID)
          .get();

      return userPurchase.get("count") != null
          ? userPurchase.get("count")
          : "0";
    } catch (e) {
      return '0';
    }
  }

  static recordBoostPurchase(PurchaseDetails purchase, String count) async {
    try {
      PurchaseModel purchaseModel = PurchaseModel(
          active: true,
          productId: purchase.productID,
          receipt: purchase.purchaseID ?? '',
          serverVerificationData:
              purchase.verificationData.serverVerificationData,
          source: purchase.verificationData.source,
          subscriptionPeriod: purchase.purchaseID == MONTHLY_SUBSCRIPTION
              ? 'monthly'
              : 'yearly',
          transactionDate: int.parse(purchase.transactionDate!),
          userID: MyAppState.currentUser!.userID,
          ultralikeCount: count);
      await firestore
          .collection(BOOST)
          .doc(MyAppState.currentUser!.userID)
          .set(purchaseModel.toJson());

      DocumentSnapshot<Map<String, dynamic>> userPurchase = await firestore
          .collection(BOOSTCOUNT)
          .doc(MyAppState.currentUser!.userID)
          .get();
      if (userPurchase.exists) {
        Map<String, dynamic> payload = <String, dynamic>{
          'userid': MyAppState.currentUser!.userID,
          'count': count,
        };
        await firestore
            .collection(BOOSTCOUNT)
            .doc(MyAppState.currentUser!.userID)
            .set(payload);
      } else {
        Map<String, dynamic> payload = <String, dynamic>{
          'userid': MyAppState.currentUser!.userID,
          'count': count,
        };
        await firestore
            .collection(BOOSTCOUNT)
            .doc(MyAppState.currentUser!.userID)
            .set(payload);
      }
    } catch (e) {
      print("Exceptonnnnn:" + e.toString());
      await hideProgress();
    }
  }

  static subscribePurchase(PurchaseModel purchase) async {
    PurchaseModel purchaseModel = PurchaseModel(
        active: true,
        productId: purchase.productId,
        receipt: purchase.productId,
        serverVerificationData: purchase.serverVerificationData,
        source: purchase.source,
        subscriptionPeriod:
            purchase.productId == MONTHLY_SUBSCRIPTION ? 'monthly' : 'yearly',
        transactionDate: DateTime.now().millisecondsSinceEpoch,
        userID: MyAppState.currentUser!.userID,
        userID2: purchase.userID2);
    await firestore.collection(SUBSCRIPTIONS).doc().set(purchaseModel.toJson());
    MyAppState.currentUser!.isVip = true;
    await updateCurrentUser(MyAppState.currentUser!);
  }

  static isSubscriptionActive() async {
    DocumentSnapshot<Map<String, dynamic>> userPurchase = await firestore
        .collection(SUBSCRIPTIONS)
        .doc(MyAppState.currentUser!.userID)
        .get();
    if (userPurchase.exists) {
      try {
        PurchaseModel purchaseModel =
            PurchaseModel.fromJson(userPurchase.data() ?? {});
        DateTime purchaseDate =
            DateTime.fromMillisecondsSinceEpoch(purchaseModel.transactionDate);
        DateTime endOfSubscription = DateTime.now();
        if (purchaseModel.productId == MONTHLY_SUBSCRIPTION) {
          endOfSubscription = purchaseDate.add(Duration(days: 30));
        } else if (purchaseModel.productId == YEARLY_SUBSCRIPTION) {
          endOfSubscription = purchaseDate.add(Duration(days: 365));
        }
        if (DateTime.now().isBefore(endOfSubscription)) {
          return true;
        } else {
          MyAppState.currentUser!.isVip = false;
          await updateCurrentUser(MyAppState.currentUser!);
          await firestore
              .collection(SUBSCRIPTIONS)
              .doc(MyAppState.currentUser!.userID)
              .set({'active': false});
          return false;
        }
      } catch (e, s) {
        print('FireStoreUtils.isSubscriptionActive parse error $e $s');
        return false;
      }
    } else {
      return;
    }
  }

  static Future<List<Map<String, dynamic>>> getUniversities() async {
    QuerySnapshot<Map<String, dynamic>> universitiesData =
        await firestore.collection(UNIVERSITIES).get();
    List<Map<String, dynamic>> universities = [];
    universitiesData.docs.forEach((element) {
      universities.add(element.data());
    });
    universities.sort((a, b) {
      return a['university_name']
          .toLowerCase()
          .compareTo(b['university_name'].toLowerCase());
    });
    return universities;
  }

  static Future<List<Map<String, dynamic>>> getUSState() async {
    QuerySnapshot<Map<String, dynamic>> usStateData =
        await firestore.collection(US_STATE).get();
    List<Map<String, dynamic>> usState = [];
    usStateData.docs.forEach((element) {
      Map<String, dynamic> data = element.data();
      data.remove('country');
      usState.add(data);
    });
    usState.sort((a, b) {
      return a['city'].toLowerCase().compareTo(b['city'].toLowerCase());
    });
    return usState;
  }

  Future<bool> removeChat(String id) async {
    bool isSuccessful = false;
    QuerySnapshot<Map<String, dynamic>> userPurchase = await firestore
        .collection(CHANNEL_PARTICIPATION)
        .where('channel', isEqualTo: id)
        .where("user", isEqualTo: MyAppState.currentUser!.userID)
        .get();
    if (userPurchase.docs.isNotEmpty) {
      userPurchase.docs.forEach((element) async {
        await firestore
            .collection(CHANNEL_PARTICIPATION)
            .doc(element.id)
            .delete()
            .then((onValue) {
          isSuccessful = true;
        }, onError: (e) {
          print('${e.toString()}');
          isSuccessful = false;
        });
      });
    }
    /*await firestore.collection(CHANNELS).doc(id).delete().then((onValue) {
      isSuccessful = true;
    }, onError: (e) {
      print('${e.toString()}');
      isSuccessful = false;
    });*/
    return isSuccessful;
  }
}

sendNotification(String token, String title, String body,
    Map<String, dynamic>? payload) async {
  await http.post(
    Uri.parse('https://fcm.googleapis.com/fcm/send'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=$SERVER_KEY',
    },
    body: jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{'body': body, 'title': title},
        'priority': 'high',
        'data': payload ?? <String, dynamic>{},
        'to': token
      },
    ),
  );
}
