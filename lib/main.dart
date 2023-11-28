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
      theme: ThemeData(),
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
  Map<int, int> prestigeRequirements = {
    0: 50,
    1: 100,
    2: 500,
  };
  int _prestige = 0;

  bool _canPrestige() {
    return _prestige != 3 && _love >= prestigeRequirements[_prestige]!;
  }

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
    String comboCounter = _combo > 0 ? " (x$_combo)" : "";
    setState(() {
      message = msg + comboCounter;
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
              Text('Love: $_love',
                  style: TextStyle(color: Colors.pinkAccent, fontSize: 32.0)),
              Column(
                children: [
                  Text('Prestige: ${_prestige == 3 ? "Max" : _prestige}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                          fontSize: 20)),
                  Dog(messageUpdater: onMessageUpdate, prestige: _prestige),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Ball(
                        messageUpdater: onMessageUpdate,
                      ),
                      const Steak(),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _canPrestige() ? Colors.pink : Colors.grey,
                      textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _canPrestige() ? Colors.white : Colors.black),
                    ),
                    onPressed: () {
                      if (_canPrestige()) {
                        setState(() {
                          _prestige += 1;
                          _combo = 0;
                          _love = 0;
                        });
                      }
                    },
                    child: Text(_canPrestige()
                        ? 'Prestige'
                        : (_prestige != 3
                            ? 'Next Prestige at ${prestigeRequirements[_prestige]} love'
                            : 'Max Prestige'))),
              )
            ]),
          )),
    );
  }
}
