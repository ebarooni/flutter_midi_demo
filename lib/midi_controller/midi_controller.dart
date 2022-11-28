import 'package:flutter/material.dart';
import 'available_devices/available_devices.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'dart:io' show Platform;

class MidiController extends StatefulWidget {
  const MidiController({Key? key}) : super(key: key);

  @override
  State<MidiController> createState() => _MidiControllerState();
}

class _MidiControllerState extends State<MidiController> {
  Future<List<MidiDevice>?> _availableDevices = MidiCommand().devices;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            Platform.operatingSystem,
            style: const TextStyle(fontSize: 48),
          ),
          ElevatedButton(
            onPressed: (() => checkForNewMidiDevices()),
            child: const Text('Show available MIDI devices'),
          ),
          AvailableDevices(availableDevices: _availableDevices),
        ],
      ),
    );
  }

  void checkForNewMidiDevices() {
    setState(() {
      _availableDevices = MidiCommand().devices;
    });
  }
}
