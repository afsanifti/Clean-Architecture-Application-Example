import 'package:clean_arch_examples/core/res/color_swatches.dart';
import 'package:clean_arch_examples/core/res/fonts.dart';
import 'package:clean_arch_examples/core/services/injection_container.dart';
import 'package:clean_arch_examples/core/services/router.dart';
import 'package:clean_arch_examples/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Education App',
      theme: ThemeData(
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: Fonts.googleSans,
        appBarTheme: const AppBarTheme(color: Colors.transparent),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: ColorSwatches.primaryColour,
        ),
      ),
      onGenerateRoute: generateRoute,
    );
  }
}
