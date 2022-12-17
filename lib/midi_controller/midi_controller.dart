import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';

class MidiController extends StatefulWidget {
  const MidiController({
    required this.midiDataStream,
    required this.openDevicesTab,
    Key? key,
  }) : super(key: key);

  final Stream<MidiPacket>? midiDataStream;
  final Function(int) openDevicesTab;

  @override
  State<MidiController> createState() => _MidiControllerState();
}

class _MidiControllerState extends State<MidiController> {
  late StreamSubscription<MidiPacket>? _midiEventSubscription;
  final List<MidiPacket> packetList = [];

  @override
  void initState() {
    super.initState();
    _midiEventSubscription = widget.midiDataStream?.listen((packet) {
      print(packet);
      setState(() {
        if (packetList.length > 30) {
          packetList.removeLast();
        }
        packetList.insert(0, packet);
      });
    });
  }

  @override
  void dispose() {
    _midiEventSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return packetList.isEmpty
        ? Center(
            child: ElevatedButton.icon(
              onPressed: () => widget.openDevicesTab(1),
              icon: const Icon(
                Icons.add,
                size: 40,
              ),
              label: Text(
                'Connect to a device',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          )
        : Column(
            children: [
              ListTile(
                iconColor: Colors.red,
                leading: const Icon(Icons.delete),
                title: const Text('Tap to empty the messages stream'),
                onTap: () => packetList.clear(),
                tileColor: const Color.fromARGB(255, 247, 245, 245),
              ),
              const Divider(
                height: 1,
              ),
              ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(packetList.elementAt(index).data.toString()),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: packetList.length,
                shrinkWrap: true,
                reverse: true,
              ),
            ],
          );
  }
}
