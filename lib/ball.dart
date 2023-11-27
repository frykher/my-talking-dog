import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

// todo: display heart effects and send message to top layer widget
class Ball extends StatefulWidget {
  Ball({super.key, required this.messageUpdater});

  final Function(String) messageUpdater;
  final player = AudioPlayer();

  @override
  State<Ball> createState() => _BallState();
}

class _BallState extends State<Ball> {
  DragStartDetails? startVerticalDragDetails;
  DragUpdateDetails? updateVerticalDragDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      child: Center(
        child: GestureDetector(
          onVerticalDragStart: (dragDetails) {
            startVerticalDragDetails = dragDetails;
          },
          onVerticalDragUpdate: (dragDetails) {
            updateVerticalDragDetails = dragDetails;
          },
          onVerticalDragEnd: (endDetails) {
            double dx = updateVerticalDragDetails!.globalPosition.dx -
                startVerticalDragDetails!.globalPosition.dx;
            double dy = updateVerticalDragDetails!.globalPosition.dy -
                startVerticalDragDetails!.globalPosition.dy;
            double velocity = endDetails.primaryVelocity!;

            //Convert values to be positive
            if (dx < 0) dx = -dx;
            if (dy < 0) dy = -dy;

            if (velocity < 0) {
              widget.messageUpdater('Dog fetches the ball');
              widget.player.play(AssetSource('audios/swipe.mp3'));
            }
          },
          child: const Image(
            image: AssetImage('assets/ball.jpg'),
            width: 150,
            height: 150,
          ),
        ),
      ),
    );
  }
}
