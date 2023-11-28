import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class Dog extends StatelessWidget {
  Dog({super.key, required this.messageUpdater, required this.prestige});

  final Function(String) messageUpdater;
  final player = AudioPlayer();
  final int prestige;
  static const List<String> dogPrestiges = [
    'dog-starter.png',
    'dog-intermediate.jpg',
    'dog-third.png',
    'dog-max.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    return DragTarget(onAccept: (str) {
      messageUpdater(str.toString());
      player.play(AssetSource('audios/eat.mp3'));
    }, builder:
        (BuildContext context, List<dynamic> accepted, List<dynamic> rejected) {
      return Container(
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
            child: Image(
              image: AssetImage('assets/${dogPrestiges[prestige]}'),
              width: 150,
              height: 150,
            ),
          ),
        ),
      );
    });
  }
}
