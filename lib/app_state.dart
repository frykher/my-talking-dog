import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _loggedIn = false;
  String? _uid;

  bool get loggedIn => _loggedIn;
  String? get uid => _uid;

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseAuth.instance.userChanges().listen((user) {
      print("fired");
      if (user != null) {
        print("yeees");
        _loggedIn = true;
        _uid = user.uid;
      } else {
        _loggedIn = false;
        _uid = null;
      }
      notifyListeners();
    });
  }
}
