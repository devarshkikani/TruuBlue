import 'package:dating/common/colors.dart';
import 'package:dating/common/common_widget.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/ui/art_board/second_art_board_screen.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FirstArtBoardScreen extends StatefulWidget {
  final String userCount;

  FirstArtBoardScreen({
    Key? key,
    required this.userCount,
  }) : super(key: key);

  @override
  State<FirstArtBoardScreen> createState() => _FirstArtBoardScreenState();
}

class _FirstArtBoardScreenState extends State<FirstArtBoardScreen> {
  String backgoundURL =
      '''https://firebasestorage.googleapis.com/v0/b/truubluedev.appspot.com/o/videos%2FUntitled.mp4?alt=media&token=19362686-6df9-4d48-99ee-8374b14cac4b''';
  late VideoPlayerController _controller;
  String userCount = '';
  @override
  void initState() {
    super.initState();
    userCount = widget.userCount;
    _controller = VideoPlayerController.network(backgoundURL)
      ..setLooping(true)
      ..initialize().then((_) {
        _controller.play();
        print(_controller.value.isLooping);
        print(_controller.value.isPlaying);
        setState(() {});
      });
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
              child: _controller.value.isInitialized
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: VideoPlayer(_controller),
                    )
                  : Container(),
            ),
          ),
          SafeArea(child: topView()),
        ],
      ),
    );
  }

  Widget topView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
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
            'congratulations!'.toUpperCase(),
            style: TextStyle(
              fontFamily: 'Rift',
              fontSize: 50,
              fontWeight: FontWeight.w700,
              color: whiteColor,
            ),
          ),
          sizedBox30,
          Text(
            "You are member #${userCount == '' ? '0000' : userCount}.\nOnce we reach 5000 members in colorado, we'll go live and notify you immediately"
                .toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Rift',
              fontSize: 32,
              color: whiteColor,
            ),
          ),
          sizedBox30,
          sizedBox30,
          sizedBox30,
          GestureDetector(
            onTap: () {
              pushAndRemoveUntil(
                  context,
                  SecondArtBoardScreen(
                    controller: _controller,
                  ),
                  false);
            },
            child: Container(
              height: 60,
              width: 250,
              color: secondaryColor,
              alignment: Alignment.center,
              child: Text(
                'continue'.toUpperCase(),
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
