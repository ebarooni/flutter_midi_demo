import 'package:flutter/material.dart';
import 'midi_controller/midi_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Midi Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Midi Demo'),
        ),
        body: const MidiController(),
      ),
    );
  }
}
