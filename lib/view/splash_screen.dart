import "package:flutter/material.dart";

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("lib/assets/pictures/app_logo.png"),
          fit: BoxFit.cover
        )
      ),
    );
  }
}
