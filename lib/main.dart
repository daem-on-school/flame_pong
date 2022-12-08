import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flame/game.dart';
import 'package:flame_pong/bloc/state.dart';
import 'package:flame_pong/score_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'game/game.dart';

part 'main_view.dart';

final firebaseEnabled = kIsWeb || !Platform.isWindows;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (firebaseEnabled) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pong',
      theme: ThemeData(
          primarySwatch: Colors.purple,
          useMaterial3: true,
          fontFamily: 'Inter'
      ),
      home: MainView(),
    );
  }
}
