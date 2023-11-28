import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

// todo: display heart effects and send message to top layer widget
class Dog extends StatelessWidget {
  Dog({super.key, required this.messageUpdater, required this.love});

  final Function(String) messageUpdater;
  final player = AudioPlayer();
  final int love;

  @override
  Widget build(BuildContext context) {
    return DragTarget(onAccept: (str) {
      messageUpdater(str.toString());
      player.play(AssetSource('audios/eat.mp3'));
    }, builder:
        (BuildContext context, List<dynamic> accepted, List<dynamic> rejected) {
      return Container(
        margin: const EdgeInsets.only(top: 150, right: 200),
        child: Center(
          child: GestureDetector(
            onLongPress: () {
              messageUpdater('You cuddle the dog.');
              player.play(AssetSource('audios/aww.mp3'));
            },
            onDoubleTap: () {
              messageUpdater('You pet the dog.');
              player.play(AssetSource('audios/aww.mp3'));
            },
            onScaleStart: (details) {
              messageUpdater("You pinch the dog's nose.");
              player.play(AssetSource('audios/sneeze.mp3'));
            },
            child: const Image(
              image: AssetImage('assets/dog.png'),
              width: 150,
              height: 150,
            ),
          ),
        ),
      );
    });
  }
}
