import 'package:blog/custom_theme/gradient_color.dart';
import 'package:blog/views/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'custom_theme/custom_theme.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        builder: (context, child) {
        return GradientColor(child: child!);
      },
         theme: theme,
          home: const Splash());
  }
}
