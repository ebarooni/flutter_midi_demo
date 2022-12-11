import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';

class Devices extends StatelessWidget {
  final Future<List<MidiDevice>?> availableDevices;
  final Function(MidiDevice) disconnectDevice;
  final Function(MidiDevice) connectToDevice;

  const Devices({
    required this.availableDevices,
    required this.disconnectDevice,
    required this.connectToDevice,
    Key? key,
  }) : super(key: key);

  IconData _deviceIconForType(String type) {
    switch (type) {
      case "native":
        return Icons.devices;
      case "network":
        return Icons.language;
      case "BLE":
        return Icons.bluetooth;
      default:
        return Icons.device_unknown;
    }
  }

  void connectOrDisconnectDevice(MidiDevice device) {
    if (device.connected) {
      disconnectDevice(device);
    } else {
      connectToDevice(device);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: availableDevices,
      builder: (context, snapshot) {
        Widget children;
        if (snapshot.hasData && snapshot.data != null) {
          var devices = (snapshot.data as List<MidiDevice>);
          children = ListView.separated(
            itemBuilder: ((context, index) {
              return ListTile(
                title: Text(
                  devices.elementAt(index).name,
                  style: Theme.of(context).textTheme.headline6,
                ),
                subtitle: Text(
                    'ins:${devices.elementAt(index).inputPorts.length} outs:${devices.elementAt(index).outputPorts.length}'),
                leading: Icon(devices.elementAt(index).connected
                    ? Icons.radio_button_on
                    : Icons.radio_button_off),
                trailing:
                    Icon(_deviceIconForType(devices.elementAt(index).type)),
                onTap: () =>
                    connectOrDisconnectDevice(devices.elementAt(index)),
              );
            }),
            separatorBuilder: (context, index) => const Divider(),
            itemCount: devices.length,
          );
        } else {
          children = const Center(child: CircularProgressIndicator());
        }
        return children;
      },
    );
  }
}
