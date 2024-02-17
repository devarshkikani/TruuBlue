import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/CustomFlutterTinderCard.dart';
import 'package:dating/constants.dart';
import 'package:dating/main.dart';
import 'package:dating/model/ConversationModel.dart';
import 'package:dating/model/MessageData.dart';
import 'package:dating/model/Swipe.dart';
import 'package:dating/model/User.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/ui/fullScreenImageViewer/FullScreenImageViewer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class UserDetailsScreen extends StatefulWidget {
  final User user;
  final bool isMatch;
  final bool isMenuVisible;
  final bool? likedYou;
  const UserDetailsScreen(
      {Key? key,
      required this.user,
      required this.isMatch,
      required this.isMenuVisible,
      this.likedYou})
      : super(key: key);

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  late User user;
  List<String?> images = [];
  List _pages = [];
  PageController controller = PageController(
    initialPage: 0,
  );
  PageController gridPageViewController = PageController(
    initialPage: 0,
  );
  List<Widget> _gridPages = [];
  String whatLiked = '';
  ConversationModel? conversationModel;
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    user = widget.user;
    images.add(user.profilePictureURL);
    images.removeWhere((element) => element == null);
    images.addAll(user.photos.cast<String?>());
    getMessage();
    super.initState();
  }

  Future<void> getMessage() async {
    if (widget.likedYou == true) {
      await FirebaseFirestore.instance
          .collection(SWIPES)
          .where('user2', isEqualTo: MyAppState.currentUser?.userID)
          .where('user1', isEqualTo: user.userID)
          .get()
          .then((querySnapShot) {
        querySnapShot.docs.forEach((doc) {
          Swipe match = Swipe.fromJson(doc.data());
          if (match.id.isEmpty) {
            match.id = doc.id;
          }
          setState(() {
            whatLiked = match.whatLiked;
          });
        });
      });
    } else if (widget.likedYou == false) {
      await FirebaseFirestore.instance
          .collection(SWIPES)
          .where('user1', isEqualTo: MyAppState.currentUser?.userID)
          .where('user2', isEqualTo: user.userID)
          .get()
          .then((querySnapShot) {
        querySnapShot.docs.forEach((doc) {
          Swipe match = Swipe.fromJson(doc.data());
          if (match.id.isEmpty) {
            match.id = doc.id;
          }
          setState(() {
            whatLiked = match.whatLiked;
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: isDarkMode(context) ? Colors.black : Colors.white));
    _gridPages = _buildGridView();
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomRight,
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * .6,
                      child: PageView.builder(
                        itemBuilder: (BuildContext context, int index) =>
                            _buildImage(index),
                        itemCount: images.length,
                        controller: controller,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                    Positioned(
                      top: 5,
                      child: SmoothPageIndicator(
                        controller: controller, // PageController
                        count: images.length,
                        effect: SlideEffect(
                            spacing: 4.0,
                            radius: 4.0,
                            dotWidth: (MediaQuery.of(context).size.width /
                                    images.length) -
                                4,
                            dotHeight: 4.0,
                            paintStyle: PaintingStyle.fill,
                            dotColor: Colors.grey,
                            activeDotColor:
                                Colors.white), // your preferred effect
                      ),
                    ),
                    /* Positioned(
                      right: 16,
                      bottom: -60,
                      child: FloatingActionButton(
                          mini: false,
                          child: Icon(
                            Icons.arrow_downward,
                            size: 30,
                            color: Color(COLOR_BLUE_BUTTON),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    )*/
                  ]),
              Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                child: Row(
                  children: <Widget>[
                    /*Text(
                      '${user.fullName()}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
                    ),*/
                    Flexible(
                      child: Container(
                        child: Text(
                          user.age.isEmpty
                              ? '${user.fullName()}, ${user.preferPronoun}, ${user.calculateAge()}'
                              : '${user.fullName()}, ${user.age}',
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              fontSize: 27, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 12,
              ),
              if (widget.likedYou != null)
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, bottom: 12),
                  child: Text(
                    widget.likedYou == true
                        ? '${widget.user.fullName()} liked your $whatLiked'
                        : 'you liked ${widget.user.fullName().toLowerCase()} $whatLiked',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
              /* Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.school),
                    Text('   ${user.school}')
                  ],
                ),
              ),*/
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.location_on),
                    Text('   ${user.milesAway}')
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 8),
                child: Text(
                  user.bio.isEmpty || user.bio == 'N/A' ? '' : '  ${user.bio}',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Photos'.tr(),
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    if (_pages.length >= 2)
                      SmoothPageIndicator(
                        controller: gridPageViewController,
                        // PageController
                        count: _pages.length,
                        effect: JumpingDotEffect(
                            spacing: 4.0,
                            radius: 4.0,
                            dotWidth: 8,
                            dotHeight: 8.0,
                            paintStyle: PaintingStyle.fill,
                            dotColor: Colors.grey,
                            activeDotColor:
                                Color(COLOR_PRIMARY)), // your preferred effect
                      ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16, bottom: 8),
                child: SizedBox(
                    height: user.photos.length > 2 ? 260 : 130,
                    width: double.infinity,
                    child: PageView(
                      controller: gridPageViewController,
                      children: _gridPages,
                    )),
              ),
              Visibility(
                visible: !widget.isMatch,
                child: Container(
                  height: 110,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    'Start conversation with ${user.fullName()} by send message'),
              ),
              Row(
                children: [
                  Expanded(
                    child: _textFormField(),
                  ),
                  GestureDetector(
                    onTap: () {
                      _sendMessage(textEditingController.text,
                          Url(mime: '', url: ''), '', user);
                    },
                    child: Container(
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        /*bottomSheet: Visibility(
          visible: !widget.isMatch,
          child: Container(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FloatingActionButton(
                    elevation: 4,
                    heroTag: 'left'.tr(),
                    onPressed: () {
                      Navigator.pop(context, CardSwipeOrientation.LEFT);
                    },
                    backgroundColor: Colors.white,
                    mini: false,
                    child: Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                  FloatingActionButton(
                    elevation: 4,
                    heroTag: 'center'.tr(),
                    onPressed: () {
                      Navigator.pop(context, CardSwipeOrientation.RIGHT);
                    },
                    backgroundColor: Colors.white,
                    mini: true,
                    child: Icon(
                      Icons.star,
                      color: Colors.blue,
                      size: 30,
                    ),
                  ),
                  FloatingActionButton(
                    elevation: 4,
                    heroTag: 'right'.tr(),
                    onPressed: () {
                      Navigator.pop(context, CardSwipeOrientation.RIGHT);
                    },
                    backgroundColor: Colors.white,
                    mini: false,
                    child: Icon(
                      Icons.favorite,
                      color: Colors.green,
                      size: 40,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),*/
      ),
    );
  }

  Widget _textFormField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: textEditingController,
        decoration: InputDecoration(
          hintText: 'Add a comment',
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
          fillColor: Colors.grey.shade100,
          isDense: true,
          filled: true,
        ),
      ),
    );
  }

  List<Widget> _buildGridView() {
    _pages.clear();
    List<Widget> gridViewPages = [];
    var len = images.length;
    var size = 6;
    for (var i = 0; i < len; i += size) {
      var end = (i + size < len) ? i + size : len;
      _pages.add(images.sublist(i, end));
    }
    _pages.forEach((elements) {
      gridViewPages.add(GridView.builder(
          padding: EdgeInsets.only(right: 16, left: 16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10),
          itemBuilder: (context, index) => elements[index] != null
              ? _imageBuilder(elements[index])
              : SizedBox(),
          itemCount: elements.length,
          physics: BouncingScrollPhysics()));
    });
    return gridViewPages;
  }

  Widget _imageBuilder(String url) {
    return GestureDetector(
      onTap: () {
        push(context, FullScreenImageViewer(imageUrl: url));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.circular(12),
        ),
        color: Color(COLOR_PRIMARY),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: user.profilePictureURL == DEFAULT_AVATAR_URL ? '' : url,
            placeholder: (context, imageUrl) {
              return Icon(
                Icons.hourglass_empty,
                size: 75,
                color: isDarkMode(context) ? Colors.black : Colors.white,
              );
            },
            errorWidget: (context, imageUrl, error) {
              return Icon(
                Icons.error_outline,
                size: 75,
                color: isDarkMode(context) ? Colors.black : Colors.white,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildImage(int index) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: CachedNetworkImage(
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            imageUrl: user.profilePictureURL == DEFAULT_AVATAR_URL
                ? ''
                : images[index] ?? DEFAULT_AVATAR_URL,
            placeholder: (context, imageUrl) {
              return Icon(
                Icons.hourglass_empty,
                size: 75,
                color: isDarkMode(context) ? Colors.black : Colors.white,
              );
            },
            errorWidget: (context, imageUrl, error) {
              return Icon(
                Icons.error_outline,
                size: 75,
                color: isDarkMode(context) ? Colors.black : Colors.white,
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Container(
              width: 50,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black54, Colors.black26])),
              child: MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                textColor: Colors.green,
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back_ios,
                      size: 30,
                      color: Color(0xffffffff),
                    ),
                    /* Text("Back",style: TextStyle(fontSize: 20),),*/
                  ],
                ),
                padding: EdgeInsets.all(10),
                shape: CircleBorder(),
              )),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: widget.isMenuVisible
                ? Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(0)),
                        gradient: const LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Colors.black54, Colors.black26])),
                    child: widget.isMenuVisible
                        ? Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 16.0, right: 16.0, bottom: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    // _undo();
                                  },
                                  child: Image.asset(
                                    'assets/images/undo.png',
                                    height: 20,
                                    width: 40,
                                    color: Colors.white,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(
                                        context, CardSwipeOrientation.LEFT);
                                  },
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(
                                        context, CardSwipeOrientation.RIGHT);
                                  },
                                  child: Icon(
                                    Icons.star_border,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(
                                        context, CardSwipeOrientation.RIGHT);
                                  },
                                  child: Icon(
                                    Icons.favorite_border,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Image.asset(
                                    'assets/images/thunder.png',
                                    height: 20,
                                    width: 40,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                  )
                : Container())
      ],
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

  @override
  void dispose() {
    gridPageViewController.dispose();
    controller.dispose();
    super.dispose();
  }
}
