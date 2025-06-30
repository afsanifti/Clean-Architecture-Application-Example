import 'package:clean_arch_examples/core/common/views/page_under_construction.dart';
import 'package:clean_arch_examples/core/services/injection_container.dart';
import 'package:clean_arch_examples/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:clean_arch_examples/src/on_boarding/presentation/views/on_boarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case OnBoardingScreen.routeName:
      // In the on boarding, we don't need context.
      return _pageBuilder(
        /// So this (_) higher function matches the required [BuildContext]
        /// from the [_pageBuilder] and receives the [BuildContext]
        /// and returns a [Widget] in this case [BlocProvider]
        (_) => BlocProvider(
          ///  Instead of creating these objects directly in your widgets or
          ///  classes, you ask the service locator for them. This decouples
          ///  object creation from usage, making your code easier to test and
          ///  maintain.
          create: (_) => sl<OnBoardingCubit>(),
          child: const OnBoardingScreen(),
        ),
        settings: settings,
      );
    default:
      return _pageBuilder(
        (_) => const PageUnderConstruction(),
        settings: settings,
      );
  }
}

PageRouteBuilder<dynamic> _pageBuilder(
  /// Type definition:
  /// A function that takes a [BuildContext] as an argument
  /// and returns a [Widget]
  Widget Function(BuildContext) page, {
  required RouteSettings settings,
}) {
  return PageRouteBuilder(
    settings: settings,
    pageBuilder: (context, _, _) => page(context),
    transitionsBuilder:
        (_, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
  );
}
