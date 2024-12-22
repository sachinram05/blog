import 'dart:async';
import 'package:blog/custom_widgets/custom_gradient.dart';
import 'package:blog/views/auth.dart';
import 'package:blog/views/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    checkUserToken();
  }

  Future<void> checkUserToken() async {
    await Future.delayed(const Duration(seconds: 2));
      final storedToken = await SharedPreferences.getInstance();
      final token = storedToken.getString('token');
      if (token != null && token.isNotEmpty) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => const Home()));
      } else {
         Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => const Auth()));
      }
  }

  @override
  Widget build(BuildContext context) {
    return CustomGradientScaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Image.asset('assets/images/blogSplash.png'),
        ),
      ),
    );
  }
}
