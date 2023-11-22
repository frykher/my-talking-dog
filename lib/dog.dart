import 'package:flutter/material.dart';

// todo: display heart effects and send message to top layer widget
class Dog extends StatefulWidget {
  const Dog({super.key, required this.messageUpdater});

  final Function(String) messageUpdater;

  @override
  State<Dog> createState() => _DogState();
}

class _DogState extends State<Dog> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/talking-dog-wallpaper.jpeg'),
          fit: BoxFit.cover,
        )),
        child: GestureDetector(
          onDoubleTap: () {
            widget.messageUpdater('You pet the dog.');
          },
          child: Container(
            margin: const EdgeInsets.only(top: 150, right: 200),
            child: const Center(
                child: Image(
              image: AssetImage('assets/dog.png'),
              width: 150,
              height: 150,
            )),
          ),
        ));
  }
}
