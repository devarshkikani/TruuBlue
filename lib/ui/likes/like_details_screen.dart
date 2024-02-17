import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/common/colors.dart';
import 'package:dating/constants.dart';
import 'package:dating/main.dart';
import 'package:dating/model/ConversationModel.dart';
import 'package:dating/model/MessageData.dart';
import 'package:dating/model/Swipe.dart';
import 'package:dating/model/User.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/theme/textstyle.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class LikeDetailsScreen extends StatefulWidget {
  User friend;
  Function(bool isLike) cancel;
  LikeDetailsScreen({
    Key? key,
    required this.friend,
    required this.cancel,
  }) : super(key: key);

  @override
  State<LikeDetailsScreen> createState() => Like_ImageDetailsScreenState();
}

class Like_ImageDetailsScreenState extends State<LikeDetailsScreen> {
  TextEditingController textEditingController = TextEditingController();
  FocusNode addCommentFocudNode = FocusNode();
  bool isFromUltraLike = false;
  FireStoreUtils _fireStoreUtils = FireStoreUtils();
  ConversationModel? conversationModel;
  String likeItem = '';

  @override
  void initState() {
    whatLiked();
    super.initState();
  }

  void whatLiked() async {
    await FirebaseFirestore.instance
        .collection(SWIPES)
        .where('user2', isEqualTo: MyAppState.currentUser?.userID)
        .where('user1', isEqualTo: widget.friend.userID)
        .get()
        .then((querySnapShot) {
      querySnapShot.docs.forEach((doc) {
        Swipe match = Swipe.fromJson(doc.data());
        if (match.id.isEmpty) {
          match.id = doc.id;
        }
        setState(() {
          likeItem = match.whatLiked;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white30,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: AnimationLimiter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimationConfiguration.staggeredList(
                    position: 1,
                    duration: const Duration(milliseconds: 400),
                    child: SlideAnimation(
                      verticalOffset: -44.0,
                      child: FadeInAnimation(
                        child: Text(
                          widget.friend.firstName,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  AnimationConfiguration.staggeredList(
                    position: 2,
                    duration: const Duration(milliseconds: 400),
                    child: widget.friend.profilePictureURL != ''
                        ? SlideAnimation(
                            verticalOffset: -44.0,
                            child: FadeInAnimation(
                              child: Stack(
                                children: [
                                  _imageView(widget.friend.profilePictureURL),
                                  if (likeItem != '')
                                    Positioned(
                                      bottom: 0,
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        margin: EdgeInsets.only(
                                          bottom: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white70,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                          ),
                                        ),
                                        child: Text('Liked your $likeItem'),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          )
                        : SizedBox(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  AnimationConfiguration.staggeredList(
                    position: 3,
                    duration: const Duration(milliseconds: 400),
                    child: SlideAnimation(
                      verticalOffset: -44.0,
                      child: FadeInAnimation(
                        child: _textFormField(context),
                      ),
                    ),
                  ),
                  AnimationConfiguration.staggeredList(
                    position: 4,
                    duration: const Duration(milliseconds: 400),
                    child: SlideAnimation(
                      verticalOffset: -44.0,
                      child: FadeInAnimation(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: GestureDetector(
                            onTap: () async {
                              await matchOrMessage();
                            },
                            child: Container(
                              padding: EdgeInsets.all(15),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color(0xFF70573ac),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: widget.friend.otherLike
                                  ? Text(
                                      'Send a Message',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      'Match with ${widget.friend.firstName}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        widget.cancel(widget.friend.otherLike);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> sendWithoutLike() async {
    Navigator.pop(context);
    await showProgress(context, 'Sending like..', false);
    await _fireStoreUtils.onSwipeRight(widget.friend, 'photo');
    await _fireStoreUtils.otherLikeYouLike(
        MyAppState.currentUser!.userID, widget.friend.userID, 'Like');
    if (textEditingController.text != '') {
      _sendMessage(textEditingController.text, Url(mime: '', url: ''), '',
          widget.friend);
    }
    SharedPreferences pref = await SharedPreferences.getInstance();
    int likeCount = pref.getInt('oldNewLikesCount') ?? 0;
    if (likeCount != 0) {
      pref.setInt('oldNewLikesCount', likeCount - 1);
    }
    hideProgress();
  }

  Future<void> matchOrMessage() async {
    if (!widget.friend.otherLike && textEditingController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Adding a comment doubles your chance of a match!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  addCommentFocudNode.requestFocus();
                },
                child: Container(
                  padding: EdgeInsets.all(15),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xFF68ce09),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Text(
                    'Add a Comment',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () async {
                  await sendWithoutLike();
                },
                child: Container(
                  padding: EdgeInsets.all(15),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xFF70573ac),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Text(
                    'Send without Comment',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      if (widget.friend.otherLike) {
        if (textEditingController.text != '') {
          await showProgress(context, 'Sending message...', false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            new SnackBar(
              content: new Text('please write a messgae first'),
            ),
          );
        }
      } else {
        await showProgress(context, 'Sending like...', false);
        await _fireStoreUtils.onSwipeRight(widget.friend, 'photo');
        SharedPreferences pref = await SharedPreferences.getInstance();
        int likeCount = pref.getInt('oldNewLikesCount') ?? 0;
        if (likeCount != 0) {
          pref.setInt('oldNewLikesCount', likeCount - 1);
        }
      }
      if (textEditingController.text != '') {
        _sendMessage(textEditingController.text, Url(mime: '', url: ''), '',
            widget.friend);
      }
      widget.cancel(true);
      hideProgress();
    }
  }

  Widget _imageView(String url) {
    return Container(
      height: 280,
      margin: EdgeInsets.symmetric(vertical: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CachedNetworkImage(
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          imageUrl: url == ' ' ? DEFAULT_AVATAR_URL : url,
          placeholder: (context, imageUrl) {
            return Icon(
              Icons.account_circle,
              size: MediaQuery.of(context).size.height * .3,
              color: isDarkMode(context) ? Colors.black : Colors.white,
            );
          },
          errorWidget: (context, imageUrl, error) {
            return Icon(
              Icons.account_circle,
              size: MediaQuery.of(context).size.height * .3,
              color: isDarkMode(context) ? Colors.black : Colors.white,
            );
          },
        ),
      ),
    );
  }

  Widget _textFormField(context) {
    return TextFormField(
      maxLength: 150,
      controller: textEditingController,
      focusNode: addCommentFocudNode,
      onFieldSubmitted: (String? value) {},
      decoration: InputDecoration(
        hintText: 'Write a message',
        counterText: "",
        hintStyle: regualrText14.copyWith(
          color: greyColor,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        fillColor: Colors.white,
        isDense: true,
        filled: true,
      ),
    );
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
      showAlertDialog(context, 'An Error Occurred'.tr(),
          'Couldn\'t send Message, please try again later'.tr());
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
}
