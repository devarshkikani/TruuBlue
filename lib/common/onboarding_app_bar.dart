import 'package:flutter/material.dart';

PreferredSizeWidget onBoardingAppBar({
  required Function() backOnTap,
  required Function() nextOnTap,
  bool? userCanMove,
  required Animation<double> animationController1,
  required Animation<double> animationController2,
}) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(50),
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: backOnTap,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, anim) => RotationTransition(
                  turns: animationController1,
                  child: FadeTransition(
                      opacity: anim,
                      child: child,
                      alwaysIncludeSemantics: true),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 30,
                  color: Color(0xFF0573ac),
                  key: const ValueKey('icon2'),
                ),
              ),
            ),
            Image.asset(
              'assets/images/truubluenew.png',
            ),
            userCanMove == true
                ? InkWell(
                    onTap: nextOnTap,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, anim) => RotationTransition(
                        turns: animationController2,
                        child: FadeTransition(opacity: anim, child: child),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 30,
                        color: Color(0xFF0573ac),
                        key: const ValueKey('icon2'),
                      ),
                    ),
                  )
                : SizedBox(
                    width: 30,
                  ),
          ],
        ),
      ),
    ),
  );
}
