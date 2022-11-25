import 'package:flutter/material.dart';
import 'available_devices.dart';
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
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            Platform.operatingSystem,
            style: const TextStyle(fontSize: 48),
          ),
          const AvailableDevices(),
        ],
      ),
    );
  }
}
