import 'package:flutter/material.dart';

class CustomGradientScaffold extends StatelessWidget {
  const CustomGradientScaffold(
      {super.key, required this.body, this.bottomNavigationBar});
  final Widget body;
  final BottomNavigationBar? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 240, 219, 187),
              Color.fromARGB(255, 213, 200, 249)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: body,
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
