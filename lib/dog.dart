import 'package:flutter/material.dart';

class Dog extends StatelessWidget {
  const Dog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/talking-dog-wallpaper.jpeg'),
          fit: BoxFit.cover,
        )),
        child: Container(
          margin: const EdgeInsets.only(top: 150, right: 200),
          child: const Center(
              child: Image(
            image: AssetImage('assets/dog.png'),
            width: 150,
            height: 150,
          )),
        ));
  }
}