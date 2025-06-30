import 'package:clean_arch_examples/core/common/widgets/on_boarding_background.dart';
import 'package:clean_arch_examples/core/res/media_res.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PageUnderConstruction extends StatelessWidget {
  const PageUnderConstruction({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnBoardingBackground(
        image: MediaRes.onBoardingBackground,
        child: Center(child: Lottie.asset(MediaRes.underConstructionLottie)),
      )
    );
  }
}
