import 'package:flutter/material.dart';


class GradientColor extends StatelessWidget {
  final Widget child;

  const GradientColor({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:const BoxDecoration(
        gradient: LinearGradient(
          colors: [ Color.fromARGB(255,240, 219, 187), Color.fromARGB(255,213,200,249)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }
}
