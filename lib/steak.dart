import 'package:flutter/material.dart';

class Steak extends StatelessWidget {
  const Steak({super.key});

  @override
  Widget build(BuildContext context) {
    return Draggable(
      data: "You feed the dog.",
      child: const Image(
        image: AssetImage('assets/steak.webp'),
        width: 200,
      ),
      feedback: const Image(
        image: AssetImage('assets/steak.webp'),
        width: 200,
        opacity: const AlwaysStoppedAnimation(0.5),
      )
    );
  }
}
