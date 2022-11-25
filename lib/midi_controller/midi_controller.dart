import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'dart:io' show Platform;

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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            Platform.operatingSystem,
            style: const TextStyle(fontSize: 48),
          ),
          ElevatedButton(
            onPressed: () => MidiCommand().devices.then((List<MidiDevice>? midiDevicesList) => print(midiDevicesList)),
            child: const Text('Show available MIDI devices'),
          ),
        ],
      ),
    );
  }
}
