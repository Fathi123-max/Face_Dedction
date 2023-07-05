import 'package:flutter/material.dart';

import 'face_dedector/face_dedetor.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Face detection',
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Face detection'),
        ),
        body: FaceDetectorView(),
      ),
    );
  }
}
