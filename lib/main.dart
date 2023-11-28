import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_talking_dog/steak.dart';

import 'ball.dart';
import 'dog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String message = "";
  bool messageVisible = false;
  Timer? _currentTimer;
  int _love = 0;
  int _combo = 0;
  String _lastAction = "";

  void _incrementLove(String action) {
    if (_lastAction != action) {
      _combo = 0;
    }
    _combo += 1;
    setState(() {
      _love += _combo;
    });
    _lastAction = action;
  }

  void onMessageUpdate(String msg) {
    setState(() {
      message = msg;
      messageVisible = true;
    });
    _incrementLove(msg);
    if (_currentTimer != null) {
      _currentTimer!.cancel();
    }
    _currentTimer = Timer(const Duration(seconds: 3),
        () => setState(() => messageVisible = false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Text('Love: $_love'),
        title: const Center(
            child: Text('Dog', style: TextStyle(color: Colors.white))),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/talking-dog-wallpaper.jpeg'),
            fit: BoxFit.cover,
          )),
          child: SafeArea(
            child: Column(children: [
              AnimatedOpacity(
                opacity: messageVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Text(message,
                    style: const TextStyle(color: Colors.yellow, fontSize: 32)),
              ),
              Dog(messageUpdater: onMessageUpdate, love: _love),
              Column(
                children: [
                  Ball(
                    messageUpdater: onMessageUpdate,
                  ),
                  Steak(),
                ],
              )
            ]),
          )),
    );
  }
}
