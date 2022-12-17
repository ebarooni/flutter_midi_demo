import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';

class DeviceConnectionIndicator extends StatelessWidget {
  const DeviceConnectionIndicator({required this.devices, Key? key})
      : super(key: key);
  final Future<List<MidiDevice>?> devices;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: devices,
      builder: (context, snapshot) {
        Widget children;
        if (snapshot.hasData &&
            snapshot.data != null &&
            (snapshot.data as List<MidiDevice>).isNotEmpty) {
          var devices = (snapshot.data as List<MidiDevice>);
          var isConnected = false;
          for (var device in devices) {
            if (device.connected) {
              isConnected = true;
            }
          }
          children = Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Text(
                  isConnected ? 'Connected' : 'Disconnected',
                  style: TextStyle(
                    color: isConnected
                        ? const Color.fromARGB(255, 45, 108, 47)
                        : const Color.fromARGB(255, 195, 49, 39),
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Icon(
                  isConnected ? Icons.check_circle : Icons.block,
                  color: isConnected
                      ? const Color.fromARGB(255, 45, 108, 47)
                      : const Color.fromARGB(255, 195, 49, 39),
                ),
              ],
            ),
          );
        } else {
          children = Row(
            children: const [
              Text('Initializing'),
              Icon(Icons.pending),
            ],
          );
        }
        return children;
      },
    );
  }
}
