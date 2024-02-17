// ignore_for_file: must_be_immutable

import 'package:dating/common/colors.dart';
import 'package:dating/common/common_widget.dart';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

class SecondArtBoardScreen extends StatefulWidget {
  SecondArtBoardScreen({Key? key, required this.controller}) : super(key: key);
  late VideoPlayerController controller;

  @override
  State<SecondArtBoardScreen> createState() => _SecondArtBoardScreenState();
}

class _SecondArtBoardScreenState extends State<SecondArtBoardScreen> {
  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  colors: [Colors.white, blackColor.withOpacity(0.2)],
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                ).createShader(bounds);
              },
              blendMode: BlendMode.srcATop,
              child: widget.controller.value.isInitialized
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: VideoPlayer(widget.controller),
                    )
                  : Container(),
            ),
          ),
          SafeArea(
            child: topView(),
          ),
        ],
      ),
    );
  }

  Widget topView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          sizedBox10,
          Image.asset(
            'assets/images/truubluenew.png',
            width: 250,
          ),
          sizedBox30,
          sizedBox30,
          Text(
            'help us spread\nthe word!'.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Rift',
              fontSize: 50,
              fontWeight: FontWeight.w700,
              color: whiteColor,
            ),
          ),
          sizedBox30,
          Text(
            "invite three of your progressive friends to try truublue and we'll enter you into drawing to win "
                .toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Rift',
              fontSize: 32,
              color: whiteColor,
            ),
          ),
          sizedBox30,
          Text(
            "\$1000 CASH".toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Rift',
              fontSize: 50,
              color: whiteColor,
            ),
          ),
          sizedBox30,
          sizedBox30,
          sizedBox30,
          GestureDetector(
            onTap: () {
              Share.share('https://www.truublue.com/');
            },
            child: Container(
              height: 60,
              width: 250,
              color: secondaryColor,
              alignment: Alignment.center,
              child: Text(
                'click to share'.toUpperCase(),
                style: TextStyle(
                  fontFamily: 'Rift',
                  fontSize: 32,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w800,
                  color: whiteColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
