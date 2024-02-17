import 'dart:ui';

import 'package:dating/main.dart';
import 'package:dating/model/User.dart';
import 'package:dating/ui/AppEntryOffers/ultra_like_purchase_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

// ignore: must_be_immutable
class QuestionDetailsScreen extends StatefulWidget {
  final User user;
  int? ultraLikeCount;
  final Function(String? message, bool ultraLike) sendLike;
  final Function() cancel;
  QuestionDetailsScreen({
    Key? key,
    required this.user,
    required this.ultraLikeCount,
    required this.sendLike,
    required this.cancel,
  }) : super(key: key);

  @override
  State<QuestionDetailsScreen> createState() => QuestionDetailsScreenState();
}

class QuestionDetailsScreenState extends State<QuestionDetailsScreen> {
  TextEditingController textEditingController = TextEditingController();
  FocusNode addCommentFocudNode = FocusNode();
  bool isFromUltraLike = false;

  @override
  Widget build(BuildContext context) {
    return Center(
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
                        widget.user.firstName,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                AnimationConfiguration.staggeredList(
                  position: 2,
                  duration: const Duration(milliseconds: 400),
                  child: SlideAnimation(
                    verticalOffset: -44.0,
                    child: FadeInAnimation(
                      child: _questionView(widget.user),
                    ),
                  ),
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
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  if (widget.ultraLikeCount! > 0) {
                                    if (textEditingController.text.isEmpty) {
                                      showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: Text(
                                              'Adding a comment doubles your chance of a match!'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  isFromUltraLike = true;
                                                  setState(() {});
                                                  Navigator.pop(context);
                                                  addCommentFocudNode
                                                      .requestFocus();
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(15),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFF68ce09),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.0),
                                                  ),
                                                  child: Text(
                                                    'Add a Comment',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  widget.sendLike(
                                                      textEditingController
                                                          .text,
                                                      true);
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(15),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFF70573ac),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.0),
                                                  ),
                                                  child: Text(
                                                    'Send without Comment',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
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
                                      widget.sendLike(
                                          textEditingController.text, true);
                                    }
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            UltraLikePurchaseLike(
                                          user: MyAppState.currentUser!,
                                        ),
                                      ),
                                    ).then((value) {
                                      if (value != null) {
                                        setState(() {
                                          widget.ultraLikeCount = value;
                                        });
                                      }
                                    });
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF68ce09),
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${widget.ultraLikeCount}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Image.asset(
                                        'assets/images/thunder_green.png',
                                        height: 18,
                                        width: 18,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 3,
                              child: GestureDetector(
                                onTap: () {
                                  if (textEditingController.text.isEmpty) {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: Text(
                                            'Adding a comment doubles your chance of a match!'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                                addCommentFocudNode
                                                    .requestFocus();
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(15),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: Color(0xFF68ce09),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
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
                                              onTap: () {
                                                Navigator.pop(context);
                                                widget.sendLike(
                                                    textEditingController.text,
                                                    false);
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(15),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: Color(0xFF70573ac),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
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
                                    widget.sendLike(
                                        textEditingController.text, false);
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF70573ac),
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  child: Text(
                                    'Send a like',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                AnimationConfiguration.staggeredList(
                  position: 5,
                  duration: const Duration(milliseconds: 400),
                  child: SlideAnimation(
                    verticalOffset: -44.0,
                    child: FadeInAnimation(
                      child: Center(
                        child: GestureDetector(
                          onTap: widget.cancel,
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _questionView(User user) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.answeredQuestion.isNotEmpty
                      ? widget.user.answeredQuestion[0]["question"]
                      : "Most spontaneous thing l've done",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.user.answeredQuestion.isNotEmpty
                      ? widget.user.answeredQuestion[0]["answer"]
                      : "Booked an all inclusive solo trip to Mexico.",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _textFormField(context) {
    return TextFormField(
      maxLength: 150,
      controller: textEditingController,
      focusNode: addCommentFocudNode,
      onFieldSubmitted: (String? value) {
        if (isFromUltraLike) {
          showDialog(
              context: context,
              builder: (_) => BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 10.0,
                      sigmaY: 10.0,
                    ),
                    child: Container(
                      color: Colors.white24,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            margin: EdgeInsets.all(20),
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'You’ve sent an Ultra Like! You have ${widget.ultraLikeCount} Ultra Likes available and you can buy more any time.',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    widget.sendLike(
                                        textEditingController.text, true);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            UltraLikePurchaseLike(
                                          user: MyAppState.currentUser!,
                                        ),
                                      ),
                                    ).then((value) {
                                      if (value != null) {
                                        setState(() {
                                          widget.ultraLikeCount = value;
                                        });
                                      }
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    padding: EdgeInsets.all(15),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF70573ac),
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    child: Text(
                                      'Get more Ultra Likes',
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
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              widget.sendLike(textEditingController.text, true);
                            },
                            child: Text(
                              'Not now',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ));
        }
      },
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
        fillColor: Colors.white,
        isDense: true,
        filled: true,
      ),
    );
  }
}
