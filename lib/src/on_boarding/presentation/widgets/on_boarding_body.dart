import 'package:clean_arch_examples/core/extensions/context_extension.dart';
import 'package:clean_arch_examples/core/res/fonts.dart';
import 'package:clean_arch_examples/src/on_boarding/domain/entities/page_content.dart';
import 'package:clean_arch_examples/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class OnBoardingBody extends StatelessWidget {
  const OnBoardingBody({required this.pageContent, super.key});

  final PageContent pageContent;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(pageContent.image, height: context.height * .4),
        SizedBox(height: context.height * 0.03),
        // TODO(know): know what happened here
        Padding(
          padding: const EdgeInsets.all(20).copyWith(bottom: 0),
          child: Column(
            children: [
              Text(
                pageContent.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: Colors.white70,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: context.height * .02),
              Text(
                pageContent.description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white54,
                  fontFamily: Fonts.googleSans,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: context.height * 0.05),
              ElevatedButton(
                onPressed: () {
                  // TODO(get-started): implement this functionality
                  // cache user
                  context.read<OnBoardingCubit>().cacheFirstTimer();
                  // push them to the appropriate screen
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 17,
                  ),
                  backgroundColor: context.theme.primaryColor,
                  foregroundColor: Colors.white
                ),
                child: const Text('Get Started'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
