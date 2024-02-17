import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating/constants.dart';
import 'package:dating/main.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/ui/AppEntryOffers/ultra_like_purchase_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

// ignore: must_be_immutable
class ImageDetailsScreen extends StatefulWidget {
  final String imageUrl;
  final String name;
  int? ultraLikeCount;
  final Function(String? message, bool ultraLike) sendLike;
  final Function() cancel;
  ImageDetailsScreen({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.ultraLikeCount,
    required this.sendLike,
    required this.cancel,
  }) : super(key: key);

  @override
  State<ImageDetailsScreen> createState() => _ImageDetailsScreenState();
}

class _ImageDetailsScreenState extends State<ImageDetailsScreen> {
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
                        widget.name,
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
                      child: _imageView(widget.imageUrl),
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
                Center(
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

  Widget _imageView(String url) {
    return Container(
      height: 300,
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
                                  'You’ve sent an Ultra Like! You have ${widget.ultraLikeCount! - 1} Ultra Likes left and you can buy more any time.',
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
