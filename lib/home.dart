import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_talking_dog/steak.dart';

import 'ball.dart';
import 'dog.dart';

class MyHomePage extends StatefulWidget {
  String uid;
  MyHomePage({super.key, required this.uid});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late DatabaseReference ref;
  String message = "";
  bool messageVisible = false;
  Timer? _currentTimer;
  int _love = 0;
  late int _combo = 0;
  String _lastAction = "";
  Map<int, int> prestigeRequirements = {
    0: 50,
    1: 100,
    2: 500,
  };
  int _prestige = 0;

  @override
  void initState() {
    ref = FirebaseDatabase.instance.ref("users").child(widget.uid);
    ref.child("love").onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as int;
      setState(() {
        _love = data;
      });
    });
    ref.child("prestige").onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as int;
      setState(() {
        _prestige = data;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    if (_currentTimer != null) {
      _currentTimer!.cancel();
    }
    super.dispose();
  }

  bool _canPrestige() {
    return _prestige != 3 && _love >= prestigeRequirements[_prestige]!;
  }

  Future<void> _incrementLove(String action) async {
    if (_lastAction != action) {
      _combo = 0;
    }
    _combo += 1;
    _love += _combo;
    await ref.update({"love": _love});
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
                  style: const TextStyle(
                      color: Colors.pinkAccent, fontSize: 32.0)),
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
                    onPressed: () async {
                      if (_canPrestige()) {
                        setState(() {
                          _combo = 0;
                        });
                        await ref
                            .update({"prestige": _prestige + 1, "love": 0});
                      }
                    },
                    child: Text(_canPrestige()
                        ? 'Prestige'
                        : (_prestige != 3
                            ? 'Next Prestige at ${prestigeRequirements[_prestige]} love'
                            : 'Max Prestige'))),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: const Text("Sign Out"),
                    onPressed: () => FirebaseAuth.instance.signOut(),
                  ))
            ]),
          )),
    );
  }
}
