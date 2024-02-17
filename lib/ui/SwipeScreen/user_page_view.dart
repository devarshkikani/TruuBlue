import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/constants.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/ui/onBoarding/onBoarding_hobby_question.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dating/model/User.dart';
import 'package:dating/services/helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';

List isLike = [];

class UserPageView extends StatefulWidget {
  UserPageView({
    Key? key,
    required this.user,
    required this.likeTap,
    required this.questionTap,
    required this.questionLikeTap,
    required this.onBlockOrReport,
  }) : super(key: key);
  final User user;
  final Function(String url) likeTap;
  final Function() questionTap;
  final Function() questionLikeTap;
  final Function() onBlockOrReport;

  @override
  State<UserPageView> createState() => _UserPageViewState();
}

class _UserPageViewState extends State<UserPageView> {
  bool isvipService = true;

  List<String> blockTextList = [
    'No reason',
    "I'm not interested in this person",
    'Profile is fake, spam, or scammer',
    'Inapproproate content',
    'Underage or minor',
    'Offline behavior',
    'Someone is in danger',
  ];

  List<String> reportTextList = [
    "I'm not interrested in this person",
    "Profile is fake, spam, or scammer",
    'Inapproproate content',
    'Underage or minor',
    'Offline behavior',
    'Someone is in danger',
  ];

  @override
  void initState() {
    super.initState();
  }

  void likeflag(id, categoryQuestionId) async {
    await FirebaseFirestore.instance
        .collection('question_like')
        .where("other_user_id", isEqualTo: widget.user.userID)
        .where('id', isEqualTo: id)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        isLike.addAll(value.docs);
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final birthday = widget.user.birthdate.toString();
    var birthyear = birthday.split("/").toList();
    var diffrtence = DateTime.now().year.toInt() - int.parse(birthyear[2]);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: AnimationLimiter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimationConfiguration.staggeredList(
                        position: 1,
                        duration: const Duration(milliseconds: 400),
                        child: SlideAnimation(
                          verticalOffset: -44.0,
                          child: FadeInAnimation(
                            child: GestureDetector(
                              onTap: () {
                                push(context, OnBoardingHobbyQuestion());
                              },
                              child: Row(
                                children: [
                                  Text(
                                    widget.user.firstName,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    diffrtence.toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      AnimationConfiguration.staggeredList(
                        position: 2,
                        duration: const Duration(milliseconds: 400),
                        child: SlideAnimation(
                          verticalOffset: -44.0,
                          child: FadeInAnimation(
                            child: Text(
                              widget.user.preferPronoun.toString(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              AnimationConfiguration.staggeredList(
                position: 3,
                duration: const Duration(milliseconds: 400),
                child: SlideAnimation(
                  verticalOffset: -44.0,
                  child: FadeInAnimation(
                    child: _buildProfileView(),
                  ),
                ),
              ),
              AnimationConfiguration.staggeredList(
                position: 4,
                duration: const Duration(milliseconds: 400),
                child: SlideAnimation(
                  verticalOffset: -44.0,
                  child: FadeInAnimation(
                    child: _buildDetails(0),
                  ),
                ),
              ),
              AnimationConfiguration.staggeredList(
                position: 5,
                duration: const Duration(milliseconds: 400),
                child: SlideAnimation(
                  verticalOffset: -44.0,
                  child: FadeInAnimation(
                    child: _buildDetailScreen(),
                  ),
                ),
              ),
              AnimationConfiguration.staggeredList(
                position: 6,
                duration: const Duration(milliseconds: 400),
                child: SlideAnimation(
                  verticalOffset: -44.0,
                  child: FadeInAnimation(
                    child: _buildUserQuestionPhotos(),
                  ),
                ),
              ),
              AnimationConfiguration.staggeredList(
                position: 7,
                duration: const Duration(milliseconds: 400),
                child: SlideAnimation(
                  verticalOffset: -44.0,
                  child: FadeInAnimation(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: InkWell(
                        onTap: () {
                          showCupertinoModalPopup<void>(
                            context: context,
                            builder: (BuildContext context) =>
                                CupertinoActionSheet(
                              cancelButton: CupertinoActionSheetAction(
                                isDefaultAction: false,
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.black),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              actions: <CupertinoActionSheetAction>[
                                CupertinoActionSheetAction(
                                  isDefaultAction: true,
                                  onPressed: () {
                                    Navigator.pop(context);
                                    blockSheet();
                                  },
                                  child: const Text(
                                    'Block',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                CupertinoActionSheetAction(
                                  isDestructiveAction: true,
                                  onPressed: () {
                                    Navigator.pop(context);
                                    reportSheet();
                                  },
                                  child: const Text('Report'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Report ${widget.user.fullName()}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> blockSheet() {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Block',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Your reason is private',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(
                        blockTextList.length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: customDecorationText(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(
                                          'Are you sure you want to block ${widget.user.firstName}?'),
                                      insetPadding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(
                                                context); //close Dialog
                                          },
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            await FireStoreUtils().blockUser(
                                              widget.user,
                                              'Block',
                                              blockTextList[index],
                                            );
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    '${widget.user.firstName} has been blocked.'),
                                              ),
                                            );
                                            widget.onBlockOrReport();
                                          },
                                          child: Text('Block'),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            title: blockTextList[index],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }

  Future<void> reportSheet() {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Report',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Your reason is private',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade400,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.close,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(
                      reportTextList.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: customDecorationText(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                        'Are you sure you want to report ${widget.user.firstName} account?'),
                                    insetPadding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context); //close Dialog
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          await FireStoreUtils().blockUser(
                                            widget.user,
                                            'Report',
                                            reportTextList[index],
                                          );
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  ' You report to ${widget.user.firstName} account'),
                                            ),
                                          );
                                          widget.onBlockOrReport();
                                        },
                                        child: Text('Report'),
                                      ),
                                    ],
                                  );
                                });
                          },
                          title: reportTextList[index],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget customDecorationText({required String title, onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.grey.shade200,
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Text(
          title,
        ),
      ),
    );
  }

  Widget _buildProfileView() {
    return _buildImageView(widget.user.profilePictureURL, null);
  }

  Widget _buildDetails(int index) {
    return GestureDetector(
      onTap: () {
        widget.questionTap();
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20, 20, 16, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.user.answeredQuestion.isNotEmpty
                  ? widget.user.answeredQuestion[index]["question"]
                  : "Most spontaneous thing l've done",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.user.answeredQuestion.isNotEmpty
                  ? widget.user.answeredQuestion[index]["answer"]
                  : "Booked an all inclusive solo trip ",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: () async {
                  widget.questionTap();
                  // if (isLike.isEmpty &&
                  //     widget.user.answeredQuestion.isNotEmpty) {
                  //   await FirebaseFirestore.instance
                  //       .collection('question_like')
                  //       .doc()
                  //       .set({
                  //     "id": widget.user.answeredQuestion[index]['id'],
                  //     "category_question_id": widget.user.answeredQuestion[0]
                  //         ['category_question_id'],
                  //     "user_id": MyAppState.currentUser!.userID,
                  //     "other_user_id": widget.user.userID
                  //   });
                  // } else {
                  //   if (widget.user.answeredQuestion.isNotEmpty) {
                  //     var snapshot = await FirebaseFirestore.instance
                  //         .collection('question_like')
                  //         .where("other_user_id", isEqualTo: widget.user.userID)
                  //         .where('id',
                  //             isEqualTo: widget.user.answeredQuestion[0]['id'])
                  //         .get();
                  //     for (var doc in snapshot.docs) {
                  //       await doc.reference.delete();
                  //     }
                  //     isLike.clear();
                  //   }
                  // }
                  // if (widget.user.answeredQuestion.isNotEmpty) {
                  //   likeflag(
                  //       widget.user.answeredQuestion[index]['id'],
                  //       widget.user.answeredQuestion[index]
                  //           ['category_question_id']);
                  // }
                  // await widget.questionLikeTap();
                  // setState(() {});
                },
                child: Container(
                  height: 40,
                  width: 40,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: Offset(0.2, 0.2),
                        color: Colors.black.withOpacity(0.18),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/ic_heart.png',
                    color: isLike.isNotEmpty
                        ? isLike[index]["other_user_id"] == widget.user.userID
                            ? Colors.red
                            : null
                        : null,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailScreen() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 6,
          ),
          SizedBox(
            height: 50,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 0,
              ),
              child: _buildHorizontalView(
                widget.user,
              ),
            ),
          ),
          Divider(
            color: Colors.grey.withOpacity(0.2),
            thickness: 1,
          ),
          if (widget.user.your_details.univerties != 'null')
            _buildVerticalView(
                widget.user.your_details.religiose_belief.isEmpty
                    ? "Religion"
                    : widget.user.your_details.religiose_belief,
                Icon(Icons.circle_outlined),
                true),
          _buildVerticalView("Looking for " + widget.user.genderWantToDate,
              Icon(Icons.male), true),
          _buildVerticalView(widget.user.ethnicityWantToDate,
              Icon(Icons.favorite_outline), true),
          if (widget.user.your_details.univerties != 'null')
            _buildVerticalView(
                widget.user.your_details.univerties.isEmpty
                    ? "Univercity"
                    : widget.user.your_details.univerties,
                Icon(Icons.school_outlined),
                false),
        ],
      ),
    );
  }

  Widget _buildHorizontalView(User user) {
    return ListView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.zero,
      children: [
        _buildYourDetailsView(
            '${DateTime.now().year - DateFormat('MM/dd/yyyy').parse(user.birthdate).year}',
            Icon(Icons.cake_outlined)),
        _buildYourDetailsView(''''5''6''', Icon(Icons.height_rounded)),
        if (user.your_details.home_town != 'null')
          _buildYourDetailsView(
              user.your_details.home_town, Icon(Icons.location_on_outlined)),
        user.have_Children != null
            ? _buildYourDetailsView(
                user.have_Children!, Icon(Icons.watch_later_outlined))
            : SizedBox(),
        user.you_Drink != null
            ? _buildYourDetailsView(
                user.you_Drink.toString(), Icon(Icons.no_drinks))
            : SizedBox(),
        user.you_Smoke != null
            ? _buildYourDetailsView(
                user.you_Smoke.toString(), Icon(Icons.smoking_rooms_rounded))
            : SizedBox(),
        _buildYourDetailsView(user.isVip == true ? 'Yes' : 'No',
            Icon(Icons.local_hospital_outlined)),
        _buildYourDetailsView(
          user.settings.gender,
          Icon(Icons.male),
        ),
      ],
    );
  }

  Widget _buildYourDetailsView(String title, Widget icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 5,
        ),
        icon,
        SizedBox(
          width: 5,
        ),
        Text(
          title,
          style: TextStyle(color: Colors.black),
        ),
        SizedBox(
          width: 5,
        ),
        VerticalDivider(
          color: Colors.grey.withOpacity(0.2),
          width: 2,
          thickness: 1,
          endIndent: 10,
          indent: 10,
        )
      ],
    );
  }

  Widget _buildVerticalView(String title, Widget icon, bool isLastIndex) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
          child: Row(
            children: [
              icon,
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        if (isLastIndex)
          Divider(
            color: Colors.grey.withOpacity(0.2),
            thickness: 1,
          ),
        if (!isLastIndex)
          SizedBox(
            height: 10,
          ),
      ],
    );
  }

  Widget _buildUserQuestionPhotos() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.user.answeredQuestion.length > widget.user.photos.length
          ? widget.user.answeredQuestion.length
          : widget.user.photos.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            if (widget.user.answeredQuestion.length > index)
              _buildDetails(index),
            if (widget.user.photos.length > index)
              _buildImageView(widget.user.photos[index], index)
          ],
        );
      },
    );
  }

  Widget _buildImageView(String url, int? index) {
    return GestureDetector(
      onTap: () {
        widget.likeTap(url);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            if (widget.user.prompt != null &&
                widget.user.prompt != [] &&
                widget.user.prompt!.isNotEmpty &&
                index != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.user.prompt![index] != "")
                        SizedBox(
                          height: 10,
                        ),
                      if (widget.user.prompt![index] != "")
                        Text(
                          widget.user.prompt![index],
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      if (widget.user.prompt![index] != "")
                        SizedBox(
                          height: 10,
                        ),
                    ],
                  ),
                ),
              ),
            Container(
              height: 300,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                      topRight: index != null &&
                              widget.user.prompt != null &&
                              widget.user.prompt != [] &&
                              widget.user.prompt!.isNotEmpty
                          ? widget.user.prompt![index] != ""
                              ? Radius.circular(0)
                              : Radius.circular(10)
                          : Radius.circular(10),
                      topLeft: index != null &&
                              widget.user.prompt != null &&
                              widget.user.prompt != [] &&
                              widget.user.prompt!.isNotEmpty
                          ? widget.user.prompt![index] != ""
                              ? Radius.circular(0)
                              : Radius.circular(10)
                          : Radius.circular(10),
                    ),
                    child: CachedNetworkImage(
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      imageUrl: url == '' ? DEFAULT_AVATAR_URL : url,
                      placeholder: (context, imageUrl) {
                        return Icon(
                          Icons.account_circle,
                          size: MediaQuery.of(context).size.height * .3,
                          color:
                              isDarkMode(context) ? Colors.black : Colors.white,
                        );
                      },
                      errorWidget: (context, imageUrl, error) {
                        return Icon(
                          Icons.account_circle,
                          size: MediaQuery.of(context).size.height * .3,
                          color:
                              isDarkMode(context) ? Colors.black : Colors.white,
                        );
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: () async {
                        widget.likeTap(url);
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        padding: EdgeInsets.all(10),
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
                          'assets/images/ic_heart.png',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // List<Widget> questionWidget =
  //     List.generate(widget.user.answeredQuestion.length, (index) => null);

  // Future<void> _launchDetailsScreen(User tinderUser) async {
  //   // CardSwipeOrientation? result = await
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (context) => UserDetailsScreen(
  //         user: tinderUser,
  //         isMatch: false,
  //         isMenuVisible: true,
  //       ),
  //     ),
  //   );
  // if (result != null) {
  //   if (result == CardSwipeOrientation.LEFT) {
  //     controller.triggerLeft();
  //   } else {
  //     controller.triggerRight();
  //   }
  // }
  // }
}
