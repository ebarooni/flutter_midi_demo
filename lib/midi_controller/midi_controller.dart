import 'package:flutter/material.dart';

class MidiController extends StatefulWidget {
  const MidiController({Key? key}) : super(key: key);

  @override
  State<MidiController> createState() => _MidiControllerState();
}

class _MidiControllerState extends State<MidiController> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          Placeholder()
        ],
      ),
    );
  }
}
