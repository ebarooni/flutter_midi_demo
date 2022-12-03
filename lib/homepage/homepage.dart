import 'package:flutter/material.dart';
import '../midi_controller/midi_controller.dart';
import './bottom_nav_bar/bottom_nav_bar.dart';

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Midi Demo'),
      ),
      body: const MidiController(),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
